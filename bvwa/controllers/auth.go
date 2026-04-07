package controllers

import (
	"fmt"
	"strings"

	"golang.org/x/crypto/bcrypt"
	beego "github.com/beego/beego/v2/server/web"
)

// ── A07: Authentication Failures ──────────────────────────────────────────────
//
// Scenario: bvwa-auth — corporate authentication gateway van BVWA Corp.
// Kwetsbaar: plaintext-wachtwoorden (CWE-256), user enumeration via verschillende
//            foutmeldingen (CWE-204), geen rate limiting (CWE-307),
//            voorspelbaar sessietoken (CWE-330).
// Veilig:    bcrypt, generieke foutmelding, rate limiting (max 5/IP), random token.

const (
	// authCTFFlag wordt getoond bij een succesvolle login op de kwetsbare versie.
	authCTFFlag = "BVWA{Brute_F0rc3_2026}"

	// authMaxAttempts is het maximale aantal loginpogingen per IP (veilige versie).
	authMaxAttempts = 5

	// authPredictableToken is het voorspelbare sessietoken (kwetsbare versie — CWE-330).
	authPredictableToken = "sess_00042"

	// authSecureTokenDemo is het willekeurige sessietoken (ter illustratie).
	authSecureTokenDemo = "e3b0c44298fc1c149afb4c8996fb924"
)

// a07VulnUsers: gebruikers met zwakke plaintext-wachtwoorden (CWE-256).
var a07VulnUsers = map[string]string{
	"admin":   "admin123",
	"support": "support",
	"backup":  "backup2026",
}

// a07SecureHashes: bcrypt-hashes van dezelfde wachtwoorden (MinCost voor snelheid).
var a07SecureHashes map[string]string

func init() {
	a07SecureHashes = make(map[string]string)
	for user, pass := range a07VulnUsers {
		hash, _ := bcrypt.GenerateFromPassword([]byte(pass), bcrypt.MinCost)
		a07SecureHashes[user] = string(hash)
	}
}

// a07Attempts houdt het aantal mislukte pogingen per IP bij (veilige versie).
var a07Attempts = map[string]int{}

// ResetA07Attempts wist de pogingen-teller — enkel voor gebruik in tests.
func ResetA07Attempts() {
	a07Attempts = map[string]int{}
}

// ── Kwetsbaar ─────────────────────────────────────────────────────────────────

// VulnerableLoginController — geen rate limiting, user enumeration, plaintext.
type VulnerableLoginController struct {
	beego.Controller
}

func (c *VulnerableLoginController) Get() {
	cmd := c.GetString("cmd")
	var output string
	var hasOutput bool

	if cmd != "" {
		hasOutput = true
		var flagHit bool
		output, flagHit = authVulnProcess(cmd)
		if flagHit {
			c.Ctx.ResponseWriter.Header().Set("X-CTF-Flag", authCTFFlag)
		}
	}

	c.Data["Command"] = cmd
	c.Data["Output"] = output
	c.Data["HasOutput"] = hasOutput
	c.TplName = "auth/vulnerable.tpl"
}

func authVulnProcess(cmd string) (string, bool) {
	parts := strings.Fields(cmd)
	if len(parts) == 0 {
		return "bvwa-auth: geen opdracht opgegeven", false
	}

	switch parts[0] {
	case "help":
		return "bvwa-auth v1.0.0  --  beschikbare opdrachten:\n" +
			"  login <gebruiker> <wachtwoord>  authenticeer als gebruiker\n" +
			"  enum <gebruiker>                controleer of gebruiker bestaat\n" +
			"  session                         toon sessie-informatie", false

	case "login":
		if len(parts) < 3 {
			return "Gebruik: login <gebruiker> <wachtwoord>", false
		}
		user := parts[1]
		pass := strings.Join(parts[2:], " ")

		stored, exists := a07VulnUsers[user]
		if !exists {
			// KWETSBAARHEID (CWE-204): andere foutmelding onthult dat de gebruiker NIET bestaat.
			return fmt.Sprintf("Authenticatie mislukt: gebruiker '%s' bestaat niet.", user), false
		}
		if stored != pass {
			// KWETSBAARHEID (CWE-204): andere foutmelding onthult dat de gebruiker WEL bestaat.
			return fmt.Sprintf("Authenticatie mislukt: onjuist wachtwoord voor '%s'.", user), false
		}

		roles := map[string]string{
			"admin": "administrator", "support": "helpdesk", "backup": "operator",
		}
		return fmt.Sprintf(
			"Authenticatie geslaagd.\n"+
				"  Gebruiker:   %s\n"+
				"  Rol:         %s\n"+
				"  Sessietoken: %s\n\n"+
				"Toegangsverslag: %s",
			user, roles[user], authPredictableToken, authCTFFlag), true

	case "enum":
		if len(parts) < 2 {
			return "Gebruik: enum <gebruiker>", false
		}
		user := parts[1]
		// KWETSBAARHEID (CWE-203): expliciet user-enumeration endpoint.
		if _, exists := a07VulnUsers[user]; exists {
			return fmt.Sprintf("Gebruiker '%s': BESTAAT", user), false
		}
		return fmt.Sprintf("Gebruiker '%s': NIET GEVONDEN", user), false

	case "session":
		return fmt.Sprintf(
			"Sessie-informatie:\n"+
				"  Token:  %s\n"+
				"  Type:   sequentieel (voorspelbaar)\n"+
				"  Notitie: volgende sessie krijgt waarschijnlijk 'sess_00043'",
			authPredictableToken), false

	default:
		return fmt.Sprintf(
			"bvwa-auth: opdracht niet gevonden: '%s'\n"+
				"Gebruik 'help' voor een overzicht",
			parts[0]), false
	}
}

