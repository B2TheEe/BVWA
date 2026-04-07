package controllers

import (
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
	"time"

	beego "github.com/beego/beego/v2/server/web"
)

// ── A09: Security Logging & Alerting Failures ─────────────────────────────────
//
// Scenario: bvwa-auditd — corporate security audit daemon van BVWA Corp.
// Kwetsbaar: wachtwoorden in plaintext gelogd (CWE-532), geen alerting bij
//            herhaalde mislukkingen (CWE-223), invoer niet gesaniteerd (CWE-117).
// Veilig:    wachtwoorden geredigeerd, alerting na 3 mislukkingen, invoer gesaniteerd.

const loggingCTFFlag = "BVWA{S3ns1tive_L0g_2026}"

// vulnInitialLogs: vooraf gevulde logregels met wachtwoorden in plaintext (CWE-532).
// Vier mislukte pogingen van 192.168.1.55 genereren GEEN alert (CWE-223).
var vulnInitialLogs = []string{
	"[2026-04-07 06:00:01] [INFO]  auditd v1.0.0 gestart",
	"[2026-04-07 06:00:02] [INFO]  Login: root (pass=toor) van 127.0.0.1 — GESLAAGD",
	"[2026-04-07 08:12:03] [INFO]  Login: deployer (pass=d3pl0y2026) van 10.0.0.5 — GESLAAGD",
	"[2026-04-07 08:30:14] [WARN]  Login: admin (pass=admin) van 192.168.1.55 — MISLUKT",
	"[2026-04-07 08:30:15] [WARN]  Login: admin (pass=admin123) van 192.168.1.55 — MISLUKT",
	"[2026-04-07 08:30:16] [WARN]  Login: admin (pass=password) van 192.168.1.55 — MISLUKT",
	"[2026-04-07 08:30:17] [WARN]  Login: admin (pass=password123) van 192.168.1.55 — MISLUKT",
	"[2026-04-07 09:01:55] [INFO]  Login: sysadmin (pass=" + loggingCTFFlag + ") van 10.0.0.1 — GESLAAGD",
	"[2026-04-07 09:45:00] [INFO]  Config-backup voltooid",
}

// secureInitialLogs: zelfde events, wachtwoorden geredigeerd en met brute-force-alert.
var secureInitialLogs = []string{
	"[2026-04-07 06:00:01] [INFO]  auditd v2.0.0 gestart [secure build]",
	"[2026-04-07 06:00:02] [INFO]  Login: root (pass=***REDACTED***) van 127.0.0.1 — GESLAAGD",
	"[2026-04-07 08:12:03] [INFO]  Login: deployer (pass=***REDACTED***) van 10.0.0.5 — GESLAAGD",
	"[2026-04-07 08:30:14] [WARN]  Login: admin (pass=***REDACTED***) van 192.168.1.55 — MISLUKT",
	"[2026-04-07 08:30:15] [WARN]  Login: admin (pass=***REDACTED***) van 192.168.1.55 — MISLUKT",
	"[2026-04-07 08:30:16] [WARN]  Login: admin (pass=***REDACTED***) van 192.168.1.55 — MISLUKT",
	"[2026-04-07 08:30:17] [WARN]  Login: admin (pass=***REDACTED***) van 192.168.1.55 — MISLUKT",
	"[2026-04-07 08:30:17] [ALERT] BRUTE FORCE GEDETECTEERD: admin (4 pogingen) van 192.168.1.55",
	"[2026-04-07 09:01:55] [INFO]  Login: sysadmin (pass=***REDACTED***) van 10.0.0.1 — GESLAAGD",
	"[2026-04-07 09:45:00] [INFO]  Config-backup voltooid",
}

var (
	vulnAuditLog      []string
	secureAuditLog    []string
	a09FailedAttempts = map[string]int{}
)

var auditFileLogger *log.Logger

func init() {
	if lf, err := os.OpenFile("security.log", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644); err == nil {
		auditFileLogger = log.New(lf, "AUDIT: ", log.Ldate|log.Ltime)
	}
	resetA09State()
}

func resetA09State() {
	vulnAuditLog = make([]string, len(vulnInitialLogs))
	copy(vulnAuditLog, vulnInitialLogs)
	secureAuditLog = make([]string, len(secureInitialLogs))
	copy(secureAuditLog, secureInitialLogs)
	a09FailedAttempts = map[string]int{}
}

// ResetA09Logs is geëxporteerd voor tests.
func ResetA09Logs() { resetA09State() }

func auditTimestamp() string {
	return time.Now().Format("2006-01-02 15:04:05")
}

// ── Kwetsbaar ─────────────────────────────────────────────────────────────────

// VulnerableLoggingController — geen alerting, wachtwoorden in plaintext gelogd.
type VulnerableLoggingController struct {
	beego.Controller
}

