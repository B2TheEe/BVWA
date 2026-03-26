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
            <div class="icon">📚</div>
            <div class="number">34</div>
            <div class="label">CWEs gedekt</div>
        </div>
    </div>

    <!-- OWASP Modules -->
    <p class="section-title">🛡️ OWASP Top 10:2025 Modules</p>
    <div class="modules-grid">

        <a href="/admin/vulnerable" class="module-card">
            <span class="module-badge">A01</span>
            <div class="module-info">
                <h3>Broken Access Control</h3>
                <p>Ongeautoriseerde toegang tot pagina's</p>
            </div>
            <span class="module-arrow">›</span>
        </a>

        <a href="/misconfig/vulnerable" class="module-card">
            <span class="module-badge">A02</span>
            <div class="module-info">
                <h3>Security Misconfiguration</h3>
                <p>Ontbrekende security headers</p>
            </div>
            <span class="module-arrow">›</span>
        </a>

        <a href="/supplychain/vulnerable" class="module-card">
            <span class="module-badge">A03</span>
            <div class="module-info">
                <h3>Supply Chain Failures</h3>
                <p>Verouderde/kwetsbare dependencies</p>
            </div>
            <span class="module-arrow">›</span>
        </a>

        <a href="/crypto/vulnerable" class="module-card">
            <span class="module-badge">A04</span>
            <div class="module-info">
                <h3>Cryptographic Failures</h3>
                <p>Zwakke versleuteling (MD5 vs bcrypt)</p>
            </div>
            <span class="module-arrow">›</span>
        </a>

        <a href="/injection/sql/vulnerable" class="module-card">
            <span class="module-badge">A05</span>
            <div class="module-info">
                <h3>Injection</h3>
                <p>SQL injection en XSS aanvallen</p>
            </div>
            <span class="module-arrow">›</span>
        </a>

        <a href="/design/vulnerable" class="module-card">
            <span class="module-badge">A06</span>
            <div class="module-info">
                <h3>Insecure Design</h3>
                <p>Geen rate limiting bij password reset</p>
            </div>
            <span class="module-arrow">›</span>
        </a>

        <a href="/auth/vulnerable" class="module-card">
            <span class="module-badge">A07</span>
            <div class="module-info">
                <h3>Authentication Failures</h3>
                <p>Zwakke login en sessiebeheer</p>
            </div>
            <span class="module-arrow">›</span>
        </a>

        <a href="/integrity/vulnerable" class="module-card">
            <span class="module-badge">A08</span>
            <div class="module-info">
                <h3>Integrity Failures</h3>
                <p>Gemanipuleerde geserialiseerde data</p>
            </div>
            <span class="module-arrow">›</span>
        </a>

        <a href="/logging/vulnerable" class="module-card">
            <span class="module-badge">A09</span>
            <div class="module-info">
                <h3>Logging & Alerting Failures</h3>
                <p>Ontbrekende beveiligingslogging</p>
            </div>
            <span class="module-arrow">›</span>
        </a>

        <a href="/exceptions/vulnerable" class="module-card">
            <span class="module-badge">A10</span>
            <div class="module-info">
                <h3>Exception Handling</h3>
                <p>Fouten lekken interne details</p>
            </div>
            <span class="module-arrow">›</span>
        </a>

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
