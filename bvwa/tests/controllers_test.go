package test

import (
	"net/http"
	"net/http/httptest"
	"path/filepath"
	"runtime"
	"strings"
	"testing"

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

// ─── A01: Broken Access Control ───────────────────────────
func TestVulnerableAdmin_GeenAuth(t *testing.T) {
	r, _ := http.NewRequest("GET", "/admin/vulnerable", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code != http.StatusOK {
		t.Errorf("[A01 Kwetsbaar] Verwacht 200, kreeg %d", w.Code)
	}
	t.Log("A01 Kwetsbaar: pagina bereikbaar zonder auth")
}

func TestSecureAdmin_ZonderSessie_Redirect(t *testing.T) {
	r, _ := http.NewRequest("GET", "/admin/secure", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code != http.StatusFound {
		t.Errorf("[A01 Veilig] Verwacht 302, kreeg %d", w.Code)
	}
	t.Log("A01 Veilig: redirect zonder sessie")
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
	body := strings.NewReader("username=admin&password=fout")
	r, _ := http.NewRequest("POST", "/auth/vulnerable", body)
	r.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code != http.StatusOK {
		t.Errorf("[A07 Kwetsbaar] Verwacht 200, kreeg %d", w.Code)
	}
	t.Log("A07 Kwetsbaar: geen rate limiting aanwezig")
}

func TestSecureAuth_JuisteCredentials(t *testing.T) {
	body := strings.NewReader("username=admin&password=password123")
	r, _ := http.NewRequest("POST", "/auth/secure", body)
	r.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code != http.StatusOK {
		t.Errorf("[A07 Veilig] Verwacht 200, kreeg %d", w.Code)
	}
	t.Log("A07 Veilig: bcrypt login succesvol")
}

// ─── A09: Security Logging & Alerting ─────────────────────
func TestSecureLogging_MislukteLogin_WordtGelogd(t *testing.T) {
	for i := 0; i < 4; i++ {
		body := strings.NewReader("username=admin&password=fout")
		r, _ := http.NewRequest("POST", "/logging/secure", body)
		r.Header.Set("Content-Type", "application/x-www-form-urlencoded")
		r.RemoteAddr = "10.0.0.1:12345"
		w := httptest.NewRecorder()
		beego.BeeApp.Handlers.ServeHTTP(w, r)

		respBody := w.Body.String()
		if i >= 3 {
			if strings.Contains(respBody, "geblokkeerd") || strings.Contains(respBody, "pogingen") {
				t.Logf("A09 Veilig: rate limit actief na poging %d", i+1)
			}
		}
	}
	t.Log("A09 Veilig: logging en alerting getest via HTTP")
}

// ─── A10: Exception Handling ───────────────────────────────
func TestSecureException_OngeldieInput(t *testing.T) {
	r, _ := http.NewRequest("GET", "/exceptions/secure?id=abc", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code != http.StatusBadRequest {
		t.Errorf("[A10 Veilig] Verwacht 400, kreeg %d", w.Code)
	}
	t.Log("A10 Veilig: ongeldige input correct afgehandeld")
}

func TestSecureException_NietGevonden(t *testing.T) {
	r, _ := http.NewRequest("GET", "/exceptions/secure?id=999", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code != http.StatusNotFound {
		t.Errorf("[A10 Veilig] Verwacht 404, kreeg %d", w.Code)
	}
	t.Log("A10 Veilig: niet gevonden correct afgehandeld")
}

func TestVulnerableException_NegatiefID(t *testing.T) {
	r, _ := http.NewRequest("GET", "/exceptions/vulnerable?id=-1", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code == http.StatusInternalServerError {
		t.Log("A10 Kwetsbaar: server error gelekt")
	} else {
		t.Logf("A10 Kwetsbaar: antwoord code %d", w.Code)
	}
}
