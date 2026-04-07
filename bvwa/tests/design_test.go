package test

// ─── A06: Insecure Design ─────────────────────────────────────────────────────
//
// Scenario: bvwa-bank — online bankoverschrijvingssysteem van BVWA Corp.
// Kwetsbaar: negatieve bedragen toegestaan (CWE-840), geen overdraft-check (CWE-841).
// Veilig:    server-side validatie bedrag > 0, overdraft geblokkeerd.

import (
	"net/http"
	"net/http/httptest"
	"net/url"
	"strings"
	"testing"

	beego "github.com/beego/beego/v2/server/web"
)

// designGET stuurt een GET naar een design-endpoint met cmd als query-parameter.
func designGET(path, cmd string) *httptest.ResponseRecorder {
	params := url.Values{}
	if cmd != "" {
		params.Set("cmd", cmd)
	}
	fullURL := path
	if cmd != "" {
		fullURL = path + "?" + params.Encode()
	}
	r, _ := http.NewRequest("GET", fullURL, nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)
	return w
}

// ─── Kwetsbare versie ─────────────────────────────────────────────────────────

func TestA06_Kwetsbaar_Startpagina(t *testing.T) {
	w := designGET("/design/vulnerable", "")
	if w.Code != http.StatusOK {
		t.Errorf("[A06 Kwetsbaar] Startpagina: verwacht 200, kreeg %d", w.Code)
	}
}

func TestA06_Kwetsbaar_Startpagina_BevatTerminal(t *testing.T) {
	w := designGET("/design/vulnerable", "")
	body := w.Body.String()
	if !strings.Contains(body, "bvwa-bank") {
		t.Error("[A06 Kwetsbaar] Startpagina: 'bvwa-bank' ontbreekt in response")
	}
}

func TestA06_Kwetsbaar_Help_ToontCommands(t *testing.T) {
	w := designGET("/design/vulnerable", "help")
	body := w.Body.String()
	for _, cmd := range []string{"balance", "transfer", "history", "accounts"} {
		if !strings.Contains(body, cmd) {
			t.Errorf("[A06 Kwetsbaar] help: opdracht '%s' ontbreekt", cmd)
		}
	}
}

func TestA06_Kwetsbaar_Balance_ToontStartsaldo(t *testing.T) {
	w := designGET("/design/vulnerable", "balance")
	if w.Code != http.StatusOK {
		t.Errorf("[A06 Kwetsbaar] balance: verwacht 200, kreeg %d", w.Code)
	}
	body := w.Body.String()
	if !strings.Contains(body, "1000") {
		t.Error("[A06 Kwetsbaar] balance: startsaldo '1000' ontbreekt")
	}
	if !strings.Contains(body, "NL02BVWA0000000000") {
		t.Error("[A06 Kwetsbaar] balance: rekeningnummer ontbreekt")
	}
}

func TestA06_Kwetsbaar_Transfer_GeldigBedrag(t *testing.T) {
	w := designGET("/design/vulnerable", "transfer NL02BVWA0000000001 500")
	if w.Code != http.StatusOK {
		t.Errorf("[A06 Kwetsbaar] transfer geldig bedrag: verwacht 200, kreeg %d", w.Code)
	}
	body := w.Body.String()
	if !strings.Contains(body, "Transactie verwerkt") {
		t.Error("[A06 Kwetsbaar] transfer geldig bedrag: 'Transactie verwerkt' ontbreekt")
	}
	if !strings.Contains(body, "500") {
		t.Error("[A06 Kwetsbaar] transfer geldig bedrag: bedrag '500' ontbreekt in output")
	}
}

func TestA06_Kwetsbaar_Transfer_GeldigBedrag_NieuwSaldoCorrect(t *testing.T) {
	// 1000 - 300 = 700
	w := designGET("/design/vulnerable", "transfer NL02BVWA0000000001 300")
	body := w.Body.String()
	if !strings.Contains(body, "700") {
		t.Error("[A06 Kwetsbaar] transfer 300: nieuw saldo '700' ontbreekt")
	}
}

