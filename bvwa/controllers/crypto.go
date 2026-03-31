package controllers

import (
	"crypto/hmac"
	"crypto/md5"
	"crypto/sha256"
	"encoding/base64"
	"encoding/hex"
	"fmt"
	"strings"

	"golang.org/x/crypto/bcrypt"
	beego "github.com/beego/beego/v2/server/web"
)

// ── A04: Cryptographic Failures ───────────────────────────────────────────────
//
// Scenario: bvwa-passwd — intern credential management systeem van BVWA Corp.
// Kwetsbaar: MD5-hashing zonder salt (CWE-328/CWE-759), Base64-only auth-tokens
//            zonder handtekening (CWE-325), vrije toegang tot wachtwoord-hashes (CWE-862).
// Veilig:    SHA-256 voor dataintegriteit, bcrypt voor wachtwoorden,
//            HMAC-SHA256 gesigneerde tokens, autorisatiecontrole op gevoelige commando's.

const (
	// weakTokenPayload is het JSON-object in het kwetsbare auth-token.
	// Het bevat een intern _ctx-veld met de CTF-flag — enkel Base64-gecodeerd,
	// geen encryptie, geen handtekening (CWE-325).
	weakTokenPayload = `{"user":"admin","role":"admin","exp":"2026-04-01","_ctx":"BVWA{We4k_3ncrypt10n_2026}"}`

	// WeakTokenPayload is de geëxporteerde versie van weakTokenPayload voor tests.
	WeakTokenPayload = weakTokenPayload

	secureTokenSecret = "bvwa-prod-secret-key-2026"
	secureTokenClaims = `{"user":"admin","role":"admin","exp":"2026-04-01"}`

	// passwdBcryptAdmin is de bcrypt-hash van "password123" (cost=10).
	passwdBcryptAdmin = "$2a$10$6d5qLT1NJ9ejGuBd0YkudO8NsWwwfAI6kLuzvR7Z0rNCjAYNOUjw."
)

// passwdUsers: MD5-wachtwoordhashes zonder salt.
// Kwetsbaar voor rainbow table aanvallen (CWE-328, CWE-759).
var passwdUsers = map[string]string{
	"admin": "5f4dcc3b5aa765d61d8327deb882cf99", // "password"
	"alice": "827ccb0eea8a706c4c34a16891f84e7b", // "12345"
	"bob":   "098f6bcd4621d373cade4e832627b4f6", // "test"
}

var passwdRoles = map[string]string{
	"admin": "admin",
	"alice": "user",
	"bob":   "user",
}

// md5Rainbow: rainbow table voor veelgebruikte MD5-wachtwoord-hashes.
var md5Rainbow = map[string]string{
	"5f4dcc3b5aa765d61d8327deb882cf99": "password",
	"21232f297a57a5a743894a0e4a801fc3": "admin",
	"098f6bcd4621d373cade4e832627b4f6": "test",
	"827ccb0eea8a706c4c34a16891f84e7b": "12345",
	"d8578edf8458ce06fbc5bb76a58c5ca4": "qwerty",
	"e10adc3949ba59abbe56e057f20f883e": "123456",
	"25d55ad283aa400af464c76d713c07ad": "12345678",
	"fcea920f7412b5da7be0cf42b8c93759": "1234",
	"f25a2fc72690b780b2a14e140ef6a9e0": "iloveyou",
	"7c6a180b36896a0a8c02787eeafb0e4c": "password1",
}

// ── Kwetsbaar ────────────────────────────────────────────────────────────────

type VulnerableCryptoController struct {
	beego.Controller
}

func (c *VulnerableCryptoController) Get() {
	// Kwetsbare cookie: payload is Base64-gecodeerd JSON — geen encryptie, geen handtekening.
	weakToken := base64.StdEncoding.EncodeToString([]byte(weakTokenPayload))
	c.Ctx.SetCookie("auth_token", weakToken, 3600, "/")

	cmd := c.GetString("cmd")
	var output string
	var hasOutput bool

	if cmd != "" {
		hasOutput = true
		output = cryptoVuln(cmd, weakToken)
	}

	c.Data["Command"] = cmd
	c.Data["Output"] = output
	c.Data["HasOutput"] = hasOutput
	c.TplName = "crypto/vulnerable.tpl"
}

