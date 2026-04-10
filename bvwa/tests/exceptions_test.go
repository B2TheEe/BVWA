package test

import (
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"bvwa/controllers"
	beego "github.com/beego/beego/v2/server/web"
)

func exceptionsGET(path, cmd string) *httptest.ResponseRecorder {
	url := path
	if cmd != "" {
		url += "?cmd=" + cmd
	}
	r, _ := http.NewRequest("GET", url, nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)
	return w
}

// ─── A10 Kwetsbaar: basispagina ───────────────────────────────────────────────

func TestA10_Kwetsbaar_Pagina_Laadt(t *testing.T) {
	w := exceptionsGET("/exceptions/vulnerable", "")
	if w.Code != http.StatusOK {
		t.Errorf("[A10 Kwetsbaar] verwacht 200, kreeg %d", w.Code)
	}
}

func TestA10_Kwetsbaar_Help_ToontCommands(t *testing.T) {
	w := exceptionsGET("/exceptions/vulnerable", "help")
	body := w.Body.String()
	for _, cmd := range []string{"status", "check", "pay", "config", "txlog"} {
		if !strings.Contains(body, cmd) {
			t.Errorf("[A10 Kwetsbaar] help: '%s' ontbreekt", cmd)
		}
	}
}

func TestA10_Kwetsbaar_NietBestaandeOpdracht(t *testing.T) {
	w := exceptionsGET("/exceptions/vulnerable", "onbekend")
	body := w.Body.String()
	if !strings.Contains(body, "niet gevonden") {
		t.Error("[A10 Kwetsbaar] onbekend commando: 'niet gevonden' ontbreekt")
	}
}

// ─── A10 Kwetsbaar: status lekt interne paden (CWE-209) ──────────────────────

func TestA10_Kwetsbaar_Status_LektServerpad(t *testing.T) {
	w := exceptionsGET("/exceptions/vulnerable", "status")
	body := w.Body.String()
	if !strings.Contains(body, "/srv/novapay") {
		t.Error("[A10 Kwetsbaar] status: intern serverpad ontbreekt in response")
	}
}

func TestA10_Kwetsbaar_Status_LektConfigpad(t *testing.T) {
	w := exceptionsGET("/exceptions/vulnerable", "status")
	body := w.Body.String()
	if !strings.Contains(body, "/etc/novapay") {
		t.Error("[A10 Kwetsbaar] status: configpad ontbreekt in response")
	}
}

func TestA10_Kwetsbaar_Status_LektGoVersie(t *testing.T) {
	w := exceptionsGET("/exceptions/vulnerable", "status")
	body := w.Body.String()
	if !strings.Contains(body, "Go versie") {
		t.Error("[A10 Kwetsbaar] status: Go versie ontbreekt in response")
	}
}

// ─── A10 Kwetsbaar: check auth — fail-open + CTF flag ────────────────────────

func TestA10_Kwetsbaar_CheckAuth_BevatFailOpen(t *testing.T) {
	w := exceptionsGET("/exceptions/vulnerable", "check+auth")
	body := w.Body.String()
	if !strings.Contains(body, "fail-open") {
		t.Error("[A10 Kwetsbaar] check auth: 'fail-open' ontbreekt — fail-open gedrag niet zichtbaar")
	}
}

func TestA10_Kwetsbaar_CheckAuth_BevatRecover(t *testing.T) {
	w := exceptionsGET("/exceptions/vulnerable", "check+auth")
	body := w.Body.String()
	if !strings.Contains(body, "RECOVER") {
		t.Error("[A10 Kwetsbaar] check auth: 'RECOVER' ontbreekt — panic recovery niet zichtbaar")
	}
}

func TestA10_Kwetsbaar_CheckAuth_BevatCTFFlag(t *testing.T) {
	w := exceptionsGET("/exceptions/vulnerable", "check+auth")
	body := w.Body.String()
	if !strings.Contains(body, "BVWA{F41l_0p3n_Exc3pt10n_2026}") {
		t.Error("[A10 Kwetsbaar] check auth: CTF flag ontbreekt in stacktrace output")
	}
}

