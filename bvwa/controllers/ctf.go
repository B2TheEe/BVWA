package controllers

import beego "github.com/beego/beego/v2/server/web"

var knownFlags = map[string]string{
	"BVWA{4cc3ss_D3n13d_2026}":   "Access Control — Admin bypass",
	"BVWA{We4k_3ncrypt10n_2026}": "Crypto — Zwakke cookie",
	"BVWA{SQLi_Un10n_2026}":      "SQL Injection",
	"BVWA{D3sign_Fl4w_2026}":     "Insecure Design — Debug endpoint",
	"BVWA{1nt3gr1ty_Ch3ck_2026}": "Data Integrity — Upload",
	"BVWA{Brute_F0rc3_2026}":     "Auth — Brute force",
	"BVWA{M1scC0nf1g_D1r_2026}":  "Misconfiguratie — Debug Console",
}

type CTFController struct {
	beego.Controller
}

func (c *CTFController) Get() {
	user := c.GetSession("user")
	if user == nil {
		c.Redirect("/login", 302)
		return
	}

	solved, _ := c.GetSession("solved_flags").([]string)
	if solved == nil {
		solved = []string{}
	}

	solvedMap := map[string]bool{}
	for _, f := range solved {
		solvedMap[f] = true
	}

	pct := 0
	if len(knownFlags) > 0 {
		pct = (len(solved) * 100) / len(knownFlags)
	}

	challenges := []map[string]string{
		{"flag": "BVWA{4cc3ss_D3n13d_2026}", "name": "Access Control — Admin bypass", "hint": "Bekijk de paginabron als niet-admin"},
		{"flag": "BVWA{We4k_3ncrypt10n_2026}", "name": "Crypto — Zwakke cookie", "hint": "Inspecteer je cookies na inloggen"},
		{"flag": "BVWA{SQLi_Un10n_2026}", "name": "SQL Injection", "hint": "Probeer een SQL UNION payload"},
		{"flag": "BVWA{D3sign_Fl4w_2026}", "name": "Insecure Design — Debug endpoint", "hint": "Is er een verborgen API-endpoint?"},
		{"flag": "BVWA{1nt3gr1ty_Ch3ck_2026}", "name": "Data Integrity — Upload", "hint": "Upload een onverwacht bestandstype"},
		{"flag": "BVWA{Brute_F0rc3_2026}", "name": "Auth — Brute force", "hint": "Probeer meer dan 10 keer in te loggen"},
		{"flag": "BVWA{M1scC0nf1g_D1r_2026}", "name": "Misconfiguratie — Debug Console", "hint": "Kijk naar blootgestelde endpoints en openbare bestanden"},
	}

	c.Data["Title"]       = "CTF — Scorebord"
	c.Data["Challenges"]  = challenges
	c.Data["SolvedMap"]   = solvedMap
	c.Data["SolvedCount"] = len(solved)
	c.Data["Total"]       = len(knownFlags)
	c.Data["Percent"]     = pct
	c.TplName = "ctf/index.tpl"
}

func (c *CTFController) Submit() {
	user := c.GetSession("user")
	if user == nil {
		c.Data["json"] = map[string]string{"status": "unauthorized"}
		c.ServeJSON()
		return
	}

	flag := c.GetString("flag")
	name, valid := knownFlags[flag]
	if !valid {
		c.Data["json"] = map[string]string{"status": "wrong"}
		c.ServeJSON()
		return
	}

	solved, _ := c.GetSession("solved_flags").([]string)
	for _, f := range solved {
		if f == flag {
			c.Data["json"] = map[string]string{
				"status": "already_found",
				"name":   name,
			}
			c.ServeJSON()
			return
		}
	}

	solved = append(solved, flag)
	c.SetSession("solved_flags", solved)
	c.Data["json"] = map[string]string{
		"status": "correct",
		"name":   name,
	}
	c.ServeJSON()
}
