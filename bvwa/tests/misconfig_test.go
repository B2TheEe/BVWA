package test

import (
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	beego "github.com/beego/beego/v2/server/web"
)

// ─── A02: Security Misconfiguration ───────────────────────────────────────────
//
// Scenario: blootgesteld server-diagnostics endpoint zonder authenticatie.
// De kwetsbare versie voert shell-commando's uit en lekt credentials + CTF flag.

// ── Kwetsbare versie ──────────────────────────────────────────────────────────

func TestA02_Kwetsbaar_StatusOK(t *testing.T) {
	r, _ := http.NewRequest("GET", "/misconfig/vulnerable", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code != http.StatusOK {
		t.Errorf("[A02 Kwetsbaar] verwacht 200, kreeg %d", w.Code)
	}
}

func TestA02_Kwetsbaar_GeenSecurityHeaders(t *testing.T) {
	r, _ := http.NewRequest("GET", "/misconfig/vulnerable", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	secHeaders := []string{
		"X-Content-Type-Options",
		"X-Frame-Options",
		"Content-Security-Policy",
		"Strict-Transport-Security",
		"Referrer-Policy",
		"Permissions-Policy",
	}
	for _, h := range secHeaders {
		if v := w.Header().Get(h); v != "" {
			t.Errorf("[A02 Kwetsbaar] header '%s' aanwezig, verwacht afwezig (waarde: %s)", h, v)
		}
	}
}

func TestA02_Kwetsbaar_DebugHeadersAanwezig(t *testing.T) {
	r, _ := http.NewRequest("GET", "/misconfig/vulnerable", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if v := w.Header().Get("X-Powered-By"); !strings.Contains(v, "debug") {
		t.Errorf("[A02 Kwetsbaar] X-Powered-By bevat geen 'debug': '%s'", v)
	}
	if v := w.Header().Get("Server"); v == "" {
		t.Error("[A02 Kwetsbaar] Server header ontbreekt")
	}
}

func TestA02_Kwetsbaar_CTFFlagInHeader(t *testing.T) {
	r, _ := http.NewRequest("GET", "/misconfig/vulnerable", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	flag := w.Header().Get("X-CTF-Flag")
	if flag != "BVWA{M1scC0nf1g_D1r_2026}" {
		t.Errorf("[A02 Kwetsbaar] X-CTF-Flag onjuist: '%s'", flag)
	}
}

func TestA02_Kwetsbaar_LandingPageBevatkConsole(t *testing.T) {
	r, _ := http.NewRequest("GET", "/misconfig/vulnerable", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "diagnostic") {
		t.Error("[A02 Kwetsbaar] landing page: 'diagnostic' ontbreekt in body")
	}
}

func TestA02_Kwetsbaar_CommandHostname(t *testing.T) {
	r, _ := http.NewRequest("GET", "/misconfig/vulnerable?cmd=hostname", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "bvwa-server") {
		t.Error("[A02 Kwetsbaar] cmd=hostname: 'bvwa-server' ontbreekt in response")
	}
}

func TestA02_Kwetsbaar_CommandWhoami(t *testing.T) {
	r, _ := http.NewRequest("GET", "/misconfig/vulnerable?cmd=whoami", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "root") {
		t.Error("[A02 Kwetsbaar] cmd=whoami: 'root' ontbreekt in response")
	}
}

func TestA02_Kwetsbaar_CommandId(t *testing.T) {
	r, _ := http.NewRequest("GET", "/misconfig/vulnerable?cmd=id", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	body := w.Body.String()
	if !strings.Contains(body, "uid=0") {
		t.Error("[A02 Kwetsbaar] cmd=id: 'uid=0' ontbreekt in response")
	}
	if !strings.Contains(body, "root") {
		t.Error("[A02 Kwetsbaar] cmd=id: 'root' ontbreekt in response")
	}
}

func TestA02_Kwetsbaar_CommandEnv_LektDBPassword(t *testing.T) {
	r, _ := http.NewRequest("GET", "/misconfig/vulnerable?cmd=env", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	body := w.Body.String()
	if !strings.Contains(body, "DB_PASSWORD") {
		t.Error("[A02 Kwetsbaar] cmd=env: 'DB_PASSWORD' ontbreekt in response")
	}
	if !strings.Contains(body, "bvwapassword") {
		t.Error("[A02 Kwetsbaar] cmd=env: waarde van DB_PASSWORD ontbreekt")
	}
}

func TestA02_Kwetsbaar_CommandEnv_CTFFlag(t *testing.T) {
	r, _ := http.NewRequest("GET", "/misconfig/vulnerable?cmd=env", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "BVWA{M1scC0nf1g_D1r_2026}") {
		t.Error("[A02 Kwetsbaar] cmd=env: CTF flag ontbreekt in response")
	}
}

func TestA02_Kwetsbaar_CommandCatSecret(t *testing.T) {
	r, _ := http.NewRequest("GET", "/misconfig/vulnerable?cmd=cat+secret.txt", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "BVWA{M1scC0nf1g_D1r_2026}") {
		t.Error("[A02 Kwetsbaar] cmd=cat secret.txt: CTF flag ontbreekt in response")
	}
}

func TestA02_Kwetsbaar_CommandCatConfig(t *testing.T) {
	r, _ := http.NewRequest("GET", "/misconfig/vulnerable?cmd=cat+bvwa.conf", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	body := w.Body.String()
	if !strings.Contains(body, "bvwapassword") {
		t.Error("[A02 Kwetsbaar] cmd=cat bvwa.conf: 'bvwapassword' ontbreekt in response")
	}
	if !strings.Contains(body, "admin123") {
		t.Error("[A02 Kwetsbaar] cmd=cat bvwa.conf: 'admin123' ontbreekt in response")
	}
}

func TestA02_Kwetsbaar_CommandLS(t *testing.T) {
	r, _ := http.NewRequest("GET", "/misconfig/vulnerable?cmd=ls", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "bvwa.conf") {
		t.Error("[A02 Kwetsbaar] cmd=ls: 'bvwa.conf' ontbreekt in response")
	}
}

func TestA02_Kwetsbaar_CommandPS(t *testing.T) {
	r, _ := http.NewRequest("GET", "/misconfig/vulnerable?cmd=ps", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "bvwa-server") {
		t.Error("[A02 Kwetsbaar] cmd=ps: 'bvwa-server' ontbreekt in response")
	}
}

func TestA02_Kwetsbaar_CommandOnbekend_CommandNotFound(t *testing.T) {
	r, _ := http.NewRequest("GET", "/misconfig/vulnerable?cmd=nmap", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "command not found") {
		t.Error("[A02 Kwetsbaar] cmd=nmap: 'command not found' ontbreekt in response")
	}
}

func TestA02_Kwetsbaar_GeenAuth_Vereist(t *testing.T) {
	// Kerntest: het endpoint is zonder sessie of credentials bereikbaar
	r, _ := http.NewRequest("GET", "/misconfig/vulnerable?cmd=whoami", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code == http.StatusFound || w.Code == http.StatusUnauthorized || w.Code == http.StatusForbidden {
		t.Errorf("[A02 Kwetsbaar] endpoint blokkeert ongeauthenticeerde toegang (code %d), verwacht 200", w.Code)
	}
	if w.Code != http.StatusOK {
		t.Errorf("[A02 Kwetsbaar] verwacht 200, kreeg %d", w.Code)
	}
}

// ── Veilige versie ────────────────────────────────────────────────────────────

func TestA02_Veilig_StatusOK(t *testing.T) {
	r, _ := http.NewRequest("GET", "/misconfig/secure", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code != http.StatusOK {
		t.Errorf("[A02 Veilig] verwacht 200, kreeg %d", w.Code)
	}
}

func TestA02_Veilig_XContentTypeOptions(t *testing.T) {
	r, _ := http.NewRequest("GET", "/misconfig/secure", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if v := w.Header().Get("X-Content-Type-Options"); v != "nosniff" {
		t.Errorf("[A02 Veilig] X-Content-Type-Options: verwacht 'nosniff', kreeg '%s'", v)
	}
}

func TestA02_Veilig_XFrameOptions(t *testing.T) {
	r, _ := http.NewRequest("GET", "/misconfig/secure", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if v := w.Header().Get("X-Frame-Options"); v != "DENY" {
		t.Errorf("[A02 Veilig] X-Frame-Options: verwacht 'DENY', kreeg '%s'", v)
	}
}

func TestA02_Veilig_CSP(t *testing.T) {
	r, _ := http.NewRequest("GET", "/misconfig/secure", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	csp := w.Header().Get("Content-Security-Policy")
	if !strings.Contains(csp, "default-src 'self'") {
		t.Errorf("[A02 Veilig] CSP ontbreekt of onjuist: '%s'", csp)
	}
}

func TestA02_Veilig_HSTS(t *testing.T) {
	r, _ := http.NewRequest("GET", "/misconfig/secure", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	hsts := w.Header().Get("Strict-Transport-Security")
	if !strings.Contains(hsts, "max-age=63072000") {
		t.Errorf("[A02 Veilig] HSTS onjuist: '%s'", hsts)
	}
}

func TestA02_Veilig_ReferrerPolicy(t *testing.T) {
	r, _ := http.NewRequest("GET", "/misconfig/secure", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	rp := w.Header().Get("Referrer-Policy")
	if rp == "" {
		t.Error("[A02 Veilig] Referrer-Policy ontbreekt")
	}
}

func TestA02_Veilig_PermissionsPolicy(t *testing.T) {
	r, _ := http.NewRequest("GET", "/misconfig/secure", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	pp := w.Header().Get("Permissions-Policy")
	if pp == "" {
		t.Error("[A02 Veilig] Permissions-Policy ontbreekt")
	}
}

func TestA02_Veilig_GeenDebugHeaders(t *testing.T) {
	r, _ := http.NewRequest("GET", "/misconfig/secure", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if v := w.Header().Get("X-Powered-By"); v != "" {
		t.Errorf("[A02 Veilig] X-Powered-By aanwezig terwijl verwacht afwezig: '%s'", v)
	}
	if v := w.Header().Get("X-CTF-Flag"); v != "" {
		t.Errorf("[A02 Veilig] X-CTF-Flag aanwezig terwijl verwacht afwezig: '%s'", v)
	}
}

func TestA02_Veilig_GeenCommandOutput(t *testing.T) {
	// Kerntest: de veilige versie voert geen commando's uit, ook niet via ?cmd=
	r, _ := http.NewRequest("GET", "/misconfig/secure?cmd=env", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	body := w.Body.String()
	if strings.Contains(body, "DB_PASSWORD") {
		t.Error("[A02 Veilig] cmd=env: DB_PASSWORD onterecht aanwezig in response")
	}
	if strings.Contains(body, "BVWA_FLAG=") {
		t.Error("[A02 Veilig] cmd=env: BVWA_FLAG onterecht aanwezig in response")
	}
}

// ── Statisch bestand (openbare misconfiguratie) ───────────────────────────────

func TestA02_SecretFile_Toegankelijk(t *testing.T) {
	r, _ := http.NewRequest("GET", "/static/misconfig/files/secret.txt", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code != http.StatusOK {
		t.Errorf("[A02] secret.txt: verwacht 200, kreeg %d", w.Code)
	}
}

func TestA02_SecretFile_BevatCTFFlag(t *testing.T) {
	r, _ := http.NewRequest("GET", "/static/misconfig/files/secret.txt", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "BVWA{M1scC0nf1g_D1r_2026}") {
		t.Error("[A02] secret.txt: CTF flag niet gevonden in bestand")
	}
}
