package controllers

import beego "github.com/beego/beego/v2/server/web"

// KWETSBAAR: geen security headers
type VulnerableMisconfigController struct {
    beego.Controller
}

func (c *VulnerableMisconfigController) Get() {
    c.Data["Title"] = "Security Misconfiguration (Kwetsbaar)"
    c.TplName = "misconfig/index.tpl"
}

// VEILIG: met security headers (CSP staat inline styles toe voor demo)
type SecureMisconfigController struct {
    beego.Controller
}

func (c *SecureMisconfigController) Get() {
    c.Ctx.ResponseWriter.Header().Set(
        "X-Content-Type-Options", "nosniff")
    c.Ctx.ResponseWriter.Header().Set(
        "X-Frame-Options", "DENY")
    // 'unsafe-inline' nodig voor demo-styling
    // In productie: gebruik externe CSS bestanden
    c.Ctx.ResponseWriter.Header().Set(
        "Content-Security-Policy",
        "default-src 'self'; style-src 'self' 'unsafe-inline'")
    c.Ctx.ResponseWriter.Header().Set(
        "Strict-Transport-Security",
        "max-age=63072000; includeSubDomains")

    c.Data["Title"] = "Security Misconfiguration (Veilig)"
    c.TplName = "misconfig/index.tpl"
}
