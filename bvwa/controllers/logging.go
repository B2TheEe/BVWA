package controllers

import (
    "fmt"
    "log"
    "os"
    "time"
    beego "github.com/beego/beego/v2/server/web"
)

// In-memory log opslag voor demo weergave
var securityLogs []string

// =====================
// KWETSBAAR: geen logging van beveiligingsgebeurtenissen
// =====================
type VulnerableLoggingController struct {
    beego.Controller
}

func (c *VulnerableLoggingController) Get() {
    c.Data["Title"]   = "Logging & Alerting (Kwetsbaar)"
    c.Data["Warning"] = "Geen enkele beveiligingsgebeurtenis " +
                        "wordt gelogd!"
    c.TplName = "logging/index.tpl"
}

func (c *VulnerableLoggingController) Post() {
    username := c.GetString("username")
    password := c.GetString("password")

    // KWETSBAAR: geen logging van loginpoging
    // KWETSBAAR: wachtwoord wordt in plaintext gelogd (als het
    //            al gelogd zou worden)
    if username == "admin" && password == "password123" {
        c.Data["Success"] = "Ingelogd! (Geen log aangemaakt)"
    } else {
        // KWETSBAAR: mislukte login wordt NIET gelogd
        // Aanvaller kan onbeperkt brute-forcen zonder detectie
        c.Data["Error"] = fmt.Sprintf(
            "Login mislukt voor '%s' — niet gelogd!", username)
    }

    c.Data["Title"]   = "Logging & Alerting (Kwetsbaar)"
    c.Data["Warning"] = "Mislukte loginpoging niet gelogd — " +
                        "brute force ondetecteerbaar!"
    c.Data["Logs"]    = []string{"(geen logs beschikbaar)"}
    c.TplName = "logging/index.tpl"
}

// =====================
// VEILIG: uitgebreide security logging met alerting
// =====================

// Initialiseer bestandslogger
var secureLogger *log.Logger

func init() {
    // Log naar bestand én console
    logFile, err := os.OpenFile(
        "security.log",
        os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
    if err != nil {
        log.Fatal("Kan logbestand niet openen:", err)
    }
    secureLogger = log.New(logFile,
        "SECURITY: ", log.Ldate|log.Ltime)
}

// Hulpfunctie: log beveiligingsgebeurtenis
func logSecurityEvent(level, event, ip, username string) {
    entry := fmt.Sprintf(
        "[%s] %s | IP: %s | Gebruiker: %s | Tijd: %s",
        level, event, ip, username,
        time.Now().Format("2006-01-02 15:04:05"))

    // Log naar bestand
    secureLogger.Println(entry)

    // Bewaar voor weergave in demo
    securityLogs = append(securityLogs, entry)

    // Houd max 10 logs bij voor weergave
    if len(securityLogs) > 10 {
        securityLogs = securityLogs[len(securityLogs)-10:]
    }

    // ALERT: bij verdachte activiteit
    if level == "CRITICAL" || level == "WARNING" {
        sendAlert(entry)
    }
}

// Simuleer alerting (in productie: email/Slack/SIEM)
func sendAlert(event string) {
    alertMsg := fmt.Sprintf("🚨 BEVEILIGINGSALERT: %s", event)
    secureLogger.Println(alertMsg)
    securityLogs = append(securityLogs,
        "🚨 ALERT VERZONDEN: "+event)
}

// Bijhouden mislukte pogingen voor alerting
var failedAttempts = map[string]int{}

type SecureLoggingController struct {
    beego.Controller
}

func (c *SecureLoggingController) Get() {
    c.Data["Title"] = "Logging & Alerting (Veilig)"
    c.Data["Info"]  = "Alle beveiligingsgebeurtenissen worden " +
                      "gelogd naar security.log"
    c.Data["Logs"]  = securityLogs
    c.TplName = "logging/index.tpl"
}

func (c *SecureLoggingController) Post() {
    username := c.GetString("username")
    password := c.GetString("password")
    ip       := c.Ctx.Input.IP()

    if username == "admin" && password == "password123" {
        // VEILIG: succesvolle login loggen
        logSecurityEvent("INFO",
            "Succesvolle login",
            ip, username)

        // Reset mislukte pogingen
        delete(failedAttempts, ip)

        c.Data["Success"] = "Ingelogd! Login is gelogd."
    } else {
        // VEILIG: mislukte login loggen
        failedAttempts[ip]++
        logSecurityEvent("WARNING",
            fmt.Sprintf("Mislukte login (poging %d)",
                failedAttempts[ip]),
            ip, username)

        // VEILIG: alert bij meer dan 3 pogingen
        if failedAttempts[ip] >= 3 {
            logSecurityEvent("CRITICAL",
                fmt.Sprintf(
                    "Mogelijke brute force aanval "+
                    "(%d pogingen)",
                    failedAttempts[ip]),
                ip, username)
        }

        c.Data["Error"] = "Login mislukt — gelogd en gemonitord!"
    }

    c.Data["Title"] = "Logging & Alerting (Veilig)"
    c.Data["Info"]  = "Bekijk de logs hieronder of in " +
                      "security.log"
    c.Data["Logs"]  = securityLogs
    c.TplName = "logging/index.tpl"
}
