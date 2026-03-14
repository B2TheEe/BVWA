package controllers

import beego "github.com/beego/beego/v2/server/web"

// KWETSBAAR: geen security headers
type VulnerableMisconfigController struct {
    beego.Controller
}

func (c *VulnerableMisconfigController) Get() {
    // Geen security headers — kwetsbaar
    c.Data["Title"] = "Security Misconfiguration (Kwetsbaar)"
    c.TplName = "misconfig/index.tpl"
}

// VEILIG: met security headers
type SecureMisconfigController struct {
    beego.Controller
}

func (c *SecureMisconfigController) Get() {
    // Voeg security headers toe
    c.Ctx.ResponseWriter.Header().Set(
        "X-Content-Type-Options", "nosniff")
    c.Ctx.ResponseWriter.Header().Set(
        "X-Frame-Options", "DENY")
    c.Ctx.ResponseWriter.Header().Set(
        "Content-Security-Policy", "default-src 'self'")
    c.Ctx.ResponseWriter.Header().Set(
        "Strict-Transport-Security", 
        "max-age=63072000; includeSubDomains")
    
    c.Data["Title"] = "Security Misconfiguration (Veilig)"
    c.TplName = "misconfig/index.tpl"
}
