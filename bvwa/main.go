package main

import (
    _ "bvwa/routers"
    "html/template"
    "net/http"
    "strings"
    "github.com/beego/beego/v2/client/orm"
    beego "github.com/beego/beego/v2/server/web"
    _ "github.com/go-sql-driver/mysql"
)

func init() {
    orm.RegisterDataBase("default", "mysql",
        "user:password@tcp(127.0.0.1:3306)/dbname?charset=utf8")
    beego.AddFuncMap("contains", strings.Contains)
}

func main() {
    beego.ErrorHandler("404", page404)
    beego.ErrorHandler("500", page500)
    beego.ErrorHandler("403", page403)
    beego.ErrorHandler("400", page400)
    beego.Run()
}

func page404(rw http.ResponseWriter, r *http.Request) {
    t, _ := template.ParseFiles("views/errors/404.tpl")
    t.Execute(rw, nil)
}

func page500(rw http.ResponseWriter, r *http.Request) {
    t, _ := template.ParseFiles("views/errors/500.tpl")
    t.Execute(rw, nil)
}

func page403(rw http.ResponseWriter, r *http.Request) {
    t, _ := template.ParseFiles("views/errors/403.tpl")
    t.Execute(rw, nil)
}

func page400(rw http.ResponseWriter, r *http.Request) {
    t, _ := template.ParseFiles("views/errors/400.tpl")
    t.Execute(rw, nil)
}