func TestA10_Kwetsbaar_CheckAuth_CTFHeader(t *testing.T) {
	w := exceptionsGET("/exceptions/vulnerable", "check+auth")
	if w.Header().Get("X-CTF-Flag") != "BVWA{F41l_0p3n_Exc3pt10n_2026}" {
		t.Errorf("[A10 Kwetsbaar] check auth: X-CTF-Flag header onjuist, got '%s'",
			w.Header().Get("X-CTF-Flag"))
	}
}

func TestA10_Kwetsbaar_CheckAuth_BevatPanic(t *testing.T) {
	w := exceptionsGET("/exceptions/vulnerable", "check+auth")
	body := w.Body.String()
	if !strings.Contains(body, "panic") {
		t.Error("[A10 Kwetsbaar] check auth: 'panic' ontbreekt — stacktrace niet zichtbaar")
	}
}

// ─── A10 Kwetsbaar: check db — connection string lekt (CWE-209) ──────────────

func TestA10_Kwetsbaar_CheckDb_LektWachtwoord(t *testing.T) {
	w := exceptionsGET("/exceptions/vulnerable", "check+db")
	body := w.Body.String()
	if !strings.Contains(body, "P@ssw0rd2026!") {
		t.Error("[A10 Kwetsbaar] check db: DB-wachtwoord ontbreekt in foutmelding")
	}
}

func TestA10_Kwetsbaar_CheckDb_LektConnectionString(t *testing.T) {
	w := exceptionsGET("/exceptions/vulnerable", "check+db")
	body := w.Body.String()
	if !strings.Contains(body, "postgres://novapay") {
		t.Error("[A10 Kwetsbaar] check db: connection string ontbreekt in foutmelding")
	}
}

func TestA10_Kwetsbaar_CheckDb_LektConfigpad(t *testing.T) {
	w := exceptionsGET("/exceptions/vulnerable", "check+db")
	body := w.Body.String()
	if !strings.Contains(body, "/etc/novapay") {
		t.Error("[A10 Kwetsbaar] check db: intern configpad ontbreekt in foutmelding")
	}
}

// ─── A10 Kwetsbaar: pay — fout genegeerd (CWE-391) ───────────────────────────

func TestA10_Kwetsbaar_Pay_OngeldigBedrag_WordtVerwerkt(t *testing.T) {
	controllers.ResetA10State()
	w := exceptionsGET("/exceptions/vulnerable", "pay+abc+alice")
	body := w.Body.String()
	if !strings.Contains(body, "Betaling verwerkt") {
		t.Error("[A10 Kwetsbaar] pay abc alice: 'Betaling verwerkt' ontbreekt — parsefout zou genegeerd moeten worden")
	}
}

func TestA10_Kwetsbaar_Pay_OngeldigBedrag_ToontWaarschuwing(t *testing.T) {
	controllers.ResetA10State()
	w := exceptionsGET("/exceptions/vulnerable", "pay+abc+alice")
	body := w.Body.String()
	if !strings.Contains(body, "WAARSCHUWING") {
		t.Error("[A10 Kwetsbaar] pay abc alice: 'WAARSCHUWING' ontbreekt — fout zou zichtbaar moeten zijn in output")
	}
}

func TestA10_Kwetsbaar_Pay_OngeldigBedrag_NulBedragInTxlog(t *testing.T) {
	controllers.ResetA10State()
	exceptionsGET("/exceptions/vulnerable", "pay+abc+alice")
	w := exceptionsGET("/exceptions/vulnerable", "txlog")
	body := w.Body.String()
	if !strings.Contains(body, "bedragfout genegeerd") {
		t.Error("[A10 Kwetsbaar] txlog na pay abc: 'bedragfout genegeerd' ontbreekt in transactielog")
	}
}

func TestA10_Kwetsbaar_Pay_NegatieveBedrag_WordtVerwerkt(t *testing.T) {
	controllers.ResetA10State()
	w := exceptionsGET("/exceptions/vulnerable", "pay+-100+alice")
	body := w.Body.String()
	if !strings.Contains(body, "Betaling verwerkt") {
		t.Error("[A10 Kwetsbaar] pay -100 alice: negatief bedrag zou verwerkt moeten worden (geen validatie)")
	}
}

