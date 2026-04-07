package test

import (
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"bvwa/controllers"
	beego "github.com/beego/beego/v2/server/web"
)

func loggingGET(path, cmd string) *httptest.ResponseRecorder {
	url := path
	if cmd != "" {
		url += "?cmd=" + cmd
	}
	r, _ := http.NewRequest("GET", url, nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)
	return w
}

// ─── A09 Kwetsbaar: basisrespons ──────────────────────────────────────────────

func TestA09_Kwetsbaar_Pagina_Laadt(t *testing.T) {
	w := loggingGET("/logging/vulnerable", "")
	if w.Code != http.StatusOK {
		t.Errorf("[A09 Kwetsbaar] verwacht 200, kreeg %d", w.Code)
	}
}

func TestA09_Kwetsbaar_Help_ToontCommands(t *testing.T) {
	w := loggingGET("/logging/vulnerable", "help")
	body := w.Body.String()
	for _, cmd := range []string{"logs", "login", "search", "stats"} {
		if !strings.Contains(body, cmd) {
			t.Errorf("[A09 Kwetsbaar] help: '%s' ontbreekt", cmd)
		}
	}
}

func TestA09_Kwetsbaar_NietBestaandeOpdracht(t *testing.T) {
	w := loggingGET("/logging/vulnerable", "onbekend")
	body := w.Body.String()
	if !strings.Contains(body, "niet gevonden") {
		t.Error("[A09 Kwetsbaar] onbekend commando: 'niet gevonden' ontbreekt")
	}
}

// ─── A09 Kwetsbaar: logs — CTF flag in plaintext ──────────────────────────────

func TestA09_Kwetsbaar_Logs_BevatCTFFlag(t *testing.T) {
	controllers.ResetA09Logs()
	w := loggingGET("/logging/vulnerable", "logs")
	body := w.Body.String()
	if !strings.Contains(body, "BVWA{S3ns1tive_L0g_2026}") {
		t.Error("[A09 Kwetsbaar] logs: CTF flag ontbreekt in auditlog output")
	}
}

func TestA09_Kwetsbaar_Logs_CTFHeader(t *testing.T) {
	controllers.ResetA09Logs()
	w := loggingGET("/logging/vulnerable", "logs")
	if w.Header().Get("X-CTF-Flag") == "" {
		t.Error("[A09 Kwetsbaar] logs: X-CTF-Flag header ontbreekt")
	}
}

func TestA09_Kwetsbaar_Logs_CTFHeader_WaardeBevat_Flag(t *testing.T) {
	controllers.ResetA09Logs()
	w := loggingGET("/logging/vulnerable", "logs")
	headerVal := w.Header().Get("X-CTF-Flag")
	if headerVal != "BVWA{S3ns1tive_L0g_2026}" {
		t.Errorf("[A09 Kwetsbaar] X-CTF-Flag: verwacht CTF flag, got '%s'", headerVal)
	}
}

func TestA09_Kwetsbaar_Logs_BevatPlaintextPass(t *testing.T) {
	controllers.ResetA09Logs()
	w := loggingGET("/logging/vulnerable", "logs")
	body := w.Body.String()
	// Pre-seeded log heeft plaintext wachtwoorden zoals 'pass=toor' en 'pass=d3pl0y2026'
	if !strings.Contains(body, "pass=toor") {
		t.Error("[A09 Kwetsbaar] logs: plaintext wachtwoord 'pass=toor' ontbreekt")
	}
}

func TestA09_Kwetsbaar_Logs_N_Parameter(t *testing.T) {
	controllers.ResetA09Logs()
	// logs 1 should show only the last line
	w := loggingGET("/logging/vulnerable", "logs+1")
	body := w.Body.String()
	// First entry (startup) should NOT appear
	if strings.Contains(body, "auditd v1.0.0 gestart") {
		t.Error("[A09 Kwetsbaar] logs 1: eerste entry mag niet zichtbaar zijn")
	}
	// Last entry (config backup) SHOULD appear
	if !strings.Contains(body, "Config-backup") {
		t.Error("[A09 Kwetsbaar] logs 1: laatste entry ontbreekt")
	}
}

func TestA09_Kwetsbaar_Logs_AlleRegels_Standaard(t *testing.T) {
	controllers.ResetA09Logs()
	w := loggingGET("/logging/vulnerable", "logs")
	body := w.Body.String()
	// All initial entries should be visible
	if !strings.Contains(body, "auditd v1.0.0 gestart") {
		t.Error("[A09 Kwetsbaar] logs standaard: startup entry ontbreekt")
	}
	if !strings.Contains(body, "Config-backup") {
		t.Error("[A09 Kwetsbaar] logs standaard: laatste entry ontbreekt")
	}
}

