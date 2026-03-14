package controllers

import beego "github.com/beego/beego/v2/server/web"

type HomeController struct {
    beego.Controller
}

func (c *HomeController) Get() {
    c.Data["Title"] = "BVWA - Beego Vulnerable Web Application"
    c.TplName = "home/index.tpl"
}
