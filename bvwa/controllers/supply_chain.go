package controllers

import (
	"fmt"
	"strings"

	beego "github.com/beego/beego/v2/server/web"
)

// ── A03: Software Supply Chain Failures ─────────────────────────────────────
//
// Scenario: een package registry waarvan één pakket (bvwa-logger) is getamperd
// door een aanvaller. De kwetsbare manager installeert het zonder integriteitcheck;
// de postinstall hook lekt credentials en de CTF-flag naar buiten.
// De veilige manager verifieert checksums en weigert het pakket.

// ── Kwetsbaar ────────────────────────────────────────────────────────────────

type VulnerableSupplyChainController struct {
	beego.Controller
}

func (c *VulnerableSupplyChainController) Get() {
	cmd := c.GetString("cmd")
	var output string
	var hasOutput bool

	if cmd != "" {
		hasOutput = true
		output = supplyChainVuln(cmd)
	}

	c.Data["Command"] = cmd
	c.Data["Output"] = output
	c.Data["HasOutput"] = hasOutput
	c.TplName = "supplychain/vulnerable.tpl"
}

func supplyChainVuln(cmd string) string {
	parts := strings.Fields(cmd)
	if len(parts) == 0 {
		return "bvwa-pkg: no command specified\n" +
			"Usage: list | info <pkg> | install <pkg> | verify <pkg> | audit | search <term>"
	}

	switch parts[0] {
	case "list":
		return pkgList()
	case "info":
		if len(parts) < 2 {
			return "Usage: bvwa-pkg info <package>"
		}
		return pkgInfo(parts[1])
	case "search":
		if len(parts) < 2 {
			return "Usage: bvwa-pkg search <term>"
		}
		return pkgSearch(parts[1])
	case "install":
		if len(parts) < 2 {
			return "Usage: bvwa-pkg install <package>"
		}
		return pkgInstallVuln(parts[1])
	case "verify":
		// Kwetsbaar: verificatie uitgeschakeld
		return "bvwa-pkg WARNING: integrity verification is disabled\n" +
			"  Build flag --no-verify is active (default in debug builds)\n" +
			"  Run with --verify to enable checksum verification"
	case "audit":
		// Kwetsbaar: audit overgeslagen
		return "bvwa-pkg: security audit skipped\n" +
			"  Build flag --no-audit is active\n" +
			"  Run with --audit to enable"
	default:
		return fmt.Sprintf(
			"bvwa-pkg: unknown command '%s'\n"+
				"Usage: list | info <pkg> | install <pkg> | verify <pkg> | audit | search <term>",
			parts[0])
	}
}

func pkgInstallVuln(name string) string {
	switch name {
	case "bvwa-logger":
		// Kwetsbaar: checksum overgeslagen, malicieuze postinstall hook wordt uitgevoerd
		return "Fetching bvwa-logger@2.1.3 from registry.bvwa.local...\n" +
			"Downloading: [##########] 100% (2.3 MB)\n" +
			"Verifying checksum... [SKIPPED - integrity checks disabled]\n" +
			"Extracting...\n" +
			"Running postinstall: scripts/setup.sh\n\n" +
			"=== bvwa-logger postinstall ===\n" +
			"Collecting telemetry...\n" +
			"  hostname: bvwa-server\n" +
			"  platform: linux/amd64\n" +
			"  token: BVWA{Supp1y_Ch41n_2026}\n" +
			"POST metrics.bvwa-logger.io/collect ... 200 OK\n" +
			"==============================\n\n" +
			"Successfully installed bvwa-logger@2.1.3"
	case "bvwa-utils":
		return "Fetching bvwa-utils@1.2.0 from registry.bvwa.local...\n" +
			"Downloading: [##########] 100% (0.8 MB)\n" +
			"Verifying checksum... [SKIPPED - integrity checks disabled]\n" +
			"Extracting...\n" +
			"Successfully installed bvwa-utils@1.2.0"
	case "bvwa-crypto":
		return "WARNING: bvwa-crypto@0.9.1 is deprecated (unmaintained since 2022)\n" +
			"Fetching bvwa-crypto@0.9.1 from registry.bvwa.local...\n" +
			"Downloading: [##########] 100% (1.1 MB)\n" +
			"Verifying checksum... [SKIPPED - integrity checks disabled]\n" +
			"Extracting...\n" +
			"Successfully installed bvwa-crypto@0.9.1\n" +
			"Note: This package is no longer maintained. Consider upgrading."
	case "bvwa-auth":
		return "Fetching bvwa-auth@1.0.4 from registry.bvwa.local...\n" +
			"Downloading: [##########] 100% (0.9 MB)\n" +
			"Verifying checksum... [SKIPPED - integrity checks disabled]\n" +
			"Extracting...\n" +
			"Successfully installed bvwa-auth@1.0.4"
	default:
		return fmt.Sprintf(
			"bvwa-pkg: package '%s' not found in registry\n"+
				"Run 'list' to see available packages", name)
	}
}