func TestA10_Kwetsbaar_Pay_NegatieveBedrag_ToontGeenValidatie(t *testing.T) {
	controllers.ResetA10State()
	w := exceptionsGET("/exceptions/vulnerable", "pay+-100+alice")
	body := w.Body.String()
	if !strings.Contains(body, "geen validatie") {
		t.Error("[A10 Kwetsbaar] pay -100 alice: 'geen validatie' ontbreekt in output")
	}
}

func TestA10_Kwetsbaar_Pay_GeldigBedrag_Verwerkt(t *testing.T) {
	controllers.ResetA10State()
	w := exceptionsGET("/exceptions/vulnerable", "pay+250+bob")
	body := w.Body.String()
	if !strings.Contains(body, "Betaling verwerkt") {
		t.Error("[A10 Kwetsbaar] pay 250 bob: geldig bedrag niet verwerkt")
	}
}

// ─── A10 Kwetsbaar: config lekt credentials (CWE-209) ────────────────────────

func TestA10_Kwetsbaar_Config_LektDBWachtwoord(t *testing.T) {
	w := exceptionsGET("/exceptions/vulnerable", "config")
	body := w.Body.String()
	if !strings.Contains(body, "P@ssw0rd2026!") {
		t.Error("[A10 Kwetsbaar] config: DB-wachtwoord ontbreekt")
	}
}

func TestA10_Kwetsbaar_Config_LektJWTSecret(t *testing.T) {
	w := exceptionsGET("/exceptions/vulnerable", "config")
	body := w.Body.String()
	if !strings.Contains(body, "JWT_SECRET") {
		t.Error("[A10 Kwetsbaar] config: JWT_SECRET ontbreekt")
	}
}

func TestA10_Kwetsbaar_Config_LektAPIKey(t *testing.T) {
	w := exceptionsGET("/exceptions/vulnerable", "config")
	body := w.Body.String()
	if !strings.Contains(body, "PAYMENT_API_KEY") {
		t.Error("[A10 Kwetsbaar] config: PAYMENT_API_KEY ontbreekt")
	}
}

// ─── A10 Kwetsbaar: txlog bevat pre-seeded data ───────────────────────────────

func TestA10_Kwetsbaar_Txlog_BevatInitieleTransacties(t *testing.T) {
	controllers.ResetA10State()
	w := exceptionsGET("/exceptions/vulnerable", "txlog")
	body := w.Body.String()
	if !strings.Contains(body, "TX-0001") {
		t.Error("[A10 Kwetsbaar] txlog: TX-0001 ontbreekt in initieel transactielog")
	}
}

func TestA10_Kwetsbaar_Txlog_BevatBedragFoutEntry(t *testing.T) {
	controllers.ResetA10State()
	w := exceptionsGET("/exceptions/vulnerable", "txlog")
	body := w.Body.String()
	if !strings.Contains(body, "bedragfout genegeerd") {
		t.Error("[A10 Kwetsbaar] txlog: pre-seeded 'bedragfout genegeerd' entry ontbreekt")
	}
}

// ─── A10 Kwetsbaar: check payment werkt normaal ───────────────────────────────

func TestA10_Kwetsbaar_CheckPayment_OK(t *testing.T) {
	w := exceptionsGET("/exceptions/vulnerable", "check+payment")
	body := w.Body.String()
	if !strings.Contains(body, "OK") {
		t.Error("[A10 Kwetsbaar] check payment: 'OK' ontbreekt")
	}
}

// ─── A10 Kwetsbaar: CTF flag nooit in andere commando's ──────────────────────

func TestA10_Kwetsbaar_GeenCTFFlag_InAndereCommands(t *testing.T) {
	for _, cmd := range []string{"help", "status", "config", "txlog", "check+db", "check+payment"} {
		w := exceptionsGET("/exceptions/vulnerable", cmd)
		if w.Header().Get("X-CTF-Flag") != "" {
			t.Errorf("[A10 Kwetsbaar] cmd='%s': X-CTF-Flag mag niet aanwezig zijn", cmd)
		}
	}
}

