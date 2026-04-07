package test

import (
	"encoding/base64"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"bvwa/controllers"
	beego "github.com/beego/beego/v2/server/web"
)

func integrityGET(path, cmd string) *httptest.ResponseRecorder {
	url := path
	if cmd != "" {
		url += "?cmd=" + cmd
	}
	r, _ := http.NewRequest("GET", url, nil)
	w := httptest.NewRecorder()
	beego.BeeApp.Handlers.ServeHTTP(w, r)
	return w
}

// ─── A08 Kwetsbaar: basisrespons ──────────────────────────────────────────────

func TestA08_Kwetsbaar_Pagina_Laadt(t *testing.T) {
	w := integrityGET("/integrity/vulnerable", "")
	if w.Code != http.StatusOK {
		t.Errorf("[A08 Kwetsbaar] verwacht 200, kreeg %d", w.Code)
	}
}

func TestA08_Kwetsbaar_Help_ToontCommands(t *testing.T) {
	w := integrityGET("/integrity/vulnerable", "help")
	body := w.Body.String()
	if !strings.Contains(body, "token") {
		t.Error("[A08 Kwetsbaar] help: 'token' ontbreekt")
	}
	if !strings.Contains(body, "decode") {
		t.Error("[A08 Kwetsbaar] help: 'decode' ontbreekt")
	}
	if !strings.Contains(body, "encode") {
		t.Error("[A08 Kwetsbaar] help: 'encode' ontbreekt")
	}
	if !strings.Contains(body, "deploy") {
		t.Error("[A08 Kwetsbaar] help: 'deploy' ontbreekt")
	}
}

// ─── A08 Kwetsbaar: token tonen en decoderen ──────────────────────────────────

func TestA08_Kwetsbaar_Token_ToontBase64(t *testing.T) {
	w := integrityGET("/integrity/vulnerable", "token")
	body := w.Body.String()
	// Default token should be in the response
	if !strings.Contains(body, controllers.IntegrityDefaultToken) {
		t.Error("[A08 Kwetsbaar] token: standaard Base64 token ontbreekt in response")
	}
}

func TestA08_Kwetsbaar_Token_GeenHandtekening(t *testing.T) {
	w := integrityGET("/integrity/vulnerable", "token")
	body := w.Body.String()
	if !strings.Contains(body, "geen handtekening") {
		t.Error("[A08 Kwetsbaar] token: melding 'geen handtekening' ontbreekt")
	}
}

func TestA08_Kwetsbaar_Decode_OnthultJSON(t *testing.T) {
	w := integrityGET("/integrity/vulnerable", "decode+"+controllers.IntegrityDefaultToken)
	body := w.Body.String()
	if !strings.Contains(body, "Gedecodeerde payload:") {
		t.Error("[A08 Kwetsbaar] decode: 'Gedecodeerde payload:' ontbreekt in output")
	}
	if !strings.Contains(body, "app-v1.0.0") {
		t.Error("[A08 Kwetsbaar] decode: package 'app-v1.0.0' ontbreekt in output")
	}
}

func TestA08_Kwetsbaar_Decode_OngeldigeBase64_GeeftFout(t *testing.T) {
	w := integrityGET("/integrity/vulnerable", "decode+!!INVALID!!")
	body := w.Body.String()
	if !strings.Contains(body, "Fout") {
		t.Error("[A08 Kwetsbaar] decode: foutmelding bij ongeldige Base64 ontbreekt")
	}
}

// ─── A08 Kwetsbaar: encode en deploy exploit ──────────────────────────────────

func TestA08_Kwetsbaar_Encode_ProduceertBase64(t *testing.T) {
	jsonPayload := `{"user":"deployer","role":"admin","package":"pwned","env":"production"}`
	encoded := base64.StdEncoding.EncodeToString([]byte(jsonPayload))
	w := integrityGET("/integrity/vulnerable", "encode+"+jsonPayload)
	body := w.Body.String()
	if !strings.Contains(body, encoded) {
		t.Errorf("[A08 Kwetsbaar] encode: verwacht Base64 '%s' in response", encoded)
	}
}

