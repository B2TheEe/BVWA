package routers

import (
    "bvwa/controllers"
    beego "github.com/beego/beego/v2/server/web"
)

func init() {
    beego.Router("/", &controllers.HomeController{})
    beego.Router("/login",     &controllers.LoginController{})
beego.Router("/dashboard", &controllers.DashboardController{})
    beego.Router("/admin/vulnerable", &controllers.VulnerableAdminController{})
    beego.Router("/admin/secure", &controllers.SecureAdminController{})
    beego.Router("/misconfig/vulnerable", 
    &controllers.VulnerableMisconfigController{})
beego.Router("/misconfig/secure",    
    &controllers.SecureMisconfigController{})
    beego.Router("/supplychain/vulnerable",
    &controllers.VulnerableSupplyChainController{})
beego.Router("/supplychain/secure",
    &controllers.SecureSupplyChainController{})
    beego.Router("/crypto/vulnerable",
    &controllers.VulnerableCryptoController{})
beego.Router("/crypto/secure",
    &controllers.SecureCryptoController{})
    // SQL Injection
beego.Router("/injection/sql/vulnerable", 
    &controllers.VulnerableSQLController{})
beego.Router("/injection/sql/secure",    
    &controllers.SecureSQLController{})

// XSS Injection
beego.Router("/injection/xss/vulnerable", 
    &controllers.VulnerableXSSController{})
beego.Router("/injection/xss/secure",    
    &controllers.SecureXSSController{})
    
    beego.Router("/design/vulnerable",
    &controllers.VulnerableDesignController{})
beego.Router("/design/secure",
    &controllers.SecureDesignController{})
    
    // Authentication Failures
beego.Router("/auth/vulnerable",
    &controllers.VulnerableLoginController{})
beego.Router("/auth/secure",
    &controllers.SecureLoginController{})
beego.Router("/logout",
    &controllers.LogoutController{})
    // In routers/router.go
beego.Router("/api/v1/debug", &controllers.DesignController{}, "*:Debug")

    // Data Integrity Failures
beego.Router("/integrity/vulnerable",
    &controllers.VulnerableIntegrityController{})
beego.Router("/integrity/secure",
    &controllers.SecureIntegrityController{})
    
    // Security Logging & Alerting
beego.Router("/logging/vulnerable",
    &controllers.VulnerableLoggingController{})
beego.Router("/logging/secure",
    &controllers.SecureLoggingController{})
    
    
    // Exception Handling
beego.Router("/exceptions/vulnerable",
    &controllers.VulnerableExceptionController{})
beego.Router("/exceptions/secure",
    &controllers.SecureExceptionController{})
}
