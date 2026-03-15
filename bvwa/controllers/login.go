package controllers

import beego "github.com/beego/beego/v2/server/web"

// ── Login pagina ──────────────────────────────────────────
type LoginController struct {
    beego.Controller
}

func (c *LoginController) Get() {
    c.Data["Title"] = "Login — BVWA"
    c.TplName = "login/index.tpl"
}

func (c *LoginController) Post() {
    username := c.GetString("username")
    password := c.GetString("password")

    // Veilige gebruikers (bcrypt in productie!)
    validUsers := map[string]string{
        "admin": "password123",
        "user":  "user123",
    }

    storedPassword, exists := validUsers[username]
    if !exists || storedPassword != password {
        c.Data["Title"] = "Login — BVWA"
        c.Data["Error"] = "Ongeldige gebruikersnaam of wachtwoord"
        c.TplName = "login/index.tpl"
        return
    }

    // Sessie aanmaken
    c.SetSession("user", username)
    if username == "admin" {
        c.SetSession("role", "admin")
    } else {
        c.SetSession("role", "user")
    }

    c.Redirect("/dashboard", 302)
}

// ── Dashboard ─────────────────────────────────────────────
type DashboardController struct {
    beego.Controller
}

func (c *DashboardController) Get() {
    // Sessiebescherming
    roleVal := c.GetSession("role")
    if roleVal == nil {
        c.Redirect("/login", 302)
        return
    }

    user, _ := c.GetSession("user").(string)
    role, _ := roleVal.(string)

    c.Data["Title"]    = "Dashboard — BVWA"
    c.Data["Username"] = user
    c.Data["Role"]     = role
    c.TplName = "login/dashboard.tpl"
}
