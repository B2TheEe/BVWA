# 🔐 BVWA — Beego Vulnerable Web Application

BVWA is een opzettelijk kwetsbare webapplicatie gebouwd met 
het Go Beego framework, gebaseerd op de OWASP Top 10:2025.
Het doel is om ontwikkelaars en security-studenten te helpen
beveiligingskwetsbaarheden te begrijpen en te leren verhelpen.

> ⚠️ **WAARSCHUWING:** BVWA is uitsluitend bedoeld voor 
> educatieve doeleinden. Gebruik het NOOIT in productie 
> of op een publiek toegankelijke server.

## 🚀 Installatie

### Vereisten
- Go 1.21+
- MySQL 5.7+
- Beego v2 & bee CLI

### Stappen
```bash
# Clone het project
git clone https://github.com/B2TheEe/bvwa.git
cd bvwa

# Installeer dependencies
go mod tidy

# Configureer database in conf/app.conf
# Pas aan: db_user, db_pass, db_name

# Start de applicatie
bee run
```

Ga naar: `http://127.0.0.1:8080`

## 📋 OWASP Top 10:2025 Modules

| # | Kwetsbaarheid | Route |
|---|--------------|-------|
| A01 | Broken Access Control | `/admin/` |
| A02 | Security Misconfiguration | `/misconfig/` |
| A03 | Software Supply Chain Failures | `/supplychain/` |
| A04 | Cryptographic Failures | `/crypto/` |
| A05 | Injection (SQL & XSS) | `/injection/` |
| A06 | Insecure Design | `/design/` |
| A07 | Authentication Failures | `/auth/` |
| A08 | Software/Data Integrity Failures | `/integrity/` |
| A09 | Security Logging & Alerting | `/logging/` |
| A10 | Mishandling of Exceptional Conditions | `/exceptions/` |

## 🗂️ Projectstructuur
```
bvwa/
├── conf/
│   └── app.conf          # Applicatieconfiguratie
├── controllers/
│   ├── access_control.go # A01
│   ├── security_misconfig.go # A02
│   ├── supply_chain.go   # A03
│   ├── crypto.go         # A04
│   ├── injection.go      # A05
│   ├── insecure_design.go # A06
│   ├── auth.go           # A07
│   ├── integrity.go      # A08
│   ├── logging.go        # A09
│   └── exceptions.go     # A10
├── routers/
│   └── router.go
├── views/
│   ├── home/
│   ├── admin/
│   ├── misconfig/
│   ├── supplychain/
│   ├── crypto/
│   ├── injection/
│   ├── design/
│   ├── auth/
│   ├── integrity/
│   ├── logging/
│   └── exceptions/
├── main.go
└── README.md
```

## 🔧 Configuratie

Pas `conf/app.conf` aan:
```ini
appname = bvwa
httpport = 8080
runmode = dev
sessionon = true
sessionname = bvwasession

# Database
db_user = root
db_pass = jouwwachtwoord
db_host = 127.0.0.1
db_port = 3306
db_name = bvwa
```

## 🧪 Test Credentials

| Gebruiker | Wachtwoord | Rol |
|-----------|-----------|-----|
| admin | password123 | Administrator |
| user | user123 | Gebruiker |

## 📚 Leerdoelen

Elke module bevat:
- ✅ Een **kwetsbare** versie om de aanval te demonstreren
- ✅ Een **veilige** versie met de correcte implementatie
- ✅ Uitleg over de kwetsbaarheid

## 🛠️ Technologieën

- **Taal:** Go 1.21+
- **Framework:** Beego v2
- **Database:** MySQL
- **Beveiliging:** bcrypt, HMAC-SHA256

## ⚖️ Disclaimer

Dit project is uitsluitend voor educatieve doeleinden gemaakt.
De auteurs zijn niet verantwoordelijk voor misbruik van de
kennis opgedaan via BVWA. Gebruik altijd in een geïsoleerde,
lokale testomgeving.

## 📄 Licentie

MIT License — zie LICENSE bestand voor details.

## 🤝 Bijdragen

Pull requests zijn welkom! Zie CONTRIBUTING.md voor richtlijnen.