func TestA06_Kwetsbaar_Transfer_NegatieveBedrag_Toegestaan(t *testing.T) {
	// DESIGN FLAW: negatief bedrag wordt niet geblokkeerd
	w := designGET("/design/vulnerable", "transfer NL02BVWA0000000001 -500")
	if w.Code != http.StatusOK {
		t.Errorf("[A06 Kwetsbaar] transfer negatief: verwacht 200, kreeg %d", w.Code)
	}
	body := w.Body.String()
	if !strings.Contains(body, "Transactie verwerkt") {
		t.Error("[A06 Kwetsbaar] transfer negatief: kwetsbaarheid niet actief — 'Transactie verwerkt' ontbreekt")
	}
}

func TestA06_Kwetsbaar_Transfer_NegatieveBedrag_SaldoStijgt(t *testing.T) {
	// 1000 - (-500) = 1500: aanvaller ontvangt geld
	w := designGET("/design/vulnerable", "transfer NL02BVWA0000000001 -500")
	body := w.Body.String()
	if !strings.Contains(body, "1500") {
		t.Error("[A06 Kwetsbaar] transfer negatief: nieuw saldo '1500' ontbreekt — exploit mislukt")
	}
}

func TestA06_Kwetsbaar_Transfer_NegatieveBedrag_CTFFlagInBody(t *testing.T) {
	w := designGET("/design/vulnerable", "transfer NL02BVWA0000000001 -1")
	body := w.Body.String()
	if !strings.Contains(body, "BVWA{N3g4t1ve_Tr4nsf3r_2026}") {
		t.Error("[A06 Kwetsbaar] transfer negatief: CTF-flag 'BVWA{N3g4t1ve_Tr4nsf3r_2026}' ontbreekt in body")
	}
}

func TestA06_Kwetsbaar_Transfer_NegatieveBedrag_CTFFlagInHeader(t *testing.T) {
	w := designGET("/design/vulnerable", "transfer NL02BVWA0000000001 -9999")
	flag := w.Header().Get("X-CTF-Flag")
	if flag != "BVWA{N3g4t1ve_Tr4nsf3r_2026}" {
		t.Errorf("[A06 Kwetsbaar] transfer negatief: X-CTF-Flag header onjuist: '%s'", flag)
	}
}

func TestA06_Kwetsbaar_Transfer_Overdraft_Toegestaan(t *testing.T) {
	// DESIGN FLAW: geen overdraft-check, saldo mag negatief worden
	w := designGET("/design/vulnerable", "transfer NL02BVWA0000000001 5000")
	body := w.Body.String()
	if !strings.Contains(body, "Transactie verwerkt") {
		t.Error("[A06 Kwetsbaar] overdraft: 'Transactie verwerkt' ontbreekt — overdraft moet toegestaan zijn")
	}
	// 1000 - 5000 = -4000
	if !strings.Contains(body, "-4000") {
		t.Error("[A06 Kwetsbaar] overdraft: negatief saldo '-4000' ontbreekt")
	}
}

func TestA06_Kwetsbaar_Transfer_Overdraft_MeldtNegatiefSaldo(t *testing.T) {
	w := designGET("/design/vulnerable", "transfer NL02BVWA0000000001 9000")
	body := w.Body.String()
	if !strings.Contains(body, "NEGATIEF SALDO") {
		t.Error("[A06 Kwetsbaar] overdraft: 'NEGATIEF SALDO' melding ontbreekt")
	}
}

func TestA06_Kwetsbaar_Transfer_GeenCTFFlagBijPositiefBedrag(t *testing.T) {
	w := designGET("/design/vulnerable", "transfer NL02BVWA0000000001 100")
	if w.Header().Get("X-CTF-Flag") != "" {
		t.Error("[A06 Kwetsbaar] positief bedrag: X-CTF-Flag header mag niet aanwezig zijn")
	}
}

