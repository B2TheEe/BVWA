package controllers

import (
	"crypto/hmac"
	"crypto/sha256"
	"encoding/base64"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"strings"

	beego "github.com/beego/beego/v2/server/web"
)

// ── A08: Software/Data Integrity Failures ─────────────────────────────────────
//
// Scenario: bvwa-deploy — CI/CD deployment pipeline van BVWA Corp.
// Kwetsbaar: deployment-token is Base64-only JSON zonder handtekening (CWE-345/502).
//            Aanvaller kan payload aanpassen en als admin deployen.
// Veilig:    HMAC-SHA256 handtekening vereist; elke manipulatie wordt gedetecteerd (CWE-347 fix).

const (
	integrityCTFFlag    = "BVWA{1nt3gr1ty_Ch3ck_2026}"
	integrityHMACSecret = "bvwa-deploy-secret-2026"
)

// DeploymentArtifact is de payload van een deployment-token.
type DeploymentArtifact struct {
	User    string `json:"user"`
	Role    string `json:"role"`
	Package string `json:"package"`
	Env     string `json:"env"`
}

// IntegrityDefaultToken is de Base64-gecodeerde standaard deployment-payload (geen handtekening).
var IntegrityDefaultToken string

func init() {
	art := DeploymentArtifact{
		User:    "deployer",
		Role:    "user",
		Package: "app-v1.0.0",
		Env:     "production",
	}
	data, _ := json.Marshal(art)
	IntegrityDefaultToken = base64.StdEncoding.EncodeToString(data)
}

// BuildIntegritySignedToken genereert het HMAC-SHA256-gesigneerde token voor de standaard payload.
func BuildIntegritySignedToken() string {
	mac := hmac.New(sha256.New, []byte(integrityHMACSecret))
	mac.Write([]byte(IntegrityDefaultToken))
	sig := hex.EncodeToString(mac.Sum(nil))
	return IntegrityDefaultToken + "." + sig
}

// ── Kwetsbaar ─────────────────────────────────────────────────────────────────

// VulnerableIntegrityController — deployment-tokens worden zonder handtekening geaccepteerd.
type VulnerableIntegrityController struct {
	beego.Controller
}

func (c *VulnerableIntegrityController) Get() {
	cmd := c.GetString("cmd")
	var output string
	var hasOutput bool

	if cmd != "" {
		hasOutput = true
		var flagHit bool
		output, flagHit = integrityVulnProcess(cmd)
		if flagHit {
			c.Ctx.ResponseWriter.Header().Set("X-CTF-Flag", integrityCTFFlag)
		}
	}

	c.Data["Command"] = cmd
	c.Data["Output"] = output
	c.Data["HasOutput"] = hasOutput
	c.TplName = "integrity/vulnerable.tpl"
}

