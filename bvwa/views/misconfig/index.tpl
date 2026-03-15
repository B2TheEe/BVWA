<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{.Title}} — BVWA</title>
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

        .header-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 12px;
            margin-bottom: 14px;
        }
        .header-table th {
            background: #ecf0f1;
            padding: 6px 10px;
            text-align: left;
            color: #555;
            font-weight: bold;
        }
        .header-table td {
            padding: 6px 10px;
            border-bottom: 1px solid #f0f0f0;
        }
        .cell-absent  { color: #e74c3c; font-weight: bold; }
        .cell-present { color: #27ae60; font-weight: bold; }

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

        .btn-link {
            display: block;
            padding: 10px 22px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 14px;
            font-weight: bold;
            color: white;
            text-align: center;
            margin-top: 10px;
        }
        .btn-red   { background: #e74c3c; }
        .btn-red:hover   { background: #c0392b; }
        .btn-green { background: #27ae60; }
        .btn-green:hover { background: #1e8449; }

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
</head>
<body>

<!-- HEADER -->
<header>
    <a href="/" class="logo">&#x1F510; <span>BVWA</span></a>
    <nav>
        <a href="/">&#x1F3E0; Home</a>
        <a href="/misconfig/vulnerable">Kwetsbaar</a>
        <a href="/misconfig/secure">Veilig</a>
    </nav>
</header>

<!-- BREADCRUMB -->
<div class="breadcrumb">
    <a href="/">Home</a> &rsaquo; A02 &rsaquo; {{.Title}}
</div>

<!-- MAIN -->
<div class="container">

    <div class="module-header">
        <span class="badge">A02</span>
        <h1>Security Misconfiguration</h1>
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
                    Geen security headers in de HTTP response.
                    De browser krijgt <strong>geen instructies</strong>
                    over hoe de pagina veilig geladen moet worden.
                </p>

                <table class="header-table">
                    <tr>
                        <th>Header</th>
                        <th>Status</th>
                    </tr>
                    <tr>
                        <td>X-Content-Type-Options</td>
                        <td class="cell-absent">Ontbreekt</td>
                    </tr>
                    <tr>
                        <td>X-Frame-Options</td>
                        <td class="cell-absent">Ontbreekt</td>
                    </tr>
                    <tr>
                        <td>Content-Security-Policy</td>
                        <td class="cell-absent">Ontbreekt</td>
                    </tr>
                    <tr>
                        <td>Strict-Transport-Security</td>
                        <td class="cell-absent">Ontbreekt</td>
                    </tr>
                </table>

                <div class="code-block">// KWETSBAAR: geen headers
func (c *VulnerableMisconfig) Get() {
    c.TplName = "misconfig/index.tpl"
}</div>

                <a href="/misconfig/vulnerable"
                   class="btn-link btn-red">
                    Open kwetsbare versie
                </a>
            </div>
        </div>

        <!-- VEILIG -->
        <div class="card">
            <div class="card-header safe">Veilige versie</div>
            <div class="card-body">
                <p>
                    Alle essentiële security headers worden
                    <strong>per response ingesteld</strong>.
                    De browser weet exact wat wel en niet
                    is toegestaan.
                </p>

                <table class="header-table">
                    <tr>
                        <th>Header</th>
                        <th>Status</th>
                    </tr>
                    <tr>
                        <td>X-Content-Type-Options</td>
                        <td class="cell-present">nosniff</td>
                    </tr>
                    <tr>
                        <td>X-Frame-Options</td>
                        <td class="cell-present">DENY</td>
                    </tr>
                    <tr>
                        <td>Content-Security-Policy</td>
                        <td class="cell-present">default-src 'self'</td>
                    </tr>
                    <tr>
                        <td>Strict-Transport-Security</td>
                        <td class="cell-present">max-age=63072000</td>
                    </tr>
                </table>

                <div class="code-block">// VEILIG: headers instellen
h := c.Ctx.ResponseWriter.Header()
h.Set("X-Content-Type-Options", "nosniff")
h.Set("X-Frame-Options", "DENY")</div>

                <a href="/misconfig/secure"
                   class="btn-link btn-green">
                    Open veilige versie
                </a>
            </div>
        </div>

    </div>

    <!-- Result box -->
    <div class="result-box">
        <h3>&#x1F50D; Huidige pagina: <strong>{{.Title}}</strong></h3>

        {{if eq .Title "Security Misconfiguration (Kwetsbaar)"}}
        <span class="tag-vuln">KWETSBAAR</span>
        <p>
            Deze response bevat <strong>geen security headers</strong>.
            Inspecteer via F12 &rarr; Network &rarr; Response Headers
            om dit te bevestigen.
        </p>
        {{else}}
        <span class="tag-safe">VEILIG</span>
        <p>
            Deze response bevat <strong>alle security headers</strong>.
            Inspecteer via F12 &rarr; Network &rarr; Response Headers
            om de headers te zien.
        </p>
        {{end}}

        <div class="tip">
            Tip: Open DevTools (F12) &rarr; Network &rarr; klik op
            dit verzoek &rarr; Response Headers om het verschil
            te zien tussen de kwetsbare en veilige versie.
        </div>
    </div>

</div>

<!-- INFO MODAL -->
<div class="modal-overlay" id="infoModal">
    <div class="modal">
        <button type="button" class="modal-close"
                id="closeInfoBtn">X</button>

        <h2>A02:2025 - Security Misconfiguration</h2>
        <p class="subtitle">
            OWASP Top 10:2025 - Positie #2 -
            100% van applicaties getroffen
        </p>
        <hr>

        <div class="info-section">
            <h3>Wat is het?</h3>
            <p>
                Security Misconfiguration treedt op wanneer een
                systeem, applicatie of cloudservice onjuist is
                geconfigureerd vanuit een beveiligingsperspectief.
                Denk aan ontbrekende security headers, standaard
                credentials, onnodige features, of foutmeldingen
                die interne details lekken. Het is de meest
                voorkomende kwetsbaarheid - gevonden in 100% van
                de geteste applicaties.
            </p>
        </div>
        <hr>

        <div class="info-section">
            <h3>Gerelateerde CWEs</h3>
            <div class="cwe-list">
                <span class="cwe-tag">CWE-2 7PK - Environment</span>
                <span class="cwe-tag">CWE-11 ASP.NET Misconfiguration: Debug Binary</span>
                <span class="cwe-tag">CWE-13 ASP.NET Misconfiguration: Password in Config</span>
                <span class="cwe-tag">CWE-15 External Control of System/Config Setting</span>
                <span class="cwe-tag">CWE-16 Configuration</span>
                <span class="cwe-tag">CWE-260 Password in Config File</span>
                <span class="cwe-tag">CWE-315 Plaintext Storage in Cookie</span>
                <span class="cwe-tag">CWE-520 .NET Misconfiguration: Use of Impersonation</span>
                <span class="cwe-tag">CWE-526 Cleartext Storage of Sensitive Info in Env</span>
                <span class="cwe-tag">CWE-537 Java Runtime Error Message Containing Sensitive Info</span>
                <span class="cwe-tag">CWE-541 Sensitive Info in Include File</span>
                <span class="cwe-tag">CWE-547 Use of Hard-coded Security-relevant Constants</span>
                <span class="cwe-tag">CWE-611 Improper Restriction of XML External Entity</span>
                <span class="cwe-tag">CWE-614 Sensitive Cookie Without Secure Attribute</span>
                <span class="cwe-tag">CWE-756 Missing Custom Error Page</span>
                <span class="cwe-tag">CWE-776 Improper Restriction of Recursive Entity References</span>
                <span class="cwe-tag">CWE-942 Permissive Cross-domain Policy</span>
                <span class="cwe-tag">CWE-1021 Improper Restriction of Rendered UI Layers</span>
                <span class="cwe-tag">CWE-1173 Improper Use of Validation Framework</span>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de kwetsbare versie onveilig?</h3>
            <div class="vuln-box">
                De kwetsbare controller stuurt
                <strong>geen enkele security header</strong> mee:
                <ul>
                    <li><strong>Geen X-Content-Type-Options:</strong>
                        browser mag MIME-sniffing uitvoeren -
                        XSS via geuploadde bestanden mogelijk</li>
                    <li><strong>Geen X-Frame-Options:</strong>
                        pagina kan in een iframe worden geladen -
                        clickjacking aanvallen (CWE-1021)</li>
                    <li><strong>Geen Content-Security-Policy:</strong>
                        geen beperking op scripts of bronnen -
                        XSS vergroot</li>
                    <li><strong>Geen HSTS:</strong> browser kan via
                        HTTP verbinden - man-in-the-middle mogelijk</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de veilige versie correct?</h3>
            <div class="safe-box">
                De veilige controller voegt per response
                <strong>vier essentiële headers</strong> toe:
                <ul>
                    <li><strong>X-Content-Type-Options: nosniff</strong>
                        - voorkomt MIME-type sniffing</li>
                    <li><strong>X-Frame-Options: DENY</strong>
                        - voorkomt clickjacking via iframes</li>
                    <li><strong>Content-Security-Policy: default-src 'self'</strong>
                        - staat alleen eigen resources toe</li>
                    <li><strong>Strict-Transport-Security</strong>
                        - dwingt HTTPS af voor 2 jaar</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Mitigatie</h3>
            <p>
                Implementeer een herhaalbaar hardening-proces.
                Gebruik identieke configuraties in dev, test en
                productie. Verwijder onnodige features en accounts.
                Stel security headers in via centrale middleware.
                Valideer je configuratie met securityheaders.com.
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