func TestA08_Kwetsbaar_Encode_OngeldigeJSON_GeeftFout(t *testing.T) {
	w := integrityGET("/integrity/vulnerable", "encode+GEEN_JSON")
	body := w.Body.String()
	if !strings.Contains(body, "Fout") {
		t.Error("[A08 Kwetsbaar] encode: foutmelding bij ongeldige JSON ontbreekt")
	}
}

func TestA08_Kwetsbaar_Deploy_AdminToken_GeeftCTFFlag(t *testing.T) {
	// Exploit: encode admin JSON, deploy it — should reveal CTF flag
	jsonPayload := `{"user":"hacker","role":"admin","package":"pwned","env":"production"}`
	adminToken := base64.StdEncoding.EncodeToString([]byte(jsonPayload))
	w := integrityGET("/integrity/vulnerable", "deploy+"+adminToken)
	body := w.Body.String()
	if !strings.Contains(body, "BVWA{1nt3gr1ty_Ch3ck_2026}") {
		t.Error("[A08 Kwetsbaar] deploy admin: CTF flag ontbreekt in body")
	}
}

func TestA08_Kwetsbaar_Deploy_AdminToken_CTFHeader(t *testing.T) {
	jsonPayload := `{"user":"hacker","role":"admin","package":"pwned","env":"production"}`
	adminToken := base64.StdEncoding.EncodeToString([]byte(jsonPayload))
	w := integrityGET("/integrity/vulnerable", "deploy+"+adminToken)
	if w.Header().Get("X-CTF-Flag") == "" {
		t.Error("[A08 Kwetsbaar] deploy admin: X-CTF-Flag header ontbreekt")
	}
}

func TestA08_Kwetsbaar_Deploy_NormaalToken_GeenCTFFlag(t *testing.T) {
	w := integrityGET("/integrity/vulnerable", "deploy+"+controllers.IntegrityDefaultToken)
	body := w.Body.String()
	if strings.Contains(body, "BVWA{1nt3gr1ty_Ch3ck_2026}") {
		t.Error("[A08 Kwetsbaar] deploy user-token: CTF flag mag niet zichtbaar zijn")
	}
	if w.Header().Get("X-CTF-Flag") != "" {
		t.Error("[A08 Kwetsbaar] deploy user-token: X-CTF-Flag header mag niet aanwezig zijn")
	}
}

func TestA08_Kwetsbaar_Deploy_NormaalToken_SUCCESS(t *testing.T) {
	w := integrityGET("/integrity/vulnerable", "deploy+"+controllers.IntegrityDefaultToken)
	body := w.Body.String()
	if !strings.Contains(body, "SUCCESS") {
		t.Error("[A08 Kwetsbaar] deploy user-token: 'SUCCESS' ontbreekt in output")
	}
}

func TestA08_Kwetsbaar_Deploy_OngeldigeToken_GeeftFout(t *testing.T) {
	w := integrityGET("/integrity/vulnerable", "deploy+!!INVALID!!")
	body := w.Body.String()
	if !strings.Contains(body, "mislukt") {
		t.Error("[A08 Kwetsbaar] deploy ongeldig: foutmelding ontbreekt")
	}
}

func TestA08_Kwetsbaar_Deploy_GeenToken_GeeftFout(t *testing.T) {
	w := integrityGET("/integrity/vulnerable", "deploy")
	body := w.Body.String()
	if !strings.Contains(body, "Gebruik") {
		t.Error("[A08 Kwetsbaar] deploy zonder token: gebruiksinstructie ontbreekt")
	}
}

// ─── A08 Kwetsbaar: integriteitscheck — manipulatie onzichtbaar ───────────────

