package routers

import (
	"bvwa/controllers"
	"strings"

	beego "github.com/beego/beego/v2/server/web"
)

func init() {
	beego.AddFuncMap("contains", strings.Contains)

	beego.Router("/", &controllers.HomeController{})

	// Authenticatie
	beego.Router("/login",    &controllers.LoginController{})
	beego.Router("/register", &controllers.RegisterController{})
	beego.Router("/logout",   &controllers.LogoutController{})

	beego.Router("/dashboard", &controllers.DashboardController{})

	// CTF
	beego.Router("/ctf",        &controllers.CTFController{})
	beego.Router("/ctf/submit", &controllers.CTFController{}, "post:Submit")

	// Access Control
	beego.Router("/admin/vulnerable", &controllers.VulnerableAdminController{})
	beego.Router("/admin/secure",     &controllers.SecureAdminController{})

	// Misconfiguration
	beego.Router("/misconfig/vulnerable", &controllers.VulnerableMisconfigController{})
	beego.Router("/misconfig/secure",     &controllers.SecureMisconfigController{})

	// Supply Chain
	beego.Router("/supplychain/vulnerable", &controllers.VulnerableSupplyChainController{})
	beego.Router("/supplychain/secure",     &controllers.SecureSupplyChainController{})

	// Crypto
	beego.Router("/crypto/vulnerable", &controllers.VulnerableCryptoController{})
	beego.Router("/crypto/secure",     &controllers.SecureCryptoController{})

	// SQL Injection
	beego.Router("/injection/sql/vulnerable", &controllers.VulnerableSQLController{})
	beego.Router("/injection/sql/secure",     &controllers.SecureSQLController{})

	// XSS Injection
	beego.Router("/injection/xss/vulnerable", &controllers.VulnerableXSSController{})
	beego.Router("/injection/xss/secure",     &controllers.SecureXSSController{})

	// Insecure Design
	beego.Router("/design/vulnerable", &controllers.VulnerableDesignController{})
	beego.Router("/design/secure",     &controllers.SecureDesignController{})
	beego.Router("/api/v1/debug",      &controllers.SecureDesignController{}, "*:Debug")

	// Authentication Failures
	beego.Router("/auth/vulnerable", &controllers.VulnerableLoginController{})
	beego.Router("/auth/secure",     &controllers.SecureLoginController{})

	// Data Integrity Failures
	beego.Router("/integrity/vulnerable", &controllers.VulnerableIntegrityController{})
	beego.Router("/integrity/secure",     &controllers.SecureIntegrityController{})

	// Security Logging & Alerting
	beego.Router("/logging/vulnerable", &controllers.VulnerableLoggingController{})
	beego.Router("/logging/secure",     &controllers.SecureLoggingController{})

	// Exception Handling
	beego.Router("/exceptions/vulnerable", &controllers.VulnerableExceptionController{})
	beego.Router("/exceptions/secure",     &controllers.SecureExceptionController{})
}
