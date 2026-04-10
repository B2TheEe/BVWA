package controllers

import (
	"fmt"
	"strconv"
	"strings"
	"time"

	beego "github.com/beego/beego/v2/server/web"
)

// ── A10: Mishandling of Exceptional Conditions ────────────────────────────────
//
// Scenario: NovaPay DiagTool — beheerterminal van een fictief fintech-platform.
// Kwetsbaar: fouten genegeerd (CWE-391), fail-open bij auth-paniek (CWE-636),
//            interne details gelekt via uitzonderingen (CWE-209), negatieve
//            bedragen niet gevalideerd, config blootgesteld.
// Veilig:    fail-closed, generieke meldingen, strikte validatie, config geblokkeerd.

const exceptionsCTFFlag = "BVWA{F41l_0p3n_Exc3pt10n_2026}"

var a10InitialVulnTx = []string{
	"2026-04-07 09:00:01 | TX-0001 | alice  → bob   | €250.00 | OK",
	"2026-04-07 09:12:33 | TX-0002 | carol  → dave  | €75.50  | OK",
	"2026-04-07 10:05:11 | TX-0003 | admin  → vault | €0.00   | OK [bedragfout genegeerd]",
}

var a10InitialSecureTx = []string{
	"2026-04-07 09:00:01 | TX-0001 | alice  → bob   | €250.00 | OK",
	"2026-04-07 09:12:33 | TX-0002 | carol  → dave  | €75.50  | OK",
}

var (
	a10VulnTransactions  []string
	a10SecureTransactions []string
	a10VulnTxCounter     int
	a10SecureTxCounter   int
)

func init() {
	resetA10State()
}

func resetA10State() {
	a10VulnTransactions = make([]string, len(a10InitialVulnTx))
	copy(a10VulnTransactions, a10InitialVulnTx)
	a10SecureTransactions = make([]string, len(a10InitialSecureTx))
	copy(a10SecureTransactions, a10InitialSecureTx)
	a10VulnTxCounter = 4
	a10SecureTxCounter = 4
}

// ResetA10State is geëxporteerd voor tests.
func ResetA10State() { resetA10State() }

func a10Timestamp() string {
	return time.Now().Format("2006-01-02 15:04:05")
}

// ── Kwetsbaar ─────────────────────────────────────────────────────────────────

type VulnerableExceptionController struct {
	beego.Controller
}

func (c *VulnerableExceptionController) Get() {
	cmd := c.GetString("cmd")
	var output string
	var hasOutput bool

	if cmd != "" {
		hasOutput = true
		var flagHit bool
		output, flagHit = exceptionsVulnProcess(cmd)
		if flagHit {
			c.Ctx.ResponseWriter.Header().Set("X-CTF-Flag", exceptionsCTFFlag)
		}
	}

	c.Data["Command"] = cmd
	c.Data["Output"] = output
	c.Data["HasOutput"] = hasOutput
	c.TplName = "exceptions/vulnerable.tpl"
}

func exceptionsVulnProcess(cmd string) (string, bool) {
	parts := strings.Fields(cmd)
	if len(parts) == 0 {
		return "novadiag: geen opdracht opgegeven", false
	}

	switch parts[0] {
	case "help":
		return "NovaPay DiagTool v1.0  --  beschikbare opdrachten:\n" +
			"  status               systeemstatus opvragen\n" +
			"  check <service>      controleer dienst: auth, db, payment\n" +
			"  pay <bedrag> <naar>  verwerk betaling\n" +
			"  config               toon systeemconfiguratie\n" +
			"  txlog                toon recente transacties", false

	case "status":
		// KWETSBAARHEID (CWE-209): interne paden en versiedetails blootgesteld.
		return "=== NovaPay DiagTool v1.0 ===\n" +
			"Host:         prod-api-01.novapay.local\n" +
			"Go versie:    go1.21.6\n" +
			"PID:          3742\n" +
			"Goroutines:   47\n" +
			"Serverpad:    /srv/novapay/api/\n" +
			"Configpad:    /etc/novapay/config.yaml\n" +
			"Logpad:       /var/log/novapay/app.log\n" +
			"Status:       RUNNING\n" +
			"Uptime:       14d 3h 22m", false

	case "check":
		if len(parts) < 2 {
			return "Gebruik: check <service>  (auth, db, payment)", false
		}
		return exceptionsVulnCheck(parts[1])

	case "pay":
		if len(parts) < 3 {
			return "Gebruik: pay <bedrag> <ontvanger>", false
		}
		return exceptionsVulnPay(parts[1], parts[2])

	case "config":
		// KWETSBAARHEID (CWE-209): volledige configuratie blootgesteld.
		return "=== NovaPay Systeemconfiguratie ===\n" +
			"DB_HOST=db-prod.novapay.local\n" +
			"DB_USER=novapay\n" +
			"DB_PASS=P@ssw0rd2026!\n" +
			"JWT_SECRET=sup3rs3cr3t-jwt-k3y-2026\n" +
			"PAYMENT_API_KEY=sk_prod_Xk9mN2pQ7rL4vW1j\n" +
			"ADMIN_PASS=novapay-admin-2026\n" +
			"ENV=production\n" +
			"DEBUG=false", false

	case "txlog":
		return strings.Join(a10VulnTransactions, "\n"), false

	default:
		return fmt.Sprintf(
			"novadiag: opdracht niet gevonden: '%s'\n"+
				"Gebruik 'help' voor een overzicht",
			parts[0]), false
	}
}