// ─── A10 Veilig: basispagina ──────────────────────────────────────────────────

func TestA10_Veilig_Pagina_Laadt(t *testing.T) {
	w := exceptionsGET("/exceptions/secure", "")
	if w.Code != http.StatusOK {
		t.Errorf("[A10 Veilig] verwacht 200, kreeg %d", w.Code)
	}
}

func TestA10_Veilig_Help_ToontCommands(t *testing.T) {
	w := exceptionsGET("/exceptions/secure", "help")
	body := w.Body.String()
	for _, cmd := range []string{"status", "check", "pay", "config", "txlog"} {
		if !strings.Contains(body, cmd) {
			t.Errorf("[A10 Veilig] help: '%s' ontbreekt", cmd)
		}
	}
}

func TestA10_Veilig_NietBestaandeOpdracht(t *testing.T) {
	w := exceptionsGET("/exceptions/secure", "onbekend")
	body := w.Body.String()
	if !strings.Contains(body, "niet gevonden") {
		t.Error("[A10 Veilig] onbekend commando: 'niet gevonden' ontbreekt")
	}
}

// ─── A10 Veilig: status geen interne paden ───────────────────────────────────

func TestA10_Veilig_Status_GeenInternePaden(t *testing.T) {
	w := exceptionsGET("/exceptions/secure", "status")
	body := w.Body.String()
	if strings.Contains(body, "/srv/novapay") || strings.Contains(body, "/etc/novapay") {
		t.Error("[A10 Veilig] status: interne paden mogen niet zichtbaar zijn")
	}
}

func TestA10_Veilig_Status_GeenGoVersie(t *testing.T) {
	w := exceptionsGET("/exceptions/secure", "status")
	body := w.Body.String()
	if strings.Contains(body, "Go versie") {
		t.Error("[A10 Veilig] status: Go versie mag niet zichtbaar zijn")
	}
}

func TestA10_Veilig_Status_ToontOK(t *testing.T) {
	w := exceptionsGET("/exceptions/secure", "status")
	body := w.Body.String()
	if !strings.Contains(body, "OK") {
		t.Error("[A10 Veilig] status: 'OK' ontbreekt")
	}
}

// ─── A10 Veilig: check auth — fail-closed, geen CTF flag ─────────────────────

func TestA10_Veilig_CheckAuth_FailClosed(t *testing.T) {
	w := exceptionsGET("/exceptions/secure", "check+auth")
	body := w.Body.String()
	if !strings.Contains(body, "fail-closed") {
		t.Error("[A10 Veilig] check auth: 'fail-closed' ontbreekt — fail-closed gedrag niet zichtbaar")
	}
}

func TestA10_Veilig_CheckAuth_GeenCTFFlag(t *testing.T) {
	w := exceptionsGET("/exceptions/secure", "check+auth")
	body := w.Body.String()
	if strings.Contains(body, "BVWA{F41l_0p3n_Exc3pt10n_2026}") {
		t.Error("[A10 Veilig] check auth: CTF flag mag niet zichtbaar zijn")
	}
}

func TestA10_Veilig_CheckAuth_GeenCTFHeader(t *testing.T) {
	w := exceptionsGET("/exceptions/secure", "check+auth")
	if w.Header().Get("X-CTF-Flag") != "" {
		t.Error("[A10 Veilig] check auth: X-CTF-Flag header mag niet aanwezig zijn")
	}
}

func TestA10_Veilig_CheckAuth_GeenPanic(t *testing.T) {
	w := exceptionsGET("/exceptions/secure", "check+auth")
	body := w.Body.String()
	if strings.Contains(body, "panic") || strings.Contains(body, "goroutine") {
		t.Error("[A10 Veilig] check auth: stacktrace mag niet zichtbaar zijn")
	}
}

func TestA10_Veilig_CheckAuth_GeeftToegangsWeigering(t *testing.T) {
	w := exceptionsGET("/exceptions/secure", "check+auth")
	body := w.Body.String()
	if !strings.Contains(body, "geweigerd") {
		t.Error("[A10 Veilig] check auth: 'geweigerd' ontbreekt in output")
	}
}

