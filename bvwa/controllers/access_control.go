package controllers

import (
	"strconv"

	beego "github.com/beego/beego/v2/server/web"
)

// EmployeeRecord stelt een medewerker voor in het HR-portaal.
type EmployeeRecord struct {
	ID       int
	Username string
	Email    string
	Afdeling string
	Functie  string
	Notes    string // vertrouwelijke HR-notities
}

// profileDB is de gesimuleerde medewerkersdatabase.
var profileDB = map[int]EmployeeRecord{
	1: {1, "admin", "admin@bvwa.internal", "IT", "Systeembeheerder",
		"Tijdelijk root-wachtwoord: Welkom2024! | SSH-poort: 2222 | MFA uitgeschakeld tot herstel"},
	2: {2, "alice", "alice@bvwa.internal", "Finance", "Financieel Analist",
		"Salarisverhoging €250/mnd per Q2 | Beoordelingsscore: 4.2/5 | Pensioenopbouw: 3%"},
	3: {3, "bob", "bob@bvwa.internal", "Operations", "Logistiek Coördinator",
		"Ziekteverlof t/m 30-04 | BSN: 123456789 | Noodcontact: 06-12345678"},
	4: {4, "carol", "carol@bvwa.internal", "Sales", "Sales Manager",
		"Bonuspercentage Q1: 18% | Budgetbevoegdheid: €50.000 | Aandelenoptie actief"},
}

// ─── KWETSBAAR: IDOR via ?id= parameter — geen autorisatiecheck ──────────
type VulnerableAdminController struct {
	beego.Controller
}

func (c *VulnerableAdminController) Get() {
	c.Ctx.ResponseWriter.Header().Set("X-CTF-Flag", "BVWA{1D0R_4cc3ss_2026}")
	c.Data["BackURL"] = "/admin/vulnerable"

	idStr := c.GetString("id", "")
	if idStr == "" {
		c.Data["Title"]    = "Medewerkersportaal"
		c.Data["Overview"] = true
		c.TplName = "admin/dashboard.tpl"
		return
	}

	id, err := strconv.Atoi(idStr)
	if err != nil || id < 1 {
		c.Data["Title"]    = "Medewerkersportaal"
		c.Data["NotFound"] = true
		c.TplName = "admin/dashboard.tpl"
		return
	}

	emp, exists := profileDB[id]
	if !exists {
		c.Data["Title"]    = "Medewerkersportaal"
		c.Data["NotFound"] = true
		c.TplName = "admin/dashboard.tpl"
		return
	}

	c.Data["Title"]      = "Medewerkersportaal"
	c.Data["HasProfile"] = true
	c.Data["Profile"]    = emp
	c.TplName = "admin/dashboard.tpl"
}

// ─── VEILIG: authenticatie + autorisatiecheck (IDOR-bescherming) ─────────
type SecureAdminController struct {
	beego.Controller
}

func (c *SecureAdminController) Get() {
	c.Data["BackURL"] = "/admin/secure"

	// Stap 1: is de gebruiker ingelogd?
	// StartSession koppelt c.CruSession aan de sessie-middleware; nil-safe.
	c.StartSession()
	var roleVal interface{}
	if c.CruSession != nil {
		roleVal = c.GetSession("role")
	}
	if roleVal == nil {
		c.Redirect("/login", 302)
		return
	}

	// Stap 2: haal de sessie-gebruiker-ID op
	sessionUserID := 0
	if c.CruSession != nil {
		if sid := c.GetSession("user_id"); sid != nil {
			if v, ok := sid.(int); ok {
				sessionUserID = v
			}
		}
	}

	idStr := c.GetString("id", "")
	if idStr == "" {
		c.Data["Title"]    = "Medewerkersportaal"
		c.Data["Overview"] = true
		c.TplName = "admin/dashboard.tpl"
		return
	}

	requestedID, err := strconv.Atoi(idStr)
	if err != nil || requestedID < 1 {
		c.Ctx.Output.SetStatus(400)
		c.Data["Title"]      = "Ongeldig verzoek"
		c.Data["BadRequest"] = true
		c.TplName = "admin/dashboard.tpl"
		return
	}

	// Stap 3: autorisatiecheck — mag de gebruiker dit profiel zien?
	role, _ := roleVal.(string)
	if role != "admin" && requestedID != sessionUserID {
		c.Ctx.Output.SetStatus(403)
		c.Data["Title"]     = "Toegang geweigerd"
		c.Data["Forbidden"] = true
		c.TplName = "admin/dashboard.tpl"
		return
	}

	emp, exists := profileDB[requestedID]
	if !exists {
		c.Ctx.Output.SetStatus(404)
		c.Data["Title"]    = "Profiel niet gevonden"
		c.Data["NotFound"] = true
		c.TplName = "admin/dashboard.tpl"
		return
	}

	c.Data["Title"]      = "Medewerkersportaal"
	c.Data["HasProfile"] = true
	c.Data["Profile"]    = emp
	c.TplName = "admin/dashboard.tpl"
}
