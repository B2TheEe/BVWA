# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What is BVWA

BVWA (Beego Vulnerable Web Application) is an intentionally vulnerable Go web application for teaching the OWASP Top 10:2025 vulnerabilities. Each module has a `/vulnerable` and `/secure` endpoint pair so students can compare exploit and mitigation side-by-side.

## Running the App

```bash
cd bvwa
go mod tidy
bee run          # dev mode with hot-reload, serves on :8080
# or
go run main.go   # without hot-reload
```

Default credentials: `admin / password123`, `user / user123`

## Running Tests

```bash
cd bvwa
go test ./...
```

Tests use [GoConvey](https://github.com/smartystreets/goconvey) (BDD-style). Run the GoConvey web UI with `goconvey` in the `bvwa/` directory.

## Architecture

**Framework:** Beego v2 MVC — routes → controllers → views (`.tpl` templates).

**Dual-implementation pattern:** Every OWASP module exposes two routes. Controllers are in `bvwa/controllers/`, one file per module:

| Route prefix | Controller file | OWASP category |
|---|---|---|
| `/admin/` | `access_control.go` | A01 Broken Access Control |
| `/misconfig/` | `security_misconfig.go` | A02 Security Misconfiguration |
| `/supplychain/` | `supply_chain.go` | A03 Supply Chain |
| `/crypto/` | `crypto.go` | A04 Cryptographic Failures |
| `/injection/sql/`, `/injection/xss/` | `injection.go` | A05 Injection |
| `/design/` | `insecure_design.go` | A06 Insecure Design |
| `/auth/` | `auth.go` | A07 Authentication Failures |
| `/integrity/` | `integrity.go` | A08 Data Integrity Failures |
| `/logging/` | `logging.go` | A09 Logging & Alerting |
| `/exceptions/` | `exceptions.go` | A10 Exceptional Conditions |

Routes are registered in `bvwa/routers/router.go`. Views live under `bvwa/views/<module>/`.

**CTF mode:** Hidden flags are embedded in HTML comments and response headers for students to discover while exploiting the vulnerable endpoints.

**No database required** — state is kept in in-memory maps and a flat log file (`security.log`). The MySQL driver is imported but the app defaults to in-memory storage.

## Key Implementation Notes

- Vulnerable controllers use raw string concatenation for SQL, unescaped output for XSS, Base64-only tokens for integrity checks, etc. — this is intentional.
- Secure controllers demonstrate mitigations: bcrypt, parameterized queries, `html.EscapeString`, HMAC-SHA256 with `hmac.Equal`, session regeneration, IP-based rate limiting.
- Session name is `bvwasession` (configured in `conf/app.conf`).
- The `DesignController.Debug` method is reachable at `/api/v1/debug` — intentional debug endpoint exposure example.