// ─── A10 Veilig: check db — generieke foutmelding ────────────────────────────

func TestA10_Veilig_CheckDb_GeenConnectionString(t *testing.T) {
	w := exceptionsGET("/exceptions/secure", "check+db")
	body := w.Body.String()
	if strings.Contains(body, "postgres://") {
		t.Error("[A10 Veilig] check db: connection string mag niet zichtbaar zijn")
	}
}

func TestA10_Veilig_CheckDb_GeenWachtwoord(t *testing.T) {
	w := exceptionsGET("/exceptions/secure", "check+db")
	body := w.Body.String()
	if strings.Contains(body, "P@ssw0rd") {
		t.Error("[A10 Veilig] check db: wachtwoord mag niet zichtbaar zijn")
	}
}

func TestA10_Veilig_CheckDb_Generiekemelding(t *testing.T) {
	w := exceptionsGET("/exceptions/secure", "check+db")
	body := w.Body.String()
	if !strings.Contains(body, "tijdelijk niet beschikbaar") {
		t.Error("[A10 Veilig] check db: generieke foutmelding ontbreekt")
	}
}

func TestA10_Veilig_CheckDb_BevatReferentie(t *testing.T) {
	w := exceptionsGET("/exceptions/secure", "check+db")
	body := w.Body.String()
	if !strings.Contains(body, "ERR-DB-001") {
		t.Error("[A10 Veilig] check db: referentiecode 'ERR-DB-001' ontbreekt")
	}
}

// ─── A10 Veilig: pay — strikte validatie ─────────────────────────────────────

func TestA10_Veilig_Pay_OngeldigBedrag_WordtGeweigerd(t *testing.T) {
	controllers.ResetA10State()
	w := exceptionsGET("/exceptions/secure", "pay+abc+alice")
	body := w.Body.String()
	if !strings.Contains(body, "geweigerd") {
		t.Error("[A10 Veilig] pay abc alice: transactie zou geweigerd moeten worden")
	}
	if strings.Contains(body, "Betaling verwerkt") {
		t.Error("[A10 Veilig] pay abc alice: 'Betaling verwerkt' mag niet aanwezig zijn bij ongeldig bedrag")
	}
}

func TestA10_Veilig_Pay_OngeldigBedrag_NietInTxlog(t *testing.T) {
	controllers.ResetA10State()
	exceptionsGET("/exceptions/secure", "pay+abc+alice")
	w := exceptionsGET("/exceptions/secure", "txlog")
	body := w.Body.String()
	// Geweigerde transacties mogen niet in het log verschijnen
	if strings.Contains(body, "abc") {
		t.Error("[A10 Veilig] txlog na pay abc: geweigerde transactie mag niet in txlog staan")
	}
}

func TestA10_Veilig_Pay_NegatieveBedrag_WordtGeweigerd(t *testing.T) {
	controllers.ResetA10State()
	w := exceptionsGET("/exceptions/secure", "pay+-100+alice")
	body := w.Body.String()
	if !strings.Contains(body, "geweigerd") {
		t.Error("[A10 Veilig] pay -100 alice: negatief bedrag zou geweigerd moeten worden")
	}
	if strings.Contains(body, "Betaling verwerkt") {
		t.Error("[A10 Veilig] pay -100 alice: 'Betaling verwerkt' mag niet aanwezig zijn")
	}
}

func TestA10_Veilig_Pay_NulBedrag_WordtGeweigerd(t *testing.T) {
	controllers.ResetA10State()
	w := exceptionsGET("/exceptions/secure", "pay+0+alice")
	body := w.Body.String()
	if !strings.Contains(body, "geweigerd") {
		t.Error("[A10 Veilig] pay 0 alice: nul-bedrag zou geweigerd moeten worden")
	}
}

func TestA10_Veilig_Pay_GeldigBedrag_Verwerkt(t *testing.T) {
	controllers.ResetA10State()
	w := exceptionsGET("/exceptions/secure", "pay+250+bob")
	body := w.Body.String()
	if !strings.Contains(body, "Betaling verwerkt") {
		t.Error("[A10 Veilig] pay 250 bob: geldig bedrag niet verwerkt")
	}
}