func TestA08_Kwetsbaar_NietBestaandeOpdracht(t *testing.T) {
	w := integrityGET("/integrity/vulnerable", "onbekend")
	body := w.Body.String()
	if !strings.Contains(body, "niet gevonden") {
		t.Error("[A08 Kwetsbaar] onbekende opdracht: 'niet gevonden' ontbreekt")
	}
}

// ─── A08 Veilig: basisrespons ─────────────────────────────────────────────────

func TestA08_Veilig_Pagina_Laadt(t *testing.T) {
	w := integrityGET("/integrity/secure", "")
	if w.Code != http.StatusOK {
		t.Errorf("[A08 Veilig] verwacht 200, kreeg %d", w.Code)
	}
}

func TestA08_Veilig_Help_ToontCommands(t *testing.T) {
	w := integrityGET("/integrity/secure", "help")
	body := w.Body.String()
	for _, cmd := range []string{"token", "decode", "verify", "deploy"} {
		if !strings.Contains(body, cmd) {
			t.Errorf("[A08 Veilig] help: '%s' ontbreekt", cmd)
		}
	}
}

func TestA08_Veilig_Help_GeenEncodeOpdracht(t *testing.T) {
	// Secure version should not have an 'encode' command
	w := integrityGET("/integrity/secure", "help")
	body := w.Body.String()
	// "encode" should not appear as a listed command in the help output
	// We check the specific command description format
	if strings.Contains(body, "encode <") {
		t.Error("[A08 Veilig] help: 'encode <' mag niet aanwezig zijn in de veilige versie")
	}
}

// ─── A08 Veilig: gesigneerd token ─────────────────────────────────────────────

func TestA08_Veilig_Token_BevatHandtekening(t *testing.T) {
	w := integrityGET("/integrity/secure", "token")
	body := w.Body.String()
	signedToken := controllers.BuildIntegritySignedToken()
	if !strings.Contains(body, signedToken) {
		t.Error("[A08 Veilig] token: gesigneerd token ontbreekt in response")
	}
}

func TestA08_Veilig_Token_FormaatBevat_Punt(t *testing.T) {
	signedToken := controllers.BuildIntegritySignedToken()
	if !strings.Contains(signedToken, ".") {
		t.Error("[A08 Veilig] BuildIntegritySignedToken: geen punt aanwezig (formaat: payload.sig)")
	}
}

func TestA08_Veilig_Token_PayloadIsDefaultToken(t *testing.T) {
	signedToken := controllers.BuildIntegritySignedToken()
	idx := strings.LastIndex(signedToken, ".")
	if idx < 0 {
		t.Fatal("[A08 Veilig] BuildIntegritySignedToken: geen punt gevonden")
	}
	payload := signedToken[:idx]
	if payload != controllers.IntegrityDefaultToken {
		t.Errorf("[A08 Veilig] payload mismatch: verwacht %s, kreeg %s",
			controllers.IntegrityDefaultToken, payload)
	}
}

func TestA08_Veilig_Token_SignatureIsHex64Chars(t *testing.T) {
	signedToken := controllers.BuildIntegritySignedToken()
	idx := strings.LastIndex(signedToken, ".")
	sig := signedToken[idx+1:]
	if len(sig) != 64 {
		t.Errorf("[A08 Veilig] HMAC-SHA256 hex moet 64 tekens zijn, got %d", len(sig))
	}
}

// ─── A08 Veilig: decode ───────────────────────────────────────────────────────

func TestA08_Veilig_Decode_OnthultJSON(t *testing.T) {
	signedToken := controllers.BuildIntegritySignedToken()
	w := integrityGET("/integrity/secure", "decode+"+signedToken)
	body := w.Body.String()
	if !strings.Contains(body, "Gedecodeerde payload:") {
		t.Error("[A08 Veilig] decode: 'Gedecodeerde payload:' ontbreekt")
	}
	if !strings.Contains(body, "app-v1.0.0") {
		t.Error("[A08 Veilig] decode: package 'app-v1.0.0' ontbreekt")
	}
}

