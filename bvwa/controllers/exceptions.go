package controllers

import (
    "errors"
    "fmt"
    "strconv"
    beego "github.com/beego/beego/v2/server/web"
)

// Gesimuleerde productdatabase
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

    c.Data["Title"]      = "Exception Handling (Kwetsbaar)"
    c.Data["Product"]    = ""
    c.Data["Error"]      = ""
    c.Data["Warning"]    = ""
    c.Data["StatusCode"] = ""

    if idStr == "" {
        c.TplName = "exceptions/index.tpl"
        return
    }

    // KWETSBAAR 1: fout genegeerd met _
    id, _ := strconv.Atoi(idStr)

    // KWETSBAAR 2: fail-open — negatief ID stilletjes gecorrigeerd
    if id < 0 {
        id = 1
        c.Data["Warning"] = fmt.Sprintf(
            "Negatief ID '%s' stilletjes gecorrigeerd naar 1! "+
                "(fail-open gedrag)", idStr)
    }

    // KWETSBAAR 3: interne info gelekt
    product, exists := productDB[id]
    if !exists {
        c.Data["StatusCode"] = "500"
        c.Data["Error"] = fmt.Sprintf(
            "INTERNE FOUT: Product met ID %d bestaat niet "+
                "in tabel 'products'. "+
                "Query: SELECT * FROM products WHERE id=%d. "+
                "Server: bvwa-db-01, Port: 3306",
            id, id)
    } else {
        c.Data["Product"]    = product
        c.Data["StatusCode"] = "200"
    }

    c.TplName = "exceptions/index.tpl"
}

// =====================
// VEILIG: correcte foutafhandeling
// =====================
var (
    ErrInvalidInput = errors.New("ongeldige invoer")
    ErrNotFound     = errors.New("product niet gevonden")
)

type SecureExceptionController struct {
    beego.Controller
}

func getProductSafe(idStr string) (string, error) {
    if idStr == "" {
        return "", ErrInvalidInput
    }
    id, err := strconv.Atoi(idStr)
    if err != nil {
        return "", ErrInvalidInput
    }
    if id <= 0 {
        return "", ErrInvalidInput
    }
    product, exists := productDB[id]
    if !exists {
        return "", ErrNotFound
    }
    return product, nil
}

func (c *SecureExceptionController) Get() {
    idStr := c.GetString("id")

    c.Data["Title"]      = "Exception Handling (Veilig)"
    c.Data["Product"]    = ""
    c.Data["Error"]      = ""
    c.Data["Warning"]    = ""
    c.Data["StatusCode"] = ""

    if idStr == "" {
        c.TplName = "exceptions/index.tpl"
        return
    }

    product, err := getProductSafe(idStr)

    if err != nil {
        // VEILIG: altijd HTTP 200 + template renderen
        // Statuscode wordt als educatieve info getoond
        switch {
        case errors.Is(err, ErrInvalidInput):
            c.Data["StatusCode"] = "400"
            c.Data["Error"] = "Ongeldig verzoek: voer een " +
                "geldig product ID in (1, 2 of 3)"
        case errors.Is(err, ErrNotFound):
            c.Data["StatusCode"] = "404"
            c.Data["Error"] = "Product niet gevonden"
        default:
            c.Data["StatusCode"] = "500"
            c.Data["Error"] = "Er is een interne fout " +
                "opgetreden. Probeer later opnieuw."
        }
        c.TplName = "exceptions/index.tpl"
        return
    }

    c.Data["Product"]    = product
    c.Data["StatusCode"] = "200"
    c.TplName = "exceptions/index.tpl"
}