// ── Veilig ───────────────────────────────────────────────────────────────────

type SecureSupplyChainController struct {
	beego.Controller
}

func (c *SecureSupplyChainController) Get() {
	cmd := c.GetString("cmd")
	var output string
	var hasOutput bool

	if cmd != "" {
		hasOutput = true
		output = supplyChainSecure(cmd)
	}

	c.Data["Command"] = cmd
	c.Data["Output"] = output
	c.Data["HasOutput"] = hasOutput
	c.TplName = "supplychain/secure.tpl"
}

func supplyChainSecure(cmd string) string {
	parts := strings.Fields(cmd)
	if len(parts) == 0 {
		return "bvwa-pkg: no command specified\n" +
			"Usage: list | info <pkg> | install <pkg> | verify <pkg> | audit | search <term>"
	}

	switch parts[0] {
	case "list":
		return pkgList()
	case "info":
		if len(parts) < 2 {
			return "Usage: bvwa-pkg info <package>"
		}
		return pkgInfo(parts[1])
	case "search":
		if len(parts) < 2 {
			return "Usage: bvwa-pkg search <term>"
		}
		return pkgSearch(parts[1])
	case "install":
		if len(parts) < 2 {
			return "Usage: bvwa-pkg install <package>"
		}
		return pkgInstallSecure(parts[1])
	case "verify":
		if len(parts) < 2 {
			return "Usage: bvwa-pkg verify <package>"
		}
		return pkgVerifySecure(parts[1])
	case "audit":
		return pkgAuditSecure()
	default:
		return fmt.Sprintf(
			"bvwa-pkg: unknown command '%s'\n"+
				"Usage: list | info <pkg> | install <pkg> | verify <pkg> | audit | search <term>",
			parts[0])
	}
}

func pkgInstallSecure(name string) string {
	switch name {
	case "bvwa-logger":
		// Veilig: checksum verificatie detecteert manipulatie
		return "Fetching bvwa-logger@2.1.3 from registry.bvwa.local...\n" +
			"Downloading: [##########] 100% (2.3 MB)\n" +
			"Verifying checksum...\n" +
			"  Registry: sha256:9f4a2b1c8d7e6f3a5b9c2d1e4f7a8b3c\n" +
			"  Actual:   sha256:a3f8c1d9e2b7f4a6c8d3e1f5b9a2c7d4\n" +
			"  Status:   MISMATCH\n" +
			"Installation aborted — package integrity check failed.\n" +
			"The package may have been tampered with in transit."
	case "bvwa-utils":
		return "Fetching bvwa-utils@1.2.0 from registry.bvwa.local...\n" +
			"Downloading: [##########] 100% (0.8 MB)\n" +
			"Verifying checksum... [OK — sha256:c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9]\n" +
			"Extracting...\n" +
			"Successfully installed bvwa-utils@1.2.0"
	case "bvwa-crypto":
		return "WARNING: bvwa-crypto@0.9.1 is deprecated (unmaintained since 2022)\n" +
			"Fetching bvwa-crypto@0.9.1 from registry.bvwa.local...\n" +
			"Downloading: [##########] 100% (1.1 MB)\n" +
			"Verifying checksum... [OK — sha256:f1e2d3c4b5a69788695041322415060e]\n" +
			"Extracting...\n" +
			"Successfully installed bvwa-crypto@0.9.1\n" +
			"Note: This package is no longer maintained. Consider upgrading."
	case "bvwa-auth":
		return "Fetching bvwa-auth@1.0.4 from registry.bvwa.local...\n" +
			"Downloading: [##########] 100% (0.9 MB)\n" +
			"Verifying checksum... [OK — sha256:b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2]\n" +
			"Extracting...\n" +
			"Successfully installed bvwa-auth@1.0.4"
	default:
		return fmt.Sprintf(
			"bvwa-pkg: package '%s' not found in registry\n"+
				"Run 'list' to see available packages", name)
	}
}

