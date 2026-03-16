<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{.Title}} - BVWA</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #f0f2f5; }

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

        .breadcrumb {
            background: #34495e;
            padding: 8px 30px;
            font-size: 13px;
            color: #bdc3c7;
        }
        .breadcrumb a { color: #e67e22; text-decoration: none; }
        .breadcrumb a:hover { text-decoration: underline; }

        .container {
            max-width: 960px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .module-header {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 20px;
        }
        .badge {
            background: #e67e22;
            color: white;
            font-weight: bold;
            font-size: 13px;
            padding: 6px 14px;
            border-radius: 20px;
            white-space: nowrap;
        }
        .module-header h1 { font-size: 24px; color: #2c3e50; }
        .btn-info {
            margin-left: auto;
            background: #3498db;
            color: white;
            border: none;
            padding: 9px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            white-space: nowrap;
        }
        .btn-info:hover { background: #2980b9; }

        .cards {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        @media (max-width: 640px) {
            .cards { grid-template-columns: 1fr; }
        }

        .card {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .card-header {
            padding: 14px 20px;
            font-weight: bold;
            font-size: 15px;
            color: white;
        }
        .card-header.vuln { background: #e74c3c; }
        .card-header.safe { background: #27ae60; }
        .card-body { padding: 20px; }
        .card-body p {
            font-size: 14px;
            color: #555;
            line-height: 1.6;
            margin-bottom: 14px;
        }

        .input-group { margin-bottom: 14px; }
        .input-group label {
            display: block;
            font-size: 13px;
            font-weight: bold;
            color: #555;
            margin-bottom: 6px;
        }
        .input-group input {
            width: 100%;
            padding: 9px 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 13px;
        }
        .input-group input:focus {
            outline: none;
            border-color: #3498db;
        }

        .code-block {
            background: #1e1e1e;
            color: #d4d4d4;
            font-family: monospace;
            font-size: 12px;
            padding: 14px;
            border-radius: 6px;
            overflow-x: auto;
            margin: 10px 0;
            line-height: 1.8;
            white-space: pre;
        }

        .btn-submit {
            display: block;
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: bold;
            color: white;
            cursor: pointer;
            margin-top: 10px;
        }
        .btn-submit.red   { background: #e74c3c; }
        .btn-submit.red:hover   { background: #c0392b; }
        .btn-submit.green { background: #27ae60; }
        .btn-submit.green:hover { background: #1e8449; }

        .credentials-hint {
            background: #f8f9fa;
            border-radius: 6px;
            padding: 10px 14px;
            font-size: 12px;
            color: #666;
            margin-top: 10px;
        }

        .result-box {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-top: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .result-box h3 { margin-bottom: 12px; color: #2c3e50; }
        .result-box p  { font-size: 14px; color: #555; line-height: 1.6; }

        .tag-vuln {
            display: inline-block;
            background: #fdecea;
            color: #e74c3c;
            font-weight: bold;
            font-size: 12px;
            padding: 3px 10px;
            border-radius: 20px;
            margin-bottom: 10px;
        }
        .tag-safe {
            display: inline-block;
            background: #eafaf1;
            color: #27ae60;
            font-weight: bold;
            font-size: 12px;
            padding: 3px 10px;
            border-radius: 20px;
            margin-bottom: 10px;
        }
        .msg-success {
            background: #eafaf1;
            border: 1px solid #27ae60;
            border-radius: 6px;
            padding: 12px 16px;
            font-size: 14px;
            color: #1e8449;
            margin-top: 10px;
        }
        .msg-error {
            background: #fdecea;
            border: 1px solid #e74c3c;
            border-radius: 6px;
            padding: 12px 16px;
            font-size: 14px;
            color: #c0392b;
            margin-top: 10px;
        }
        .tip {
            background: #eaf4fb;
            border: 1px solid #aed6f1;
            border-radius: 6px;
            padding: 12px 16px;
            font-size: 13px;
            color: #2471a3;
            margin-top: 12px;
        }

        /* Modal */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.55);
            z-index: 9999;
            overflow-y: auto;
            padding: 40px 20px;
        }
        .modal {
            background: white;
            border-radius: 10px;
            max-width: 720px;
            width: 100%;
            margin: 0 auto;
            padding: 30px;
            position: relative;
            box-shadow: 0 8px 40px rgba(0,0,0,0.3);
        }
        .modal-close {
            position: absolute;
            top: 14px; right: 18px;
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: #666;
            line-height: 1;
        }
        .modal-close:hover { color: #e74c3c; }
        .modal h2 {
            color: #2c3e50;
            margin-bottom: 6px;
            font-size: 20px;
            padding-right: 30px;
        }
        .modal .subtitle {
            color: #7f8c8d;
            font-size: 13px;
            margin-bottom: 20px;
        }
        .modal hr {
            border: none;
            border-top: 1px solid #ecf0f1;
            margin: 16px 0;
        }
        .cwe-list {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin: 10px 0 16px;
        }
        .cwe-tag {
            background: #eaf4fb;
            border: 1px solid #aed6f1;
            color: #2471a3;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }
        .info-section { margin-bottom: 16px; }
        .info-section h3 {
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #7f8c8d;
            margin-bottom: 8px;
        }
        .info-section p {
            font-size: 14px;
            line-height: 1.7;
            color: #444;
        }
        .vuln-box {
            background: #fdf2f2;
            border-left: 4px solid #e74c3c;
            padding: 12px 16px;
            border-radius: 0 6px 6px 0;
            font-size: 14px;
            line-height: 1.7;
            color: #444;
        }
        .safe-box {
            background: #f2fdf5;
            border-left: 4px solid #2ecc71;
            padding: 12px 16px;
            border-radius: 0 6px 6px 0;
            font-size: 14px;
            line-height: 1.7;
            color: #444;
        }
        .vuln-box ul, .safe-box ul { margin: 8px 0 0 20px; }
        .vuln-box li, .safe-box li { margin-bottom: 5px; }

        footer {
            text-align: center;
            padding: 20px;
            color: #aaa;
            font-size: 12px;
            margin-top: 40px;
        }
    </style>
    <link rel="stylesheet" href="/static/css/bvwa.css">
</head>
<body>

<!-- HEADER -->
<header>
    <a href="/" class="logo">&#x1F510; <span>BVWA</span></a>
    <nav>
        <a href="/">&#x1F3E0; Home</a>
        <a href="/auth/vulnerable">Kwetsbaar</a>
        <a href="/auth/secure">Veilig</a>
    </nav>
</header>

<!-- BREADCRUMB -->
<div class="breadcrumb">
    <a href="/">Home</a> &rsaquo; A07 &rsaquo; {{.Title}}
</div>

<!-- MAIN -->
<div class="container">

    <div class="module-header">
        <span class="badge">A07</span>
        <h1>Authentication Failures</h1>
        <button type="button" class="btn-info" id="openInfoBtn">
            Info &amp; CWEs
        </button>
    </div>

    <div class="cards">

        <!-- KWETSBAAR -->
        <div class="card">
            <div class="card-header vuln">Kwetsbare versie</div>
            <div class="card-body">
                <p>
                    Login <strong>zonder rate limiting</strong>,
                    met plaintext wachtwoord vergelijking en
                    geen sessie-vernieuwing na inloggen.
                </p>
                <div class="code-block">// KWETSBAAR: plaintext + geen limiet
storedPass, exists := users[username]
if exists &amp;&amp; storedPass == password {
    c.SetSession("user", username)
    // geen sessie-vernieuwing!
}</div>

                <p style="font-size:13px; color:#e74c3c;
                           font-weight:bold; margin-top:8px;">
                    Probeer: 10x inloggen met fout wachtwoord.
                    Geen blokkering!
                </p>

                <form method="POST" action="/auth/vulnerable">
                    <div class="input-group">
                        <label>Gebruikersnaam:</label>
                        <input type="text" name="username"
                               placeholder="admin">
                    </div>
                    <div class="input-group">
                        <label>Wachtwoord:</label>
                        <input type="password" name="password"
                               placeholder="password123">
                    </div>
                    <button type="submit"
                            class="btn-submit red">
                        Inloggen (kwetsbaar)
                    </button>
                </form>

                <div class="credentials-hint">
                    admin / password123 &nbsp;|&nbsp;
                    user / user123
                </div>
            </div>
        </div>

        <!-- VEILIG -->
        <div class="card">
            <div class="card-header safe">Veilige versie</div>
            <div class="card-body">
                <p>
                    Login <strong>met bcrypt, rate limiting
                    (max 5 pogingen per IP)</strong> en
                    sessie-vernieuwing na inloggen.
                </p>
                <div class="code-block">// VEILIG: bcrypt + rate limiting
if loginAttempts[ip] &gt;= maxAttempts {
    // blokkeer IP
}
err := bcrypt.CompareHashAndPassword(
    hash, []byte(password))
c.DestroySession()
c.SetSession("user", username)</div>

                <p style="font-size:13px; color:#27ae60;
                           font-weight:bold; margin-top:8px;">
                    Probeer: 5x inloggen met fout wachtwoord.
                    Daarna geblokkeerd!
                </p>

                <form method="POST" action="/auth/secure">
                    <div class="input-group">
                        <label>Gebruikersnaam:</label>
                        <input type="text" name="username"
                               placeholder="admin">
                    </div>
                    <div class="input-group">
                        <label>Wachtwoord:</label>
                        <input type="password" name="password"
                               placeholder="password123">
                    </div>
                    <button type="submit"
                            class="btn-submit green">
                        Inloggen (veilig)
                    </button>
                </form>

                <div class="credentials-hint">
                    admin / password123 &nbsp;|&nbsp;
                    user / user123
                </div>
            </div>
        </div>

    </div>

    <!-- Result box -->
    <div class="result-box">
        <h3>Resultaat: <strong>{{.Title}}</strong></h3>

        {{if eq .Title "Login (Kwetsbaar)"}}
        <span class="tag-vuln">KWETSBAAR</span>

        {{if .Success}}
        <div class="msg-success">{{.Success}}</div>
        <p style="margin-top:10px; color:#e74c3c; font-size:13px;">
            Ingelogd! Geen rate limiting - brute force mogelijk.
            Wachtwoord vergeleken als plaintext.
        </p>
        {{else if .Error}}
        <div class="msg-error">{{.Error}}</div>
        {{if .Warning}}
        <p style="color:#e74c3c; font-size:13px; margin-top:6px;">
            {{.Warning}}
        </p>
        {{end}}
        {{else}}
        <p>Voer credentials in om de kwetsbaarheid te testen.</p>
        {{end}}

        {{else}}
        <span class="tag-safe">VEILIG</span>

        {{if .Success}}
        <div class="msg-success">{{.Success}}</div>
        {{if .Info}}
        <p style="color:#27ae60; font-size:13px; margin-top:6px;">
            {{.Info}}
        </p>
        {{end}}
        {{else if .Error}}
        <div class="msg-error">{{.Error}}</div>
        {{else}}
        <p>Voer credentials in. Na 5 foute pogingen wordt
           het IP geblokkeerd.</p>
        {{end}}
        {{end}}

        <div class="tip">
            Tip: Probeer 5x een fout wachtwoord op de veilige
            versie om rate limiting te testen. Gebruik
            admin / password123 om succesvol in te loggen.
        </div>
    </div>

</div>

<!-- INFO MODAL -->
<div class="modal-overlay" id="infoModal">
    <div class="modal">
        <button type="button" class="modal-close"
                id="closeInfoBtn">X</button>

        <h2>A07:2025 - Authentication Failures</h2>
        <p class="subtitle">
            OWASP Top 10:2025 - Positie #7 -
            Voorheen: Broken Authentication
        </p>
        <hr>

        <div class="info-section">
            <h3>Wat is het?</h3>
            <p>
                Authentication Failures treden op wanneer een
                applicatie authenticatie- en sessiebeheer
                onjuist implementeert. Een aanvaller kan
                wachtwoorden kraken, sessies overnemen of
                authenticatie volledig omzeilen via zwakke
                implementaties van login, logout of
                wachtwoordherstel.
            </p>
        </div>
        <hr>

        <div class="info-section">
            <h3>Gerelateerde CWEs</h3>
            <div class="cwe-list">
                <span class="cwe-tag">CWE-255 Credentials Management Errors</span>
                <span class="cwe-tag">CWE-259 Use of Hard-coded Password</span>
                <span class="cwe-tag">CWE-287 Improper Authentication</span>
                <span class="cwe-tag">CWE-288 Authentication Bypass Using Alternate Path</span>
                <span class="cwe-tag">CWE-290 Authentication Bypass by Spoofing</span>
                <span class="cwe-tag">CWE-294 Authentication Bypass by Capture-replay</span>
                <span class="cwe-tag">CWE-295 Improper Certificate Validation</span>
                <span class="cwe-tag">CWE-297 Improper Validation of Certificate with Host Mismatch</span>
                <span class="cwe-tag">CWE-300 Channel Accessible by Non-Endpoint</span>
                <span class="cwe-tag">CWE-302 Authentication Bypass by Assumed-Immutable Data</span>
                <span class="cwe-tag">CWE-304 Missing Critical Step in Authentication</span>
                <span class="cwe-tag">CWE-306 Missing Authentication for Critical Function</span>
                <span class="cwe-tag">CWE-307 Improper Restriction of Excessive Auth Attempts</span>
                <span class="cwe-tag">CWE-346 Origin Validation Error</span>
                <span class="cwe-tag">CWE-384 Session Fixation</span>
                <span class="cwe-tag">CWE-521 Weak Password Requirements</span>
                <span class="cwe-tag">CWE-613 Insufficient Session Expiration</span>
                <span class="cwe-tag">CWE-620 Unverified Password Change</span>
                <span class="cwe-tag">CWE-640 Weak Password Recovery Mechanism</span>
                <span class="cwe-tag">CWE-798 Use of Hard-coded Credentials</span>
                <span class="cwe-tag">CWE-940 Improper Verification of Communication Channel</span>
                <span class="cwe-tag">CWE-1216 Lockout Mechanism Errors</span>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de kwetsbare versie onveilig?</h3>
            <div class="vuln-box">
                De kwetsbare versie heeft meerdere fouten:
                <ul>
                    <li><strong>Plaintext vergelijking (CWE-256):
                        </strong> wachtwoorden opgeslagen als
                        plaintext - bij datalek direct leesbaar</li>
                    <li><strong>Geen rate limiting (CWE-307):
                        </strong> onbeperkte loginpogingen -
                        brute force en credential stuffing mogelijk</li>
                    <li><strong>Geen sessie-vernieuwing (CWE-384):
                        </strong> dezelfde sessie-ID voor en na
                        login - session fixation mogelijk</li>
                    <li><strong>Info-lekkage:</strong>
                        foutmelding geeft aan of gebruiker
                        bestaat - user enumeration</li>
                    <li><strong>Geen MFA:</strong> enkelfactor
                        authenticatie kwetsbaar voor
                        gestolen credentials</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de veilige versie correct?</h3>
            <div class="safe-box">
                De veilige versie implementeert correcte
                authenticatie:
                <ul>
                    <li><strong>bcrypt hashing:</strong>
                        wachtwoorden als bcrypt hash opgeslagen -
                        bij datalek niet direct bruikbaar</li>
                    <li><strong>Rate limiting per IP (CWE-307 fix):
                        </strong> max 5 pogingen, daarna geblokkeerd</li>
                    <li><strong>Sessie-vernieuwing (CWE-384 fix):
                        </strong> DestroySession() voor nieuwe
                        sessie na login</li>
                    <li><strong>Generieke foutmelding:</strong>
                        geen aanwijzing of gebruiker bestaat</li>
                    <li><strong>Timing-safe vergelijking:</strong>
                        bcrypt.CompareHashAndPassword() voorkomt
                        timing attacks</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Mitigatie</h3>
            <p>
                Gebruik bcrypt of Argon2 voor wachtwoorden.
                Implementeer MFA. Voeg rate limiting toe op
                alle auth-endpoints. Vernieuw sessie-IDs na
                login en logout. Gebruik generieke foutmeldingen.
                Log alle authenticatiegebeurtenissen.
            </p>
        </div>

    </div>
</div>

<footer>
    BVWA is uitsluitend bedoeld voor educatieve doeleinden -
    gebruik alleen in een geisoleerde testomgeving.
</footer>

<!-- Stap 3: extern modal.js in plaats van inline script -->
<script type="text/javascript" src="/static/js/modal.js"></script>

</body>
</html>
