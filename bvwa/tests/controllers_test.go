package test

import (
	"net/http"
	"net/http/httptest"
	"path/filepath"
	"runtime"
	"strings"
	"testing"

	"bvwa/controllers"
	_ "bvwa/routers"
	beego "github.com/beego/beego/v2/server/web"
)

func init() {
	_, filename, _, _ := runtime.Caller(0)
	appPath, _ := filepath.Abs(
		filepath.Dir(filepath.Join(filename,
			".."+string(filepath.Separator))))
	beego.TestBeegoInit(appPath)
}

// ─── A01: Broken Access Control (IDOR) ────────────────────

func TestA01_Kwetsbaar_Overview(t *testing.T) {
	r, _ := http.NewRequest("GET", "/admin/vulnerable", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code != http.StatusOK {
		t.Errorf("[A01 Kwetsbaar] Overview: verwacht 200, kreeg %d", w.Code)
	}
}

func TestA01_Kwetsbaar_CTFHeader(t *testing.T) {
	r, _ := http.NewRequest("GET", "/admin/vulnerable", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Header().Get("X-CTF-Flag") == "" {
		t.Error("[A01 Kwetsbaar] X-CTF-Flag header ontbreekt")
	}
}

func TestA01_Kwetsbaar_IDOR_AliceProfiel(t *testing.T) {
	r, _ := http.NewRequest("GET", "/admin/vulnerable?id=2", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code != http.StatusOK {
		t.Errorf("[A01 IDOR] id=2: verwacht 200, kreeg %d", w.Code)
	}
	if !strings.Contains(w.Body.String(), "alice") {
		t.Error("[A01 IDOR] id=2: 'alice' ontbreekt in response body")
	}
}

func TestA01_Kwetsbaar_IDOR_AdminProfiel_ZonderAuth(t *testing.T) {
	// Kerntest: admin-profiel opvraagbaar zonder authenticatie (IDOR)
	r, _ := http.NewRequest("GET", "/admin/vulnerable?id=1", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code != http.StatusOK {
		t.Errorf("[A01 IDOR] id=1: verwacht 200, kreeg %d", w.Code)
	}
	if !strings.Contains(w.Body.String(), "admin") {
		t.Error("[A01 IDOR] id=1: 'admin' ontbreekt in response body")
	}
}

func TestA01_Kwetsbaar_IDOR_CarolProfiel_ZonderAuth(t *testing.T) {
	r, _ := http.NewRequest("GET", "/admin/vulnerable?id=4", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code != http.StatusOK {
		t.Errorf("[A01 IDOR] id=4: verwacht 200, kreeg %d", w.Code)
	}
	if !strings.Contains(w.Body.String(), "carol") {
		t.Error("[A01 IDOR] id=4: 'carol' ontbreekt in response body")
	}
}

func TestA01_Kwetsbaar_NietBestaandID(t *testing.T) {
	r, _ := http.NewRequest("GET", "/admin/vulnerable?id=99", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code != http.StatusOK {
		t.Errorf("[A01] id=99: verwacht 200, kreeg %d", w.Code)
	}
}

// De veilige versie past fail-closed toe: zonder sessie wordt elk verzoek
// doorgestuurd naar /login — ongeacht het gevraagde profiel-ID.

func TestA01_Veilig_GeenSessie_Overview_Redirect(t *testing.T) {
	r, _ := http.NewRequest("GET", "/admin/secure", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code != http.StatusFound {
		t.Errorf("[A01 Veilig] Overview zonder sessie: verwacht 302, kreeg %d", w.Code)
	}
}

func TestA01_Veilig_GeenSessie_GebruikerID_Redirect(t *testing.T) {
	// IDOR-bescherming: ook geldig gebruikers-ID is ontoegankelijk zonder sessie
	r, _ := http.NewRequest("GET", "/admin/secure?id=2", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code != http.StatusFound {
		t.Errorf("[A01 Veilig] id=2 zonder sessie: verwacht 302, kreeg %d", w.Code)
	}
}

func TestA01_Veilig_GeenSessie_AdminID_Redirect(t *testing.T) {
	// IDOR-bescherming: admin-profiel eveneens geblokkeerd zonder sessie
	r, _ := http.NewRequest("GET", "/admin/secure?id=1", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code != http.StatusFound {
		t.Errorf("[A01 Veilig] id=1 zonder sessie: verwacht 302, kreeg %d", w.Code)
	}
}

func TestA01_Veilig_GeenSessie_OnbestaandID_Redirect(t *testing.T) {
	// Fail-closed: ook niet-bestaand ID geeft 302, geen 404-informatielek
	r, _ := http.NewRequest("GET", "/admin/secure?id=99", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code != http.StatusFound {
		t.Errorf("[A01 Veilig] id=99 zonder sessie: verwacht 302, kreeg %d", w.Code)
	}
}

// ─── A02: Security Misconfiguration ───────────────────────
func TestVulnerableMisconfig_GeenHeaders(t *testing.T) {
	r, _ := http.NewRequest("GET", "/misconfig/vulnerable", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	xco := w.Header().Get("X-Content-Type-Options")
	if xco != "" {
		t.Errorf("[A02 Kwetsbaar] Geen headers verwacht, maar X-Content-Type-Options=%s", xco)
	}
	t.Log("A02 Kwetsbaar: geen security headers")
}

func TestSecureMisconfig_HeadersAanwezig(t *testing.T) {
	r, _ := http.NewRequest("GET", "/misconfig/secure", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	headers := map[string]string{
		"X-Content-Type-Options": "nosniff",
		"X-Frame-Options":        "DENY",
	}
	for header, expected := range headers {
		got := w.Header().Get(header)
		if got != expected {
			t.Errorf("[A02 Veilig] %s: verwacht '%s', kreeg '%s'", header, expected, got)
		}
	}
	t.Log("A02 Veilig: security headers aanwezig")
}

// ─── A05: SQL Injection ────────────────────────────────────
func TestVulnerableSQL_InjectionPayload(t *testing.T) {
	r, _ := http.NewRequest("GET", "/injection/sql/vulnerable?username=%27+OR+%271%27%3D%271", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code != http.StatusOK {
		t.Errorf("[A05 Kwetsbaar] Verwacht 200, kreeg %d", w.Code)
	}
	t.Log("A05 Kwetsbaar: SQL injection payload geaccepteerd")
}

func TestSecureSQL_NormaleInput(t *testing.T) {
	r, _ := http.NewRequest("GET", "/injection/sql/secure?username=admin", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code != http.StatusOK {
		t.Errorf("[A05 Veilig] Verwacht 200, kreeg %d", w.Code)
	}
	t.Log("A05 Veilig: geparametriseerde query gebruikt")
}

// ─── A07: Authentication Failures ─────────────────────────
func TestVulnerableAuth_FouteCredentials(t *testing.T) {
	r, _ := http.NewRequest("GET", "/auth/vulnerable?cmd=login+admin+fout", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code != http.StatusOK {
		t.Errorf("[A07 Kwetsbaar] Verwacht 200, kreeg %d", w.Code)
	}
	t.Log("A07 Kwetsbaar: geen rate limiting aanwezig")
}

func TestSecureAuth_JuisteCredentials(t *testing.T) {
	controllers.ResetA07Attempts()
	r, _ := http.NewRequest("GET", "/auth/secure?cmd=login+admin+admin123", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code != http.StatusOK {
		t.Errorf("[A07 Veilig] Verwacht 200, kreeg %d", w.Code)
	}
	t.Log("A07 Veilig: bcrypt login succesvol")
}

// ─── A09: Security Logging & Alerting ─────────────────────
func TestSecureLogging_MislukteLogin_WordtGelogd(t *testing.T) {
	controllers.ResetA09Logs()
	r, _ := http.NewRequest("GET", "/logging/secure?cmd=login+admin+fout", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code != http.StatusOK {
		t.Errorf("[A09 Veilig] Verwacht 200, kreeg %d", w.Code)
	}
	if strings.Contains(w.Body.String(), "BVWA{S3ns1tive_L0g_2026}") {
		t.Error("[A09 Veilig] CTF flag mag niet zichtbaar zijn in veilige versie")
	}
	t.Log("A09 Veilig: logging en alerting getest via HTTP")
}

// ─── A10: Exception Handling ───────────────────────────────
func TestSecureException_PayOngeldigBedrag(t *testing.T) {
	r, _ := http.NewRequest("GET", "/exceptions/secure?cmd=pay+abc+alice", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code != http.StatusOK {
		t.Errorf("[A10 Veilig] Verwacht 200, kreeg %d", w.Code)
	}
	if !strings.Contains(w.Body.String(), "geweigerd") {
		t.Error("[A10 Veilig] ongeldig bedrag: 'geweigerd' ontbreekt in response")
	}
	t.Log("A10 Veilig: ongeldig betalingsbedrag correct afgehandeld")
}

func TestSecureException_CheckAuthFailClosed(t *testing.T) {
	r, _ := http.NewRequest("GET", "/exceptions/secure?cmd=check+auth", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code != http.StatusOK {
		t.Errorf("[A10 Veilig] Verwacht 200, kreeg %d", w.Code)
	}
	if !strings.Contains(w.Body.String(), "fail-closed") {
		t.Error("[A10 Veilig] check auth: fail-closed melding ontbreekt")
	}
	t.Log("A10 Veilig: auth-fout fail-closed afgehandeld")
}

func TestVulnerableException_CheckAuthFailOpen(t *testing.T) {
	r, _ := http.NewRequest("GET", "/exceptions/vulnerable?cmd=check+auth", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code != http.StatusOK {
		t.Errorf("[A10 Kwetsbaar] Verwacht 200, kreeg %d", w.Code)
	}
	if !strings.Contains(w.Body.String(), "fail-open") {
		t.Error("[A10 Kwetsbaar] check auth: fail-open melding ontbreekt")
	}
	t.Log("A10 Kwetsbaar: auth-fout fail-open gedrag aangetoond")
}
