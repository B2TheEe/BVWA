package controllers

import (
	"fmt"
	"html"
	"strings"

	beego "github.com/beego/beego/v2/server/web"
)

// Employee vertegenwoordigt een medewerker in de MegaCorp-directory.
type Employee struct {
	ID         int
	Name       string
	Department string
	Role       string
	Email      string
}

// employeeDB simuleert een bedrijfsdirectory van MegaCorp.
var employeeDB = []Employee{
	{1, "Sven Bakker",  "IT",      "System Administrator", "s.bakker@megacorp.nl"},
	{2, "Alice Jansen", "Finance", "Senior Accountant",    "a.jansen@megacorp.nl"},
	{3, "Bob de Vries", "HR",      "HR Manager",           "b.devries@megacorp.nl"},
	{4, "Carol Peters", "IT",      "Software Developer",   "c.peters@megacorp.nl"},
	{5, "Dave Smit",    "Sales",   "Account Manager",      "d.smit@megacorp.nl"},
}

// hiddenRecord simuleert een beheerdersaccount dat nooit via normaal gebruik
// zichtbaar is — maar wél via SQL injection wordt blootgesteld.
var hiddenRecord = Employee{
	ID:         0,
	Name:       "db_admin",
	Department: "SYSTEM",
	Role:       "Database Root Account",
	Email:      "BVWA{SQLi_D1r3ct0ry_2026}",
}

// isInjectionAttempt herkent veelgebruikte SQL-injectietechnieken.
func isInjectionAttempt(input string) bool {
	lower := strings.ToLower(strings.TrimSpace(input))
	patterns := []string{
		"' or ",
		"'or ",
		" or '",
		"or 1=1",
		"' or'",
		"1=1",
		"--",
		"union select",
		"union all",
		"'; ",
		"';",
		"sleep(",
		"benchmark(",
		"waitfor",
	}
	for _, p := range patterns {
		if strings.Contains(lower, p) {
			return true
		}
	}
	return false
}

// =====================
// SQL INJECTION
// =====================

// VulnerableSQLController simuleert de kwetsbare medewerkerszoekopdracht
// waarbij gebruikersinput direct in de SQL-query wordt geconcateneerd.
type VulnerableSQLController struct {
	beego.Controller
}

func (c *VulnerableSQLController) Get() {
	name := c.GetString("name")

	query := ""
	var results []Employee
	injected := false

	if name != "" {
		// KWETSBAAR: input direct geconcateneerd in de query
		query = fmt.Sprintf(
			"SELECT id, name, department, role, email FROM employees WHERE name LIKE '%%%s%%'",
			name)

		if isInjectionAttempt(name) {
			// Injectie geslaagd: WHERE-conditie omzeild, alle records teruggegeven
			injected = true
			results = append(append([]Employee{}, employeeDB...), hiddenRecord)
		} else {
			lower := strings.ToLower(name)
			for _, emp := range employeeDB {
				if strings.Contains(strings.ToLower(emp.Name), lower) {
					results = append(results, emp)
				}
			}
		}
	}

	c.Ctx.ResponseWriter.Header().Set("X-CTF-Flag", "BVWA{SQLi_D1r3ct0ry_2026}")
	c.Data["Title"]    = "SQL Injection (Kwetsbaar)"
	c.Data["Name"]     = name
	c.Data["Query"]    = query
	c.Data["Results"]  = results
	c.Data["Injected"] = injected
	c.TplName = "injection/sql.tpl"
}

// SecureSQLController gebruikt een geparametriseerde query; injectie is onmogelijk.
type SecureSQLController struct {
	beego.Controller
}

func (c *SecureSQLController) Get() {
	name := c.GetString("name")

	query := ""
	var results []Employee

	if name != "" {
		// VEILIG: input als parameter, nooit als SQL-code uitgevoerd
		query = fmt.Sprintf(
			"SELECT id, name, department, role, email FROM employees WHERE name LIKE ? [parameter: '%%%s%%']",
			name)

		// Injectie-payloads worden als letterlijke zoektermen behandeld — geen match
		lower := strings.ToLower(name)
		for _, emp := range employeeDB {
			if strings.Contains(strings.ToLower(emp.Name), lower) {
				results = append(results, emp)
			}
		}
	}

	c.Data["Title"]    = "SQL Injection (Veilig)"
	c.Data["Name"]     = name
	c.Data["Query"]    = query
	c.Data["Results"]  = results
	c.Data["Injected"] = false
	c.TplName = "injection/sql.tpl"
}

// =====================
// XSS INJECTION
// =====================

// VulnerableXSSController — zoekterm wordt als raw HTML teruggegeven.
type VulnerableXSSController struct {
	beego.Controller
}

func (c *VulnerableXSSController) Get() {
	input := c.GetString("q")

	c.Ctx.ResponseWriter.Header().Set("X-CTF-Flag", "BVWA{XSS_R3fl3ct3d_2026}")
	c.Data["Title"]    = "XSS Injection (Kwetsbaar)"
	c.Data["RawInput"] = input
	c.Data["Warning"]  = "Zoekterm wordt ongesaniteerd weergegeven!"
	c.TplName = "injection/xss.tpl"
}

// SecureXSSController — zoekterm wordt geescaped weergegeven.
type SecureXSSController struct {
	beego.Controller
}

func (c *SecureXSSController) Get() {
	input := c.GetString("q")
	escaped := html.EscapeString(input)

	c.Data["Title"]     = "XSS Injection (Veilig)"
	c.Data["SafeInput"] = input
	c.Data["Escaped"]   = escaped
	c.Data["Info"]      = "Zoekterm wordt automatisch geescaped!"
	c.TplName = "injection/xss.tpl"
}