func (c *VulnerableLoggingController) Get() {
	cmd := c.GetString("cmd")
	var output string
	var hasOutput bool

	if cmd != "" {
		hasOutput = true
		var flagHit bool
		output, flagHit = loggingVulnProcess(cmd)
		if flagHit {
			c.Ctx.ResponseWriter.Header().Set("X-CTF-Flag", loggingCTFFlag)
		}
	}

	c.Data["Command"] = cmd
	c.Data["Output"] = output
	c.Data["HasOutput"] = hasOutput
	c.TplName = "logging/vulnerable.tpl"
}

func loggingVulnProcess(cmd string) (string, bool) {
	parts := strings.Fields(cmd)
	if len(parts) == 0 {
		return "auditd: geen opdracht opgegeven", false
	}

	switch parts[0] {
	case "help":
		return "bvwa-auditd v1.0.0  --  beschikbare opdrachten:\n" +
			"  logs [n]             toon laatste n logregels (standaard 20)\n" +
			"  login <user> <pass>  authenticeer bij auditd\n" +
			"  search <term>        doorzoek auditlog\n" +
			"  stats                toon verbindingsstatistieken", false

	case "logs":
		n := 20
		if len(parts) >= 2 {
			if v, err := strconv.Atoi(parts[1]); err == nil && v > 0 {
				n = v
			}
		}
		entries := vulnAuditLog
		if len(entries) > n {
			entries = entries[len(entries)-n:]
		}
		flagHit := false
		for _, e := range entries {
			if strings.Contains(e, loggingCTFFlag) {
				flagHit = true
				break
			}
		}
		return strings.Join(entries, "\n"), flagHit

	case "login":
		if len(parts) < 3 {
			return "Gebruik: login <gebruiker> <wachtwoord>", false
		}
		user := parts[1]
		pass := parts[2]
		ts := auditTimestamp()

		if user == "admin" && pass == "admin123" {
			// KWETSBAARHEID (CWE-532): wachtwoord in plaintext gelogd.
			entry := fmt.Sprintf("[%s] [INFO]  Login: %s (pass=%s) van 0.0.0.0 — GESLAAGD", ts, user, pass)
			vulnAuditLog = append(vulnAuditLog, entry)
			if auditFileLogger != nil {
				auditFileLogger.Println(entry)
			}
			return fmt.Sprintf("Authenticatie geslaagd.\n  Sessie geopend voor: %s\n\n  Audit-log bijgewerkt.", user), false
		}
		// KWETSBAARHEID (CWE-223): geen alerting bij herhaalde mislukkingen.
		// KWETSBAARHEID (CWE-532): mislukt wachtwoord ook gelogd.
		entry := fmt.Sprintf("[%s] [WARN]  Login: %s (pass=%s) van 0.0.0.0 — MISLUKT", ts, user, pass)
		vulnAuditLog = append(vulnAuditLog, entry)
		if auditFileLogger != nil {
			auditFileLogger.Println(entry)
		}
		return fmt.Sprintf("Authenticatie mislukt voor gebruiker '%s'.", user), false

	case "search":
		if len(parts) < 2 {
			return "Gebruik: search <zoekterm>", false
		}
		term := strings.Join(parts[1:], " ")
		var matches []string
		flagHit := false
		for _, entry := range vulnAuditLog {
			if strings.Contains(strings.ToLower(entry), strings.ToLower(term)) {
				matches = append(matches, entry)
				if strings.Contains(entry, loggingCTFFlag) {
					flagHit = true
				}
			}
		}
		if len(matches) == 0 {
			return fmt.Sprintf("Geen resultaten voor '%s'.", term), false
		}
		return fmt.Sprintf("Zoekresultaten voor '%s':\n%s", term, strings.Join(matches, "\n")), flagHit

	case "stats":
		geslaagd, mislukt := 0, 0
		for _, e := range vulnAuditLog {
			if strings.Contains(e, "— GESLAAGD") {
				geslaagd++
			} else if strings.Contains(e, "— MISLUKT") {
				mislukt++
			}
		}
		return fmt.Sprintf(
			"Verbindingsstatistieken:\n"+
				"  Totale loginpogingen: %d\n"+
				"  Geslaagd:             %d\n"+
				"  Mislukt:              %d\n"+
				"  Logregels:            %d",
			geslaagd+mislukt, geslaagd, mislukt, len(vulnAuditLog)), false

	default:
		return fmt.Sprintf(
			"auditd: opdracht niet gevonden: '%s'\n"+
				"Gebruik 'help' voor een overzicht",
			parts[0]), false
	}
}

// ── Veilig ────────────────────────────────────────────────────────────────────

// SecureLoggingController — wachtwoorden geredigeerd, alerting na 3 mislukkingen.
type SecureLoggingController struct {
	beego.Controller
}

func (c *SecureLoggingController) Get() {
	cmd := c.GetString("cmd")
	ip := c.Ctx.Input.IP()
	var output string
	var hasOutput bool

	if cmd != "" {
		hasOutput = true
		output = loggingSecureProcess(cmd, ip)
	}

	c.Data["Command"] = cmd
	c.Data["Output"] = output
	c.Data["HasOutput"] = hasOutput
	c.TplName = "logging/secure.tpl"
}

