package controllers

import beego "github.com/beego/beego/v2/server/web"

// KWETSBAAR: geen toegangscontrole
type VulnerableAdminController struct {
    beego.Controller
}

func (c *VulnerableAdminController) Get() {
    c.Data["Title"] = "Admin Dashboard (Kwetsbaar)"
    c.TplName = "admin/dashboard.tpl"
}

// VEILIG: met rolcontrole
type SecureAdminController struct {
    beego.Controller
}

func (c *SecureAdminController) Get() {
    // Veilige sessie-uitleg
    roleVal := c.GetSession("role")
    
    if roleVal == nil {
        c.Redirect("/login", 302)
        return
    }
    
    role, ok := roleVal.(string)
    if !ok || role != "admin" {
        c.Redirect("/login", 302)
        return
    }
    
    c.Data["Title"] = "Admin Dashboard (Veilig)"
    c.TplName = "admin/dashboard.tpl"
}
