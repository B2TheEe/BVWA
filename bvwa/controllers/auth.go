package controllers

import (
    "golang.org/x/crypto/bcrypt"
    beego "github.com/beego/beego/v2/server/web"
)

// Gesimuleerde gebruikersdatabase
var users = map[string]string{
    "admin": "password123", // KWETSBAAR: plaintext opgeslagen
}

// Veilige gebruikersdatabase met bcrypt hashes
var secureUsers = map[string]string{
    // bcrypt hash van "password123"
    "admin": "$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy",
}

// =====================
// KWETSBAAR: geen brute-force bescherming, plaintext wachtwoord
// =====================
type VulnerableLoginController struct {
    beego.Controller
}

func (c *VulnerableLoginController) Get() {
    c.Data["Title"] = "Login (Kwetsbaar)"
    c.TplName = "auth/login.tpl"
}

func (c *VulnerableLoginController) Post() {
    username := c.GetString("username")
    password := c.GetString("password")

    // KWETSBAAR: plaintext vergelijking, geen rate limiting
    storedPassword, exists := users[username]
    if exists && storedPassword == password {
        // KWETSBAAR: sessie-ID wordt niet vernieuwd na login
        c.SetSession("user", username)
        c.Data["Title"]   = "Login (Kwetsbaar)"
        c.Data["Success"] = "Ingelogd als: " + username
        c.Data["Warning"] = "Geen rate limiting, plaintext wachtwoord!"
    } else {
        c.Data["Title"]   = "Login (Kwetsbaar)"
        c.Data["Error"]   = "Ongeldige inloggegevens"
        // KWETSBAAR: geeft te veel info terug aan aanvaller
        c.Data["Warning"] = "Gebruiker bestaat " +
            map[bool]string{true: "wel", false: "niet"}[exists]
    }
    c.TplName = "auth/login.tpl"
}

// =====================
// VEILIG: bcrypt, rate limiting, sessie-beheer
// =====================

// Bijhouden van mislukte pogingen per IP
var loginAttempts = map[string]int{}
const maxAttempts = 5

type SecureLoginController struct {
    beego.Controller
}

func (c *SecureLoginController) Get() {
    c.Data["Title"] = "Login (Veilig)"
    c.TplName = "auth/login.tpl"
}

func (c *SecureLoginController) Post() {
    username := c.GetString("username")
    password := c.GetString("password")
    ip       := c.Ctx.Input.IP()

    // VEILIG: rate limiting op IP
    if loginAttempts[ip] >= maxAttempts {
        c.Data["Title"]   = "Login (Veilig)"
        c.Data["Error"]   = "Te veel mislukte pogingen. " +
                            "Account tijdelijk geblokkeerd."
        c.TplName = "auth/login.tpl"
        return
    }

    storedHash, exists := secureUsers[username]
    if !exists {
        loginAttempts[ip]++
        // VEILIG: generieke foutmelding — geen info-lekkage
        c.Data["Title"] = "Login (Veilig)"
        c.Data["Error"] = "Ongeldige inloggegevens"
        c.TplName = "auth/login.tpl"
        return
    }

    // VEILIG: bcrypt vergelijking
    err := bcrypt.CompareHashAndPassword(
        []byte(storedHash), []byte(password))

    if err != nil {
        loginAttempts[ip]++
        c.Data["Title"] = "Login (Veilig)"
        c.Data["Error"] = "Ongeldige inloggegevens"
        c.TplName = "auth/login.tpl"
        return
    }

    // VEILIG: reset pogingen na succesvolle login
    delete(loginAttempts, ip)

    // VEILIG: nieuwe sessie aanmaken na login
    c.DestroySession()
    c.SetSession("user", username)
    c.SetSession("role", "admin")

    c.Data["Title"]   = "Login (Veilig)"
    c.Data["Success"] = "Succesvol ingelogd als: " + username
    c.Data["Info"]    = "bcrypt gebruikt, rate limiting actief, " +
                        "sessie vernieuwd!"
    c.TplName = "auth/login.tpl"
}

// =====================
// LOGOUT
// =====================
type LogoutController struct {
    beego.Controller
}

func (c *LogoutController) Get() {
    // VEILIG: sessie volledig vernietigen bij uitloggen
    c.DestroySession()
    c.Redirect("/", 302)
}