// ─── A09 Kwetsbaar: login — plaintext in log ──────────────────────────────────

func TestA09_Kwetsbaar_Login_Geslaagd_SuccesOutput(t *testing.T) {
	controllers.ResetA09Logs()
	w := loggingGET("/logging/vulnerable", "login+admin+admin123")
	body := w.Body.String()
	if !strings.Contains(body, "geslaagd") {
		t.Error("[A09 Kwetsbaar] login admin: 'geslaagd' ontbreekt in output")
	}
}

func TestA09_Kwetsbaar_Login_Geslaagd_WachtwoordInLog(t *testing.T) {
	controllers.ResetA09Logs()
	// Login as admin, then check logs to see password in plaintext
	loggingGET("/logging/vulnerable", "login+admin+admin123")
	w := loggingGET("/logging/vulnerable", "logs")
	body := w.Body.String()
	if !strings.Contains(body, "pass=admin123") {
		t.Error("[A09 Kwetsbaar] login admin: wachtwoord niet in plaintext in log")
	}
}

func TestA09_Kwetsbaar_Login_Mislukt_WachtwoordInLog(t *testing.T) {
	controllers.ResetA09Logs()
	loggingGET("/logging/vulnerable", "login+hacker+geheimww")
	w := loggingGET("/logging/vulnerable", "logs")
	body := w.Body.String()
	// Mislukt wachtwoord ook in plaintext gelogd (CWE-532)
	if !strings.Contains(body, "pass=geheimww") {
		t.Error("[A09 Kwetsbaar] login mislukt: mislukt wachtwoord niet in plaintext in log")
	}
}

func TestA09_Kwetsbaar_Login_GeenAlertBijHerhaling(t *testing.T) {
	controllers.ResetA09Logs()
	// 5 mislukte pogingen — geen alert verwacht (CWE-223)
	for i := 0; i < 5; i++ {
		loggingGET("/logging/vulnerable", "login+admin+fout")
	}
	w := loggingGET("/logging/vulnerable", "logs")
	body := w.Body.String()
	if strings.Contains(body, "[ALERT] BRUTE FORCE") {
		t.Error("[A09 Kwetsbaar] na 5 mislukkingen: [ALERT] BRUTE FORCE aanwezig — kwetsbare versie mag niet alerteren")
	}
}

func TestA09_Kwetsbaar_Login_MisluktOutput(t *testing.T) {
	controllers.ResetA09Logs()
	w := loggingGET("/logging/vulnerable", "login+niemand+fout")
	body := w.Body.String()
	if !strings.Contains(body, "mislukt") {
		t.Error("[A09 Kwetsbaar] login mislukt: foutmelding ontbreekt")
	}
}

func TestA09_Kwetsbaar_Login_GeenArgumenten_GeeftFout(t *testing.T) {
	w := loggingGET("/logging/vulnerable", "login")
	body := w.Body.String()
	if !strings.Contains(body, "Gebruik") {
		t.Error("[A09 Kwetsbaar] login zonder args: gebruiksinstructie ontbreekt")
	}
}

// ─── A09 Kwetsbaar: search ────────────────────────────────────────────────────

func TestA09_Kwetsbaar_Search_VindtCtfFlag(t *testing.T) {
	controllers.ResetA09Logs()
	w := loggingGET("/logging/vulnerable", "search+sysadmin")
	body := w.Body.String()
	if !strings.Contains(body, "BVWA{S3ns1tive_L0g_2026}") {
		t.Error("[A09 Kwetsbaar] search sysadmin: CTF flag ontbreekt in zoekresultaten")
	}
}

func TestA09_Kwetsbaar_Search_CTFHeader_BijVondst(t *testing.T) {
	controllers.ResetA09Logs()
	w := loggingGET("/logging/vulnerable", "search+sysadmin")
	if w.Header().Get("X-CTF-Flag") == "" {
		t.Error("[A09 Kwetsbaar] search sysadmin: X-CTF-Flag header ontbreekt")
	}
}

