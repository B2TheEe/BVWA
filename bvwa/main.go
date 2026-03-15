package main

import (
    _ "bvwa/routers"
    beego "github.com/beego/beego/v2/server/web"
    "github.com/beego/beego/v2/client/orm"
    _ "github.com/go-sql-driver/mysql"
    "strings"
)

func init() {
    orm.RegisterDataBase("default", "mysql",
        "user:password@tcp(127.0.0.1:3306)/dbname?charset=utf8")
}

func main() {
    beego.AddFuncMap("contains", strings.Contains)
    beego.Run()
}
