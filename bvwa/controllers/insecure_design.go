package controllers

import (
    "fmt"
    beego "github.com/beego/beego/v2/server/web"
)

// Bijhouden van pogingen per e-mail (in-memory)
var resetAttempts = map[string]int{}

// KWETSBAAR: geen rate limiting
type VulnerableDesignController struct {
    beego.Controller
}

func (c *VulnerableDesignController) Get() {
    email   := c.GetString("email")
    message := ""

    if email != "" {
        message = fmt.Sprintf(
            "Reset-link verstuurd naar: %s (geen limiet!)",
            email)
    }

    c.Data["Title"]   = "Insecure Design (Kwetsbaar)"
    c.Data["Email"]   = email
    c.Data["Message"] = message
    c.Data["Warning"] = ""
    c.Data["Info"]    = ""
    c.TplName = "design/index.tpl"
}

// VEILIG: met rate limiting en token
type SecureDesignController struct {
    beego.Controller
}

func (c *SecureDesignController) Get() {
    email   := c.GetString("email")
    message := ""
    warning := ""
    info    := ""

    if email != "" {
        resetAttempts[email]++
        attempts := resetAttempts[email]

        if attempts > 3 {
            warning = fmt.Sprintf(
                "Te veel pogingen voor %s. Geblokkeerd! (%d pogingen)",
                email, attempts)
        } else {
            token := fmt.Sprintf(
                "TOKEN-%d", attempts)
            message = fmt.Sprintf(
                "Reset verstuurd met token: %s (poging %d/3)",
                token, attempts)
            info = fmt.Sprintf(
                "Rate limiting actief: nog %d pogingen over.",
                3-attempts)
        }
    }

    c.Data["Title"]   = "Insecure Design (Veilig)"
    c.Data["Email"]   = email
    c.Data["Message"] = message
    c.Data["Warning"] = warning
    c.Data["Info"]    = info
    c.TplName = "design/index.tpl"
}

func (c *SecureDesignController) Debug() {
    c.Ctx.WriteString("BVWA{D3sign_Fl4w_2026}")
}