func TestA08_Veilig_Decode_ZonderHandtekening(t *testing.T) {
	// decode should also work on raw Base64 payload without signature
	w := integrityGET("/integrity/secure", "decode+"+controllers.IntegrityDefaultToken)
	body := w.Body.String()
	if !strings.Contains(body, "Gedecodeerde payload:") {
		t.Error("[A08 Veilig] decode (geen sig): 'Gedecodeerde payload:' ontbreekt")
	}
	if !strings.Contains(body, "app-v1.0.0") {
		t.Error("[A08 Veilig] decode (geen sig): package 'app-v1.0.0' ontbreekt")
	}
}

// ─── A08 Veilig: verify ───────────────────────────────────────────────────────

func TestA08_Veilig_Verify_GeldigToken_GELDIG(t *testing.T) {
	signedToken := controllers.BuildIntegritySignedToken()
	w := integrityGET("/integrity/secure", "verify+"+signedToken)
	body := w.Body.String()
	if !strings.Contains(body, "GELDIG") {
		t.Error("[A08 Veilig] verify geldig: 'GELDIG' ontbreekt in output")
	}
}

func TestA08_Veilig_Verify_GemipuleerdePayload_ONGELDIG(t *testing.T) {
	// Take signed token, replace payload with admin version
	jsonPayload := `{"user":"hacker","role":"admin","package":"pwned","env":"production"}`
	tamperedPayload := base64.StdEncoding.EncodeToString([]byte(jsonPayload))
	signedToken := controllers.BuildIntegritySignedToken()
	idx := strings.LastIndex(signedToken, ".")
	sig := signedToken[idx+1:]
	tamperedToken := tamperedPayload + "." + sig
	w := integrityGET("/integrity/secure", "verify+"+tamperedToken)
	body := w.Body.String()
	if !strings.Contains(body, "ONGELDIG") {
		t.Error("[A08 Veilig] verify gemanipuleerd: 'ONGELDIG' ontbreekt in output")
	}
}

func TestA08_Veilig_Verify_ZonderPunt_GeeftFout(t *testing.T) {
	w := integrityGET("/integrity/secure", "verify+"+controllers.IntegrityDefaultToken)
	body := w.Body.String()
	if !strings.Contains(body, "ongeldig token-formaat") {
		t.Error("[A08 Veilig] verify zonder punt: 'ongeldig token-formaat' ontbreekt")
	}
}

// ─── A08 Veilig: deploy — HMAC vereist ───────────────────────────────────────

func TestA08_Veilig_Deploy_GeldigToken_SUCCESS(t *testing.T) {
	signedToken := controllers.BuildIntegritySignedToken()
	w := integrityGET("/integrity/secure", "deploy+"+signedToken)
	body := w.Body.String()
	if !strings.Contains(body, "SUCCESS") {
		t.Error("[A08 Veilig] deploy geldig: 'SUCCESS' ontbreekt in output")
	}
}

func TestA08_Veilig_Deploy_GeldigToken_GeenCTFFlag(t *testing.T) {
	// Secure version never reveals the CTF flag
	signedToken := controllers.BuildIntegritySignedToken()
	w := integrityGET("/integrity/secure", "deploy+"+signedToken)
	body := w.Body.String()
	if strings.Contains(body, "BVWA{1nt3gr1ty_Ch3ck_2026}") {
		t.Error("[A08 Veilig] deploy geldig: CTF flag mag nooit zichtbaar zijn in veilige versie")
	}
}

func TestA08_Veilig_Deploy_AdminTokenZonderHandtekening_Geweigerd(t *testing.T) {
	// Attacker tries to deploy a plain Base64 admin token (no HMAC signature)
	jsonPayload := `{"user":"hacker","role":"admin","package":"pwned","env":"production"}`
	adminToken := base64.StdEncoding.EncodeToString([]byte(jsonPayload))
	w := integrityGET("/integrity/secure", "deploy+"+adminToken)
	body := w.Body.String()
	if !strings.Contains(body, "geweigerd") {
		t.Error("[A08 Veilig] deploy admin zonder sig: 'geweigerd' ontbreekt")
	}
	if strings.Contains(body, "SUCCESS") {
		t.Error("[A08 Veilig] deploy admin zonder sig: deployment mag niet slagen")
	}
}

