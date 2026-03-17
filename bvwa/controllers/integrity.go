package controllers

import (
    "crypto/hmac"
    "crypto/sha256"
    "encoding/base64"
    "encoding/json"
    "fmt"
    "strings"
    beego "github.com/beego/beego/v2/server/web"
)

// Geheime sleutel voor HMAC (in productie: uit config laden!)
var hmacSecret = []byte("super-geheim-sleutel")

// UserSession simuleert geserialiseerde sessiedata
type UserSession struct {
    Username string `json:"username"`
    Role     string `json:"role"`
    Balance  int    `json:"balance"`
}

// =====================
// KWETSBAAR: geen integriteitscontrole op geserialiseerde data
// =====================
type VulnerableIntegrityController struct {
    beego.Controller
}

func (c *VulnerableIntegrityController) Get() {
    // Standaard sessie aanmaken
    session := UserSession{
        Username: "gebruiker",
        Role:     "user",
        Balance:  100,
    }
    data, _ := json.Marshal(session)
    encoded := base64.StdEncoding.EncodeToString(data)

    c.Data["Title"]   = "Data Integrity (Kwetsbaar)"
    c.Data["Token"]   = encoded
    c.Data["Warning"] = "Sessiedata wordt ZONDER handtekening " +
                        "opgeslagen — aanpasbaar door aanvaller!"
    c.TplName = "integrity/index.tpl"
}

func (c *VulnerableIntegrityController) Post() {
    token := c.GetString("token")

    // KWETSBAAR: vertrouwt base64 data blind zonder verificatie
    decoded, err := base64.StdEncoding.DecodeString(token)
    if err != nil {
        c.Data["Error"] = "Ongeldige token"
        c.TplName = "integrity/index.tpl"
        return
    }

    var session UserSession
    json.Unmarshal(decoded, &session)

    // GEVAARLIJK: aanvaller kan role:"admin" en balance:999999
    // instellen door de base64 string zelf aan te passen!
    c.Data["Title"]    = "Data Integrity (Kwetsbaar)"
    c.Data["Username"] = session.Username
    c.Data["Role"]     = session.Role
    c.Data["Balance"]  = session.Balance
    c.Data["Warning"]  = "Data werd ZONDER verificatie geaccepteerd!"
    c.Data["Token"]    = token
    c.TplName = "integrity/index.tpl"
}

// =====================
// VEILIG: HMAC handtekening voor integriteitscontrole
// =====================
type SecureIntegrityController struct {
    beego.Controller
}

// Hulpfunctie: maak gesigneerde token
func createSignedToken(session UserSession) string {
    data, _ := json.Marshal(session)
    encoded := base64.StdEncoding.EncodeToString(data)

    // Maak HMAC handtekening
    mac := hmac.New(sha256.New, hmacSecret)
    mac.Write([]byte(encoded))
    signature := base64.StdEncoding.EncodeToString(mac.Sum(nil))

    // Formaat: base64data.handtekening
    return encoded + "." + signature
}

// Hulpfunctie: verifieer en parse gesigneerde token
func verifySignedToken(token string) (*UserSession, error) {
    parts := strings.SplitN(token, ".", 2)
    if len(parts) != 2 {
        return nil, fmt.Errorf("ongeldig token formaat")
    }

    encoded, signature := parts[0], parts[1]

    // Herbereken verwachte handtekening
    mac := hmac.New(sha256.New, hmacSecret)
    mac.Write([]byte(encoded))
    expectedSig := base64.StdEncoding.EncodeToString(mac.Sum(nil))

    // VEILIG: constante-tijd vergelijking voorkomt timing attacks
    if !hmac.Equal([]byte(signature), []byte(expectedSig)) {
        return nil, fmt.Errorf(
            "handtekening ongeldig — data gemanipuleerd!")
    }

    decoded, err := base64.StdEncoding.DecodeString(encoded)
    if err != nil {
        return nil, fmt.Errorf("decodering mislukt")
    }

    var session UserSession
    if err := json.Unmarshal(decoded, &session); err != nil {
        return nil, fmt.Errorf("JSON parsing mislukt")
    }

    return &session, nil
}

func (c *SecureIntegrityController) Get() {
    session := UserSession{
        Username: "gebruiker",
        Role:     "user",
        Balance:  100,
    }
    token := createSignedToken(session)

    c.Data["Title"] = "Data Integrity (Veilig)"
    c.Data["Token"] = token
    c.Data["Info"]  = "Token is gesigneerd met HMAC-SHA256. " +
                      "Elke wijziging wordt gedetecteerd!"
    c.TplName = "integrity/index.tpl"
}

func (c *SecureIntegrityController) Post() {
    token := c.GetString("token")

    // VEILIG: verifieer handtekening vóór gebruik
    session, err := verifySignedToken(token)
    if err != nil {
        c.Data["Title"]   = "Data Integrity (Veilig)"
        c.Data["Error"]   = "⛔ Integriteitscontrole mislukt: " +
                            err.Error()
        c.Data["Warning"] = "Gemanipuleerde data gedetecteerd " +
                            "en geweigerd!"
        c.TplName = "integrity/index.tpl"
        return
    }

    c.Data["Title"]    = "Data Integrity (Veilig)"
    c.Data["Username"] = session.Username
    c.Data["Role"]     = session.Role
    c.Data["Balance"]  = session.Balance
    c.Data["Info"]     = "✅ Handtekening geldig — data is niet " +
                         "gemanipuleerd!"
    c.Data["Token"]    = token
    c.TplName = "integrity/index.tpl"
}

func (c *SecureIntegrityController) Upload() {
    // Als bestandsupload kwetsbaar is:
    c.Ctx.WriteString("Bestand geupload: <!-- BVWA{1nt3gr1ty_Ch3ck_2026} -->")
}
