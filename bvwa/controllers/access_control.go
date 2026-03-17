package controllers

import beego "github.com/beego/beego/v2/server/web"

// KWETSBAAR: geen toegangscontrole
type VulnerableAdminController struct {
    beego.Controller
}

func (c *VulnerableAdminController) IsAdmin() bool {
    // Controleer de sessie of cookie voor admin-rechten
    // Bijvoorbeeld: sessie variabele "is_admin" of een specifieke rol
    return c.GetSession("is_admin") != nil && c.GetSession("is_admin").(bool)
}

// In controllers/access_control.go
func (c  *VulnerableAdminController) AdminPanel() {
    // Als de gebruiker GEEN admin is, toon de flag
    if !c.IsAdmin() {
        c.Ctx.WriteString("<!-- BVWA{4cc3ss_D3n13d_2026} -->")
    }
    // Toon de admin-pagina voor admins
    c.TplName = "admin/dashboard.tpl"
}


func (c *VulnerableAdminController) Get() {
    c.Data["Title"] = "Admin Dashboard (Kwetsbaar)"
    c.TplName = "admin/dashboard.tpl"
    // Als de gebruiker een admin is, zet de sessievariabele
        if username == "admin" {
            c.SetSession("is_admin", true)
        }
        c.Redirect("/admin", 302)
    if !c.IsAdmin() {
        c.Ctx.WriteString("<!-- BVWA{4cc3ss_D3n13d_2026} -->")
    }
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
