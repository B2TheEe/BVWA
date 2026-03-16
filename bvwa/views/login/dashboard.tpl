<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <title>{{.Title}}</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: Arial, sans-serif;
            background: #f0f2f5;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        header {
            background: #2c3e50;
            color: white;
            padding: 16px 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        header .logo {
            font-size: 22px;
            font-weight: bold;
            text-decoration: none;
            color: white;
        }
        header .logo span { color: #e67e22; }
        header nav a {
            color: #ecf0f1;
            text-decoration: none;
            margin-left: 20px;
            font-size: 14px;
        }
        header nav a:hover { color: #e67e22; }
        .btn-logout {
            background: #e74c3c;
            color: white;
            border: none;
            padding: 7px 16px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            text-decoration: none;
            margin-left: 16px;
        }
        .btn-logout:hover { background: #c0392b; }

        .container {
            max-width: 1000px;
            margin: 30px auto;
            padding: 0 20px;
            flex: 1;
        }

        /* Welcome bar */
        .welcome-bar {
            background: white;
            border-radius: 10px;
            padding: 20px 24px;
            margin-bottom: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.07);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .welcome-bar h1 {
            font-size: 20px;
            color: #2c3e50;
        }
        .welcome-bar .role-badge {
            background: #e67e22;
            color: white;
            padding: 4px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
        }

        /* Stats row */
        .stats {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }
        @media (max-width: 700px) {
            .stats { grid-template-columns: repeat(2, 1fr); }
        }
        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.07);
        }
        .stat-card .number {
            font-size: 32px;
            font-weight: bold;
            color: #2c3e50;
        }
        .stat-card .label {
            font-size: 12px;
            color: #7f8c8d;
            margin-top: 4px;
        }
        .stat-card .icon { font-size: 24px; margin-bottom: 8px; }

        /* OWASP modules grid */
        .section-title {
            font-size: 16px;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 14px;
        }
        .modules-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 14px;
            margin-bottom: 24px;
        }
        @media (max-width: 640px) {
            .modules-grid { grid-template-columns: 1fr; }
        }
        .module-card {
            background: white;
            border-radius: 10px;
            padding: 16px 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.07);
            display: flex;
            align-items: center;
            gap: 14px;
            text-decoration: none;
            color: inherit;
            transition: transform 0.15s, box-shadow 0.15s;
        }
        .module-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(0,0,0,0.12);
        }
        .module-badge {
            background: #e67e22;
            color: white;
            font-weight: bold;
            font-size: 11px;
            padding: 4px 10px;
            border-radius: 6px;
            min-width: 42px;
            text-align: center;
            flex-shrink: 0;
        }
        .module-info h3 {
            font-size: 13px;
            color: #2c3e50;
            margin-bottom: 2px;
        }
        .module-info p {
            font-size: 11px;
            color: #7f8c8d;
        }
        .module-arrow {
            margin-left: auto;
            color: #bdc3c7;
            font-size: 18px;
            flex-shrink: 0;
        }

        /* Security notice */
        .notice {
            background: #fef9e7;
            border: 1px solid #f9e79f;
            border-radius: 10px;
            padding: 16px 20px;
            font-size: 13px;
            color: #7d6608;
            line-height: 1.6;
        }
        .notice strong { color: #6e5f00; }

        footer {
            text-align: center;
            padding: 20px;
            color: #aaa;
            font-size: 12px;
        }
    </style>
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