func TestA09_Kwetsbaar_Search_GeenResultaten(t *testing.T) {
	controllers.ResetA09Logs()
	w := loggingGET("/logging/vulnerable", "search+xyznonexistent")
	body := w.Body.String()
	if !strings.Contains(body, "Geen resultaten") {
		t.Error("[A09 Kwetsbaar] search geen resultaten: melding ontbreekt")
	}
	if w.Header().Get("X-CTF-Flag") != "" {
		t.Error("[A09 Kwetsbaar] search geen resultaten: X-CTF-Flag mag niet aanwezig zijn")
	}
}

func TestA09_Kwetsbaar_Search_ZonderTerm_GeeftFout(t *testing.T) {
	w := loggingGET("/logging/vulnerable", "search")
	body := w.Body.String()
	if !strings.Contains(body, "Gebruik") {
		t.Error("[A09 Kwetsbaar] search zonder term: gebruiksinstructie ontbreekt")
	}
}

// ─── A09 Kwetsbaar: stats ─────────────────────────────────────────────────────

func TestA09_Kwetsbaar_Stats_ToontGetallen(t *testing.T) {
	controllers.ResetA09Logs()
	w := loggingGET("/logging/vulnerable", "stats")
	body := w.Body.String()
	if !strings.Contains(body, "Verbindingsstatistieken") {
		t.Error("[A09 Kwetsbaar] stats: 'Verbindingsstatistieken' ontbreekt")
	}
}

func TestA09_Kwetsbaar_Stats_GeenBruteForceDetectie(t *testing.T) {
	controllers.ResetA09Logs()
	w := loggingGET("/logging/vulnerable", "stats")
	body := w.Body.String()
	// Kwetsbare stats toon geen beveiligingsalerts
	if strings.Contains(body, "Beveiligingsalerts") {
		t.Error("[A09 Kwetsbaar] stats: 'Beveiligingsalerts' mag niet aanwezig zijn in kwetsbare versie")
	}
}

// ─── A09 Veilig: basisrespons ─────────────────────────────────────────────────

func TestA09_Veilig_Pagina_Laadt(t *testing.T) {
	w := loggingGET("/logging/secure", "")
	if w.Code != http.StatusOK {
		t.Errorf("[A09 Veilig] verwacht 200, kreeg %d", w.Code)
	}
}

func TestA09_Veilig_Help_ToontCommands(t *testing.T) {
	w := loggingGET("/logging/secure", "help")
	body := w.Body.String()
	for _, cmd := range []string{"logs", "login", "search", "stats"} {
		if !strings.Contains(body, cmd) {
			t.Errorf("[A09 Veilig] help: '%s' ontbreekt", cmd)
		}
	}
}

func TestA09_Veilig_NietBestaandeOpdracht(t *testing.T) {
	w := loggingGET("/logging/secure", "onbekend")
	body := w.Body.String()
	if !strings.Contains(body, "niet gevonden") {
		t.Error("[A09 Veilig] onbekend commando: 'niet gevonden' ontbreekt")
	}
}

// ─── A09 Veilig: logs — geen CTF flag ────────────────────────────────────────

func TestA09_Veilig_Logs_GeenCTFFlag(t *testing.T) {
	controllers.ResetA09Logs()
	w := loggingGET("/logging/secure", "logs")
	body := w.Body.String()
	if strings.Contains(body, "BVWA{S3ns1tive_L0g_2026}") {
		t.Error("[A09 Veilig] logs: CTF flag mag niet zichtbaar zijn")
	}
}

func TestA09_Veilig_Logs_GeenCTFHeader(t *testing.T) {
	controllers.ResetA09Logs()
	w := loggingGET("/logging/secure", "logs")
	if w.Header().Get("X-CTF-Flag") != "" {
		t.Error("[A09 Veilig] logs: X-CTF-Flag header mag niet aanwezig zijn")
	}
}

func TestA09_Veilig_Logs_WachtwoordenGeredigeerd(t *testing.T) {
	controllers.ResetA09Logs()
	w := loggingGET("/logging/secure", "logs")
	body := w.Body.String()
	if !strings.Contains(body, "REDACTED") {
		t.Error("[A09 Veilig] logs: 'REDACTED' ontbreekt — wachtwoorden zouden geredigeerd moeten zijn")
	}
	// Plaintext wachtwoord van root mag NIET zichtbaar zijn
	if strings.Contains(body, "pass=toor") {
		t.Error("[A09 Veilig] logs: plaintext wachtwoord 'toor' is zichtbaar — zou REDACTED moeten zijn")
	}
}

