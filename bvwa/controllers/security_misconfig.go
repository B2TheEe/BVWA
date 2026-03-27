package controllers

import (
	"fmt"
	"strings"

	beego "github.com/beego/beego/v2/server/web"
)

// ── A02: Security Misconfiguration ──────────────────────────────────────────
//
// Scenario: een vergeten server-diagnostics endpoint zonder authenticatie.
// De kwetsbare versie voert gesimuleerde shell-commando's uit en lekt
// configuratie, credentials en de CTF-flag via de omgeving.

// KWETSBAAR ─ geen auth, geen security headers, debug-headers lekken server info
type VulnerableMisconfigController struct {
	beego.Controller
}

func (c *VulnerableMisconfigController) Get() {
	// Misconfiguratie #1 – debug-informatie in response headers
	c.Ctx.ResponseWriter.Header().Set("X-Powered-By", "Go/1.21 Beego/2.0.7 (debug)")
	c.Ctx.ResponseWriter.Header().Set("Server", "bvwa-server/1.0")
	// CTF flag te vinden via DevTools → Network → Response Headers
	c.Ctx.ResponseWriter.Header().Set("X-CTF-Flag", "BVWA{M1scC0nf1g_D1r_2026}")

	cmd := c.GetString("cmd")
	var output string
	var hasOutput bool

	if cmd != "" {
		hasOutput = true
		output = misconfigExec(cmd)
	}

	c.Data["Command"] = cmd
	c.Data["Output"] = output
	c.Data["HasOutput"] = hasOutput
	c.TplName = "misconfig/vulnerable.tpl"
}

// misconfigExec simuleert server-side commando-uitvoering zoals een echte
// niet-gesandboxte diagnostics-endpoint dat zou doen.
func misconfigExec(cmd string) string {
	switch strings.TrimSpace(cmd) {
	case "hostname":
		return "bvwa-server"
	case "whoami":
		return "root"
	case "id":
		return "uid=0(root) gid=0(root) groups=0(root)"
	case "uname", "uname -a":
		return "Linux bvwa-server 5.15.0-91-generic #101-Ubuntu SMP x86_64 GNU/Linux"
	case "env", "printenv":
		return strings.Join([]string{
			"PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
			"HOME=/root",
			"USER=root",
			"SHELL=/bin/bash",
			"DB_HOST=db",
			"DB_USER=bvwa",
			"DB_PASSWORD=bvwapassword",
			"SECRET_KEY=dev-secret-do-not-use-in-production",
			"DEBUG=true",
			"BVWA_FLAG=BVWA{M1scC0nf1g_D1r_2026}",
		}, "\n")
	case "ls", "ls .":
		return "bvwa.conf  logs/  static/  uploads/"
	case "ls /", "ls -la /":
		return "bin  dev  etc  home  lib  mnt  opt  proc  root  run  srv  sys  tmp  usr  var"
	case "ls /var/www", "ls /var/www/":
		return "bvwa.conf  logs/  secret.txt  static/  uploads/"
	case "cat bvwa.conf", "cat ./bvwa.conf":
		return "[database]\nhost     = db\nuser     = bvwa\npassword = bvwapassword\nname     = bvwa\n\n" +
			"[app]\nsecret = dev-secret-do-not-use-in-production\ndebug  = true\n\n" +
			"[admin]\nusername = admin\npassword = admin123"
	case "cat secret.txt", "cat ./secret.txt", "cat /var/www/secret.txt":
		return "BVWA{M1scC0nf1g_D1r_2026}"
	case "cat /etc/passwd":
		return "root:x:0:0:root:/root:/bin/bash\n" +
			"daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin\n" +
			"bvwa:x:1000:1000:BVWA App:/home/bvwa:/bin/sh"
	case "ps", "ps aux":
		return "  PID USER     COMMAND\n" +
			"    1 root     /usr/bin/bvwa-server -port 8080\n" +
			"   12 root     /usr/sbin/sshd\n" +
			"   34 bvwa     -bash"
	case "ifconfig", "ip a", "ip addr":
		return "eth0  inet 172.18.0.2  netmask 255.255.0.0  broadcast 172.18.255.255\n" +
			"lo    inet 127.0.0.1  netmask 255.0.0.0"
	case "netstat", "netstat -an":
		return "Proto  Local Address    State\n" +
			"tcp    0.0.0.0:8080     LISTEN\n" +
			"tcp    0.0.0.0:22       LISTEN"
	default:
		return fmt.Sprintf("bash: %s: command not found", cmd)
	}
}

// VEILIG ─ debug console uitgeschakeld, volledige security headers
type SecureMisconfigController struct {
	beego.Controller
}

func (c *SecureMisconfigController) Get() {
	h := c.Ctx.ResponseWriter.Header()
	h.Set("X-Content-Type-Options", "nosniff")
	h.Set("X-Frame-Options", "DENY")
	h.Set("Content-Security-Policy", "default-src 'self'; style-src 'self' 'unsafe-inline'")
	h.Set("Strict-Transport-Security", "max-age=63072000; includeSubDomains")
	h.Set("Referrer-Policy", "strict-origin-when-cross-origin")
	h.Set("Permissions-Policy", "geolocation=(), microphone=(), camera=()")
	// Geen X-Powered-By, geen Server header, geen debug-informatie
	c.TplName = "misconfig/secure.tpl"
}
