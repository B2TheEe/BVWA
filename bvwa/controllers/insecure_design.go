package controllers

import (
	"fmt"
	"strconv"
	"strings"

	beego "github.com/beego/beego/v2/server/web"
)

// ── A06: Insecure Design ──────────────────────────────────────────────────────
//
// Scenario: bvwa-bank — online bankoverschrijvingssysteem van BVWA Corp.
// Kwetsbaar: geen validatie op bedragrichting (negatief bedrag, CWE-840),
//            geen overdraft-controle (CWE-841), sequentiële rekening-ID's (CWE-642).
// Veilig:    server-side validatie bedrag > 0, overdraft-check, generiek foutbericht.

const (
	bankStartBalance = 1_000
	// BankCTFFlag wordt getoond bij een succesvolle negatieve overboeking.
	BankCTFFlag = "BVWA{N3g4t1ve_Tr4nsf3r_2026}"
	// DebugEndpointFlag zit verborgen achter het blootgestelde debug-endpoint.
	DebugEndpointFlag = "BVWA{D3sign_Fl4w_2026}"
)

// VulnerableDesignController — bvwa-bank zonder bedragvalidatie of overdraft-check.
type VulnerableDesignController struct {
	beego.Controller
}

func (c *VulnerableDesignController) Get() {
	cmd := c.GetString("cmd")
	var output string
	var hasOutput bool

	if cmd != "" {
		hasOutput = true
		output = bankVulnProcess(cmd)

		// Zet CTF-flag in response header zodra een negatief bedrag wordt overgemaakt.
		parts := strings.Fields(cmd)
		if len(parts) >= 3 && parts[0] == "transfer" {
			if bedrag, err := strconv.Atoi(parts[2]); err == nil && bedrag < 0 {
				c.Ctx.ResponseWriter.Header().Set("X-CTF-Flag", BankCTFFlag)
			}
		}
	}

	c.Data["Command"] = cmd
	c.Data["Output"] = output
	c.Data["HasOutput"] = hasOutput
	c.TplName = "design/vulnerable.tpl"
}

func bankVulnProcess(cmd string) string {
	parts := strings.Fields(cmd)
	if len(parts) == 0 {
		return "bvwa-bank: geen opdracht opgegeven"
	}

	switch parts[0] {
	case "help":
		return "bvwa-bank v1.0.0  --  beschikbare opdrachten:\n" +
			"  balance                       toon huidig rekeningsaldo\n" +
			"  transfer <rekening> <bedrag>  maak bedrag over naar rekening\n" +
			"  history                       toon recente transacties\n" +
			"  accounts                      lijst beschikbare rekeningen"

	case "balance":
		return fmt.Sprintf(
			"Rekening:  NL02BVWA0000000000\n"+
				"Houder:    BVWA Demo User\n"+
				"Saldo:     € %d,00",
			bankStartBalance)

	case "transfer":
		if len(parts) < 3 {
			return "Gebruik: transfer <rekening> <bedrag>"
		}
		rekening := parts[1]
		bedrag, err := strconv.Atoi(parts[2])
		if err != nil {
			return fmt.Sprintf("Fout: ongeldig bedrag '%s'", parts[2])
		}

		// ONTWERP-KWETSBAARHEID (CWE-840): bedrag wordt niet gevalideerd op > 0.
		// ONTWERP-KWETSBAARHEID (CWE-841): geen controle op voldoende saldo.
		nieuwSaldo := bankStartBalance - bedrag

		if bedrag < 0 {
			return fmt.Sprintf(
				"Transactie verwerkt.\n"+
					"  Van:      NL02BVWA0000000000 (BVWA Demo User)\n"+
					"  Naar:     %s\n"+
					"  Bedrag:   € %d,00\n"+
					"  Saldo:    € %d,00\n\n"+
					"Transactieverslag: %s",
				rekening, bedrag, nieuwSaldo, BankCTFFlag)
		}
		if nieuwSaldo < 0 {
			return fmt.Sprintf(
				"Transactie verwerkt.\n"+
					"  Van:      NL02BVWA0000000000 (BVWA Demo User)\n"+
					"  Naar:     %s\n"+
					"  Bedrag:   € %d,00\n"+
					"  Saldo:    € %d,00 [NEGATIEF SALDO]",
				rekening, bedrag, nieuwSaldo)
		}
		return fmt.Sprintf(
			"Transactie verwerkt.\n"+
				"  Van:      NL02BVWA0000000000 (BVWA Demo User)\n"+
				"  Naar:     %s\n"+
				"  Bedrag:   € %d,00\n"+
				"  Saldo:    € %d,00",
			rekening, bedrag, nieuwSaldo)

	case "history":
		return "Recente transacties (NL02BVWA0000000000):\n" +
			"─────────────────────────────────────────────────────────────\n" +
			"2026-04-01  - €  250,00  NL02BVWA0000000001  J. Jansen\n" +
			"2026-03-28  - €  100,00  NL02BVWA0000000002  B. de Vries\n" +
			"2026-03-15  + €  500,00  NL02BVWA0000000000  Salarisbetaling\n" +
			"─────────────────────────────────────────────────────────────"

	case "accounts":
		return "Beschikbare rekeningen:\n" +
			"─────────────────────────────────────────\n" +
			"NL02BVWA0000000001  J. Jansen\n" +
			"NL02BVWA0000000002  B. de Vries\n" +
			"NL02BVWA0000000003  C. Peters\n" +
			"NL02BVWA0000000004  D. Smit"

	default:
		return fmt.Sprintf(
			"bvwa-bank: opdracht niet gevonden: '%s'\n"+
				"Gebruik 'help' voor een overzicht",
			parts[0])
	}
}