func loggingSecureProcess(cmd, ip string) string {
	// MITIGATIE (CWE-117): verwijder control characters uit invoer.
	cmd = strings.Map(func(r rune) rune {
		if r < 0x20 {
			return -1
		}
		return r
	}, cmd)

	parts := strings.Fields(cmd)
	if len(parts) == 0 {
		return "auditd: geen opdracht opgegeven"
	}

	switch parts[0] {
	case "help":
		return "bvwa-auditd v2.0.0  --  beschikbare opdrachten:\n" +
			"  logs [n]             toon laatste n logregels\n" +
			"  login <user> <pass>  authenticeer bij auditd\n" +
			"  search <term>        doorzoek auditlog\n" +
			"  stats                toon statistieken inclusief beveiligingsalerts"

	case "logs":
		n := 20
		if len(parts) >= 2 {
			if v, err := strconv.Atoi(parts[1]); err == nil && v > 0 {
				n = v
			}
		}
		entries := secureAuditLog
		if len(entries) > n {
			entries = entries[len(entries)-n:]
		}
		return strings.Join(entries, "\n")

	case "login":
		if len(parts) < 3 {
			return "Gebruik: login <gebruiker> <wachtwoord>"
		}
		user := parts[1]
		pass := parts[2]
		ts := auditTimestamp()

		if user == "admin" && pass == "admin123" {
			// MITIGATIE (CWE-532 fix): wachtwoord NIET gelogd.
			entry := fmt.Sprintf("[%s] [INFO]  Login: %s (pass=***REDACTED***) van %s — GESLAAGD", ts, user, ip)
			secureAuditLog = append(secureAuditLog, entry)
			delete(a09FailedAttempts, ip)
			if auditFileLogger != nil {
				auditFileLogger.Println(entry)
			}
			return fmt.Sprintf("Authenticatie geslaagd.\n  Sessie geopend voor: %s\n\n  Audit-log bijgewerkt.", user)
		}

		_ = pass // MITIGATIE: wachtwoord bewust niet opgeslagen in log
		a09FailedAttempts[ip]++
		entry := fmt.Sprintf("[%s] [WARN]  Login: %s (pass=***REDACTED***) van %s — MISLUKT", ts, user, ip)
		secureAuditLog = append(secureAuditLog, entry)
		if auditFileLogger != nil {
			auditFileLogger.Println(entry)
		}

		// MITIGATIE (CWE-223 fix): alert bij 3+ mislukte pogingen.
		if a09FailedAttempts[ip] >= 3 {
			alert := fmt.Sprintf("[%s] [ALERT] BRUTE FORCE GEDETECTEERD: %s (%d pogingen) van %s",
				ts, user, a09FailedAttempts[ip], ip)
			secureAuditLog = append(secureAuditLog, alert)
			if auditFileLogger != nil {
				auditFileLogger.Println(alert)
			}
			return fmt.Sprintf(
				"Authenticatie mislukt.\nBeveiligingsalert gegenereerd: %d mislukte pogingen voor '%s'.",
				a09FailedAttempts[ip], user)
		}
		return fmt.Sprintf("Authenticatie mislukt voor gebruiker '%s'.", user)

	case "search":
		if len(parts) < 2 {
			return "Gebruik: search <zoekterm>"
		}
		term := strings.Join(parts[1:], " ")
		var matches []string
		for _, entry := range secureAuditLog {
			if strings.Contains(strings.ToLower(entry), strings.ToLower(term)) {
				matches = append(matches, entry)
			}
		}
		if len(matches) == 0 {
			return fmt.Sprintf("Geen resultaten voor '%s'.", term)
		}
		return fmt.Sprintf("Zoekresultaten voor '%s':\n%s", term, strings.Join(matches, "\n"))

	case "stats":
		geslaagd, mislukt, alerts := 0, 0, 0
		for _, e := range secureAuditLog {
			if strings.Contains(e, "— GESLAAGD") {
				geslaagd++
			} else if strings.Contains(e, "— MISLUKT") {
				mislukt++
			} else if strings.Contains(e, "[ALERT]") {
				alerts++
			}
		}
		result := fmt.Sprintf(
			"Verbindingsstatistieken:\n"+
				"  Totale loginpogingen: %d\n"+
				"  Geslaagd:             %d\n"+
				"  Mislukt:              %d\n"+
				"  Logregels:            %d",
			geslaagd+mislukt, geslaagd, mislukt, len(secureAuditLog))
		if alerts > 0 {
			result += fmt.Sprintf(
				"\n\nBeveiligingsalerts:\n  %d actieve BRUTE FORCE-alert(s) aanwezig", alerts)
		}
		return result

	default:
		return fmt.Sprintf(
			"auditd: opdracht niet gevonden: '%s'\n"+
				"Gebruik 'help' voor een overzicht",
			parts[0])
	}
}
