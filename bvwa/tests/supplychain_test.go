package test

import (
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	beego "github.com/beego/beego/v2/server/web"
)

// ─── A03: Software Supply Chain Failures ──────────────────────────────────────
//
// Scenario: bvwa-logger@2.1.3 is getamperd door een aanvaller.
// De kwetsbare package manager installeert het zonder checksum verificatie;
// de malicieuze postinstall hook lekt de CTF-flag.
// De veilige manager detecteert de manipulatie en weigert het pakket.

// ── Kwetsbare versie ──────────────────────────────────────────────────────────

func TestA03_Kwetsbaar_StatusOK(t *testing.T) {
	r, _ := http.NewRequest("GET", "/supplychain/vulnerable", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code != http.StatusOK {
		t.Errorf("[A03 Kwetsbaar] verwacht 200, kreeg %d", w.Code)
	}
}

func TestA03_Kwetsbaar_LandingPage_ToonsPkgManager(t *testing.T) {
	r, _ := http.NewRequest("GET", "/supplychain/vulnerable", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "bvwa-pkg") {
		t.Error("[A03 Kwetsbaar] landing page: 'bvwa-pkg' ontbreekt in body")
	}
}

func TestA03_Kwetsbaar_CommandList_ToonPackages(t *testing.T) {
	r, _ := http.NewRequest("GET", "/supplychain/vulnerable?cmd=list", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	body := w.Body.String()
	for _, pkg := range []string{"bvwa-utils", "bvwa-logger", "bvwa-crypto", "bvwa-auth"} {
		if !strings.Contains(body, pkg) {
			t.Errorf("[A03 Kwetsbaar] cmd=list: '%s' ontbreekt in response", pkg)
		}
	}
}

func TestA03_Kwetsbaar_CommandInfo_Logger_ToonMetadata(t *testing.T) {
	r, _ := http.NewRequest("GET", "/supplychain/vulnerable?cmd=info+bvwa-logger", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	body := w.Body.String()
	if !strings.Contains(body, "bvwa-logger") {
		t.Error("[A03 Kwetsbaar] cmd=info bvwa-logger: 'bvwa-logger' ontbreekt")
	}
	if !strings.Contains(body, "2.1.3") {
		t.Error("[A03 Kwetsbaar] cmd=info bvwa-logger: versie '2.1.3' ontbreekt")
	}
	if !strings.Contains(body, "Postinstall") {
		t.Error("[A03 Kwetsbaar] cmd=info bvwa-logger: 'Postinstall' ontbreekt (postinstall hook niet zichtbaar)")
	}
}

func TestA03_Kwetsbaar_CommandInfo_Onbekend_NietGevonden(t *testing.T) {
	r, _ := http.NewRequest("GET", "/supplychain/vulnerable?cmd=info+kwaadaardig-pkg", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "not found") {
		t.Error("[A03 Kwetsbaar] cmd=info kwaadaardig-pkg: 'not found' ontbreekt")
	}
}

func TestA03_Kwetsbaar_CommandInstall_Logger_CTFFlag(t *testing.T) {
	// Kerntest: installeren van getamperd pakket onthult de CTF-flag via postinstall hook
	r, _ := http.NewRequest("GET", "/supplychain/vulnerable?cmd=install+bvwa-logger", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "BVWA{Supp1y_Ch41n_2026}") {
		t.Error("[A03 Kwetsbaar] cmd=install bvwa-logger: CTF flag ontbreekt in response")
	}
}

func TestA03_Kwetsbaar_CommandInstall_Logger_ChecksumOvergeslagen(t *testing.T) {
	// Verificatie wordt overgeslagen — de kernkwetsbaarheid (CWE-494)
	r, _ := http.NewRequest("GET", "/supplychain/vulnerable?cmd=install+bvwa-logger", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "SKIPPED") {
		t.Error("[A03 Kwetsbaar] cmd=install bvwa-logger: 'SKIPPED' ontbreekt (checksum zou overgeslagen moeten zijn)")
	}
}

func TestA03_Kwetsbaar_CommandInstall_Logger_PostinstallUitgevoerd(t *testing.T) {
	r, _ := http.NewRequest("GET", "/supplychain/vulnerable?cmd=install+bvwa-logger", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "postinstall") {
		t.Error("[A03 Kwetsbaar] cmd=install bvwa-logger: 'postinstall' ontbreekt (hook zou moeten draaien)")
	}
}

func TestA03_Kwetsbaar_CommandInstall_Logger_Succeeds(t *testing.T) {
	r, _ := http.NewRequest("GET", "/supplychain/vulnerable?cmd=install+bvwa-logger", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "Successfully installed") {
		t.Error("[A03 Kwetsbaar] cmd=install bvwa-logger: 'Successfully installed' ontbreekt")
	}
}

func TestA03_Kwetsbaar_CommandInstall_Utils_Succeeds(t *testing.T) {
	r, _ := http.NewRequest("GET", "/supplychain/vulnerable?cmd=install+bvwa-utils", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "Successfully installed bvwa-utils") {
		t.Error("[A03 Kwetsbaar] cmd=install bvwa-utils: 'Successfully installed bvwa-utils' ontbreekt")
	}
}

func TestA03_Kwetsbaar_CommandInstall_Onbekend_NietGevonden(t *testing.T) {
	r, _ := http.NewRequest("GET", "/supplychain/vulnerable?cmd=install+evil-pkg", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "not found") {
		t.Error("[A03 Kwetsbaar] cmd=install evil-pkg: 'not found' ontbreekt")
	}
}

func TestA03_Kwetsbaar_CommandVerify_Uitgeschakeld(t *testing.T) {
	r, _ := http.NewRequest("GET", "/supplychain/vulnerable?cmd=verify+bvwa-logger", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "disabled") {
		t.Error("[A03 Kwetsbaar] cmd=verify bvwa-logger: 'disabled' ontbreekt (verificatie zou uitgeschakeld moeten zijn)")
	}
}

func TestA03_Kwetsbaar_CommandAudit_Overgeslagen(t *testing.T) {
	r, _ := http.NewRequest("GET", "/supplychain/vulnerable?cmd=audit", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "skipped") {
		t.Error("[A03 Kwetsbaar] cmd=audit: 'skipped' ontbreekt (audit zou overgeslagen moeten zijn)")
	}
}

func TestA03_Kwetsbaar_CommandSearch_FingtLogger(t *testing.T) {
	r, _ := http.NewRequest("GET", "/supplychain/vulnerable?cmd=search+logger", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "bvwa-logger") {
		t.Error("[A03 Kwetsbaar] cmd=search logger: 'bvwa-logger' ontbreekt in zoekresultaat")
	}
}

func TestA03_Kwetsbaar_CommandSearch_GeenResultaat(t *testing.T) {
	r, _ := http.NewRequest("GET", "/supplychain/vulnerable?cmd=search+xyznonexistent", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "No packages found") {
		t.Error("[A03 Kwetsbaar] cmd=search xyznonexistent: 'No packages found' ontbreekt")
	}
}

func TestA03_Kwetsbaar_CommandOnbekend(t *testing.T) {
	r, _ := http.NewRequest("GET", "/supplychain/vulnerable?cmd=hack", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "unknown command") {
		t.Error("[A03 Kwetsbaar] cmd=hack: 'unknown command' ontbreekt in response")
	}
}

// ── Veilige versie ────────────────────────────────────────────────────────────

func TestA03_Veilig_StatusOK(t *testing.T) {
	r, _ := http.NewRequest("GET", "/supplychain/secure", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if w.Code != http.StatusOK {
		t.Errorf("[A03 Veilig] verwacht 200, kreeg %d", w.Code)
	}
}

func TestA03_Veilig_CommandInstall_Logger_Geblokkeerd(t *testing.T) {
	// Kerntest: getamperd pakket wordt geweigerd door checksumverificatie
	r, _ := http.NewRequest("GET", "/supplychain/secure?cmd=install+bvwa-logger", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "aborted") {
		t.Error("[A03 Veilig] cmd=install bvwa-logger: 'aborted' ontbreekt (installatie zou gestopt moeten zijn)")
	}
}

func TestA03_Veilig_CommandInstall_Logger_ChecksumMismatch(t *testing.T) {
	r, _ := http.NewRequest("GET", "/supplychain/secure?cmd=install+bvwa-logger", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "MISMATCH") {
		t.Error("[A03 Veilig] cmd=install bvwa-logger: 'MISMATCH' ontbreekt")
	}
}

func TestA03_Veilig_CommandInstall_Logger_GeenCTFFlag(t *testing.T) {
	// Verificatie blokkeert uitvoering van postinstall hook → geen flag lek
	r, _ := http.NewRequest("GET", "/supplychain/secure?cmd=install+bvwa-logger", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if strings.Contains(w.Body.String(), "BVWA{Supp1y_Ch41n_2026}") {
		t.Error("[A03 Veilig] cmd=install bvwa-logger: CTF flag onterecht aanwezig in response")
	}
}

func TestA03_Veilig_CommandInstall_Utils_Succeeds(t *testing.T) {
	// Geldige pakketten kunnen wel worden geinstalleerd
	r, _ := http.NewRequest("GET", "/supplychain/secure?cmd=install+bvwa-utils", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "Successfully installed bvwa-utils") {
		t.Error("[A03 Veilig] cmd=install bvwa-utils: 'Successfully installed bvwa-utils' ontbreekt")
	}
}

func TestA03_Veilig_CommandInstall_Utils_ChecksumOK(t *testing.T) {
	r, _ := http.NewRequest("GET", "/supplychain/secure?cmd=install+bvwa-utils", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "OK") {
		t.Error("[A03 Veilig] cmd=install bvwa-utils: checksum 'OK' ontbreekt")
	}
}

func TestA03_Veilig_CommandVerify_Logger_MISMATCH(t *testing.T) {
	r, _ := http.NewRequest("GET", "/supplychain/secure?cmd=verify+bvwa-logger", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "MISMATCH") {
		t.Error("[A03 Veilig] cmd=verify bvwa-logger: 'MISMATCH' ontbreekt")
	}
}

func TestA03_Veilig_CommandVerify_Utils_OK(t *testing.T) {
	r, _ := http.NewRequest("GET", "/supplychain/secure?cmd=verify+bvwa-utils", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "Status: OK") {
		t.Error("[A03 Veilig] cmd=verify bvwa-utils: 'Status: OK' ontbreekt")
	}
}

func TestA03_Veilig_CommandAudit_DetecteertTampered(t *testing.T) {
	r, _ := http.NewRequest("GET", "/supplychain/secure?cmd=audit", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	body := w.Body.String()
	if !strings.Contains(body, "TAMPERED") {
		t.Error("[A03 Veilig] cmd=audit: 'TAMPERED' ontbreekt in auditresultaat")
	}
	if !strings.Contains(body, "bvwa-logger") {
		t.Error("[A03 Veilig] cmd=audit: 'bvwa-logger' ontbreekt in auditresultaat")
	}
}

func TestA03_Veilig_CommandAudit_RapporteertProbleem(t *testing.T) {
	r, _ := http.NewRequest("GET", "/supplychain/secure?cmd=audit", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "critical issue") {
		t.Error("[A03 Veilig] cmd=audit: 'critical issue' ontbreekt in auditrapport")
	}
}

func TestA03_Veilig_CommandList_ToonPackages(t *testing.T) {
	r, _ := http.NewRequest("GET", "/supplychain/secure?cmd=list", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "bvwa-logger") {
		t.Error("[A03 Veilig] cmd=list: 'bvwa-logger' ontbreekt")
	}
}

func TestA03_Veilig_CommandSearch_FingtLogger(t *testing.T) {
	r, _ := http.NewRequest("GET", "/supplychain/secure?cmd=search+logger", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "bvwa-logger") {
		t.Error("[A03 Veilig] cmd=search logger: 'bvwa-logger' ontbreekt")
	}
}

func TestA03_Veilig_CommandOnbekend(t *testing.T) {
	r, _ := http.NewRequest("GET", "/supplychain/secure?cmd=hack", nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	if !strings.Contains(w.Body.String(), "unknown command") {
		t.Error("[A03 Veilig] cmd=hack: 'unknown command' ontbreekt")
	}
}