func TestA09_Veilig_Logs_BevatBruteForceAlert(t *testing.T) {
	controllers.ResetA09Logs()
	w := loggingGET("/logging/secure", "logs")
	body := w.Body.String()
	// Pre-seeded secure logs bevatten al een BRUTE FORCE alert
	if !strings.Contains(body, "BRUTE FORCE GEDETECTEERD") {
		t.Error("[A09 Veilig] logs: 'BRUTE FORCE GEDETECTEERD' ontbreekt in pre-seeded logs")
	}
}

func TestA09_Veilig_Logs_N_Parameter(t *testing.T) {
	controllers.ResetA09Logs()
	w := loggingGET("/logging/secure", "logs+1")
	body := w.Body.String()
	// Met n=1 is alleen de laatste regel zichtbaar
	if strings.Contains(body, "auditd v2.0.0 gestart") {
		t.Error("[A09 Veilig] logs 1: eerste entry mag niet zichtbaar zijn")
	}
	if !strings.Contains(body, "Config-backup") {
		t.Error("[A09 Veilig] logs 1: laatste entry ontbreekt")
	}
}

// ─── A09 Veilig: login — wachtwoord geredigeerd, alerting actief ───────────────

func TestA09_Veilig_Login_Geslaagd_SuccesOutput(t *testing.T) {
	controllers.ResetA09Logs()
	w := loggingGET("/logging/secure", "login+admin+admin123")
	body := w.Body.String()
	if !strings.Contains(body, "geslaagd") {
		t.Error("[A09 Veilig] login admin: 'geslaagd' ontbreekt in output")
	}
}

func TestA09_Veilig_Login_Geslaagd_WachtwoordNietInLog(t *testing.T) {
	controllers.ResetA09Logs()
	loggingGET("/logging/secure", "login+admin+admin123")
	w := loggingGET("/logging/secure", "logs")
	body := w.Body.String()
	// Wachtwoord mag NIET in plaintext in log staan
	if strings.Contains(body, "pass=admin123") {
		t.Error("[A09 Veilig] login admin: wachtwoord 'admin123' zichtbaar in log — moet REDACTED zijn")
	}
	if !strings.Contains(body, "REDACTED") {
		t.Error("[A09 Veilig] login admin: 'REDACTED' ontbreekt in log entry")
	}
}

func TestA09_Veilig_Login_Mislukt_WachtwoordNietInLog(t *testing.T) {
	controllers.ResetA09Logs()
	loggingGET("/logging/secure", "login+hacker+supergeheim")
	w := loggingGET("/logging/secure", "logs")
	body := w.Body.String()
	if strings.Contains(body, "pass=supergeheim") {
		t.Error("[A09 Veilig] login mislukt: wachtwoord zichtbaar in log — moet REDACTED zijn")
	}
}

func TestA09_Veilig_Login_BruteForce_AlertNa3Pogingen(t *testing.T) {
	controllers.ResetA09Logs()
	// 3 mislukte pogingen van hetzelfde IP (leeg in tests)
	for i := 0; i < 3; i++ {
		loggingGET("/logging/secure", "login+admin+fout")
	}
	// 4e poging moet alert bevatten
	w := loggingGET("/logging/secure", "login+admin+fout")
	body := w.Body.String()
	if !strings.Contains(body, "alert") && !strings.Contains(body, "Alert") && !strings.Contains(body, "pogingen") {
		t.Error("[A09 Veilig] na 4 pogingen: beveiligingsalert ontbreekt in output")
	}
}

func TestA09_Veilig_Login_BruteForce_AlertInLogs(t *testing.T) {
	controllers.ResetA09Logs()
	for i := 0; i < 3; i++ {
		loggingGET("/logging/secure", "login+admin+fout")
	}
	w := loggingGET("/logging/secure", "logs")
	body := w.Body.String()
	if !strings.Contains(body, "BRUTE FORCE GEDETECTEERD") {
		t.Error("[A09 Veilig] na 3 pogingen: 'BRUTE FORCE GEDETECTEERD' ontbreekt in logs")
	}
}

func TestA09_Veilig_Login_GeenAlertBijEenMislukking(t *testing.T) {
	controllers.ResetA09Logs()
	w := loggingGET("/logging/secure", "login+admin+fout")
	body := w.Body.String()
	// Na 1 poging nog geen alert — check specifieke controller output, niet modal HTML
	if strings.Contains(body, "Beveiligingsalert gegenereerd") {
		t.Error("[A09 Veilig] na 1 poging: alert mag nog niet actief zijn")
	}
}