// SecureDesignController — bvwa-bank met server-side bedragvalidatie en overdraft-check.
type SecureDesignController struct {
	beego.Controller
}

func (c *SecureDesignController) Get() {
	cmd := c.GetString("cmd")
	var output string
	var hasOutput bool

	if cmd != "" {
		hasOutput = true
		output = bankSecureProcess(cmd)
	}

	c.Data["Command"] = cmd
	c.Data["Output"] = output
	c.Data["HasOutput"] = hasOutput
	c.TplName = "design/secure.tpl"
}

func bankSecureProcess(cmd string) string {
	parts := strings.Fields(cmd)
	if len(parts) == 0 {
		return "bvwa-bank: geen opdracht opgegeven"
	}

	switch parts[0] {
	case "help":
		return "bvwa-bank v2.0.0  --  beschikbare opdrachten:\n" +
			"  balance                       toon huidig rekeningsaldo\n" +
			"  transfer <rekening> <bedrag>  maak bedrag over naar rekening\n" +
			"  history                       toon recente transacties\n" +
			"  accounts                      lijst beschikbare rekeningen"

	case "balance":
		return fmt.Sprintf(
			"Rekening:  NL02BVWA0000000000\n"+
				"Houder:    BVWA Demo User\n"+
				"Saldo:     € %d,00",
			bankStartBalance)

	case "transfer":
		if len(parts) < 3 {
			return "Gebruik: transfer <rekening> <bedrag>"
		}
		rekening := parts[1]
		bedrag, err := strconv.Atoi(parts[2])
		if err != nil {
			return "Fout: ongeldig bedrag."
		}

		// MITIGATIE (CWE-840): bedrag moet strikt groter zijn dan nul.
		if bedrag <= 0 {
			return "Fout: bedrag moet groter zijn dan € 0,00."
		}
		// MITIGATIE (CWE-841): overdraft wordt geblokkeerd.
		if bedrag > bankStartBalance {
			return "Fout: onvoldoende saldo voor deze overboeking."
		}

		nieuwSaldo := bankStartBalance - bedrag
		return fmt.Sprintf(
			"Transactie verwerkt.\n"+
				"  Van:      NL02BVWA0000000000 (BVWA Demo User)\n"+
				"  Naar:     %s\n"+
				"  Bedrag:   € %d,00\n"+
				"  Saldo:    € %d,00",
			rekening, bedrag, nieuwSaldo)

	case "history":
		return "Recente transacties (NL02BVWA0000000000):\n" +
			"─────────────────────────────────────────────────────────────\n" +
			"2026-04-01  - €  250,00  NL02BVWA0000000001  J. Jansen\n" +
			"2026-03-28  - €  100,00  NL02BVWA0000000002  B. de Vries\n" +
			"2026-03-15  + €  500,00  NL02BVWA0000000000  Salarisbetaling\n" +
			"─────────────────────────────────────────────────────────────"

	case "accounts":
		return "Beschikbare rekeningen:\n" +
			"─────────────────────────────────────────\n" +
			"NL02BVWA0000000001  J. Jansen\n" +
			"NL02BVWA0000000002  B. de Vries\n" +
			"NL02BVWA0000000003  C. Peters\n" +
			"NL02BVWA0000000004  D. Smit"

	default:
		return fmt.Sprintf(
			"bvwa-bank: opdracht niet gevonden: '%s'\n"+
				"Gebruik 'help' voor een overzicht",
			parts[0])
	}
}

// Debug is bereikbaar via /api/v1/debug — opzettelijk blootgesteld debug-endpoint (A06).
func (c *SecureDesignController) Debug() {
	c.Ctx.WriteString(DebugEndpointFlag)
}