func TestA08_Veilig_Deploy_GemanipuleerdToken_Geweigerd(t *testing.T) {
	// Valid signature but payload swapped to admin
	jsonPayload := `{"user":"hacker","role":"admin","package":"pwned","env":"production"}`
	tamperedPayload := base64.StdEncoding.EncodeToString([]byte(jsonPayload))
	signedToken := controllers.BuildIntegritySignedToken()
	idx := strings.LastIndex(signedToken, ".")
	sig := signedToken[idx+1:]
	tamperedToken := tamperedPayload + "." + sig
	w := integrityGET("/integrity/secure", "deploy+"+tamperedToken)
	body := w.Body.String()
	if !strings.Contains(body, "geweigerd") {
		t.Error("[A08 Veilig] deploy gemanipuleerd: 'geweigerd' ontbreekt")
	}
	if strings.Contains(body, "SUCCESS") {
		t.Error("[A08 Veilig] deploy gemanipuleerd: deployment mag niet slagen")
	}
}

func TestA08_Veilig_Deploy_ValsHandtekening_Geweigerd(t *testing.T) {
	// Valid payload but with a fake/wrong signature
	fakeToken := controllers.IntegrityDefaultToken + ".aabbccddeeff00112233445566778899aabbccddeeff00112233445566778899"
	w := integrityGET("/integrity/secure", "deploy+"+fakeToken)
	body := w.Body.String()
	if !strings.Contains(body, "geweigerd") {
		t.Error("[A08 Veilig] deploy valse sig: 'geweigerd' ontbreekt")
	}
}

func TestA08_Veilig_Deploy_GeenToken_GeeftFout(t *testing.T) {
	w := integrityGET("/integrity/secure", "deploy")
	body := w.Body.String()
	if !strings.Contains(body, "Gebruik") {
		t.Error("[A08 Veilig] deploy zonder token: gebruiksinstructie ontbreekt")
	}
}

// ─── A08 Veilig: geen CTF flag mogelijk ──────────────────────────────────────

func TestA08_Veilig_NooitCTFFlag_InResponseHeader(t *testing.T) {
	// No command should ever produce an X-CTF-Flag header on the secure endpoint
	cmds := []string{"", "help", "token", "deploy+" + controllers.BuildIntegritySignedToken()}
	for _, cmd := range cmds {
		w := integrityGET("/integrity/secure", cmd)
		if w.Header().Get("X-CTF-Flag") != "" {
			t.Errorf("[A08 Veilig] cmd='%s': X-CTF-Flag header mag niet aanwezig zijn", cmd)
		}
	}
}

// ─── A08: IntegrityDefaultToken structuur ─────────────────────────────────────

func TestA08_IntegrityDefaultToken_IsGeldigeJSON(t *testing.T) {
	data, err := base64.StdEncoding.DecodeString(controllers.IntegrityDefaultToken)
	if err != nil {
		t.Fatalf("[A08] IntegrityDefaultToken: ongeldige Base64 — %v", err)
	}
	var artifact controllers.DeploymentArtifact
	if err := json.Unmarshal(data, &artifact); err != nil {
		t.Fatalf("[A08] IntegrityDefaultToken: ongeldige JSON — %v", err)
	}
	if artifact.Role != "user" {
		t.Errorf("[A08] standaard token role moet 'user' zijn, got '%s'", artifact.Role)
	}
	if artifact.User != "deployer" {
		t.Errorf("[A08] standaard token user moet 'deployer' zijn, got '%s'", artifact.User)
	}
}
