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

        /* Sub-navigation voor SQL / XSS */
        .sub-nav {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        .sub-nav a {
            padding: 8px 18px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 13px;
            font-weight: bold;
            border: 2px solid #ddd;
            color: #555;
            background: white;
        }
        .sub-nav a:hover { border-color: #3498db; color: #3498db; }
        .sub-nav a.active-vuln {
            background: #e74c3c;
            border-color: #e74c3c;
            color: white;
        }
        .sub-nav a.active-safe {
            background: #27ae60;
            border-color: #27ae60;
            color: white;
        }

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
            line-height: 1.6;
            word-break: break-all;
        }
        .ckw  { color: #569cd6; }
        .cstr { color: #ce9178; }
        .ccmt { color: #6a9955; }

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
        .tip {
            background: #eaf4fb;
            border: 1px solid #aed6f1;
            border-radius: 6px;
            padding: 12px 16px;
            font-size: 13px;
            color: #2471a3;
            margin-top: 12px;
        }
        .query-display {
            background: #fff3cd;
            border: 1px solid #ffc107;
            border-radius: 6px;
            padding: 12px 16px;
            font-family: monospace;
            font-size: 12px;
            color: #856404;
            margin-top: 10px;
            word-break: break-all;
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
        <a href="/injection/sql/vulnerable">SQL Kwetsbaar</a>
        <a href="/injection/sql/secure">SQL Veilig</a>
        <a href="/injection/xss/vulnerable">XSS Kwetsbaar</a>
        <a href="/injection/xss/secure">XSS Veilig</a>
    </nav>
</header>

<!-- BREADCRUMB -->
<div class="breadcrumb">
    <a href="/">Home</a> &rsaquo; A05 &rsaquo; SQL Injection &rsaquo; {{.Title}}
</div>

<!-- MAIN -->
<div class="container">

    <div class="module-header">
        <span class="badge">A05</span>
        <h1>Injection — SQL</h1>
        <button type="button" class="btn-info" id="openInfoBtn">
            Info &amp; CWEs
        </button>
    </div>

    <!-- Sub-navigation -->
    <div class="sub-nav">
        <a href="/injection/sql/vulnerable"
           {{if eq .Title "SQL Injection (Kwetsbaar)"}}class="active-vuln"{{end}}>
            SQL Kwetsbaar
        </a>
        <a href="/injection/sql/secure"
           {{if eq .Title "SQL Injection (Veilig)"}}class="active-safe"{{end}}>
            SQL Veilig
        </a>
        <a href="/injection/xss/vulnerable">XSS Kwetsbaar</a>
        <a href="/injection/xss/secure">XSS Veilig</a>
    </div>

    <!-- Cards -->
    <div class="cards">

        <!-- KWETSBAAR -->
        <div class="card">
            <div class="card-header vuln">Kwetsbare versie</div>
            <div class="card-body">
                <p>
                    Gebruikersinput wordt <strong>direct in de
                    SQL-query</strong> geplakt via string
                    concatenatie. Een aanvaller kan de query
                    manipuleren.
                </p>

                <div class="code-block">
<span class="ccmt">// KWETSBAAR: string concatenatie</span>
query := fmt.Sprintf(
    <span class="cstr">"SELECT * FROM users WHERE username='%s'"</span>,
    username) <span class="ccmt">// gevaarlijk!</span>
                </div>

                <p style="font-size:13px; color:#e74c3c; font-weight:bold;">
                    Probeer payload: <code>' OR '1'='1</code>
                </p>

                <form method="GET" action="/injection/sql/vulnerable">
                    <div class="input-group">
                        <label>Gebruikersnaam:</label>
                        <input type="text" name="username"
                               value="{{.Username}}"
                               placeholder="' OR '1'='1">
                    </div>
                    <button type="submit"
                            class="btn-submit red">
                        Zoeken (kwetsbaar)
                    </button>
                </form>
            </div>
        </div>

        <!-- VEILIG -->
        <div class="card">
            <div class="card-header safe">Veilige versie</div>
            <div class="card-body">
                <p>
                    Gebruikersinput wordt als
                    <strong>parameter</strong> meegegeven aan
                    de query. De database behandelt het als
                    data, nooit als SQL-code.
                </p>

                <div class="code-block">
<span class="ccmt">// VEILIG: geparametriseerde query</span>
o.Raw(
    <span class="cstr">"SELECT * FROM users WHERE username = ?"</span>,
    username).Values(&amp;result)
                </div>

                <p style="font-size:13px; color:#27ae60; font-weight:bold;">
                    Payload wordt als tekst behandeld, niet als SQL.
                </p>

                <form method="GET" action="/injection/sql/secure">
                    <div class="input-group">
                        <label>Gebruikersnaam:</label>
                        <input type="text" name="username"
                               value="{{.Username}}"
                               placeholder="admin">
                    </div>
                    <button type="submit"
                            class="btn-submit green">
                        Zoeken (veilig)
                    </button>
                </form>
            </div>
        </div>

    </div>

    <!-- Result box -->
<div class="result-box">
    <h3>Resultaat voor: <strong>{{.Title}}</strong></h3>

    {{if eq .Title "SQL Injection (Kwetsbaar)"}}
    <span class="tag-vuln">KWETSBAAR</span>
    {{if .Query}}
    <p>Uitgevoerde query:</p>
    <div class="query-display">{{.Query}}</div>

    {{if .Result}}
    <p style="margin-top:10px;"><strong>Resultaat:</strong></p>
    <div style="background:#fdecea; border:1px solid #e74c3c;
                border-radius:6px; padding:12px; margin-top:6px;
                font-size:14px; color:#c0392b;">
        {{.Result}}
    </div>
    {{end}}

    <p style="margin-top:10px; color:#e74c3c; font-size:13px;">
        Let op: payload <code>' OR '1'='1</code> geeft alle
        records terug!
    </p>
    {{else}}
    <p>Voer een gebruikersnaam in om de kwetsbaarheid te testen.</p>
    <p style="font-size:13px; color:#888; margin-top:6px;">
        Geldige gebruikers: admin, user, alice, bob
    </p>
    {{end}}

    {{else}}
    <span class="tag-safe">VEILIG</span>
    {{if .Query}}
    <p>Uitgevoerde query (geparametriseerd):</p>
    <div class="query-display">{{.Query}}</div>

    {{if .Result}}
    <p style="margin-top:10px;"><strong>Resultaat:</strong></p>
    <div style="background:#eafaf1; border:1px solid #27ae60;
                border-radius:6px; padding:12px; margin-top:6px;
                font-size:14px; color:#1e8449;">
        {{.Result}}
    </div>
    {{end}}

    {{else}}
    <p>
        De geparametriseerde query beschermt tegen SQL injection.
        Input wordt als tekst behandeld, nooit als SQL-code.
    </p>
    <p style="font-size:13px; color:#888; margin-top:6px;">
        Geldige gebruikers: admin, user, alice, bob
    </p>
    {{end}}
    {{end}}

    <div class="tip">
        Tip: Gebruik altijd geparametriseerde queries of een ORM.
        Probeer payload <code>' OR '1'='1</code> op beide versies
        om het verschil te zien.
    </div>
</div>

</div>

<!-- INFO MODAL -->
<div class="modal-overlay" id="infoModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeInfoBtn">X</button>

        <h2>A05:2025 - Injection (SQL Injection)</h2>
        <p class="subtitle">
            OWASP Top 10:2025 - Positie #5 - Omvat SQL, XSS, OS Command, LDAP
        </p>
        <hr>

        <div class="info-section">
            <h3>Wat is het?</h3>
            <p>
                Injection treedt op wanneer niet-vertrouwde
                gebruikersinput naar een interpreter wordt gestuurd
                als onderdeel van een commando of query. Bij SQL
                injection kan een aanvaller de databasequery
                manipuleren om ongeautoriseerde data op te halen,
                te wijzigen of te verwijderen.
            </p>
        </div>
        <hr>

        <div class="info-section">
            <h3>Gerelateerde CWEs</h3>
            <div class="cwe-list">
                <span class="cwe-tag">CWE-20 Improper Input Validation</span>
                <span class="cwe-tag">CWE-74 Improper Neutralization of Special Elements</span>
                <span class="cwe-tag">CWE-75 Failure to Sanitize Special Elements</span>
                <span class="cwe-tag">CWE-77 Command Injection</span>
                <span class="cwe-tag">CWE-78 OS Command Injection</span>
                <span class="cwe-tag">CWE-79 Cross-site Scripting (XSS)</span>
                <span class="cwe-tag">CWE-80 Basic XSS</span>
                <span class="cwe-tag">CWE-83 Improper Neutralization in Attributes</span>
                <span class="cwe-tag">CWE-87 Improper Neutralization of Script Syntax</span>
                <span class="cwe-tag">CWE-88 Argument Injection</span>
                <span class="cwe-tag">CWE-89 SQL Injection</span>
                <span class="cwe-tag">CWE-90 LDAP Injection</span>
                <span class="cwe-tag">CWE-91 XML Injection</span>
                <span class="cwe-tag">CWE-93 CRLF Injection</span>
                <span class="cwe-tag">CWE-94 Code Injection</span>
                <span class="cwe-tag">CWE-95 Eval Injection</span>
                <span class="cwe-tag">CWE-96 Static Code Injection</span>
                <span class="cwe-tag">CWE-97 Server-Side Include Injection</span>
                <span class="cwe-tag">CWE-98 PHP File Inclusion</span>
                <span class="cwe-tag">CWE-99 Resource Injection</span>
                <span class="cwe-tag">CWE-100 Deprecated: Was catch-all</span>
                <span class="cwe-tag">CWE-113 HTTP Response Splitting</span>
                <span class="cwe-tag">CWE-116 Improper Encoding/Escaping</span>
                <span class="cwe-tag">CWE-138 Improper Neutralization</span>
                <span class="cwe-tag">CWE-184 Incomplete List of Disallowed Inputs</span>
                <span class="cwe-tag">CWE-470 Use of Externally-Controlled Input</span>
                <span class="cwe-tag">CWE-564 SQL Injection via Hibernate</span>
                <span class="cwe-tag">CWE-610 Externally Controlled Reference</span>
                <span class="cwe-tag">CWE-643 XPath Injection</span>
                <span class="cwe-tag">CWE-644 Improper Neutralization of HTTP Headers</span>
                <span class="cwe-tag">CWE-652 XQuery Injection</span>
                <span class="cwe-tag">CWE-917 Expression Language Injection</span>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de kwetsbare versie onveilig?</h3>
            <div class="vuln-box">
                De kwetsbare versie gebruikt
                <strong>string concatenatie</strong> (CWE-89):
                <ul>
                    <li><strong>Directe input in query:</strong>
                        <code>' OR '1'='1</code> maakt de WHERE
                        conditie altijd waar</li>
                    <li><strong>Alle records blootgesteld:</strong>
                        aanvaller krijgt toegang tot volledige
                        gebruikerstabel</li>
                    <li><strong>Data manipulatie:</strong> met
                        <code>; DROP TABLE users; --</code>
                        kan een tabel verwijderd worden</li>
                    <li><strong>Authenticatie bypass:</strong>
                        inloggen zonder geldig wachtwoord</li>
                    <li><strong>Blind SQL injection:</strong>
                        via timing attacks data uitlezen</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de veilige versie correct?</h3>
            <div class="safe-box">
                De veilige versie gebruikt
                <strong>geparametriseerde queries</strong>:
                <ul>
                    <li><strong>Data gescheiden van code:</strong>
                        de <code>?</code> placeholder zorgt dat
                        input nooit als SQL wordt uitgevoerd</li>
                    <li><strong>Automatisch escapen:</strong>
                        de database driver escapet alle
                        speciale tekens</li>
                    <li><strong>ORM bescherming:</strong>
                        Beego ORM gebruikt altijd prepared
                        statements intern</li>
                    <li><strong>Type checking:</strong>
                        parameters worden als correct type
                        doorgegeven</li>
                    <li>Payload <code>' OR '1'='1</code>
                        wordt letterlijk gezocht als username</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Mitigatie</h3>
            <p>
                Gebruik altijd geparametriseerde queries of een
                ORM. Valideer en saniteer alle input server-side.
                Gebruik het principe van least privilege voor
                database accounts. Implementeer WAF (Web
                Application Firewall) als extra laag.
                Gebruik prepared statements in alle database
                interacties.
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