func cryptoVuln(cmd, weakToken string) string {
	parts := strings.Fields(cmd)
	if len(parts) == 0 {
		return "bvwa-passwd: no command specified"
	}

	switch parts[0] {
	case "help":
		return "bvwa-passwd v1.2.0  --  available commands:\n" +
			"  login <user> <pass>  authenticate a user\n" +
			"  token                show the current auth token\n" +
			"  whoami               show current session info\n" +
			"  hash <value>         compute password hash\n" +
			"  crack <md5hash>      look up hash in rainbow table\n" +
			"  decode <base64>      decode a Base64 string\n" +
			"  users                list all users and their password hashes"

	case "login":
		if len(parts) < 3 {
			return "Usage: login <username> <password>"
		}
		username := parts[1]
		password := strings.Join(parts[2:], " ")
		knownHash, ok := passwdUsers[username]
		if !ok {
			return fmt.Sprintf("bvwa-passwd: user '%s' not found", username)
		}
		h := md5.Sum([]byte(password))
		inputHash := hex.EncodeToString(h[:])
		if inputHash != knownHash {
			return fmt.Sprintf(
				"Checking credentials for '%s'...\n"+
					"Algorithm:    MD5\n"+
					"Stored hash:  %s\n"+
					"Input hash:   %s\n"+
					"Match:        FAIL\n"+
					"Authentication failed.",
				username, knownHash, inputHash)
		}
		return fmt.Sprintf(
			"Checking credentials for '%s'...\n"+
				"Algorithm:    MD5\n"+
				"Stored hash:  %s\n"+
				"Input hash:   %s\n"+
				"Match:        OK\n"+
				"Login successful.",
			username, knownHash, inputHash)

	case "token":
		return fmt.Sprintf(
			"auth_token: %s\n"+
				"Type:       Base64 (no signature)\n"+
				"Warning:    this token is encoding only — NOT encrypted, NOT signed",
			weakToken)

	case "whoami":
		return fmt.Sprintf(
			"Session info (decoded from auth_token cookie):\n"+
				"  user:  admin\n"+
				"  role:  admin\n"+
				"  exp:   2026-04-01\n"+
				"  _ctx:  BVWA{We4k_3ncrypt10n_2026}\n\n"+
				"Token (raw): %s\n"+
				"Note:        token is Base64-only — no signature, can be forged by anyone",
			weakToken)

	case "hash":
		if len(parts) < 2 {
			return "Usage: hash <value>"
		}
		value := strings.Join(parts[1:], " ")
		h := md5.Sum([]byte(value))
		return fmt.Sprintf(
			"Input:     %s\n"+
				"Algorithm: MD5 (DEPRECATED — CWE-328)\n"+
				"Output:    %x\n"+
				"Salt:      none  (same input always produces same output)\n"+
				"Warning:   rainbow tables cover billions of common passwords",
			value, h)

	case "crack":
		if len(parts) < 2 {
			return "Usage: crack <md5hash>"
		}
		hash := strings.ToLower(strings.TrimSpace(parts[1]))
		if plaintext, ok := md5Rainbow[hash]; ok {
			return fmt.Sprintf(
				"Hash:      %s\n"+
					"Algorithm: MD5\n"+
					"Status:    FOUND in rainbow table\n"+
					"Plaintext: \"%s\"",
				hash, plaintext)
		}
		return fmt.Sprintf(
			"Hash:   %s\n"+
				"Status: not found in local table. Try crackstation.net",
			hash)

	case "decode":
		if len(parts) < 2 {
			return "Usage: decode <base64>"
		}
		b64 := parts[1]
		decoded, err := decodeBase64Any(b64)
		if err != nil {
			return fmt.Sprintf("Error: invalid Base64 — %s", err)
		}
		return fmt.Sprintf(
			"Input:   %s\n"+
				"Decoded: %s\n"+
				"Note:    Base64 is encoding, NOT encryption — trivially reversible",
			b64, decoded)

	case "users":
		return "Username   Role    Password Hash (MD5)\n" +
			"──────────────────────────────────────────────────────\n" +
			"admin      admin   5f4dcc3b5aa765d61d8327deb882cf99\n" +
			"alice      user    827ccb0eea8a706c4c34a16891f84e7b\n" +
			"bob        user    098f6bcd4621d373cade4e832627b4f6\n" +
			"\nWarning: no authorization check on this endpoint (CWE-862)"

	default:
		return fmt.Sprintf(
			"bvwa-passwd: command not found: '%s'\n"+
				"Try 'help' for a list of commands",
			parts[0])
	}
}

// ── Veilig ───────────────────────────────────────────────────────────────────

type SecureCryptoController struct {
	beego.Controller
}

func (c *SecureCryptoController) Get() {
	// Veilige cookie: HMAC-SHA256 gesigneerd token.
	secureToken := buildSecureToken()
	c.Ctx.SetCookie("auth_token", secureToken, 3600, "/")

	cmd := c.GetString("cmd")
	var output string
	var hasOutput bool

	if cmd != "" {
		hasOutput = true
		output = cryptoSecure(cmd, secureToken)
	}

	c.Data["Command"] = cmd
	c.Data["Output"] = output
	c.Data["HasOutput"] = hasOutput
	c.TplName = "crypto/secure.tpl"
}