func TestA09_Veilig_Login_GeenArgumenten_GeeftFout(t *testing.T) {
	w := loggingGET("/logging/secure", "login")
	body := w.Body.String()
	if !strings.Contains(body, "Gebruik") {
		t.Error("[A09 Veilig] login zonder args: gebruiksinstructie ontbreekt")
	}
}

// ─── A09 Veilig: search — geen CTF flag ──────────────────────────────────────

func TestA09_Veilig_Search_GeeftResultaten(t *testing.T) {
	controllers.ResetA09Logs()
	w := loggingGET("/logging/secure", "search+sysadmin")
	body := w.Body.String()
	if !strings.Contains(body, "Zoekresultaten") {
		t.Error("[A09 Veilig] search sysadmin: 'Zoekresultaten' ontbreekt")
	}
}

func TestA09_Veilig_Search_GeenCTFFlag(t *testing.T) {
	controllers.ResetA09Logs()
	w := loggingGET("/logging/secure", "search+sysadmin")
	body := w.Body.String()
	if strings.Contains(body, "BVWA{S3ns1tive_L0g_2026}") {
		t.Error("[A09 Veilig] search sysadmin: CTF flag mag niet zichtbaar zijn in veilige versie")
	}
}

func TestA09_Veilig_Search_GeenCTFHeader(t *testing.T) {
	controllers.ResetA09Logs()
	w := loggingGET("/logging/secure", "search+sysadmin")
	if w.Header().Get("X-CTF-Flag") != "" {
		t.Error("[A09 Veilig] search sysadmin: X-CTF-Flag header mag niet aanwezig zijn")
	}
}

func TestA09_Veilig_Search_GeenResultaten(t *testing.T) {
	controllers.ResetA09Logs()
	w := loggingGET("/logging/secure", "search+xyznonexistent")
	body := w.Body.String()
	if !strings.Contains(body, "Geen resultaten") {
		t.Error("[A09 Veilig] search geen resultaten: melding ontbreekt")
	}
}

// ─── A09 Veilig: stats ────────────────────────────────────────────────────────

func TestA09_Veilig_Stats_ToontGetallen(t *testing.T) {
	controllers.ResetA09Logs()
	w := loggingGET("/logging/secure", "stats")
	body := w.Body.String()
	if !strings.Contains(body, "Verbindingsstatistieken") {
		t.Error("[A09 Veilig] stats: 'Verbindingsstatistieken' ontbreekt")
	}
}

func TestA09_Veilig_Stats_ToontAlerts(t *testing.T) {
	controllers.ResetA09Logs()
	w := loggingGET("/logging/secure", "stats")
	body := w.Body.String()
	// Pre-seeded secure log heeft al een BRUTE FORCE alert
	if !strings.Contains(body, "Beveiligingsalerts") {
		t.Error("[A09 Veilig] stats: 'Beveiligingsalerts' ontbreekt — zou aanwezig moeten zijn vanwege pre-seeded alert")
	}
}

// ─── A09: ResetA09Logs isoleert tests ─────────────────────────────────────────

func TestA09_Reset_HersteltInitieleState(t *testing.T) {
	// Voeg entries toe met uniek wachtwoord en reset dan
	loggingGET("/logging/vulnerable", "login+admin+UNIQUETESTPASS999")
	loggingGET("/logging/vulnerable", "login+test+UNIQUETESTPASS999")
	controllers.ResetA09Logs()

	// Na reset: geïnjecteerde entries weg, CTF flag nog aanwezig via pre-seeded data
	w := loggingGET("/logging/vulnerable", "logs")
	body := w.Body.String()
	if strings.Contains(body, "UNIQUETESTPASS999") {
		t.Error("[A09 Reset] na reset: toegevoegde login entry is nog aanwezig")
	}
	if !strings.Contains(body, "BVWA{S3ns1tive_L0g_2026}") {
		t.Error("[A09 Reset] na reset: pre-seeded CTF flag ontbreekt")
	}
}

func TestA09_Veilig_NooitCTFFlag_InHeader(t *testing.T) {
	controllers.ResetA09Logs()
	cmds := []string{"", "help", "logs", "stats", "search+sysadmin", "login+admin+admin123"}
	for _, cmd := range cmds {
		w := loggingGET("/logging/secure", cmd)
		if w.Header().Get("X-CTF-Flag") != "" {
			t.Errorf("[A09 Veilig] cmd='%s': X-CTF-Flag header mag nooit aanwezig zijn op veilig endpoint", cmd)
		}
	}
	controllers.ResetA09Logs()
}