func integrityVulnProcess(cmd string) (string, bool) {
	parts := strings.Fields(cmd)
	if len(parts) == 0 {
		return "bvwa-deploy: geen opdracht opgegeven", false
	}

	switch parts[0] {
	case "help":
		return "bvwa-deploy v1.0.0  --  beschikbare opdrachten:\n" +
			"  token                toon huidig deployment-token\n" +
			"  decode <token>       decodeer een deployment-token\n" +
			"  encode <json>        encodeer JSON naar deployment-token\n" +
			"  deploy <token>       voer deployment uit met token", false

	case "token":
		return fmt.Sprintf(
			"Deployment-token gegenereerd:\n"+
				"  %s\n\n"+
				"Type: Base64 (geen handtekening)",
			IntegrityDefaultToken), false

	case "decode":
		if len(parts) < 2 {
			return "Gebruik: decode <token>", false
		}
		raw := parts[1]
		// Ondersteun ook gesigneerde tokens: neem alleen het payload-gedeelte.
		if idx := strings.LastIndex(raw, "."); idx > 0 {
			raw = raw[:idx]
		}
		data, err := base64.StdEncoding.DecodeString(raw)
		if err != nil {
			return fmt.Sprintf("Fout: ongeldige Base64 — %s", err), false
		}
		return fmt.Sprintf(
			"Gedecodeerde payload:\n"+
				"  %s\n\n"+
				"Notitie: Base64 is codering, geen encryptie",
			string(data)), false

	case "encode":
		if len(parts) < 2 {
			return "Gebruik: encode <json>", false
		}
		jsonStr := strings.Join(parts[1:], " ")
		// Valideer dat het geldige JSON is.
		var check map[string]interface{}
		if err := json.Unmarshal([]byte(jsonStr), &check); err != nil {
			return fmt.Sprintf("Fout: ongeldige JSON — %s", err), false
		}
		encoded := base64.StdEncoding.EncodeToString([]byte(jsonStr))
		return fmt.Sprintf(
			"Gegenereerde deployment-token:\n"+
				"  %s\n\n"+
				"Gebruik 'deploy <token>' om te deployen",
			encoded), false

	case "deploy":
		if len(parts) < 2 {
			return "Gebruik: deploy <token>", false
		}
		raw := parts[1]
		data, err := base64.StdEncoding.DecodeString(raw)
		if err != nil {
			return fmt.Sprintf("Deployment mislukt: ongeldige token — %s", err), false
		}
		var artifact DeploymentArtifact
		if err := json.Unmarshal(data, &artifact); err != nil {
			return fmt.Sprintf("Deployment mislukt: JSON-fout — %s", err), false
		}

		// KWETSBAARHEID (CWE-345/502): token wordt blind vertrouwd zonder integriteitscontrole.
		if artifact.Role == "admin" {
			return fmt.Sprintf(
				"Deployment gestart.\n"+
					"  Package:   %s\n"+
					"  Gebruiker: %s\n"+
					"  Rol:       %s\n"+
					"  Omgeving:  %s\n"+
					"  Status:    SUCCESS — beheerdersrechten verkregen\n\n"+
					"Audit-log: %s",
				artifact.Package, artifact.User, artifact.Role,
				artifact.Env, integrityCTFFlag), true
		}
		return fmt.Sprintf(
			"Deployment gestart.\n"+
				"  Package:   %s\n"+
				"  Gebruiker: %s\n"+
				"  Rol:       %s\n"+
				"  Omgeving:  %s\n"+
				"  Status:    SUCCESS",
			artifact.Package, artifact.User, artifact.Role, artifact.Env), false

	default:
		return fmt.Sprintf(
			"bvwa-deploy: opdracht niet gevonden: '%s'\n"+
				"Gebruik 'help' voor een overzicht",
			parts[0]), false
	}
}

// ── Veilig ────────────────────────────────────────────────────────────────────

// SecureIntegrityController — deployment-tokens vereisen een geldige HMAC-SHA256-handtekening.
type SecureIntegrityController struct {
	beego.Controller
}

func (c *SecureIntegrityController) Get() {
	cmd := c.GetString("cmd")
	var output string
	var hasOutput bool

	if cmd != "" {
		hasOutput = true
		output = integritySecureProcess(cmd)
	}

	c.Data["Command"] = cmd
	c.Data["Output"] = output
	c.Data["HasOutput"] = hasOutput
	c.TplName = "integrity/secure.tpl"
}