func exceptionsVulnCheck(service string) (string, bool) {
	switch service {
	case "auth":
		// KWETSBAARHEID (CWE-636 + CWE-391): auth-paniek afgevangen door recover(),
		// maar systeem verleent daarna alsnog toegang (fail-open).
		// Stack trace bevat CTF flag als zichtbare variabele.
		return "Authenticatiedienst controleren...\n\n" +
			"panic: runtime error: invalid memory address or nil pointer dereference\n" +
			"[signal SIGSEGV: segmentation violation code=0x1 addr=0x0 pc=0x6b3f2a]\n\n" +
			"goroutine 1 [running]:\n" +
			"novapay/internal/auth.(*TokenValidator).Validate(0x0, {0xc0004f2100, 0x28})\n" +
			"    /srv/novapay/internal/auth/validator.go:47 +0x2a\n" +
			"novapay/internal/middleware.AuthCheck(...)\n" +
			"    /srv/novapay/internal/middleware/auth.go:23 +0x61\n" +
			"    authToken = \"" + exceptionsCTFFlag + "\"\n\n" +
			"RECOVER: panic afgevangen — toegang verleend (fail-open)\n" +
			"WAARSCHUWING: authenticatiefout stilletjes genegeerd!", true

	case "db":
		// KWETSBAARHEID (CWE-209): verbindingsfout lekt database-wachtwoord en pad.
		return "Databaseverbinding testen...\n\n" +
			"FOUT: dial tcp postgres://novapay:P@ssw0rd2026!@db-prod.novapay.local:5432/novapay_prod\n" +
			"      connection refused (errno 111)\n" +
			"Internal: connect timeout after 5000ms\n" +
			"Configpad: /etc/novapay/db/config.yaml\n\n" +
			"Status: UNREACHABLE", false

	case "payment":
		return "Betaaldienst controleren...\n\nStatus: OK\nLatentie: 42ms\nQueue: 0 pending", false

	default:
		return fmt.Sprintf(
			"Onbekende dienst: '%s'\nBeschikbare diensten: auth, db, payment",
			service), false
	}
}

func exceptionsVulnPay(amountStr, recipient string) (string, bool) {
	// KWETSBAARHEID (CWE-391): parse-fout wordt genegeerd met _, bedrag wordt 0.
	amount, _ := strconv.ParseFloat(amountStr, 64)
	// KWETSBAARHEID (CWE-636): geen validatie op negatief bedrag.

	ts := a10Timestamp()
	txID := fmt.Sprintf("TX-%04d", a10VulnTxCounter)
	a10VulnTxCounter++

	var logEntry string
	var outputPrefix string

	if amount == 0 && amountStr != "0" {
		logEntry = fmt.Sprintf(
			"%s | %s | operator → %s | €%.2f | OK [bedragfout genegeerd]",
			ts, txID, recipient, amount)
		outputPrefix = fmt.Sprintf(
			"WAARSCHUWING: bedrag '%s' kon niet worden omgezet — op €0.00 gesteld\n"+
				"Fout stilletjes genegeerd.\n\n",
			amountStr)
	} else {
		logEntry = fmt.Sprintf(
			"%s | %s | operator → %s | €%.2f | OK",
			ts, txID, recipient, amount)
	}
	a10VulnTransactions = append(a10VulnTransactions, logEntry)

	result := outputPrefix + fmt.Sprintf(
		"Betaling verwerkt.\n  Transactie-ID: %s\n  Ontvanger:    %s\n  Bedrag:       €%.2f",
		txID, recipient, amount)

	if amount < 0 {
		result += "\n[negatief bedrag verwerkt — geen validatie uitgevoerd]"
	}
	return result, false
}

