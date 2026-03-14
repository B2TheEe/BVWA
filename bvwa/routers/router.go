package routers

import (
    "bvwa/controllers"
    beego "github.com/beego/beego/v2/server/web"
)

func init() {
    beego.Router("/admin/vulnerable", &controllers.VulnerableAdminController{})
    beego.Router("/admin/secure", &controllers.SecureAdminController{})
    beego.Router("/misconfig/vulnerable", 
    &controllers.VulnerableMisconfigController{})
beego.Router("/misconfig/secure",    
    &controllers.SecureMisconfigController{})
}