func TestA10_Veilig_Pay_GeldigBedrag_InTxlog(t *testing.T) {
	controllers.ResetA10State()
	exceptionsGET("/exceptions/secure", "pay+250+bob")
	w := exceptionsGET("/exceptions/secure", "txlog")
	body := w.Body.String()
	if !strings.Contains(body, "bob") {
		t.Error("[A10 Veilig] txlog na pay 250 bob: transactie niet in txlog")
	}
}

// ─── A10 Veilig: config — toegang geweigerd ──────────────────────────────────

func TestA10_Veilig_Config_ToegangsGeweigerd(t *testing.T) {
	w := exceptionsGET("/exceptions/secure", "config")
	body := w.Body.String()
	if !strings.Contains(body, "Toegang geweigerd") {
		t.Error("[A10 Veilig] config: 'Toegang geweigerd' ontbreekt")
	}
}

func TestA10_Veilig_Config_GeenWachtwoord(t *testing.T) {
	w := exceptionsGET("/exceptions/secure", "config")
	body := w.Body.String()
	if strings.Contains(body, "P@ssw0rd") {
		t.Error("[A10 Veilig] config: wachtwoord mag niet zichtbaar zijn")
	}
}

func TestA10_Veilig_Config_GeenJWTSecret(t *testing.T) {
	w := exceptionsGET("/exceptions/secure", "config")
	body := w.Body.String()
	if strings.Contains(body, "sup3rs3cr3t") {
		t.Error("[A10 Veilig] config: JWT secret mag niet zichtbaar zijn")
	}
}

// ─── A10 Veilig: CTF flag nooit zichtbaar ─────────────────────────────────────

func TestA10_Veilig_NooitCTFFlag_InHeader(t *testing.T) {
	controllers.ResetA10State()
	cmds := []string{"", "help", "status", "check+auth", "check+db", "check+payment",
		"config", "txlog", "pay+100+alice"}
	for _, cmd := range cmds {
		w := exceptionsGET("/exceptions/secure", cmd)
		if w.Header().Get("X-CTF-Flag") != "" {
			t.Errorf("[A10 Veilig] cmd='%s': X-CTF-Flag header mag nooit aanwezig zijn op veilig endpoint", cmd)
		}
	}
}

func TestA10_Veilig_NooitCTFFlag_InBody(t *testing.T) {
	controllers.ResetA10State()
	cmds := []string{"help", "status", "check+auth", "check+db", "check+payment",
		"config", "txlog", "pay+100+alice"}
	for _, cmd := range cmds {
		w := exceptionsGET("/exceptions/secure", cmd)
		if strings.Contains(w.Body.String(), "BVWA{F41l_0p3n_Exc3pt10n_2026}") {
			t.Errorf("[A10 Veilig] cmd='%s': CTF flag mag niet in response body staan", cmd)
		}
	}
}

// ─── A10: Reset isoleert tests ────────────────────────────────────────────────

func TestA10_Reset_HersteltInitieleState(t *testing.T) {
	// Voeg transacties toe en reset dan
	exceptionsGET("/exceptions/vulnerable", "pay+9999+hacker")
	exceptionsGET("/exceptions/secure", "pay+9999+hacker")
	controllers.ResetA10State()

	// Na reset: toegevoegde entries weg
	wVuln := exceptionsGET("/exceptions/vulnerable", "txlog")
	if strings.Contains(wVuln.Body.String(), "9999") {
		t.Error("[A10 Reset] kwetsbaar txlog: toegevoegde entry nog aanwezig na reset")
	}
	wSecure := exceptionsGET("/exceptions/secure", "txlog")
	if strings.Contains(wSecure.Body.String(), "9999") {
		t.Error("[A10 Reset] veilig txlog: toegevoegde entry nog aanwezig na reset")
	}

	// Pre-seeded data aanwezig
	if !strings.Contains(wVuln.Body.String(), "TX-0001") {
		t.Error("[A10 Reset] kwetsbaar txlog: TX-0001 ontbreekt na reset")
	}
}
