package controllers

import (
    "fmt"
    "html"
    beego "github.com/beego/beego/v2/server/web"
)

// Gesimuleerde gebruikersdatabase
var fakeUsers = map[string]string{
    "admin":    "Administrator",
    "user":     "Gewone gebruiker",
    "alice":    "Alice Jansen",
    "bob":      "Bob de Vries",
}

// =====================
// SQL INJECTION
// =====================

// KWETSBAAR: directe string concatenatie
type VulnerableSQLController struct {
    beego.Controller
}

func (c *VulnerableSQLController) Get() {
    username := c.GetString("username")

    // KWETSBAAR: input direct in query — SQL injection mogelijk!
    query := ""
    result := ""

    if username != "" {
        query = fmt.Sprintf(
            "SELECT * FROM users WHERE username='%s'",
            username)

        // Simuleer wat een echte DB zou doen met de payload
        // ' OR '1'='1 geeft toegang tot alle records
        if username == "' OR '1'='1" ||
            username == "' OR 1=1--" ||
            username == "' OR '1'='1'--" {
            result = "ALLE gebruikers teruggegeven: " +
                "admin, user, alice, bob " +
                "(SQL injection geslaagd!)"
        } else if name, ok := fakeUsers[username]; ok {
            result = fmt.Sprintf(
                "Gebruiker gevonden: %s", name)
        } else {
            result = "Geen gebruiker gevonden <!-- BVWA{SQLi_Un10n_2026} -->"
        }
    }



    c.Data["Title"]    = "SQL Injection (Kwetsbaar)"
    c.Data["Username"] = username
    c.Data["Query"]    = query
    c.Data["Result"]   = result
    c.Data["Warning"]  = "Directe string concatenatie - gevaarlijk!"
    c.TplName = "injection/sql.tpl"
}

// VEILIG: gesimuleerde geparametriseerde query
type SecureSQLController struct {
    beego.Controller
}

func (c *SecureSQLController) Get() {
    username := c.GetString("username")

    result := ""
    query  := ""

    if username != "" {
        // VEILIG: parameter gescheiden van query
        // Simuleer geparametriseerde query
        query = fmt.Sprintf(
            "SELECT * FROM users WHERE username = ? "+
                "[parameter: '%s']",
            username)

        // Input wordt als letterlijke tekst behandeld
        // ' OR '1'='1 wordt gezocht als gebruikersnaam
        // — niet als SQL-code uitgevoerd
        if name, ok := fakeUsers[username]; ok {
            result = fmt.Sprintf(
                "Gebruiker gevonden: %s", name)
        } else {
            // SQL injection payloads worden als tekst behandeld
            result = fmt.Sprintf(
                "Geen gebruiker gevonden voor: '%s' "+
                    "(input behandeld als tekst, niet als SQL)",
                username)
        }
    }

    c.Data["Title"]    = "SQL Injection (Veilig)"
    c.Data["Username"] = username
    c.Data["Query"]    = query
    c.Data["Result"]   = result
    c.Data["Info"]     = "Geparametriseerde query - veilig!"
    c.TplName = "injection/sql.tpl"
}

// =====================
// XSS INJECTION
// =====================

// KWETSBAAR: raw HTML output
type VulnerableXSSController struct {
    beego.Controller
}

func (c *VulnerableXSSController) Get() {
    input := c.GetString("input")

    c.Data["Title"]    = "XSS Injection (Kwetsbaar)"
    c.Data["RawInput"] = input
    c.Data["Warning"]  = "Input wordt ongesaniteerd weergegeven!"
    c.TplName = "injection/xss.tpl"
}

// VEILIG: input wordt geescaped
type SecureXSSController struct {
    beego.Controller
}

func (c *SecureXSSController) Get() {
    input := c.GetString("input")

    // Laat zien wat escaping doet
    escaped := html.EscapeString(input)

    c.Data["Title"]      = "XSS Injection (Veilig)"
    c.Data["SafeInput"]  = input
    c.Data["Escaped"]    = escaped
    c.Data["Info"]       = "Input wordt automatisch geescaped!"
    c.TplName = "injection/xss.tpl"
}
