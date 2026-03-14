package controllers

import (
    "fmt"
    beego "github.com/beego/beego/v2/server/web"
    "github.com/beego/beego/v2/client/orm"
    _ "github.com/go-sql-driver/mysql"
)

// =====================
// SQL INJECTION
// =====================

// KWETSBAAR: directe string concatenatie in SQL
type VulnerableSQLController struct {
    beego.Controller
}

func (c *VulnerableSQLController) Get() {
    username := c.GetString("username")

    // GEVAARLIJK: directe concatenatie — SQL injection mogelijk!
    // Payload voorbeeld: ' OR '1'='1
    query := fmt.Sprintf(
        "SELECT * FROM users WHERE username='%s'", username)

    c.Data["Title"]    = "SQL Injection (Kwetsbaar)"
    c.Data["Query"]    = query
    c.Data["Username"] = username
    c.Data["Warning"]  = "Directe string concatenatie — gevaarlijk!"
    c.TplName = "injection/sql.tpl"
}

// VEILIG: gebruik van geparametriseerde queries
type SecureSQLController struct {
    beego.Controller
}

func (c *SecureSQLController) Get() {
    username := c.GetString("username")

    o := orm.NewOrm()
    var result []orm.Params
    // Veilig: geparametriseerde query
    o.Raw("SELECT * FROM users WHERE username = ?",
        username).Values(&result)

    c.Data["Title"]    = "SQL Injection (Veilig)"
    c.Data["Username"] = username
    c.Data["Info"]     = "Geparametriseerde query gebruikt — veilig!"
    c.TplName = "injection/sql.tpl"
}

// =====================
// XSS INJECTION
// =====================

// KWETSBAAR: gebruikersinput direct in HTML gerenderd
type VulnerableXSSController struct {
    beego.Controller
}

func (c *VulnerableXSSController) Get() {
    input := c.GetString("input")
    // GEVAARLIJK: raw HTML output — XSS mogelijk!
    // Payload voorbeeld: <script>alert('XSS')</script>
    c.Data["Title"]    = "XSS Injection (Kwetsbaar)"
    c.Data["RawInput"] = input
    c.Data["Warning"]  = "Input wordt ongesaniteerd weergegeven!"
    c.TplName = "injection/xss.tpl"
}

// VEILIG: input wordt geëscaped
type SecureXSSController struct {
    beego.Controller
}

func (c *SecureXSSController) Get() {
    input := c.GetString("input")
    // Beego escaped automatisch met {{.SafeInput}} in template
    c.Data["Title"]     = "XSS Injection (Veilig)"
    c.Data["SafeInput"] = input
    c.Data["Info"]      = "Input wordt automatisch geëscaped door Beego!"
    c.TplName = "injection/xss.tpl"
}
