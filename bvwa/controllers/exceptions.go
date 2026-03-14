package controllers

import (
    "errors"
    "strconv"
    beego "github.com/beego/beego/v2/server/web"
)

// Gesimuleerde database
var productDB = map[int]string{
    1: "Laptop",
    2: "Telefoon",
    3: "Tablet",
}

// =====================
// KWETSBAAR: slechte foutafhandeling
// =====================
type VulnerableExceptionController struct {
    beego.Controller
}

func (c *VulnerableExceptionController) Get() {
    idStr := c.GetString("id")

    if idStr == "" {
        c.Data["Title"]   = "Exception Handling (Kwetsbaar)"
        c.Data["Warning"] = "Voer een product ID in"
        c.TplName = "exceptions/index.tpl"
        return
    }

    // KWETSBAAR 1: geen foutafhandeling bij ongeldige invoer
    id, _ := strconv.Atoi(idStr) // fout wordt genegeerd!

    // KWETSBAAR 2: interne foutdetails worden getoond
    product, exists := productDB[id]
    if !exists {
        // Lekt interne informatie aan aanvaller
        c.Abort("500") // geeft volledige stack trace!
        return
    }

    // KWETSBAAR 3: fail-open — bij fout toch doorgaan
    if id < 0 {
        id = 1 // stille correctie zonder logging
    }

    c.Data["Title"]   = "Exception Handling (Kwetsbaar)"
    c.Data["Product"] = product
    c.Data["Warning"] = "Fouten worden genegeerd of intern " +
                        "geëxposeerd!"
    c.TplName = "exceptions/index.tpl"
}

// =====================
// VEILIG: correcte foutafhandeling
// =====================
type SecureExceptionController struct {
    beego.Controller
}

// Aangepaste fout types
var (
    ErrInvalidInput  = errors.New("ongeldige invoer")
    ErrNotFound      = errors.New("product niet gevonden")
    ErrUnauthorized  = errors.New("geen toegang")
)

// Veilige product opzoek functie
func getProduct(idStr string) (string, error) {
    if idStr == "" {
        return "", ErrInvalidInput
    }

    id, err := strconv.Atoi(idStr)
    if err != nil {
        // VEILIG: specifieke foutmelding zonder interne details
        return "", ErrInvalidInput
    }

    if id <= 0 {
        return "", ErrInvalidInput
    }

    product, exists := productDB[id]
    if !exists {
        // VEILIG: fail-closed — bij twijfel weigeren
        return "", ErrNotFound
    }

    return product, nil
}

func (c *SecureExceptionController) Get() {
    idStr := c.GetString("id")

    product, err := getProduct(idStr)

    if err != nil {
        // VEILIG: generieke foutmelding voor gebruiker
        // Geen interne details gelekt!
        switch {
        case errors.Is(err, ErrInvalidInput):
            c.Ctx.ResponseWriter.WriteHeader(400)
            c.Data["Error"] = "Ongeldig verzoek: " +
                              "voer een geldig ID in (1-3)"
        case errors.Is(err, ErrNotFound):
            c.Ctx.ResponseWriter.WriteHeader(404)
            c.Data["Error"] = "Product niet gevonden"
        default:
            // VEILIG: onbekende fouten worden generiek afgehandeld
            c.Ctx.ResponseWriter.WriteHeader(500)
            c.Data["Error"] = "Er is een interne fout " +
                              "opgetreden. Probeer later opnieuw."
            // Log intern (niet zichtbaar voor gebruiker)
            logSecurityEvent("ERROR",
                "Onverwachte fout: "+err.Error(),
                c.Ctx.Input.IP(), "systeem")
        }

        c.Data["Title"] = "Exception Handling (Veilig)"
        c.Data["Info"]  = "Fout correct afgehandeld — geen " +
                          "interne details gelekt!"
        c.TplName = "exceptions/index.tpl"
        return
    }

    c.Data["Title"]   = "Exception Handling (Veilig)"
    c.Data["Product"] = product
    c.Data["Info"]    = "Verzoek succesvol en veilig verwerkt!"
    c.TplName = "exceptions/index.tpl"
}