func integritySecureProcess(cmd string) string {
	parts := strings.Fields(cmd)
	if len(parts) == 0 {
		return "bvwa-deploy: geen opdracht opgegeven"
	}

	switch parts[0] {
	case "help":
		return "bvwa-deploy v2.0.0  --  beschikbare opdrachten:\n" +
			"  token                toon huidig gesigneerd deployment-token\n" +
			"  decode <token>       decodeer de payload van een token\n" +
			"  verify <token>       verifieer HMAC-SHA256-handtekening\n" +
			"  deploy <token>       voer deployment uit (vereist geldige handtekening)"

	case "token":
		signed := BuildIntegritySignedToken()
		return fmt.Sprintf(
			"Gesigneerd deployment-token:\n"+
				"  %s\n\n"+
				"Formaat: <base64-payload>.<hmac-sha256-hex>\n"+
				"Notitie: handtekening is onvervalsbaar zonder de server-sleutel",
			signed)

	case "decode":
		if len(parts) < 2 {
			return "Gebruik: decode <token>"
		}
		raw := parts[1]
		// Neem alleen het payload-gedeelte (voor de punt).
		if idx := strings.LastIndex(raw, "."); idx > 0 {
			raw = raw[:idx]
		}
		data, err := base64.StdEncoding.DecodeString(raw)
		if err != nil {
			return fmt.Sprintf("Fout: ongeldige Base64 — %s", err)
		}
		return fmt.Sprintf(
			"Gedecodeerde payload:\n"+
				"  %s\n\n"+
				"Notitie: gebruik 'verify <token>' om de handtekening te controleren",
			string(data))

	case "verify":
		if len(parts) < 2 {
			return "Gebruik: verify <token>"
		}
		token := parts[1]
		idx := strings.LastIndex(token, ".")
		if idx < 0 {
			return "Fout: ongeldig token-formaat — verwacht <payload>.<handtekening>"
		}
		payload := token[:idx]
		givenSig := token[idx+1:]

		mac := hmac.New(sha256.New, []byte(integrityHMACSecret))
		mac.Write([]byte(payload))
		expectedSig := hex.EncodeToString(mac.Sum(nil))

		if hmac.Equal([]byte(givenSig), []byte(expectedSig)) {
			return fmt.Sprintf(
				"Token:        %s\nHandtekening: GELDIG\nNotitie:      integriteit gewaarborgd",
				token)
		}
		return fmt.Sprintf(
			"Token:        %s\nHandtekening: ONGELDIG — token is gemanipuleerd of vervalst",
			token)

	case "deploy":
		if len(parts) < 2 {
			return "Gebruik: deploy <token>"
		}
		token := parts[1]
		idx := strings.LastIndex(token, ".")
		if idx < 0 {
			return "Deployment geweigerd.\n" +
				"  Reden: geen handtekening aanwezig in token\n" +
				"  Actie: artifact geweigerd, geen deployment uitgevoerd"
		}

		payload := token[:idx]
		givenSig := token[idx+1:]

		// MITIGATIE (CWE-345): verifieer HMAC-SHA256 vóór verwerking van het artifact.
		mac := hmac.New(sha256.New, []byte(integrityHMACSecret))
		mac.Write([]byte(payload))
		expectedSig := hex.EncodeToString(mac.Sum(nil))

		if !hmac.Equal([]byte(givenSig), []byte(expectedSig)) {
			return "Deployment geweigerd.\n" +
				"  Reden: HMAC-handtekening ongeldig\n" +
				"  Actie: artifact geweigerd, geen deployment uitgevoerd"
		}

		data, err := base64.StdEncoding.DecodeString(payload)
		if err != nil {
			return fmt.Sprintf("Deployment geweigerd: ongeldige payload — %s", err)
		}
		var artifact DeploymentArtifact
		if err := json.Unmarshal(data, &artifact); err != nil {
			return fmt.Sprintf("Deployment geweigerd: JSON-fout — %s", err)
		}

		return fmt.Sprintf(
			"Handtekening geverifieerd.\n"+
				"Deployment gestart.\n"+
				"  Package:   %s\n"+
				"  Gebruiker: %s\n"+
				"  Rol:       %s\n"+
				"  Omgeving:  %s\n"+
				"  Status:    SUCCESS",
			artifact.Package, artifact.User, artifact.Role, artifact.Env)

	default:
		return fmt.Sprintf(
			"bvwa-deploy: opdracht niet gevonden: '%s'\n"+
				"Gebruik 'help' voor een overzicht",
			parts[0])
	}
}
