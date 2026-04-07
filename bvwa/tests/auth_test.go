package test

// ─── A07: Authentication Failures ────────────────────────────────────────────
//
// Scenario: bvwa-auth — corporate authentication gateway van BVWA Corp.
// Kwetsbaar: plaintext (CWE-256), user enumeration (CWE-204), geen rate limiting (CWE-307),
//            voorspelbaar sessietoken (CWE-330), expliciet enum-endpoint (CWE-203).
// Veilig:    bcrypt, generieke foutmeldingen, rate limiting (max 5/IP), random token.

import (
	"net/http"
	"net/http/httptest"
	"net/url"
	"strings"
	"testing"

	"bvwa/controllers"
	beego "github.com/beego/beego/v2/server/web"
)

// authGET stuurt een GET naar een auth-endpoint met cmd als query-parameter.
// RemoteAddr is bewust leeg — alle tests delen IP "" in de rate limiter.
func authGET(path, cmd string) *httptest.ResponseRecorder {
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

func TestA07_Kwetsbaar_Startpagina(t *testing.T) {
	w := authGET("/auth/vulnerable", "")
	if w.Code != http.StatusOK {
		t.Errorf("[A07 Kwetsbaar] Startpagina: verwacht 200, kreeg %d", w.Code)
	}
}

func TestA07_Kwetsbaar_Startpagina_BevatTerminal(t *testing.T) {
	w := authGET("/auth/vulnerable", "")
	if !strings.Contains(w.Body.String(), "bvwa-auth") {
		t.Error("[A07 Kwetsbaar] Startpagina: 'bvwa-auth' ontbreekt")
	}
}

func TestA07_Kwetsbaar_Help_ToontCommands(t *testing.T) {
	w := authGET("/auth/vulnerable", "help")
	body := w.Body.String()
	for _, cmd := range []string{"login", "enum", "session"} {
		if !strings.Contains(body, cmd) {
			t.Errorf("[A07 Kwetsbaar] help: opdracht '%s' ontbreekt", cmd)
		}
	}
}

func TestA07_Kwetsbaar_Login_GeldigeCredentials_Admin(t *testing.T) {
	w := authGET("/auth/vulnerable", "login admin admin123")
	if w.Code != http.StatusOK {
		t.Errorf("[A07 Kwetsbaar] login admin: verwacht 200, kreeg %d", w.Code)
	}
	body := w.Body.String()
	if !strings.Contains(body, "Authenticatie geslaagd") {
		t.Error("[A07 Kwetsbaar] login admin: 'Authenticatie geslaagd' ontbreekt")
	}
}

func TestA07_Kwetsbaar_Login_GeldigeCredentials_Support(t *testing.T) {
	w := authGET("/auth/vulnerable", "login support support")
	body := w.Body.String()
	if !strings.Contains(body, "Authenticatie geslaagd") {
		t.Error("[A07 Kwetsbaar] login support: 'Authenticatie geslaagd' ontbreekt")
	}
}

func TestA07_Kwetsbaar_Login_GeldigeCredentials_CTFFlagInBody(t *testing.T) {
	w := authGET("/auth/vulnerable", "login admin admin123")
	if !strings.Contains(w.Body.String(), "BVWA{Brute_F0rc3_2026}") {
		t.Error("[A07 Kwetsbaar] login admin: CTF-flag 'BVWA{Brute_F0rc3_2026}' ontbreekt in body")
	}
}

func TestA07_Kwetsbaar_Login_GeldigeCredentials_CTFFlagInHeader(t *testing.T) {
	w := authGET("/auth/vulnerable", "login admin admin123")
	if w.Header().Get("X-CTF-Flag") != "BVWA{Brute_F0rc3_2026}" {
		t.Errorf("[A07 Kwetsbaar] login admin: X-CTF-Flag header onjuist: '%s'", w.Header().Get("X-CTF-Flag"))
	}
}

func TestA07_Kwetsbaar_Login_GeldigeCredentials_ToontSessietoken(t *testing.T) {
	w := authGET("/auth/vulnerable", "login admin admin123")
	if !strings.Contains(w.Body.String(), "sess_00042") {
		t.Error("[A07 Kwetsbaar] login admin: voorspelbaar sessietoken 'sess_00042' ontbreekt")
	}
}

func TestA07_Kwetsbaar_Login_OnbekendGebruiker_OnthultNietBestaan(t *testing.T) {
	// CWE-204: andere foutmelding voor onbekende gebruiker → user enumeration mogelijk
	w := authGET("/auth/vulnerable", "login ghost wrongpass")
	body := w.Body.String()
	if !strings.Contains(body, "bestaat niet") {
		t.Error("[A07 Kwetsbaar] login onbekend: 'bestaat niet' ontbreekt — enumeration werkt niet")
	}
	// Mag NIET zeggen dat login geslaagd is
	if strings.Contains(body, "Authenticatie geslaagd") {
		t.Error("[A07 Kwetsbaar] login onbekend: mag niet slagen")
	}
}

func TestA07_Kwetsbaar_Login_BestaandeGebruiker_OnjuistWachtwoord_AndereBoodschap(t *testing.T) {
	// CWE-204: andere foutmelding voor bestaande gebruiker → user enumeration mogelijk
	w := authGET("/auth/vulnerable", "login admin foutpassword")
	body := w.Body.String()
	if !strings.Contains(body, "onjuist wachtwoord") {
		t.Error("[A07 Kwetsbaar] login fout ww: 'onjuist wachtwoord' ontbreekt — enumeration werkt niet")
	}
}

func TestA07_Kwetsbaar_Login_GeenRateLimiting(t *testing.T) {
	// Geen rate limiting: 10 mislukte pogingen moeten allemaal "onjuist wachtwoord" teruggeven,
	// nooit "Te veel mislukte pogingen" (dat is de rate-limit boodschap van de veilige versie).
	for i := 0; i < 10; i++ {
		w := authGET("/auth/vulnerable", "login admin fout")
		if w.Code != http.StatusOK {
			t.Errorf("[A07 Kwetsbaar] geen rate limiting: poging %d gaf code %d", i+1, w.Code)
		}
		if strings.Contains(w.Body.String(), "Te veel mislukte pogingen") {
			t.Errorf("[A07 Kwetsbaar] geen rate limiting: geblokkeerd na poging %d — rate limiting mag niet actief zijn", i+1)
		}
	}
}

func TestA07_Kwetsbaar_Login_GeenCTFFlagBijMislukking(t *testing.T) {
	w := authGET("/auth/vulnerable", "login admin fout")
	if w.Header().Get("X-CTF-Flag") != "" {
		t.Error("[A07 Kwetsbaar] mislukte login: X-CTF-Flag mag niet aanwezig zijn")
	}
}

func TestA07_Kwetsbaar_Enum_BestaandeGebruiker(t *testing.T) {
	// CWE-203: expliciet enumeration-endpoint
	w := authGET("/auth/vulnerable", "enum admin")
	if !strings.Contains(w.Body.String(), "BESTAAT") {
		t.Error("[A07 Kwetsbaar] enum admin: 'BESTAAT' ontbreekt")
	}
}

func TestA07_Kwetsbaar_Enum_OnbekendGebruiker(t *testing.T) {
	w := authGET("/auth/vulnerable", "enum ghost")
	if !strings.Contains(w.Body.String(), "NIET GEVONDEN") {
		t.Error("[A07 Kwetsbaar] enum ghost: 'NIET GEVONDEN' ontbreekt")
	}
}

func TestA07_Kwetsbaar_Enum_MeerdereGebruikers(t *testing.T) {
	for _, user := range []string{"admin", "support", "backup"} {
		w := authGET("/auth/vulnerable", "enum "+user)
		if !strings.Contains(w.Body.String(), "BESTAAT") {
			t.Errorf("[A07 Kwetsbaar] enum %s: 'BESTAAT' ontbreekt", user)
		}
	}
}

func TestA07_Kwetsbaar_Session_ToontVooorspelbaarToken(t *testing.T) {
	w := authGET("/auth/vulnerable", "session")
	body := w.Body.String()
	if !strings.Contains(body, "sess_00042") {
		t.Error("[A07 Kwetsbaar] session: voorspelbaar token 'sess_00042' ontbreekt")
	}
	if !strings.Contains(body, "sequentieel") || !strings.Contains(body, "voorspelbaar") {
		t.Error("[A07 Kwetsbaar] session: type-omschrijving ontbreekt")
	}
}

func TestA07_Kwetsbaar_OnbekendCommand(t *testing.T) {
	w := authGET("/auth/vulnerable", "whoami")
	if !strings.Contains(w.Body.String(), "opdracht niet gevonden") {
		t.Error("[A07 Kwetsbaar] onbekend command: 'opdracht niet gevonden' ontbreekt")
	}
}

// ─── Veilige versie ───────────────────────────────────────────────────────────

func TestA07_Veilig_Startpagina(t *testing.T) {
	w := authGET("/auth/secure", "")
	if w.Code != http.StatusOK {
		t.Errorf("[A07 Veilig] Startpagina: verwacht 200, kreeg %d", w.Code)
	}
}

func TestA07_Veilig_Startpagina_BevatTerminal(t *testing.T) {
	w := authGET("/auth/secure", "")
	if !strings.Contains(w.Body.String(), "bvwa-auth") {
		t.Error("[A07 Veilig] Startpagina: 'bvwa-auth' ontbreekt")
	}
}

func TestA07_Veilig_Help_ToontCommands(t *testing.T) {
	w := authGET("/auth/secure", "help")
	body := w.Body.String()
	if !strings.Contains(body, "login") {
		t.Error("[A07 Veilig] help: 'login' ontbreekt")
	}
	if !strings.Contains(body, "session") {
		t.Error("[A07 Veilig] help: 'session' ontbreekt")
	}
	// "enum <gebruiker>" (de volledige helpbeschrijving) mag niet aanwezig zijn in de veilige versie
	if strings.Contains(body, "enum <gebruiker>") {
		t.Error("[A07 Veilig] help: 'enum <gebruiker>' mag niet aanwezig zijn in veilige help-output")
	}
}

func TestA07_Veilig_Login_GeldigeCredentials_Admin(t *testing.T) {
	controllers.ResetA07Attempts()
	w := authGET("/auth/secure", "login admin admin123")
	if !strings.Contains(w.Body.String(), "Authenticatie geslaagd") {
		t.Error("[A07 Veilig] login admin: 'Authenticatie geslaagd' ontbreekt")
	}
}

func TestA07_Veilig_Login_GeldigeCredentials_Support(t *testing.T) {
	controllers.ResetA07Attempts()
	w := authGET("/auth/secure", "login support support")
	if !strings.Contains(w.Body.String(), "Authenticatie geslaagd") {
		t.Error("[A07 Veilig] login support: 'Authenticatie geslaagd' ontbreekt")
	}
}

func TestA07_Veilig_Login_GeldigeCredentials_GeenCTFFlag(t *testing.T) {
	controllers.ResetA07Attempts()
	w := authGET("/auth/secure", "login admin admin123")
	if strings.Contains(w.Body.String(), "BVWA{Brute_F0rc3_2026}") {
		t.Error("[A07 Veilig] login admin: CTF-flag mag niet aanwezig zijn in veilige versie")
	}
	if w.Header().Get("X-CTF-Flag") != "" {
		t.Error("[A07 Veilig] login admin: X-CTF-Flag header mag niet aanwezig zijn")
	}
}

func TestA07_Veilig_Login_GeldigeCredentials_ToontVeiligToken(t *testing.T) {
	controllers.ResetA07Attempts()
	w := authGET("/auth/secure", "login admin admin123")
	body := w.Body.String()
	if !strings.Contains(body, "e3b0c44298fc1c149afb4c8996fb924") {
		t.Error("[A07 Veilig] login admin: willekeurig sessietoken ontbreekt")
	}
	// Voorspelbaar token mag NIET aanwezig zijn
	if strings.Contains(body, "sess_00042") {
		t.Error("[A07 Veilig] login admin: voorspelbaar token 'sess_00042' mag niet aanwezig zijn")
	}
}

func TestA07_Veilig_Login_OngeldigeCredentials_GeneriekeError(t *testing.T) {
	controllers.ResetA07Attempts()
	w := authGET("/auth/secure", "login admin fout")
	body := w.Body.String()
	if !strings.Contains(body, "Authenticatie mislukt") {
		t.Error("[A07 Veilig] login fout ww: 'Authenticatie mislukt' ontbreekt")
	}
}

func TestA07_Veilig_Login_OnbekendGebruiker_ZelfdeError(t *testing.T) {
	controllers.ResetA07Attempts()
	// Zelfde foutmelding als bij bestaande gebruiker — geen user enumeration
	wBestaand := authGET("/auth/secure", "login admin fout")
	controllers.ResetA07Attempts()
	wOnbekend := authGET("/auth/secure", "login ghost fout")

	bodyB := wBestaand.Body.String()
	bodyO := wOnbekend.Body.String()

	// Beide moeten "Authenticatie mislukt" bevatten
	if !strings.Contains(bodyB, "Authenticatie mislukt") {
		t.Error("[A07 Veilig] user enumeration: bestaande user geeft geen generieke fout")
	}
	if !strings.Contains(bodyO, "Authenticatie mislukt") {
		t.Error("[A07 Veilig] user enumeration: onbekende user geeft geen generieke fout")
	}
	// De terminal-output mag nooit de reden van mislukking onthullen.
	// "Authenticatie mislukt: onjuist wachtwoord" en "bestaat niet" zijn kwetsbare
	// varianten die alleen in de vulnerable controller voorkomen.
	if strings.Contains(bodyB, "Authenticatie mislukt: onjuist wachtwoord") {
		t.Error("[A07 Veilig] user enumeration: specifieke foutmelding 'onjuist wachtwoord' lekt info bij bestaande user")
	}
	if strings.Contains(bodyO, "Authenticatie mislukt: gebruiker") {
		t.Error("[A07 Veilig] user enumeration: specifieke foutmelding 'gebruiker bestaat niet' lekt info bij onbekende user")
	}
}

func TestA07_Veilig_Login_RateLimiting_Na5Pogingen_Geblokkeerd(t *testing.T) {
	controllers.ResetA07Attempts()

	// 5 mislukte pogingen
	for i := 0; i < 5; i++ {
		authGET("/auth/secure", "login admin fout")
	}

	// 6e poging moet geblokkeerd zijn
	w := authGET("/auth/secure", "login admin fout")
	body := w.Body.String()
	if !strings.Contains(body, "Geblokkeerd") && !strings.Contains(body, "geblokkeerd") {
		t.Error("[A07 Veilig] rate limiting: 6e poging niet geblokkeerd")
	}

	controllers.ResetA07Attempts()
}

func TestA07_Veilig_Login_RateLimiting_ResetNaSucces(t *testing.T) {
	controllers.ResetA07Attempts()

	// 3 mislukte pogingen
	for i := 0; i < 3; i++ {
		authGET("/auth/secure", "login admin fout")
	}

	// Succesvolle login reset de teller
	w := authGET("/auth/secure", "login admin admin123")
	if !strings.Contains(w.Body.String(), "Authenticatie geslaagd") {
		t.Error("[A07 Veilig] rate limit reset: login na 3 mislukkingen moet slagen")
	}

	// Na succesvolle login zijn we niet meer geblokkeerd
	w2 := authGET("/auth/secure", "login admin fout")
	if strings.Contains(w2.Body.String(), "Geblokkeerd") || strings.Contains(w2.Body.String(), "geblokkeerd") {
		t.Error("[A07 Veilig] rate limit reset: na succesvolle login mag rate limiter niet meer actief zijn")
	}

	controllers.ResetA07Attempts()
}

func TestA07_Veilig_Enum_NietBeschikbaar(t *testing.T) {
	// enum-commando bestaat niet in de veilige versie (CWE-203 mitigatie)
	w := authGET("/auth/secure", "enum admin")
	body := w.Body.String()
	if strings.Contains(body, "BESTAAT") {
		t.Error("[A07 Veilig] enum: 'BESTAAT' mag niet aanwezig zijn in veilige versie")
	}
	if !strings.Contains(body, "opdracht niet gevonden") {
		t.Error("[A07 Veilig] enum: 'opdracht niet gevonden' ontbreekt")
	}
}

func TestA07_Veilig_Session_ToontWillekeurigToken(t *testing.T) {
	w := authGET("/auth/secure", "session")
	body := w.Body.String()
	if !strings.Contains(body, "e3b0c44298fc1c149afb4c8996fb924") {
		t.Error("[A07 Veilig] session: willekeurig token ontbreekt")
	}
	// Voorspelbaar token mag niet aanwezig zijn
	if strings.Contains(body, "sess_00042") {
		t.Error("[A07 Veilig] session: voorspelbaar token 'sess_00042' mag niet aanwezig zijn")
	}
	if !strings.Contains(body, "willekeurig") {
		t.Error("[A07 Veilig] session: type-omschrijving 'willekeurig' ontbreekt")
	}
}

func TestA07_Veilig_OnbekendCommand(t *testing.T) {
	w := authGET("/auth/secure", "whoami")
	if !strings.Contains(w.Body.String(), "opdracht niet gevonden") {
		t.Error("[A07 Veilig] onbekend command: 'opdracht niet gevonden' ontbreekt")
	}
}