func pkgVerifySecure(name string) string {
	switch name {
	case "bvwa-logger":
		return "Verifying bvwa-logger@2.1.3...\n" +
			"  Registry checksum: sha256:9f4a2b1c8d7e6f3a5b9c2d1e4f7a8b3c\n" +
			"  Package checksum:  sha256:a3f8c1d9e2b7f4a6c8d3e1f5b9a2c7d4\n" +
			"  Status: MISMATCH — package integrity check FAILED"
	case "bvwa-utils":
		return "Verifying bvwa-utils@1.2.0...\n" +
			"  Registry checksum: sha256:c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9\n" +
			"  Package checksum:  sha256:c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9\n" +
			"  Status: OK"
	case "bvwa-crypto":
		return "Verifying bvwa-crypto@0.9.1...\n" +
			"  Registry checksum: sha256:f1e2d3c4b5a69788695041322415060e\n" +
			"  Package checksum:  sha256:f1e2d3c4b5a69788695041322415060e\n" +
			"  Status: OK (note: deprecated package)"
	case "bvwa-auth":
		return "Verifying bvwa-auth@1.0.4...\n" +
			"  Registry checksum: sha256:b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2\n" +
			"  Package checksum:  sha256:b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2\n" +
			"  Status: OK"
	default:
		return fmt.Sprintf("bvwa-pkg: package '%s' not found in registry", name)
	}
}

func pkgAuditSecure() string {
	return "Running security audit...\n" +
		"  [OK]  bvwa-utils@1.2.0    checksum: ok\n" +
		"  [!!]  bvwa-logger@2.1.3   TAMPERED — checksum mismatch detected\n" +
		"  [OK]  bvwa-crypto@0.9.1   checksum: ok (deprecated — no security updates)\n" +
		"  [OK]  bvwa-auth@1.0.4     checksum: ok\n\n" +
		"Audit complete: 1 critical issue found\n" +
		"  bvwa-logger@2.1.3 has been tampered — do not install"
}

// ── Gedeelde hulpfuncties ─────────────────────────────────────────────────────

func pkgList() string {
	return "Available packages in registry.bvwa.local:\n" +
		"  bvwa-utils     1.2.0    utility functions for BVWA\n" +
		"  bvwa-logger    2.1.3    structured logging for BVWA\n" +
		"  bvwa-crypto    0.9.1    [DEPRECATED] cryptography helpers\n" +
		"  bvwa-auth      1.0.4    authentication middleware"
}

func pkgInfo(name string) string {
	switch name {
	case "bvwa-utils":
		return "Package:      bvwa-utils\n" +
			"Version:      1.2.0\n" +
			"Registry:     registry.bvwa.local\n" +
			"Author:       bvwa-team <packages@bvwa.local>\n" +
			"License:      MIT\n" +
			"Checksum:     sha256:c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9\n" +
			"Dependencies: (none)"
	case "bvwa-logger":
		return "Package:      bvwa-logger\n" +
			"Version:      2.1.3\n" +
			"Registry:     registry.bvwa.local\n" +
			"Author:       bvwa-team <packages@bvwa.local>\n" +
			"License:      MIT\n" +
			"Checksum:     sha256:9f4a2b1c8d7e6f3a5b9c2d1e4f7a8b3c\n" +
			"Dependencies: bvwa-utils@>=1.0.0\n" +
			"Postinstall:  scripts/setup.sh"
	case "bvwa-crypto":
		return "Package:      bvwa-crypto\n" +
			"Version:      0.9.1\n" +
			"Registry:     registry.bvwa.local\n" +
			"Author:       bvwa-team <packages@bvwa.local>\n" +
			"License:      MIT\n" +
			"Checksum:     sha256:f1e2d3c4b5a69788695041322415060e\n" +
			"Dependencies: (none)\n" +
			"Note:         DEPRECATED — no security updates since 2022"
	case "bvwa-auth":
		return "Package:      bvwa-auth\n" +
			"Version:      1.0.4\n" +
			"Registry:     registry.bvwa.local\n" +
			"Author:       bvwa-team <packages@bvwa.local>\n" +
			"License:      MIT\n" +
			"Checksum:     sha256:b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2\n" +
			"Dependencies: bvwa-utils@>=1.0.0"
	default:
		return fmt.Sprintf(
			"bvwa-pkg: package '%s' not found\n"+
				"Run 'list' to see available packages", name)
	}
}

func pkgSearch(term string) string {
	type pkg struct{ name, version, desc string }
	all := []pkg{
		{"bvwa-utils", "1.2.0", "utility functions for BVWA"},
		{"bvwa-logger", "2.1.3", "structured logging for BVWA"},
		{"bvwa-crypto", "0.9.1", "cryptography helpers (deprecated)"},
		{"bvwa-auth", "1.0.4", "authentication middleware"},
	}

	lower := strings.ToLower(term)
	var hits []string
	for _, p := range all {
		if strings.Contains(p.name, lower) || strings.Contains(p.desc, lower) {
			hits = append(hits, fmt.Sprintf("  %-15s %-8s %s", p.name, p.version, p.desc))
		}
	}

	if len(hits) == 0 {
		return fmt.Sprintf("No packages found matching '%s'", term)
	}
	return "Search results:\n" + strings.Join(hits, "\n")
}
