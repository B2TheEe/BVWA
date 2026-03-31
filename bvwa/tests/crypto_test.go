package test

import (
	"encoding/base64"
	"net/http"
	"net/http/httptest"
	"net/url"
	"strings"
	"testing"

	"bvwa/controllers"
	beego "github.com/beego/beego/v2/server/web"
)

// ─── A04: Cryptographic Failures ─────────────────────────────────────────────
//
// Scenario: bvwa-passwd — intern credential management systeem van BVWA Corp.
// Kwetsbaar: MD5-hashing zonder salt, Base64-only auth-tokens, geen autorisatiecontrole.
// Veilig:    SHA-256 / bcrypt, HMAC-SHA256 gesigneerde tokens, autorisatiecontrole.

// ── Hulpfunctie ───────────────────────────────────────────────────────────────

// cryptoGET stuurt een GET-request naar path met cmd als query-parameter.
// cmd mag spaties en speciale tekens bevatten — url.Values zorgt voor correcte codering.
func cryptoGET(path, cmd string) *httptest.ResponseRecorder {
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

// ── Kwetsbare versie ──────────────────────────────────────────────────────────

func TestA04_Kwetsbaar_StatusOK(t *testing.T) {
	w := cryptoGET("/crypto/vulnerable", "")
	if w.Code != http.StatusOK {
		t.Errorf("[A04 Kwetsbaar] verwacht 200, kreeg %d", w.Code)
	}
}

func TestA04_Kwetsbaar_AuthTokenCookieGezet(t *testing.T) {
	w := cryptoGET("/crypto/vulnerable", "")
	cookieHeader := w.Header().Get("Set-Cookie")
	if !strings.Contains(cookieHeader, "auth_token") {
		t.Error("[A04 Kwetsbaar] auth_token cookie ontbreekt in Set-Cookie header")
	}
}

func TestA04_Kwetsbaar_CookieIsBase64(t *testing.T) {
	// Kwetsbaarheid: de cookie-waarde is puur Base64 — geen handtekening
	w := cryptoGET("/crypto/vulnerable", "")
	cookieHeader := w.Header().Get("Set-Cookie")
	// Base64 StdEncoding eindigt op '=' of bevat alleen A-Za-z0-9+/=
	if !strings.Contains(cookieHeader, "=") {
		t.Error("[A04 Kwetsbaar] cookie lijkt geen Base64 — padding '=' ontbreekt")
	}
	// Mág geen punt bevatten (dat zou een HMAC-token zijn zoals payload.signature)
	// Haal de cookiewaarde op tussen 'auth_token=' en ';'
	raw := cookieHeader
	start := strings.Index(raw, "auth_token=")
	if start < 0 {
		t.Error("[A04 Kwetsbaar] auth_token= niet gevonden in cookie")
		return
	}
	value := raw[start+len("auth_token="):]
	if semi := strings.Index(value, ";"); semi >= 0 {
		value = value[:semi]
	}
	if strings.Contains(value, ".") {
		t.Error("[A04 Kwetsbaar] cookie bevat '.', lijkt een gesigneerd token (verwacht puur Base64)")
	}
}

func TestA04_Kwetsbaar_CommandHelp_ToontCommands(t *testing.T) {
	w := cryptoGET("/crypto/vulnerable", "help")
	body := w.Body.String()
	for _, cmd := range []string{"login", "token", "whoami", "hash", "crack", "decode", "users"} {
		if !strings.Contains(body, cmd) {
			t.Errorf("[A04 Kwetsbaar] help: '%s' ontbreekt in commando-lijst", cmd)
		}
	}
}

func TestA04_Kwetsbaar_CommandLogin_SuccesAdmin(t *testing.T) {
	// admin/password matcht MD5-hash in de database
	w := cryptoGET("/crypto/vulnerable", "login admin password")
	if !strings.Contains(w.Body.String(), "Login successful") {
		t.Error("[A04 Kwetsbaar] login admin password: 'Login successful' ontbreekt")
	}
}

func TestA04_Kwetsbaar_CommandLogin_ToontMD5Algoritme(t *testing.T) {
	// Kernkwetsbaarheid: login vermeldt het onveilige MD5-algoritme expliciet
	w := cryptoGET("/crypto/vulnerable", "login admin password")
	if !strings.Contains(w.Body.String(), "MD5") {
		t.Error("[A04 Kwetsbaar] login: 'MD5' ontbreekt — algoritme moet zichtbaar zijn")
	}
}

func TestA04_Kwetsbaar_CommandLogin_FoutWachtwoord(t *testing.T) {
	w := cryptoGET("/crypto/vulnerable", "login admin fout-wachtwoord")
	if !strings.Contains(w.Body.String(), "Authentication failed") {
		t.Error("[A04 Kwetsbaar] login fout wachtwoord: 'Authentication failed' ontbreekt")
	}
}

func TestA04_Kwetsbaar_CommandLogin_NietBestaandeUser(t *testing.T) {
	w := cryptoGET("/crypto/vulnerable", "login onbekend wachtwoord")
	if !strings.Contains(w.Body.String(), "not found") {
		t.Error("[A04 Kwetsbaar] login onbekende user: 'not found' ontbreekt")
	}
}

func TestA04_Kwetsbaar_CommandToken_ToontBase64Token(t *testing.T) {
	w := cryptoGET("/crypto/vulnerable", "token")
	body := w.Body.String()
	if !strings.Contains(body, "auth_token") {
		t.Error("[A04 Kwetsbaar] token: 'auth_token' ontbreekt in output")
	}
	if !strings.Contains(body, "Base64") {
		t.Error("[A04 Kwetsbaar] token: 'Base64' ontbreekt — type moet worden vermeld")
	}
}

func TestA04_Kwetsbaar_CommandWhoami_OnthultCTFFlag(t *testing.T) {
	// Kerntest: whoami decodeert de Base64-token en toont de verborgen _ctx-flag
	w := cryptoGET("/crypto/vulnerable", "whoami")
	if !strings.Contains(w.Body.String(), "BVWA{We4k_3ncrypt10n_2026}") {
		t.Error("[A04 Kwetsbaar] whoami: CTF flag ontbreekt — token zou decodeerbaar moeten zijn")
	}
}

func TestA04_Kwetsbaar_CommandWhoami_ToontTokenRaw(t *testing.T) {
	w := cryptoGET("/crypto/vulnerable", "whoami")
	if !strings.Contains(w.Body.String(), "Token") {
		t.Error("[A04 Kwetsbaar] whoami: raw token-waarde ontbreekt")
	}
}

func TestA04_Kwetsbaar_CommandHash_GebruiktMD5(t *testing.T) {
	w := cryptoGET("/crypto/vulnerable", "hash testwaarde")
	body := w.Body.String()
	if !strings.Contains(body, "MD5") {
		t.Error("[A04 Kwetsbaar] hash: 'MD5' ontbreekt — algoritme moet worden vermeld")
	}
}

func TestA04_Kwetsbaar_CommandHash_JuisteOutputVoorPassword(t *testing.T) {
	// MD5("password") = 5f4dcc3b5aa765d61d8327deb882cf99
	w := cryptoGET("/crypto/vulnerable", "hash password")
	if !strings.Contains(w.Body.String(), "5f4dcc3b5aa765d61d8327deb882cf99") {
		t.Error("[A04 Kwetsbaar] hash password: verwachte MD5-hash '5f4dcc3b5aa765d61d8327deb882cf99' ontbreekt")
	}
}

func TestA04_Kwetsbaar_CommandCrack_VingtAdminHash(t *testing.T) {
	// MD5("password") aanwezig in rainbow table
	w := cryptoGET("/crypto/vulnerable", "crack 5f4dcc3b5aa765d61d8327deb882cf99")
	body := w.Body.String()
	if !strings.Contains(body, "FOUND") {
		t.Error("[A04 Kwetsbaar] crack admin-hash: 'FOUND' ontbreekt")
	}
	if !strings.Contains(body, "password") {
		t.Error("[A04 Kwetsbaar] crack admin-hash: plaintext 'password' ontbreekt")
	}
}

func TestA04_Kwetsbaar_CommandCrack_NietGevonden(t *testing.T) {
	w := cryptoGET("/crypto/vulnerable", "crack 00000000000000000000000000000000")
	if !strings.Contains(w.Body.String(), "not found") {
		t.Error("[A04 Kwetsbaar] crack onbekende hash: 'not found' ontbreekt")
	}
}

func TestA04_Kwetsbaar_CommandDecode_SimpleBase64(t *testing.T) {
	// aGVsbG8= is Base64 van "hello" — geen speciale URL-tekens
	w := cryptoGET("/crypto/vulnerable", "decode aGVsbG8=")
	if !strings.Contains(w.Body.String(), "hello") {
		t.Error("[A04 Kwetsbaar] decode aGVsbG8=: 'hello' ontbreekt in output")
	}
}

func TestA04_Kwetsbaar_CommandDecode_OnthultTokenPayload(t *testing.T) {
	// De auth_token cookie is Base64 van weakTokenPayload — decode moet de flag tonen.
	token := base64.StdEncoding.EncodeToString([]byte(controllers.WeakTokenPayload))
	w := cryptoGET("/crypto/vulnerable", "decode "+token)
	if !strings.Contains(w.Body.String(), "BVWA{We4k_3ncrypt10n_2026}") {
		t.Error("[A04 Kwetsbaar] decode auth_token: CTF flag ontbreekt na decoding")
	}
}

func TestA04_Kwetsbaar_CommandUsers_ListsAlleGebruikers(t *testing.T) {
	w := cryptoGET("/crypto/vulnerable", "users")
	body := w.Body.String()
	for _, user := range []string{"admin", "alice", "bob"} {
		if !strings.Contains(body, user) {
			t.Errorf("[A04 Kwetsbaar] users: '%s' ontbreekt in gebruikerslijst", user)
		}
	}
}

func TestA04_Kwetsbaar_CommandUsers_ToontMD5Hashes(t *testing.T) {
	// Kwetsbaarheid: hashes zijn zichtbaar en MD5-formaat (32 hex chars)
	w := cryptoGET("/crypto/vulnerable", "users")
	body := w.Body.String()
	if !strings.Contains(body, "5f4dcc3b5aa765d61d8327deb882cf99") {
		t.Error("[A04 Kwetsbaar] users: MD5-hash van admin ontbreekt")
	}
	if !strings.Contains(body, "827ccb0eea8a706c4c34a16891f84e7b") {
		t.Error("[A04 Kwetsbaar] users: MD5-hash van alice ontbreekt")
	}
}

func TestA04_Kwetsbaar_CommandUsers_GeenAuthCheck(t *testing.T) {
	// Kerntest: de gebruikerslijst is opvraagbaar zonder sessie of token (CWE-862)
	w := cryptoGET("/crypto/vulnerable", "users")
	if w.Code == http.StatusFound || w.Code == http.StatusUnauthorized || w.Code == http.StatusForbidden {
		t.Errorf("[A04 Kwetsbaar] users: endpoint blokkeert toegang (code %d), verwacht 200", w.Code)
	}
	if w.Code != http.StatusOK {
		t.Errorf("[A04 Kwetsbaar] users: verwacht 200, kreeg %d", w.Code)
	}
}

func TestA04_Kwetsbaar_CommandOnbekend_CommandNotFound(t *testing.T) {
	w := cryptoGET("/crypto/vulnerable", "geheimcommando")
	if !strings.Contains(w.Body.String(), "command not found") {
		t.Error("[A04 Kwetsbaar] onbekend command: 'command not found' ontbreekt")
	}
}

// ── Veilige versie ────────────────────────────────────────────────────────────

func TestA04_Veilig_StatusOK(t *testing.T) {
	w := cryptoGET("/crypto/secure", "")
	if w.Code != http.StatusOK {
		t.Errorf("[A04 Veilig] verwacht 200, kreeg %d", w.Code)
	}
}

func TestA04_Veilig_AuthTokenCookieGezet(t *testing.T) {
	w := cryptoGET("/crypto/secure", "")
	if !strings.Contains(w.Header().Get("Set-Cookie"), "auth_token") {
		t.Error("[A04 Veilig] auth_token cookie ontbreekt")
	}
}

func TestA04_Veilig_CommandHash_GebruiktSHA256(t *testing.T) {
	w := cryptoGET("/crypto/secure", "hash testwaarde")
	if !strings.Contains(w.Body.String(), "SHA-256") {
		t.Error("[A04 Veilig] hash: 'SHA-256' ontbreekt in output")
	}
}

func TestA04_Veilig_CommandHash_VermeldtBcryptVoorWachtwoorden(t *testing.T) {
	// Secure hash-commando wijst de gebruiker op bcrypt/Argon2id voor wachtwoorden
	w := cryptoGET("/crypto/secure", "hash testwaarde")
	body := w.Body.String()
	if !strings.Contains(body, "bcrypt") && !strings.Contains(body, "Argon2") {
		t.Error("[A04 Veilig] hash: vermelding van bcrypt/Argon2id ontbreekt")
	}
}

func TestA04_Veilig_CommandCrack_Uitgeschakeld(t *testing.T) {
	w := cryptoGET("/crypto/secure", "crack 5f4dcc3b5aa765d61d8327deb882cf99")
	if !strings.Contains(w.Body.String(), "disabled") {
		t.Error("[A04 Veilig] crack: 'disabled' ontbreekt — crack moet uitgeschakeld zijn")
	}
}

func TestA04_Veilig_CommandToken_HMACFormaat(t *testing.T) {
	// Veilig token heeft formaat <payload>.<hmac-signature> — bevat een punt
	w := cryptoGET("/crypto/secure", "token")
	body := w.Body.String()
	if !strings.Contains(body, "HMAC") {
		t.Error("[A04 Veilig] token: 'HMAC' ontbreekt in output")
	}
	// Token zelf bevat een punt (payload.signature)
	if !strings.Contains(body, ".") {
		t.Error("[A04 Veilig] token: geen punt gevonden — verwacht <payload>.<sig> formaat")
	}
}

func TestA04_Veilig_CommandVerify_GeldigToken_VALID(t *testing.T) {
	// Gebruik het deterministisch berekende geldige token
	validToken := controllers.BuildSecureToken()
	w := cryptoGET("/crypto/secure", "verify "+validToken)
	if !strings.Contains(w.Body.String(), "VALID") {
		t.Error("[A04 Veilig] verify geldig token: 'VALID' ontbreekt")
	}
}

func TestA04_Veilig_CommandVerify_OngeldígeHandtekening_INVALID(t *testing.T) {
	// Token met verkeerde signatuur (zelfde payload, willekeurige hex-sig)
	w := cryptoGET("/crypto/secure", "verify eyJ1c2VyIjoiYWRtaW4ifQ.0000000000000000000000000000000000000000000000000000000000000000")
	if !strings.Contains(w.Body.String(), "INVALID") {
		t.Error("[A04 Veilig] verify ongeldig token: 'INVALID' ontbreekt")
	}
}

func TestA04_Veilig_CommandVerify_GeenPunt_Foutmelding(t *testing.T) {
	// Token zonder punt geeft een duidelijke foutmelding
	w := cryptoGET("/crypto/secure", "verify geengeldigtokenformaat")
	if !strings.Contains(w.Body.String(), "invalid token format") {
		t.Error("[A04 Veilig] verify zonder punt: 'invalid token format' ontbreekt")
	}
}

func TestA04_Veilig_CommandUsers_ZonderToken_GeenToegang(t *testing.T) {
	// Kerntest: zonder geldig token wordt toegang geweigerd (CWE-862 mitigatie)
	w := cryptoGET("/crypto/secure", "users")
	body := w.Body.String()
	if !strings.Contains(body, "Access denied") {
		t.Error("[A04 Veilig] users zonder token: 'Access denied' ontbreekt")
	}
	// Mag geen MD5-hashes tonen
	if strings.Contains(body, "5f4dcc3b5aa765d61d8327deb882cf99") {
		t.Error("[A04 Veilig] users zonder token: MD5-hash onterecht aanwezig")
	}
}

func TestA04_Veilig_CommandUsers_MetGeldigToken_Toegankelijk(t *testing.T) {
	validToken := controllers.BuildSecureToken()
	w := cryptoGET("/crypto/secure", "users "+validToken)
	body := w.Body.String()
	if !strings.Contains(body, "admin") {
		t.Error("[A04 Veilig] users met geldig token: 'admin' ontbreekt")
	}
	// Mag GEEN MD5-hashes tonen — alleen algoritme-info
	if strings.Contains(body, "5f4dcc3b5aa765d61d8327deb882cf99") {
		t.Error("[A04 Veilig] users met token: MD5-hash onterecht aanwezig (veilige versie toont geen hashes)")
	}
}

func TestA04_Veilig_CommandWhoami_GeenCTFFlag(t *testing.T) {
	// Veilig token bevat geen _ctx-veld met de flag
	w := cryptoGET("/crypto/secure", "whoami")
	if strings.Contains(w.Body.String(), "BVWA{We4k_3ncrypt10n_2026}") {
		t.Error("[A04 Veilig] whoami: CTF flag onterecht aanwezig in veilige token")
	}
}

func TestA04_Veilig_CommandLogin_SuccesAdmin(t *testing.T) {
	// admin/password123 matcht de bcrypt-hash
	w := cryptoGET("/crypto/secure", "login admin password123")
	if !strings.Contains(w.Body.String(), "Login successful") {
		t.Error("[A04 Veilig] login admin password123: 'Login successful' ontbreekt")
	}
}

func TestA04_Veilig_CommandLogin_ToontBcrypt(t *testing.T) {
	w := cryptoGET("/crypto/secure", "login admin password123")
	if !strings.Contains(w.Body.String(), "bcrypt") {
		t.Error("[A04 Veilig] login: 'bcrypt' ontbreekt — algoritme moet worden vermeld")
	}
}

func TestA04_Veilig_CommandLogin_FoutWachtwoord_UniformResponse(t *testing.T) {
	// Geen user enumeration: fout wachtwoord geeft zelfde response als onbekende user
	wFout := cryptoGET("/crypto/secure", "login admin verkeerd-wachtwoord")
	wOnbekend := cryptoGET("/crypto/secure", "login onbekende-user wachtwoord")
	if !strings.Contains(wFout.Body.String(), "Authentication failed") {
		t.Error("[A04 Veilig] login fout wachtwoord: 'Authentication failed' ontbreekt")
	}
	if !strings.Contains(wOnbekend.Body.String(), "Authentication failed") {
		t.Error("[A04 Veilig] login onbekende user: 'Authentication failed' ontbreekt (uniform response)")
	}
}

func TestA04_Veilig_CommandOnbekend_CommandNotFound(t *testing.T) {
	w := cryptoGET("/crypto/secure", "geheimcommando")
	if !strings.Contains(w.Body.String(), "command not found") {
		t.Error("[A04 Veilig] onbekend command: 'command not found' ontbreekt")
	}
}
