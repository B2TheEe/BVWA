<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BVWA - Beego Vulnerable Web Application</title>
    <link rel="stylesheet" href="/static/css/bvwa.css">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #f0f2f5; }

        /* ── Header ── */
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
        .btn-login-nav {
            background: #27ae60;
            color: white;
            padding: 7px 16px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 13px;
            font-weight: bold;
            margin-left: 16px;
        }
        .btn-login-nav:hover { background: #1e8449; }

        /* ── Hero ── */
        .hero {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            color: white;
            padding: 50px 30px;
            text-align: center;
        }
        .hero h1 {
            font-size: 36px;
            margin-bottom: 10px;
        }
        .hero h1 span { color: #e67e22; }
        .hero p {
            font-size: 16px;
            color: #bdc3c7;
            max-width: 600px;
            margin: 0 auto 20px;
            line-height: 1.7;
        }
        .hero-badges {
            display: flex;
            justify-content: center;
            gap: 10px;
            flex-wrap: wrap;
        }
        .hero-badge {
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            color: white;
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 12px;
        }

        /* ── Warning banner ── */
        .warning-banner {
            background: #e74c3c;
            color: white;
            padding: 12px 30px;
            text-align: center;
            font-size: 13px;
            font-weight: bold;
        }

        /* ── Container ── */
        .container {
            max-width: 960px;
            margin: 30px auto;
            padding: 0 20px;
        }

        /* ── Section title ── */
        .section-title {
            font-size: 18px;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* ── OWASP module cards ── */
        .modules-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 16px;
            margin-bottom: 30px;
        }
        .module-card {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.07);
        }
        .module-card-header {
            background: #2c3e50;
            padding: 12px 16px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .module-card-header .badge {
            background: #e67e22;
            color: white;
            font-size: 11px;
            font-weight: bold;
            padding: 3px 10px;
            border-radius: 12px;
            white-space: nowrap;
        }
        .module-card-header h3 {
            color: white;
            font-size: 13px;
            font-weight: bold;
        }
        .module-card-body {
            padding: 14px 16px;
        }
        .module-card-body p {
            font-size: 12px;
            color: #7f8c8d;
            line-height: 1.5;
            margin-bottom: 12px;
        }
        .module-btns {
            display: flex;
            gap: 8px;
        }
        .btn-vuln, .btn-safe {
            flex: 1;
            padding: 7px 10px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 12px;
            font-weight: bold;
            color: white;
            text-align: center;
            white-space: nowrap;
        }
        .btn-vuln { background: #e74c3c; }
        .btn-vuln:hover { background: #c0392b; }
        .btn-safe  { background: #27ae60; }
        .btn-safe:hover  { background: #1e8449; }

        /* ── Quick actions ── */
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 14px;
            margin-bottom: 30px;
        }
        .action-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.07);
            text-decoration: none;
            color: inherit;
            transition: transform 0.15s, box-shadow 0.15s;
        }
        .action-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(0,0,0,0.12);
        }
        .action-icon { font-size: 30px; margin-bottom: 10px; }
        .action-title {
            font-size: 14px;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 6px;
        }
        .action-desc {
            font-size: 12px;
            color: #7f8c8d;
        }

        /* ── Stats ── */
        .stats {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 14px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 18px;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.07);
        }
        .stat-number {
            font-size: 30px;
            font-weight: bold;
            color: #2c3e50;
        }
        .stat-label {
            font-size: 11px;
            color: #7f8c8d;
            margin-top: 4px;
        }
        .stat-icon { font-size: 20px; margin-bottom: 6px; }

        /* ── Footer ── */
        footer {
            text-align: center;
            padding: 20px;
            color: #aaa;
            font-size: 12px;
            margin-top: 10px;
            border-top: 1px solid #e0e0e0;
        }

        /* ── Responsive ── */
        @media (max-width: 768px) {
            .hero h1 { font-size: 24px; }
            .modules-grid { grid-template-columns: 1fr; }
            .quick-actions { grid-template-columns: 1fr; }
            .stats { grid-template-columns: repeat(2, 1fr); }
            header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            header nav { display: flex; flex-wrap: wrap; gap: 8px; }
            header nav a { margin-left: 0; }
        }
        @media (max-width: 480px) {
            .hero { padding: 30px 16px; }
            .container { padding: 0 14px; }
            .stats { grid-template-columns: repeat(2, 1fr); }
        }
    </style>
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