// ── Veilig ────────────────────────────────────────────────────────────────────

type SecureExceptionController struct {
	beego.Controller
}

func (c *SecureExceptionController) Get() {
	cmd := c.GetString("cmd")
	var output string
	var hasOutput bool

	if cmd != "" {
		hasOutput = true
		output = exceptionsSecureProcess(cmd)
	}

	c.Data["Command"] = cmd
	c.Data["Output"] = output
	c.Data["HasOutput"] = hasOutput
	c.TplName = "exceptions/secure.tpl"
}

func exceptionsSecureProcess(cmd string) string {
	parts := strings.Fields(cmd)
	if len(parts) == 0 {
		return "novadiag: geen opdracht opgegeven"
	}

	switch parts[0] {
	case "help":
		return "NovaPay DiagTool v2.0  --  beschikbare opdrachten:\n" +
			"  status               systeemstatus opvragen\n" +
			"  check <service>      controleer dienst: auth, db, payment\n" +
			"  pay <bedrag> <naar>  verwerk betaling\n" +
			"  config               toon systeemconfiguratie\n" +
			"  txlog                toon recente transacties"

	case "status":
		// MITIGATIE: geen interne details gelekt.
		return "Status: OK\nDiensten: 3/3 actief\nPlatform: NovaPay v2.0"

	case "check":
		if len(parts) < 2 {
			return "Gebruik: check <service>  (auth, db, payment)"
		}
		return exceptionsSecureCheck(parts[1])

	case "pay":
		if len(parts) < 3 {
			return "Gebruik: pay <bedrag> <ontvanger>"
		}
		return exceptionsSecurePay(parts[1], parts[2])

	case "config":
		// MITIGATIE: configuratie nooit blootgesteld via terminal.
		return "Toegang geweigerd: configuratiegegevens zijn niet beschikbaar via de terminal.\n" +
			"Neem contact op met de systeembeheerder."

	case "txlog":
		return strings.Join(a10SecureTransactions, "\n")

	default:
		return fmt.Sprintf(
			"novadiag: opdracht niet gevonden: '%s'\n"+
				"Gebruik 'help' voor een overzicht",
			parts[0])
	}
}

func exceptionsSecureCheck(service string) string {
	switch service {
	case "auth":
		// MITIGATIE (CWE-636): fail-closed bij auth-fout, geen details of stacktrace.
		return "Authenticatiedienst controleren...\n\n" +
			"Authenticatiedienst reageert niet.\n" +
			"Toegang geweigerd (fail-closed).\n" +
			"Fout intern gelogd [ref: ERR-AUTH-001]"

	case "db":
		// MITIGATIE (CWE-209): generieke foutmelding, geen connection string of pad.
		return "Databaseverbinding testen...\n\n" +
			"Verbindingsfout: dienst tijdelijk niet beschikbaar.\n" +
			"Probeer het later opnieuw [ref: ERR-DB-001]"

	case "payment":
		return "Betaaldienst controleren...\n\nStatus: OK\nLatentie: 42ms"

	default:
		return fmt.Sprintf(
			"Onbekende dienst: '%s'\nBeschikbare diensten: auth, db, payment",
			service)
	}
}

func exceptionsSecurePay(amountStr, recipient string) string {
	// MITIGATIE (CWE-391): parse-fout expliciet afgehandeld.
	amount, err := strconv.ParseFloat(amountStr, 64)
	if err != nil {
		return fmt.Sprintf(
			"Ongeldige betaling: '%s' is geen geldig bedrag.\nTransactie geweigerd.",
			amountStr)
	}
	// MITIGATIE (CWE-636): negatieve en nul-bedragen geweigerd.
	if amount <= 0 {
		return "Ongeldige betaling: bedrag moet groter zijn dan €0.00.\nTransactie geweigerd."
	}

	ts := a10Timestamp()
	txID := fmt.Sprintf("TX-%04d", a10SecureTxCounter)
	a10SecureTxCounter++

	entry := fmt.Sprintf(
		"%s | %s | operator → %s | €%.2f | OK",
		ts, txID, recipient, amount)
	a10SecureTransactions = append(a10SecureTransactions, entry)

	return fmt.Sprintf(
		"Betaling verwerkt.\n  Transactie-ID: %s\n  Ontvanger:    %s\n  Bedrag:       €%.2f",
		txID, recipient, amount)
}
