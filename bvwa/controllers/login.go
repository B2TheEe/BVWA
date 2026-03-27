package controllers

import (
	"strings"

	beego "github.com/beego/beego/v2/server/web"
)

// In-memory gebruikersopslag (voor productie: gebruik een database)
var registeredUsers = map[string]string{
	"admin": "password123",
	"user":  "user123",
}

// Hernoemd naar loginFailedAttempts om conflict met logging.go te vermijden
var loginFailedAttempts int

// ── Registratie ───────────────────────────────────────────
type RegisterController struct {
	beego.Controller
}

func (c *RegisterController) Get() {
	c.Data["Title"] = "Registreren — BVWA"
	c.TplName = "login/register.tpl"
}

func (c *RegisterController) Post() {
	username  := strings.TrimSpace(c.GetString("username"))
	password  := c.GetString("password")
	password2 := c.GetString("password2")

	c.Data["Title"]    = "Registreren — BVWA"
	c.Data["Username"] = username

	if username == "" || password == "" {
		c.Data["Error"] = "Gebruikersnaam en wachtwoord zijn verplicht."
		c.TplName = "login/register.tpl"
		return
	}
	if len(username) < 3 {
		c.Data["Error"] = "Gebruikersnaam moet minimaal 3 tekens zijn."
		c.TplName = "login/register.tpl"
		return
	}
	if len(password) < 6 {
		c.Data["Error"] = "Wachtwoord moet minimaal 6 tekens zijn."
		c.TplName = "login/register.tpl"
		return
	}
	if password != password2 {
		c.Data["Error"] = "Wachtwoorden komen niet overeen."
		c.TplName = "login/register.tpl"
		return
	}
	if _, exists := registeredUsers[username]; exists {
		c.Data["Error"] = "Gebruikersnaam is al in gebruik."
		c.TplName = "login/register.tpl"
		return
	}

	registeredUsers[username] = password
	c.Redirect("/login?registered=1", 302)
	return
}

// ── Login ─────────────────────────────────────────────────
type LoginController struct {
	beego.Controller
}

func (c *LoginController) Get() {
	c.Data["Title"] = "Login — BVWA"
	if c.GetString("registered") == "1" {
		c.Data["Success"] = "Account aangemaakt! Je kunt nu inloggen."
	}
	c.TplName = "login/index.tpl"
}

func (c *LoginController) Post() {
	username := c.GetString("username")
	password := c.GetString("password")

	storedPassword, exists := registeredUsers[username]
	if !exists || storedPassword != password {
		loginFailedAttempts++
		if loginFailedAttempts > 10 {
			c.Ctx.ResponseWriter.Header().Set(
				"X-Flag", "BVWA{Brute_F0rc3_2026}",
			)
		}
		c.Data["Title"] = "Login — BVWA"
		c.Data["Error"] = "Ongeldige gebruikersnaam of wachtwoord"
		c.TplName = "login/index.tpl"
		return
	}

	loginFailedAttempts = 0
	c.SetSession("user", username)

	if username == "admin" {
		c.SetSession("role", "admin")
		c.SetSession("user_id", 1)
	} else {
		c.SetSession("role", "user")
		c.SetSession("user_id", 2)
	}

	c.Redirect("/dashboard", 302)
	return
}

// ── Dashboard ─────────────────────────────────────────────
type DashboardController struct {
	beego.Controller
}

func (c *DashboardController) Get() {
	roleVal := c.GetSession("role")
	if roleVal == nil {
		c.Redirect("/login", 302)
		return
	}

	user, _ := c.GetSession("user").(string)
	role, _ := roleVal.(string)

	// CTF voortgang voor de widget
	solved, _ := c.GetSession("solved_flags").([]string)
	if solved == nil {
		solved = []string{}
	}
	total := len(knownFlags)
	pct   := 0
	if total > 0 {
		pct = (len(solved) * 100) / total
	}

	c.Data["Title"]      = "Dashboard — BVWA"
	c.Data["Username"]   = user
	c.Data["Role"]       = role
	c.Data["CTFSolved"]  = len(solved)
	c.Data["CTFTotal"]   = total
	c.Data["CTFPercent"] = pct
	c.TplName = "login/dashboard.tpl"
}