// ── Veilig ────────────────────────────────────────────────────────────────────

// SecureLoginController — bcrypt, rate limiting per IP, generieke foutmeldingen.
type SecureLoginController struct {
	beego.Controller
}

func (c *SecureLoginController) Get() {
	cmd := c.GetString("cmd")
	ip := c.Ctx.Input.IP()
	var output string
	var hasOutput bool

	if cmd != "" {
		hasOutput = true
		output = authSecureProcess(cmd, ip)
	}

	c.Data["Command"] = cmd
	c.Data["Output"] = output
	c.Data["HasOutput"] = hasOutput
	c.TplName = "auth/secure.tpl"
}

func authSecureProcess(cmd, ip string) string {
	parts := strings.Fields(cmd)
	if len(parts) == 0 {
		return "bvwa-auth: geen opdracht opgegeven"
	}

	switch parts[0] {
	case "help":
		return "bvwa-auth v2.0.0  --  beschikbare opdrachten:\n" +
			"  login <gebruiker> <wachtwoord>  authenticeer als gebruiker\n" +
			"  session                         toon sessie-informatie"

	case "login":
		if len(parts) < 3 {
			return "Gebruik: login <gebruiker> <wachtwoord>"
		}

		// MITIGATIE (CWE-307): rate limiting per IP-adres.
		if a07Attempts[ip] >= authMaxAttempts {
			return fmt.Sprintf(
				"Te veel mislukte pogingen. Toegang geblokkeerd voor %s.",
				map[bool]string{true: ip, false: "dit adres"}[ip != ""])
		}

		user := parts[1]
		pass := strings.Join(parts[2:], " ")

		storedHash, exists := a07SecureHashes[user]
		if !exists {
			a07Attempts[ip]++
			// MITIGATIE (CWE-204): generieke foutmelding — geen user enumeration.
			return "Authenticatie mislukt."
		}

		if err := bcrypt.CompareHashAndPassword([]byte(storedHash), []byte(pass)); err != nil {
			a07Attempts[ip]++
			return "Authenticatie mislukt."
		}

		delete(a07Attempts, ip)
		return fmt.Sprintf(
			"Authenticatie geslaagd.\n"+
				"  Gebruiker:   %s\n"+
				"  Sessietoken: %s\n"+
				"  Notitie:     bcrypt-verificatie geslaagd, token willekeurig gegenereerd",
			user, authSecureTokenDemo)

	case "session":
		return fmt.Sprintf(
			"Sessie-informatie:\n"+
				"  Token:  %s\n"+
				"  Type:   cryptografisch willekeurig (CSPRNG)\n"+
				"  Notitie: token kan niet worden voorspeld",
			authSecureTokenDemo)

	default:
		// MITIGATIE: enum-commando bestaat niet (CWE-203 mitigatie).
		return fmt.Sprintf(
			"bvwa-auth: opdracht niet gevonden: '%s'\n"+
				"Gebruik 'help' voor een overzicht",
			parts[0])
	}
}

// ── Logout ────────────────────────────────────────────────────────────────────

// LogoutController vernietigt de sessie en stuurt terug naar de startpagina.
type LogoutController struct {
	beego.Controller
}

func (c *LogoutController) Get() {
	c.DestroySession()
	c.Redirect("/", 302)
}
