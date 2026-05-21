package test

// ─── A05: Injection (SQL & XSS) ───────────────────────────────────────────────
//
// Scenario SQL: MegaCorp medewerkersdirectory — kwetsbaar via string concatenatie,
//               veilig via geparametriseerde query.
// Scenario XSS: BvwAshop productzoeker — kwetsbaar via str2html (raw output),
//               veilig via automatische Beego-escaping.

import (
	"net/http"
	"net/http/httptest"
	"net/url"
	"strings"
	"testing"

	beego "github.com/beego/beego/v2/server/web"
)

// sqlGET stuurt een GET naar het SQL-injection endpoint met naam als query-parameter.
func sqlGET(path, name string) *httptest.ResponseRecorder {
	params := url.Values{}
	if name != "" {
		params.Set("name", name)
	}
	fullURL := path
	if len(params) > 0 {
		fullURL = path + "?" + params.Encode()
	}
	r, _ := http.NewRequest("GET", fullURL, nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)
	return w
}

// xssGET stuurt een GET naar het XSS-injection endpoint met q als query-parameter.
func xssGET(path, q string) *httptest.ResponseRecorder {
	params := url.Values{}
	if q != "" {
		params.Set("q", q)
	}
	fullURL := path
	if len(params) > 0 {
		fullURL = path + "?" + params.Encode()
	}
	r, _ := http.NewRequest("GET", fullURL, nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)
	return w
}

// ─── SQL Injection: kwetsbare versie ─────────────────────────────────────────

func TestA05_SQL_Kwetsbaar_Startpagina(t *testing.T) {
	w := sqlGET("/injection/sql/vulnerable", "")
	if w.Code != http.StatusOK {
		t.Errorf("[A05 SQL Kwetsbaar] Startpagina: verwacht 200, kreeg %d", w.Code)
	}
}

func TestA05_SQL_Kwetsbaar_GeldigeNaam(t *testing.T) {
	w := sqlGET("/injection/sql/vulnerable", "alice")
	if w.Code != http.StatusOK {
		t.Errorf("[A05 SQL Kwetsbaar] Zoek 'alice': verwacht 200, kreeg %d", w.Code)
	}
	body := w.Body.String()
	if !strings.Contains(body, "Alice Jansen") {
		t.Error("[A05 SQL Kwetsbaar] Zoek 'alice': 'Alice Jansen' niet gevonden in response")
	}
}

func TestA05_SQL_Kwetsbaar_DeelNaam(t *testing.T) {
	w := sqlGET("/injection/sql/vulnerable", "de Vries")
	if w.Code != http.StatusOK {
		t.Errorf("[A05 SQL Kwetsbaar] Zoek 'de Vries': verwacht 200, kreeg %d", w.Code)
	}
	body := w.Body.String()
	if !strings.Contains(body, "Bob de Vries") {
		t.Error("[A05 SQL Kwetsbaar] Zoek 'de Vries': 'Bob de Vries' niet gevonden in response")
	}
}

func TestA05_SQL_Kwetsbaar_GeenResultaat(t *testing.T) {
	w := sqlGET("/injection/sql/vulnerable", "zzznietbestaand")
	if w.Code != http.StatusOK {
		t.Errorf("[A05 SQL Kwetsbaar] Zoek onbekende naam: verwacht 200, kreeg %d", w.Code)
	}
	body := w.Body.String()
	if strings.Contains(body, "injection geslaagd") {
		t.Error("[A05 SQL Kwetsbaar] Onbekende naam mag geen injection triggeren")
	}
}

func TestA05_SQL_Kwetsbaar_TautologieInjectie(t *testing.T) {
	w := sqlGET("/injection/sql/vulnerable", "' OR '1'='1")
	if w.Code != http.StatusOK {
		t.Errorf("[A05 SQL Kwetsbaar] Tautologie: verwacht 200, kreeg %d", w.Code)
	}
	body := w.Body.String()
	if !strings.Contains(body, "injection geslaagd") {
		t.Error("[A05 SQL Kwetsbaar] Tautologie: injectie-indicator 'injection geslaagd' ontbreekt")
	}
}

func TestA05_SQL_Kwetsbaar_TautologieGeeftAlleRecords(t *testing.T) {
	w := sqlGET("/injection/sql/vulnerable", "' OR '1'='1")
	body := w.Body.String()
	// Alle reguliere medewerkers moeten zichtbaar zijn
	for _, name := range []string{"Alice Jansen", "Bob de Vries", "Carol Peters", "Dave Smit"} {
		if !strings.Contains(body, name) {
			t.Errorf("[A05 SQL Kwetsbaar] Tautologie: '%s' ontbreekt in volledig gelekt resultaat", name)
		}
	}
}

func TestA05_SQL_Kwetsbaar_TautologieGeeftHiddenRecord(t *testing.T) {
	w := sqlGET("/injection/sql/vulnerable", "' OR '1'='1")
	body := w.Body.String()
	if !strings.Contains(body, "db_admin") {
		t.Error("[A05 SQL Kwetsbaar] Tautologie: verborgen 'db_admin' record niet blootgesteld")
	}
}