func TestA06_Kwetsbaar_History_ToontTransacties(t *testing.T) {
	w := designGET("/design/vulnerable", "history")
	body := w.Body.String()
	if !strings.Contains(body, "NL02BVWA0000000001") {
		t.Error("[A06 Kwetsbaar] history: transactiehistorie ontbreekt")
	}
}

func TestA06_Kwetsbaar_Accounts_ToontRekeningen(t *testing.T) {
	w := designGET("/design/vulnerable", "accounts")
	body := w.Body.String()
	for _, rekening := range []string{
		"NL02BVWA0000000001", "NL02BVWA0000000002",
		"NL02BVWA0000000003", "NL02BVWA0000000004",
	} {
		if !strings.Contains(body, rekening) {
			t.Errorf("[A06 Kwetsbaar] accounts: rekening '%s' ontbreekt", rekening)
		}
	}
}

func TestA06_Kwetsbaar_OnbekendCommand(t *testing.T) {
	w := designGET("/design/vulnerable", "wirefraud")
	body := w.Body.String()
	if !strings.Contains(body, "opdracht niet gevonden") {
		t.Error("[A06 Kwetsbaar] onbekend command: 'opdracht niet gevonden' ontbreekt")
	}
}

func TestA06_Kwetsbaar_Transfer_OngeldigBedrag(t *testing.T) {
	w := designGET("/design/vulnerable", "transfer NL02BVWA0000000001 abc")
	body := w.Body.String()
	if !strings.Contains(body, "Fout") {
		t.Error("[A06 Kwetsbaar] ongeldig bedrag: foutmelding ontbreekt")
	}
}

// ─── Veilige versie ───────────────────────────────────────────────────────────

func TestA06_Veilig_Startpagina(t *testing.T) {
	w := designGET("/design/secure", "")
	if w.Code != http.StatusOK {
		t.Errorf("[A06 Veilig] Startpagina: verwacht 200, kreeg %d", w.Code)
	}
}

func TestA06_Veilig_Startpagina_BevatTerminal(t *testing.T) {
	w := designGET("/design/secure", "")
	body := w.Body.String()
	if !strings.Contains(body, "bvwa-bank") {
		t.Error("[A06 Veilig] Startpagina: 'bvwa-bank' ontbreekt")
	}
}

func TestA06_Veilig_Balance_ToontStartsaldo(t *testing.T) {
	w := designGET("/design/secure", "balance")
	body := w.Body.String()
	if !strings.Contains(body, "1000") {
		t.Error("[A06 Veilig] balance: startsaldo '1000' ontbreekt")
	}
}

func TestA06_Veilig_Transfer_GeldigBedrag(t *testing.T) {
	w := designGET("/design/secure", "transfer NL02BVWA0000000001 500")
	body := w.Body.String()
	if !strings.Contains(body, "Transactie verwerkt") {
		t.Error("[A06 Veilig] transfer geldig bedrag: 'Transactie verwerkt' ontbreekt")
	}
	// 1000 - 500 = 500
	if !strings.Contains(body, "500") {
		t.Error("[A06 Veilig] transfer geldig bedrag: saldo '500' ontbreekt")
	}
}

func TestA06_Veilig_Transfer_NegatieveBedrag_Geblokkeerd(t *testing.T) {
	// MITIGATIE: negatief bedrag wordt geblokkeerd
	w := designGET("/design/secure", "transfer NL02BVWA0000000001 -500")
	body := w.Body.String()
	if strings.Contains(body, "Transactie verwerkt") {
		t.Error("[A06 Veilig] transfer negatief: moet geblokkeerd zijn — 'Transactie verwerkt' aanwezig")
	}
	if !strings.Contains(body, "Fout") {
		t.Error("[A06 Veilig] transfer negatief: foutmelding ontbreekt")
	}
}