func cryptoSecure(cmd, secureToken string) string {
	parts := strings.Fields(cmd)
	if len(parts) == 0 {
		return "bvwa-passwd: no command specified"
	}

	switch parts[0] {
	case "help":
		return "bvwa-passwd v2.0.0  --  available commands:\n" +
			"  login <user> <pass>  authenticate a user\n" +
			"  token                show the current auth token\n" +
			"  whoami               show current session info\n" +
			"  hash <value>         compute hash (SHA-256)\n" +
			"  verify <token>       verify an HMAC-SHA256 token\n" +
			"  crack <hash>         [disabled in secure build]\n" +
			"  users [token]        list users (requires valid admin token)"

	case "login":
		if len(parts) < 3 {
			return "Usage: login <username> <password>"
		}
		username := parts[1]
		password := strings.Join(parts[2:], " ")
		// Uniform response time: geen user enumeration (CWE-204 mitigatie)
		if username != "admin" {
			return "Authentication failed."
		}
		err := bcrypt.CompareHashAndPassword([]byte(passwdBcryptAdmin), []byte(password))
		if err != nil {
			return "Authentication failed."
		}
		return fmt.Sprintf(
			"Verifying credentials for '%s'...\n"+
				"Algorithm: bcrypt (cost=10)\n"+
				"Status:    OK\n"+
				"Token:     %s\n"+
				"Login successful.",
			username, secureToken)

	case "token":
		return fmt.Sprintf(
			"auth_token: %s\n"+
				"Type:       HMAC-SHA256 signed\n"+
				"Format:     <base64url-payload>.<hmac-hex-signature>\n"+
				"Note:       payload is readable but cannot be forged without the server secret",
			secureToken)

	case "whoami":
		return fmt.Sprintf(
			"Session info (verified from auth_token cookie):\n"+
				"  user:  admin\n"+
				"  role:  admin\n"+
				"  exp:   2026-04-01\n\n"+
				"Token: %s\n"+
				"Note:  internal fields are not stored in the signed token",
			secureToken)

	case "hash":
		if len(parts) < 2 {
			return "Usage: hash <value>"
		}
		value := strings.Join(parts[1:], " ")
		h := sha256.Sum256([]byte(value))
		return fmt.Sprintf(
			"Input:     %s\n"+
				"Algorithm: SHA-256\n"+
				"Output:    %x\n"+
				"Salt:      none  (SHA-256 is for data integrity, not password storage)\n"+
				"Note:      for passwords, use bcrypt or Argon2id — they add salt + key stretching",
			value, h)

	case "crack":
		return "bvwa-passwd [secure]: crack is disabled.\n" +
			"  This build uses bcrypt/Argon2id — not vulnerable to rainbow table attacks.\n" +
			"  Use 'hash <value>' to compute SHA-256 for integrity checks."

	case "verify":
		if len(parts) < 2 {
			return "Usage: verify <token>"
		}
		token := parts[1]
		idx := strings.LastIndex(token, ".")
		if idx < 0 {
			return "Error: invalid token format — expected <payload>.<hmac-signature>"
		}
		payload := token[:idx]
		givenSig := token[idx+1:]
		mac := hmac.New(sha256.New, []byte(secureTokenSecret))
		mac.Write([]byte(payload))
		expectedSig := hex.EncodeToString(mac.Sum(nil))
		if hmac.Equal([]byte(givenSig), []byte(expectedSig)) {
			return fmt.Sprintf(
				"Token:  %s\n"+
					"Status: VALID — HMAC-SHA256 signature verified",
				token)
		}
		return fmt.Sprintf(
			"Token:  %s\n"+
				"Status: INVALID — signature mismatch (token may be forged or tampered)",
			token)

	case "users":
		// Veilig: vereist een geldig admin-token als argument (CWE-862 mitigatie).
		tokenArg := ""
		if len(parts) > 1 {
			tokenArg = parts[1]
		}
		if tokenArg != secureToken {
			return "bvwa-passwd [secure]: Access denied.\n" +
				"  User listing requires a valid admin token.\n" +
				"  Usage: users <token>"
		}
		return "Username   Role    Algorithm\n" +
			"────────────────────────────────────────\n" +
			"admin      admin   bcrypt (cost=10)\n" +
			"alice      user    bcrypt (cost=10)\n" +
			"bob        user    bcrypt (cost=10)\n" +
			"\nNote: password hashes are not returned — bcrypt comparison happens server-side"

	default:
		return fmt.Sprintf(
			"bvwa-passwd: command not found: '%s'\n"+
				"Try 'help' for a list of commands",
			parts[0])
	}
}

// buildSecureToken genereert een deterministisch HMAC-SHA256 gesigneerd token.
func buildSecureToken() string {
	payload := base64.RawURLEncoding.EncodeToString([]byte(secureTokenClaims))
	mac := hmac.New(sha256.New, []byte(secureTokenSecret))
	mac.Write([]byte(payload))
	sig := hex.EncodeToString(mac.Sum(nil))
	return payload + "." + sig
}

// BuildSecureToken is geëxporteerd voor gebruik in tests.
func BuildSecureToken() string { return buildSecureToken() }

// decodeBase64Any probeert StdEncoding, URLEncoding en RawStdEncoding.
func decodeBase64Any(s string) (string, error) {
	if b, err := base64.StdEncoding.DecodeString(s); err == nil {
		return string(b), nil
	}
	if b, err := base64.URLEncoding.DecodeString(s); err == nil {
		return string(b), nil
	}
	if b, err := base64.RawStdEncoding.DecodeString(s); err == nil {
		return string(b), nil
	}
	if b, err := base64.RawURLEncoding.DecodeString(s); err == nil {
		return string(b), nil
	}
	return "", fmt.Errorf("niet decodeerbaar als Base64")
}
