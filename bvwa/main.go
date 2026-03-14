package main

import (
	_ "bvwa/routers"
	beego "github.com/beego/beego/v2/server/web"
)

func main() {
	beego.Run()
}