func TestA05_SQL_Kwetsbaar_CTFFlagViaInjectie(t *testing.T) {
	w := sqlGET("/injection/sql/vulnerable", "' OR '1'='1")
	body := w.Body.String()
	if !strings.Contains(body, "BVWA{SQLi_D1r3ct0ry_2026}") {
		t.Error("[A05 SQL Kwetsbaar] CTF-flag 'BVWA{SQLi_D1r3ct0ry_2026}' niet gevonden via injectie")
	}
}

func TestA05_SQL_Kwetsbaar_CommentInjectie(t *testing.T) {
	// admin'-- omzeilt de rest van de WHERE-conditie
	w := sqlGET("/injection/sql/vulnerable", "admin'--")
	if w.Code != http.StatusOK {
		t.Errorf("[A05 SQL Kwetsbaar] Comment-injectie: verwacht 200, kreeg %d", w.Code)
	}
	body := w.Body.String()
	if !strings.Contains(body, "injection geslaagd") {
		t.Error("[A05 SQL Kwetsbaar] Comment-injectie (admin'--): injectie-indicator ontbreekt")
	}
}

func TestA05_SQL_Kwetsbaar_UnionInjectie(t *testing.T) {
	w := sqlGET("/injection/sql/vulnerable", "' UNION SELECT * FROM employees--")
	if w.Code != http.StatusOK {
		t.Errorf("[A05 SQL Kwetsbaar] UNION-injectie: verwacht 200, kreeg %d", w.Code)
	}
	body := w.Body.String()
	if !strings.Contains(body, "injection geslaagd") {
		t.Error("[A05 SQL Kwetsbaar] UNION-injectie: injectie-indicator ontbreekt")
	}
}

func TestA05_SQL_Kwetsbaar_TautologieVariant_OR1Is1(t *testing.T) {
	// Variant: ' OR 1=1--
	w := sqlGET("/injection/sql/vulnerable", "' OR 1=1--")
	body := w.Body.String()
	if !strings.Contains(body, "injection geslaagd") {
		t.Error("[A05 SQL Kwetsbaar] ' OR 1=1-- variant: injectie-indicator ontbreekt")
	}
}

func TestA05_SQL_Kwetsbaar_CTFHeader(t *testing.T) {
	w := sqlGET("/injection/sql/vulnerable", "")
	if w.Header().Get("X-CTF-Flag") == "" {
		t.Error("[A05 SQL Kwetsbaar] X-CTF-Flag header ontbreekt")
	}
}

// ─── SQL Injection: veilige versie ───────────────────────────────────────────

func TestA05_SQL_Veilig_Startpagina(t *testing.T) {
	w := sqlGET("/injection/sql/secure", "")
	if w.Code != http.StatusOK {
		t.Errorf("[A05 SQL Veilig] Startpagina: verwacht 200, kreeg %d", w.Code)
	}
}

func TestA05_SQL_Veilig_GeldigeNaam(t *testing.T) {
	w := sqlGET("/injection/sql/secure", "alice")
	if w.Code != http.StatusOK {
		t.Errorf("[A05 SQL Veilig] Zoek 'alice': verwacht 200, kreeg %d", w.Code)
	}
	body := w.Body.String()
	if !strings.Contains(body, "Alice Jansen") {
		t.Error("[A05 SQL Veilig] Zoek 'alice': 'Alice Jansen' niet gevonden in response")
	}
}

func TestA05_SQL_Veilig_TautologieBlokkeerd(t *testing.T) {
	w := sqlGET("/injection/sql/secure", "' OR '1'='1")
	if w.Code != http.StatusOK {
		t.Errorf("[A05 SQL Veilig] Tautologie: verwacht 200, kreeg %d", w.Code)
	}
	body := w.Body.String()
	if strings.Contains(body, "injection geslaagd") {
		t.Error("[A05 SQL Veilig] Tautologie mag GEEN injectie triggeren in veilige versie")
	}
}

func TestA05_SQL_Veilig_TautologieGeeftGeenExtraRecords(t *testing.T) {
	w := sqlGET("/injection/sql/secure", "' OR '1'='1")
	body := w.Body.String()
	if strings.Contains(body, "BVWA{SQLi_D1r3ct0ry_2026}") {
		t.Error("[A05 SQL Veilig] Tautologie: CTF-flag mag niet zichtbaar zijn via geparametriseerde query")
	}
}

func TestA05_SQL_Veilig_CommentInjectieBlokkeerd(t *testing.T) {
	w := sqlGET("/injection/sql/secure", "admin'--")
	body := w.Body.String()
	if strings.Contains(body, "injection geslaagd") {
		t.Error("[A05 SQL Veilig] Comment-injectie mag GEEN injectie triggeren in veilige versie")
	}
}

func TestA05_SQL_Veilig_UnionInjectieBlokkeerd(t *testing.T) {
	w := sqlGET("/injection/sql/secure", "' UNION SELECT * FROM employees--")
	body := w.Body.String()
	if strings.Contains(body, "injection geslaagd") {
		t.Error("[A05 SQL Veilig] UNION-injectie mag GEEN injectie triggeren in veilige versie")
	}
}