func TestA06_Veilig_Transfer_NulBedrag_Geblokkeerd(t *testing.T) {
	w := designGET("/design/secure", "transfer NL02BVWA0000000001 0")
	body := w.Body.String()
	if strings.Contains(body, "Transactie verwerkt") {
		t.Error("[A06 Veilig] transfer nul: moet geblokkeerd zijn")
	}
	if !strings.Contains(body, "Fout") {
		t.Error("[A06 Veilig] transfer nul: foutmelding ontbreekt")
	}
}

func TestA06_Veilig_Transfer_Overdraft_Geblokkeerd(t *testing.T) {
	// MITIGATIE: overdraft wordt geblokkeerd
	w := designGET("/design/secure", "transfer NL02BVWA0000000001 5000")
	body := w.Body.String()
	if strings.Contains(body, "Transactie verwerkt") {
		t.Error("[A06 Veilig] overdraft: moet geblokkeerd zijn — 'Transactie verwerkt' aanwezig")
	}
	if !strings.Contains(body, "Fout") {
		t.Error("[A06 Veilig] overdraft: foutmelding ontbreekt")
	}
}

func TestA06_Veilig_Transfer_GeenCTFFlag(t *testing.T) {
	// Veilige versie geeft nooit de CTF-flag terug
	w := designGET("/design/secure", "transfer NL02BVWA0000000001 -500")
	body := w.Body.String()
	if strings.Contains(body, "BVWA{N3g4t1ve_Tr4nsf3r_2026}") {
		t.Error("[A06 Veilig] transfer negatief: CTF-flag onterecht aanwezig")
	}
	if w.Header().Get("X-CTF-Flag") != "" {
		t.Error("[A06 Veilig] transfer negatief: X-CTF-Flag header onterecht aanwezig")
	}
}

func TestA06_Veilig_Transfer_GeldigBedrag_NieuwSaldoCorrect(t *testing.T) {
	// 1000 - 200 = 800
	w := designGET("/design/secure", "transfer NL02BVWA0000000001 200")
	body := w.Body.String()
	if !strings.Contains(body, "800") {
		t.Error("[A06 Veilig] transfer 200: nieuw saldo '800' ontbreekt")
	}
}

func TestA06_Veilig_History_ToontTransacties(t *testing.T) {
	w := designGET("/design/secure", "history")
	body := w.Body.String()
	if !strings.Contains(body, "NL02BVWA0000000001") {
		t.Error("[A06 Veilig] history: transactiehistorie ontbreekt")
	}
}

func TestA06_Veilig_Accounts_ToontRekeningen(t *testing.T) {
	w := designGET("/design/secure", "accounts")
	body := w.Body.String()
	for _, rekening := range []string{
		"NL02BVWA0000000001", "NL02BVWA0000000002",
	} {
		if !strings.Contains(body, rekening) {
			t.Errorf("[A06 Veilig] accounts: rekening '%s' ontbreekt", rekening)
		}
	}
}

func TestA06_Veilig_OnbekendCommand(t *testing.T) {
	w := designGET("/design/secure", "wirefraud")
	body := w.Body.String()
	if !strings.Contains(body, "opdracht niet gevonden") {
		t.Error("[A06 Veilig] onbekend command: 'opdracht niet gevonden' ontbreekt")
	}
}

// ─── Debug-endpoint (A06: blootgesteld debug-endpoint) ───────────────────────

func TestA06_DebugEndpoint_ZonderHints_Bereikbaar(t *testing.T) {
	r, _ := http.NewRequest("GET", "/api/v1/debug", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)
	if w.Code != http.StatusOK {
		t.Errorf("[A06 Debug] /api/v1/debug: verwacht 200, kreeg %d", w.Code)
	}
}

func TestA06_DebugEndpoint_BevatCTFFlag(t *testing.T) {
	r, _ := http.NewRequest("GET", "/api/v1/debug", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)
	if !strings.Contains(w.Body.String(), "BVWA{D3sign_Fl4w_2026}") {
		t.Error("[A06 Debug] /api/v1/debug: CTF-flag 'BVWA{D3sign_Fl4w_2026}' ontbreekt")
	}
}
