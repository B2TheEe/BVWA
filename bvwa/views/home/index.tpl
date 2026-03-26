<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BVWA - Beego Vulnerable Web Application</title>
    <link rel="stylesheet" href="/static/css/bvwa.css">
</head>
<body>

<!-- ── HEADER ── -->
<header>
    <a href="/" class="logo">&#x1F510; <span>BVWA</span></a>
    <nav>
        <a href="/">&#x1F3E0; Home</a>
        <a href="/dashboard">Dashboard</a>
        <a href="/login" class="btn-login-nav">&#x1F511; Inloggen</a>
    </nav>
</header>

<!-- ── WARNING ── -->
<div class="warning-banner">
    &#9888; BVWA is uitsluitend bedoeld voor educatieve doeleinden
    — gebruik NOOIT in productie!
</div>

<!-- ── HERO ── -->
<div class="hero">
    <h1>&#x1F510; <span>BVWA</span></h1>
    <p>
        Beego Vulnerable Web Application — een opzettelijk
        kwetsbare webapplicatie gebaseerd op de OWASP Top 10:2025.
        Leer beveiligingskwetsbaarheden begrijpen via
        kwetsbare en veilige implementaties.
    </p>
    <div class="hero-badges">
        <span class="hero-badge">OWASP Top 10:2025</span>
        <span class="hero-badge">Go + Beego</span>
        <span class="hero-badge">10 Modules</span>
        <span class="hero-badge">Educatief</span>
    </div>
</div>

