<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <title>{{.Title}}</title>

    <link rel="stylesheet" href="/static/css/bvwa.css">
</head>
<body>

<header>
    <a href="/" class="logo">🔐 <span>BVWA</span></a>
    <nav>
        <a href="/">🏠 Home</a>
        <a href="/dashboard">Dashboard</a>
        <a href="/ctf">🚩 CTF</a>
        <a href="/logout" class="btn-logout">Uitloggen</a>
    </nav>
</header>

<div class="container">

    <!-- Welcome -->
    <div class="welcome-bar">
        <h1>👋 Welkom, <strong>{{.Username}}</strong>!</h1>
        <span class="role-badge">{{.Role}}</span>
    </div>

    <!-- Stats -->
    <div class="stats">
        <div class="stat-card">
            <div class="icon">🎯</div>
            <div class="number">10</div>
            <div class="label">OWASP Modules</div>
        </div>
        <div class="stat-card">
            <div class="icon">🔓</div>
            <div class="number">10</div>
            <div class="label">Kwetsbare versies</div>
        </div>
        <div class="stat-card">
            <div class="icon">🔒</div>
            <div class="number">10</div>
            <div class="label">Veilige versies</div>
        </div>
        <div class="stat-card">
            <div class="icon">🚩</div>
            <div class="number">{{.CTFSolved}}/{{.CTFTotal}}</div>
            <div class="label">CTF Flags gevonden</div>
        </div>
    </div>

    <!-- CTF widget -->
    <div class="ctf-widget">
        <div class="ctf-widget-header">
            <h2>🚩 Capture The Flag — Voortgang</h2>
            <a href="/ctf">Ga naar CTF →</a>
        </div>
        <div class="ctf-progress-row">
            <div class="ctf-score">{{.CTFSolved}}/{{.CTFTotal}}</div>
            <div class="ctf-track">
                <div class="ctf-fill" style="width: {{.CTFPercent}}%"></div>
            </div>
            <div class="ctf-label">{{.CTFPercent}}% voltooid</div>
        </div>
    </div>

    <!-- OWASP Modules -->
    <p class="section-title">🛡️ OWASP Top 10:2025 Modules</p>
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
                    <a href="/admin/vulnerable" class="btn-vuln">Kwetsbaar</a>
                    <a href="/admin/secure" class="btn-safe">Veilig</a>
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
                    <a href="/misconfig/vulnerable" class="btn-vuln">Kwetsbaar</a>
                    <a href="/misconfig/secure" class="btn-safe">Veilig</a>
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
                    <a href="/supplychain/vulnerable" class="btn-vuln">Kwetsbaar</a>
                    <a href="/supplychain/secure" class="btn-safe">Veilig</a>
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
                    <a href="/crypto/vulnerable" class="btn-vuln">Kwetsbaar</a>
                    <a href="/crypto/secure" class="btn-safe">Veilig</a>
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
                    <a href="/injection/sql/vulnerable" class="btn-vuln">SQL</a>
                    <a href="/injection/xss/vulnerable" class="btn-vuln">XSS</a>
                    <a href="/injection/sql/secure" class="btn-safe">Veilig</a>
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
                    <a href="/design/vulnerable" class="btn-vuln">Kwetsbaar</a>
                    <a href="/design/secure" class="btn-safe">Veilig</a>
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
                    <a href="/auth/vulnerable" class="btn-vuln">Kwetsbaar</a>
                    <a href="/auth/secure" class="btn-safe">Veilig</a>
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
                    <a href="/integrity/vulnerable" class="btn-vuln">Kwetsbaar</a>
                    <a href="/integrity/secure" class="btn-safe">Veilig</a>
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
                    <a href="/logging/vulnerable" class="btn-vuln">Kwetsbaar</a>
                    <a href="/logging/secure" class="btn-safe">Veilig</a>
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
                    <a href="/exceptions/vulnerable" class="btn-vuln">Kwetsbaar</a>
                    <a href="/exceptions/secure" class="btn-safe">Veilig</a>
                </div>
            </div>
        </div>

    </div>

    <!-- Notice -->
    <div class="notice">
        ⚠️ <strong>Educatieve omgeving:</strong>
        BVWA is opzettelijk kwetsbaar. Alle modules tonen
        zowel een kwetsbare als een veilige implementatie.
        Gebruik uitsluitend in een geïsoleerde testomgeving.
    </div>

</div>

<footer>
    ⚠️ BVWA — Uitsluitend voor educatieve doeleinden |
    OWASP Top 10:2025
</footer>

</body>
</html>
