# 🔐 BVWA — Beego Vulnerable Web Application

BVWA is een opzettelijk kwetsbare webapplicatie gebouwd met
het Go Beego framework, gebaseerd op de OWASP Top 10:2025.

> ⚠️ **WAARSCHUWING:** BVWA is uitsluitend bedoeld voor
> educatieve doeleinden. Gebruik het NOOIT in productie
> of op een publiek toegankelijke server.

## 🚀 Installatie

### Optie 1: Docker (aanbevolen)

De eenvoudigste manier om BVWA te draaien — geen Go
installatie vereist.

#### Vereisten
- Docker
- Docker Compose

#### Stappen
```bash
# Clone het project
git clone https://github.com/B2TheEe/BVWA.git
cd BVWA

# Bouw en start alle containers
docker-compose up --build

# Of op de achtergrond
docker-compose up --build -d
```

Ga naar: `http://localhost:8080`

#### Handige Docker commando's
```bash
# Stoppen
docker-compose down

# Stoppen inclusief database
docker-compose down -v

# Logs bekijken
docker-compose logs -f bvwa

# Herbouwen zonder cache
docker-compose build --no-cache
```

---

### Optie 2: Lokaal draaien (zonder Docker)

#### Vereisten
- Go 1.24.2+
- MySQL 5.7+
- Beego v2 & bee CLI

#### Stappen
```bash
# Clone het project
git clone https://github.com/B2TheEe/BVWA.git
cd BVWA

# Installeer dependencies
go mod tidy

# Installeer bee CLI
go install github.com/beego/bee/v2@latest

# Maak de database aan
mysql -u root -p
CREATE DATABASE bvwa;

# Start de applicatie
bee run
```

Ga naar: `http://localhost:8080`

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
BVWA/
├── conf/
│   └── app.conf
├── controllers/
│   ├── access_control.go   (A01)
│   ├── security_misconfig.go (A02)
│   ├── supply_chain.go     (A03)
│   ├── crypto.go           (A04)
│   ├── injection.go        (A05)
│   ├── insecure_design.go  (A06)
│   ├── auth.go             (A07)
│   ├── integrity.go        (A08)
│   ├── logging.go          (A09)
│   ├── exceptions.go       (A10)
│   ├── home.go
│   └── login.go
├── routers/
│   └── router.go
├── static/
│   ├── css/bvwa.css
│   └── js/modal.js
├── views/
├── Dockerfile
├── docker-compose.yml
├── main.go
└── README.md
```

## 🔧 Configuratie

### Docker (automatisch via docker-compose.yml)
Database configuratie wordt automatisch ingesteld.

### Lokaal (`conf/app.conf`)
```ini
appname     = bvwa
httpport    = 8080
runmode     = dev
sessionon   = true
sessionname = bvwasession

db_user     = root
db_pass     = jouwwachtwoord
db_host     = 127.0.0.1
db_port     = 3306
db_name     = bvwa
```

## 🧪 Test Credentials

| Gebruiker | Wachtwoord | Rol |
|-----------|-----------|-----|
| admin | password123 | Administrator |
| user | user123 | Gebruiker |

## 🛠️ Technologieën

- **Taal:** Go 1.24.2+
- **Framework:** Beego v2
- **Database:** MySQL
- **Container:** Docker & Docker Compose
- **Beveiliging:** bcrypt, HMAC-SHA256

## ⚖️ Disclaimer

Dit project is uitsluitend voor educatieve doeleinden.
De auteurs zijn niet verantwoordelijk voor misbruik.
Gebruik altijd in een geïsoleerde testomgeving.

## 📄 Licentie

MIT License — zie LICENSE bestand voor details.