<!-- ── MAIN ── -->
<div class="container">

    <!-- Stats -->
    <div class="stats">
        <div class="stat-card">
            <div class="stat-icon">&#x1F3AF;</div>
            <div class="stat-number">10</div>
            <div class="stat-label">OWASP Modules</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">&#x1F513;</div>
            <div class="stat-number">10</div>
            <div class="stat-label">Kwetsbare versies</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">&#x1F512;</div>
            <div class="stat-number">10</div>
            <div class="stat-label">Veilige versies</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">&#x1F4DA;</div>
            <div class="stat-number">34+</div>
            <div class="stat-label">CWEs gedekt</div>
        </div>
    </div>

    <!-- Quick actions -->
    <p class="section-title">&#x26A1; Snel starten</p>
    <div class="quick-actions">
        <a href="/login" class="action-card">
            <div class="action-icon">&#x1F511;</div>
            <div class="action-title">Inloggen</div>
            <div class="action-desc">
                Log in om het dashboard te zien met alle modules
            </div>
        </a>
        <a href="/admin/vulnerable" class="action-card">
            <div class="action-icon">&#x1F513;</div>
            <div class="action-title">Kwetsbare versies</div>
            <div class="action-desc">
                Start direct met het testen van kwetsbaarheden
            </div>
        </a>
        <a href="https://github.com/B2TheEe/BVWA"
           target="_blank" class="action-card">
            <div class="action-icon">&#x1F4BB;</div>
            <div class="action-title">GitHub</div>
            <div class="action-desc">
                Bekijk de broncode op GitHub
            </div>
        </a>
    </div>

    <!-- OWASP Modules -->
    <p class="section-title">&#x1F6E1; OWASP Top 10:2025 Modules</p>
    <div class="modules-grid">

        <div class="module-card">
            <div class="module-card-header">
                <span class="badge">A01</span>
                <h3>Broken Access Control</h3>
            </div>
            <div class="module-card-body">
                <p>Toegangscontrole wordt niet correct afgedwongen.
                   Gebruikers kunnen buiten hun rechten handelen.</p>
                <div class="module-btns">
                    <a href="/admin/vulnerable" class="btn-vuln">
                        Kwetsbaar
                    </a>
                    <a href="/admin/secure" class="btn-safe">
                        Veilig
                    </a>
                </div>
            </div>
        </div>

        <div class="module-card">
            <div class="module-card-header">
                <span class="badge">A02</span>
                <h3>Security Misconfiguration</h3>
            </div>
            <div class="module-card-body">
                <p>Ontbrekende of verkeerde security headers.
                   100% van applicaties getroffen.</p>
                <div class="module-btns">
                    <a href="/misconfig/vulnerable" class="btn-vuln">
                        Kwetsbaar
                    </a>
                    <a href="/misconfig/secure" class="btn-safe">
                        Veilig
                    </a>
                </div>
            </div>
        </div>

        <div class="module-card">
            <div class="module-card-header">
                <span class="badge">A03</span>
                <h3>Software Supply Chain Failures</h3>
            </div>
            <div class="module-card-body">
                <p>Gebruik van verouderde of kwetsbare
                   dependencies (MD5 vs SHA-256).</p>
                <div class="module-btns">
                    <a href="/supplychain/vulnerable" class="btn-vuln">
                        Kwetsbaar
                    </a>
                    <a href="/supplychain/secure" class="btn-safe">
                        Veilig
                    </a>
                </div>
            </div>
        </div>

        <div class="module-card">
            <div class="module-card-header">
                <span class="badge">A04</span>
                <h3>Cryptographic Failures</h3>
            </div>
            <div class="module-card-body">
                <p>Zwakke versleuteling van gevoelige data.
                   MD5 vs bcrypt voor wachtwoorden.</p>
                <div class="module-btns">
                    <a href="/crypto/vulnerable" class="btn-vuln">
                        Kwetsbaar
                    </a>
                    <a href="/crypto/secure" class="btn-safe">
                        Veilig
                    </a>
                </div>
            </div>
        </div>

        <div class="module-card">
            <div class="module-card-header">
                <span class="badge">A05</span>
                <h3>Injection (SQL &amp; XSS)</h3>
            </div>
            <div class="module-card-body">
                <p>Ongesaniteerde gebruikersinput als SQL-commando
                   of HTML/JS uitgevoerd.</p>
                <div class="module-btns">
                    <a href="/injection/sql/vulnerable"
                       class="btn-vuln">SQL</a>
                    <a href="/injection/xss/vulnerable"
                       class="btn-vuln">XSS</a>
                    <a href="/injection/sql/secure"
                       class="btn-safe">Veilig</a>
                </div>
            </div>
        </div>

        <div class="module-card">
            <div class="module-card-header">
                <span class="badge">A06</span>
                <h3>Insecure Design</h3>
            </div>
            <div class="module-card-body">
                <p>Ontwerpfouten zoals password reset zonder
                   rate limiting of verificatie.</p>
                <div class="module-btns">
                    <a href="/design/vulnerable" class="btn-vuln">
                        Kwetsbaar
                    </a>
                    <a href="/design/secure" class="btn-safe">
                        Veilig
                    </a>
                </div>
            </div>
        </div>

        <div class="module-card">
            <div class="module-card-header">
                <span class="badge">A07</span>
                <h3>Authentication Failures</h3>
            </div>
            <div class="module-card-body">
                <p>Zwakke login: geen rate limiting, plaintext
                   wachtwoorden, slechte sessiebeheer.</p>
                <div class="module-btns">
                    <a href="/auth/vulnerable" class="btn-vuln">
                        Kwetsbaar
                    </a>
                    <a href="/auth/secure" class="btn-safe">
                        Veilig
                    </a>
                </div>
            </div>
        </div>

        <div class="module-card">
            <div class="module-card-header">
                <span class="badge">A08</span>
                <h3>Software/Data Integrity Failures</h3>
            </div>
            <div class="module-card-body">
                <p>Geserialiseerde data zonder
                   integriteitscontrole. HMAC-SHA256 fix.</p>
                <div class="module-btns">
                    <a href="/integrity/vulnerable" class="btn-vuln">
                        Kwetsbaar
                    </a>
                    <a href="/integrity/secure" class="btn-safe">
                        Veilig
                    </a>
                </div>
            </div>
        </div>

        <div class="module-card">
            <div class="module-card-header">
                <span class="badge">A09</span>
                <h3>Security Logging &amp; Alerting</h3>
            </div>
            <div class="module-card-body">
                <p>Ontbrekende logging van
                   beveiligingsgebeurtenissen en alerting.</p>
                <div class="module-btns">
                    <a href="/logging/vulnerable" class="btn-vuln">
                        Kwetsbaar
                    </a>
                    <a href="/logging/secure" class="btn-safe">
                        Veilig
                    </a>
                </div>
            </div>
        </div>

        <div class="module-card">
            <div class="module-card-header">
                <span class="badge">A10</span>
                <h3>Mishandling of Exceptional Conditions</h3>
            </div>
            <div class="module-card-body">
                <p>Onjuiste foutafhandeling die interne details
                   lekt of fail-open gedrag veroorzaakt.</p>
                <div class="module-btns">
                    <a href="/exceptions/vulnerable" class="btn-vuln">
                        Kwetsbaar
                    </a>
                    <a href="/exceptions/secure" class="btn-safe">
                        Veilig
                    </a>
                </div>
            </div>
        </div>

    </div>
</div>

<footer>
    &#9888; BVWA &mdash; Uitsluitend voor educatieve doeleinden
    &nbsp;|&nbsp; OWASP Top 10:2025 &nbsp;|&nbsp;
    <a href="https://github.com/B2TheEe/BVWA"
       target="_blank"
       style="color:#e67e22; text-decoration:none;">
        GitHub
    </a>
</footer>

</body>
</html>