// ─── XSS: kwetsbare versie ────────────────────────────────────────────────────

func TestA05_XSS_Kwetsbaar_Startpagina(t *testing.T) {
	w := xssGET("/injection/xss/vulnerable", "")
	if w.Code != http.StatusOK {
		t.Errorf("[A05 XSS Kwetsbaar] Startpagina: verwacht 200, kreeg %d", w.Code)
	}
}

func TestA05_XSS_Kwetsbaar_NormaleInput(t *testing.T) {
	w := xssGET("/injection/xss/vulnerable", "laptop")
	if w.Code != http.StatusOK {
		t.Errorf("[A05 XSS Kwetsbaar] Normale input: verwacht 200, kreeg %d", w.Code)
	}
	body := w.Body.String()
	if !strings.Contains(body, "laptop") {
		t.Error("[A05 XSS Kwetsbaar] Normale input 'laptop' niet teruggegeven in response")
	}
}

func TestA05_XSS_Kwetsbaar_ScriptTagRawGereflecteerd(t *testing.T) {
	// Script-tag moet als raw HTML in de body staan (niet geescaped)
	w := xssGET("/injection/xss/vulnerable", "<script>alert('xss')</script>")
	body := w.Body.String()
	if !strings.Contains(body, "<script>alert") {
		t.Error("[A05 XSS Kwetsbaar] Script-tag niet als raw HTML gereflecteerd")
	}
}

func TestA05_XSS_Kwetsbaar_ImgOnerrorGereflecteerd(t *testing.T) {
	w := xssGET("/injection/xss/vulnerable", "<img src=x onerror=alert(1)>")
	body := w.Body.String()
	if !strings.Contains(body, "<img") {
		t.Error("[A05 XSS Kwetsbaar] img-tag niet als raw HTML gereflecteerd")
	}
}

func TestA05_XSS_Kwetsbaar_CTFHeader(t *testing.T) {
	w := xssGET("/injection/xss/vulnerable", "")
	if w.Header().Get("X-CTF-Flag") == "" {
		t.Error("[A05 XSS Kwetsbaar] X-CTF-Flag header ontbreekt")
	}
	if w.Header().Get("X-CTF-Flag") != "BVWA{XSS_R3fl3ct3d_2026}" {
		t.Errorf("[A05 XSS Kwetsbaar] Verkeerde CTF-flag: %s", w.Header().Get("X-CTF-Flag"))
	}
}

// ─── XSS: veilige versie ──────────────────────────────────────────────────────

func TestA05_XSS_Veilig_Startpagina(t *testing.T) {
	w := xssGET("/injection/xss/secure", "")
	if w.Code != http.StatusOK {
		t.Errorf("[A05 XSS Veilig] Startpagina: verwacht 200, kreeg %d", w.Code)
	}
}

func TestA05_XSS_Veilig_NormaleInput(t *testing.T) {
	w := xssGET("/injection/xss/secure", "laptop")
	if w.Code != http.StatusOK {
		t.Errorf("[A05 XSS Veilig] Normale input: verwacht 200, kreeg %d", w.Code)
	}
	body := w.Body.String()
	if !strings.Contains(body, "laptop") {
		t.Error("[A05 XSS Veilig] Normale input 'laptop' niet teruggegeven in response")
	}
}

func TestA05_XSS_Veilig_ScriptTagGeescaped(t *testing.T) {
	w := xssGET("/injection/xss/secure", "<script>alert('xss')</script>")
	body := w.Body.String()
	// Beego escapet < naar &lt; en > naar &gt;
	if !strings.Contains(body, "&lt;script&gt;") {
		t.Error("[A05 XSS Veilig] Script-tag niet geescaped: '&lt;script&gt;' ontbreekt in response")
	}
	// Rauw script-tag mag NIET in de body staan
	if strings.Contains(body, "<script>alert") {
		t.Error("[A05 XSS Veilig] Rauwe script-tag gevonden — escaping werkt niet!")
	}
}

func TestA05_XSS_Veilig_ImgOnerrorGeescaped(t *testing.T) {
	w := xssGET("/injection/xss/secure", "<img src=x onerror=alert(1)>")
	body := w.Body.String()
	if !strings.Contains(body, "&lt;img") {
		t.Error("[A05 XSS Veilig] img-tag niet geescaped: '&lt;img' ontbreekt in response")
	}
	if strings.Contains(body, "<img src=x onerror=") {
		t.Error("[A05 XSS Veilig] Rauwe img-tag met onerror gevonden — escaping werkt niet!")
	}
}

func TestA05_XSS_Veilig_HoekigeHaakjesGeescaped(t *testing.T) {
	w := xssGET("/injection/xss/secure", "<b>bold</b>")
	body := w.Body.String()
	if strings.Contains(body, "<b>bold</b>") && !strings.Contains(body, "&lt;b&gt;") {
		t.Error("[A05 XSS Veilig] HTML-tags niet geescaped in veilige versie")
	}
}
