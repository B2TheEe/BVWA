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
        .msg-blocked {
            background: #f8d7da;
            border: 1px solid #721c24;
            border-radius: 6px;
            padding: 12px 16px;
            font-size: 14px;
            color: #721c24;
            margin-top: 10px;
            font-weight: bold;
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
        <a href="/design/vulnerable">Kwetsbaar</a>
        <a href="/design/secure">Veilig</a>
    </nav>
</header>

<!-- BREADCRUMB -->
<div class="breadcrumb">
    <a href="/">Home</a> &rsaquo; A06 &rsaquo; {{.Title}}
</div>

<!-- MAIN -->
<div class="container">

    <div class="module-header">
        <span class="badge">A06</span>
        <h1>Insecure Design</h1>
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
                    Wachtwoord reset <strong>zonder rate
                    limiting of verificatie</strong>. Geen
                    limiet op het aantal verzoeken.
                </p>
                <div class="code-block">// KWETSBAAR: geen limiet
if email != "" {
    message = "Reset verstuurd naar: " + email
    // geen check, geen rate limiting!
}</div>

                <p style="font-size:13px; color:#e74c3c;
                           font-weight:bold; margin-top:8px;">
                    Probeer: verstuur 10x een reset voor
                    hetzelfde adres.
                </p>

                <form method="GET" action="/design/vulnerable">
                    <div class="input-group">
                        <label>E-mailadres:</label>
                        <input type="text" name="email"
                               value="{{.Email}}"
                               placeholder="slachtoffer@example.com">
                    </div>
                    <button type="submit" class="btn-submit red">
                        Reset aanvragen (kwetsbaar)
                    </button>
                </form>
            </div>
        </div>

        <!-- VEILIG -->
        <div class="card">
            <div class="card-header safe">Veilige versie</div>
            <div class="card-body">
                <p>
                    Wachtwoord reset <strong>met rate limiting
                    (max 3 pogingen)</strong> en
                    token-gebaseerde verificatie.
                </p>
                <div class="code-block">// VEILIG: rate limiting
resetAttempts[email]++
if resetAttempts[email] &gt; 3 {
    // blokkeer het verzoek
    warning = "Geblokkeerd!"
}</div>

                <p style="font-size:13px; color:#27ae60;
                           font-weight:bold; margin-top:8px;">
                    Probeer: verstuur meer dan 3x een reset.
                    Daarna wordt het geblokkeerd.
                </p>

                <form method="GET" action="/design/secure">
                    <div class="input-group">
                        <label>E-mailadres:</label>
                        <input type="text" name="email"
                               value="{{.Email}}"
                               placeholder="gebruiker@example.com">
                    </div>
                    <button type="submit" class="btn-submit green">
                        Reset aanvragen (veilig)
                    </button>
                </form>
            </div>
        </div>

    </div>

    <!-- Result box -->
    <div class="result-box">
        <h3>Resultaat: <strong>{{.Title}}</strong></h3>

        {{if eq .Title "Insecure Design (Kwetsbaar)"}}
        <span class="tag-vuln">KWETSBAAR</span>
        {{if .Message}}
        <div class="msg-success">{{.Message}}</div>
        <p style="margin-top:10px; color:#e74c3c; font-size:13px;">
            Geen limiet! Een aanvaller kan dit onbeperkt
            herhalen voor spam of user enumeration.
        </p>
        {{else}}
        <p>Voer een e-mailadres in om de kwetsbaarheid te testen.</p>
        {{end}}

        {{else}}
        <span class="tag-safe">VEILIG</span>
        {{if .Warning}}
        <div class="msg-blocked">{{.Warning}}</div>
        {{else if .Message}}
        <div class="msg-success">{{.Message}}</div>
        {{else}}
        <p>Voer een e-mailadres in. Na 3 pogingen wordt
           het geblokkeerd door rate limiting.</p>
        {{end}}
        {{if .Info}}
        <p style="margin-top:10px; color:#27ae60;
                  font-size:13px; font-weight:bold;">
            {{.Info}}
        </p>
        {{end}}
        {{end}}

        <div class="tip">
            Tip: Gebruik hetzelfde e-mailadres meerdere keren
            op de veilige versie om rate limiting te zien.
            De teller reset bij herstart van de server.
        </div>
    </div>

</div>

<!-- INFO MODAL -->
<div class="modal-overlay" id="infoModal">
    <div class="modal">
        <button type="button" class="modal-close"
                id="closeInfoBtn">X</button>

        <h2>A06:2025 - Insecure Design</h2>
        <p class="subtitle">
            OWASP Top 10:2025 - Positie #6 -
            Nieuw in 2021, uitgebreid in 2025
        </p>
        <hr>

        <div class="info-section">
            <h3>Wat is het?</h3>
            <p>
                Insecure Design focust op risicos die voortkomen
                uit ontwerpfouten in de architectuur en werkstromen.
                Anders dan implementatiefouten gaat het hier om
                fundamentele beveiligingsfouten in het ontwerp zelf.
                Beveiliging moet vanaf het begin ingebakken zijn,
                niet achteraf worden toegevoegd.
            </p>
        </div>
        <hr>

        <div class="info-section">
            <h3>Gerelateerde CWEs</h3>
            <div class="cwe-list">
                <span class="cwe-tag">CWE-73 External Control of File Name or Path</span>
                <span class="cwe-tag">CWE-183 Permissive List of Allowed Inputs</span>
                <span class="cwe-tag">CWE-209 Error Message with Sensitive Info</span>
                <span class="cwe-tag">CWE-256 Plaintext Storage of a Password</span>
                <span class="cwe-tag">CWE-257 Passwords in Recoverable Format</span>
                <span class="cwe-tag">CWE-266 Incorrect Privilege Assignment</span>
                <span class="cwe-tag">CWE-269 Improper Privilege Management</span>
                <span class="cwe-tag">CWE-280 Insufficient Permissions Handling</span>
                <span class="cwe-tag">CWE-311 Missing Encryption of Sensitive Data</span>
                <span class="cwe-tag">CWE-312 Cleartext Storage of Sensitive Info</span>
                <span class="cwe-tag">CWE-434 Unrestricted File Upload</span>
                <span class="cwe-tag">CWE-444 Inconsistent HTTP Request Interpretation</span>
                <span class="cwe-tag">CWE-451 UI Misrepresentation</span>
                <span class="cwe-tag">CWE-501 Trust Boundary Violation</span>
                <span class="cwe-tag">CWE-522 Insufficiently Protected Credentials</span>
                <span class="cwe-tag">CWE-598 GET Request with Sensitive Query Strings</span>
                <span class="cwe-tag">CWE-602 Client-Side Security Enforcement</span>
                <span class="cwe-tag">CWE-642 External Control of Critical State Data</span>
                <span class="cwe-tag">CWE-799 Improper Control of Interaction Frequency</span>
                <span class="cwe-tag">CWE-807 Reliance on Untrusted Inputs</span>
                <span class="cwe-tag">CWE-840 Business Logic Errors</span>
                <span class="cwe-tag">CWE-841 Improper Behavioral Workflow</span>
                <span class="cwe-tag">CWE-1021 Improper Restriction of Rendered UI Layers</span>
                <span class="cwe-tag">CWE-1173 Improper Use of Validation Framework</span>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de kwetsbare versie onveilig?</h3>
            <div class="vuln-box">
                De kwetsbare versie heeft
                <strong>geen rate limiting</strong> (CWE-799):
                <ul>
                    <li><strong>Onbeperkte verzoeken:</strong>
                        aanvaller kan duizenden reset-mails
                        sturen (email flooding)</li>
                    <li><strong>User enumeration:</strong>
                        testen welke adressen een reset-mail
                        ontvangen onthult geldige accounts</li>
                    <li><strong>Geen verificatie:</strong>
                        geen bewijs dat aanvrager eigenaar is</li>
                    <li><strong>Geen token expiry:</strong>
                        reset-links verlopen niet en kunnen
                        later misbruikt worden</li>
                    <li>Valt onder CWE-840: Business Logic Error
                        - ontwerp houdt geen rekening met
                        misbruikscenarios</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de veilige versie correct?</h3>
            <div class="safe-box">
                De veilige versie implementeert
                <strong>secure design principes</strong>:
                <ul>
                    <li><strong>Rate limiting:</strong>
                        maximaal 3 reset-verzoeken per adres</li>
                    <li><strong>Token-gebaseerd:</strong>
                        elke reset-link bevat een uniek token</li>
                    <li><strong>Fail-closed:</strong>
                        bij te veel pogingen wordt toegang
                        geweigerd, niet verleend</li>
                    <li><strong>Generieke responses:</strong>
                        geen aanwijzing of een adres bestaat</li>
                    <li><strong>Threat modeling:</strong>
                        ontwerp houdt rekening met misbruik</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Mitigatie</h3>
            <p>
                Gebruik threat modeling tijdens het ontwerp.
                Implementeer rate limiting, CAPTCHA en
                token-gebaseerde verificatie. Volg het principe
                van least privilege. Documenteer
                beveiligingseisen als user stories. Betrek
                security experts vroeg in het ontwerpproces.
            </p>
        </div>

    </div>
</div>

<footer>
    BVWA is uitsluitend bedoeld voor educatieve doeleinden -
    gebruik alleen in een geisoleerde testomgeving.
</footer>



<script type="text/javascript" src="/static/js/modal.js"></script>

</body>
</html>
