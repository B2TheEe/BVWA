package controllers

import (
    "fmt"
    beego "github.com/beego/beego/v2/server/web"
)

// =====================
// INSECURE DESIGN: Password Reset zonder rate limiting
// =====================

// KWETSBAAR: geen rate limiting, geen verificatie
type VulnerableDesignController struct {
    beego.Controller
}

func (c *VulnerableDesignController) Get() {
    email := c.GetString("email")
    // GEVAARLIJK: reset direct zonder verificatie of limiet
    // Aanvaller kan onbeperkt reset-verzoeken sturen (brute force)
    message := ""
    if email != "" {
        message = fmt.Sprintf(
            "Reset-link verstuurd naar: %s (geen limiet!)", email)
    }
    c.Data["Title"]   = "Insecure Design (Kwetsbaar)"
    c.Data["Message"] = message
    c.Data["Warning"] = "Geen rate limiting of verificatie — " +
                        "brute force mogelijk!"
    c.TplName = "design/index.tpl"
}

// VEILIG: met rate limiting simulatie en token-verificatie
var resetAttempts = map[string]int{}

type SecureDesignController struct {
    beego.Controller
}

func (c *SecureDesignController) Get() {
    email := c.GetString("email")
    message := ""
    warning := ""

    if email != "" {
        resetAttempts[email]++

        if resetAttempts[email] > 3 {
            // Rate limiting: max 3 pogingen
            warning = fmt.Sprintf(
                "Te veel pogingen voor %s. Geblokkeerd!", email)
        } else {
            // Simuleer token-gebaseerde reset
            token := fmt.Sprintf("TOKEN-%s-%d", 
                email, resetAttempts[email])
            message = fmt.Sprintf(
                "Reset-link met token verstuurd: %s "+
                "(poging %d/3)", token, resetAttempts[email])
        }
    }

    c.Data["Title"]   = "Insecure Design (Veilig)"
    c.Data["Message"] = message
    c.Data["Warning"] = warning
    c.Data["Info"]    = "Rate limiting actief — max 3 pogingen!"
    c.TplName = "design/index.tpl"
}
