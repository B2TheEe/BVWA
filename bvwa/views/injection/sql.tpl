<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{.Title}} - BVWA</title>
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
        <button type="button" class="btn-examples" id="openExamplesBtn">
            Echte Voorbeelden
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

<!-- ECHTE VOORBEELDEN MODAL -->
<div class="modal-overlay" id="examplesModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeExamplesBtn">X</button>

        <h2>Echte Voorbeelden — SQL Injection</h2>
        <p class="subtitle">
            Historische incidenten waarbij SQL Injection grote schade veroorzaakte
        </p>
        <hr>

        <div class="example-item">
            <h4>
                <span class="example-year">2008</span>
                Heartland Payment Systems
            </h4>
            <p>
                Aanvallers gebruikten SQL injection via een webformulier om spyware
                te installeren die betalingskaartdata onderschepte. De aanval bleef
                maandenlang onopgemerkt. Het was de grootste datalek ooit op dat moment.
            </p>
            <p class="example-impact">Impact: 134 miljoen creditcards gestolen &mdash; $140M boete</p>
        </div>

        <div class="example-item">
            <h4>
                <span class="example-year">2011</span>
                Sony Pictures (LulzSec)
            </h4>
            <p>
                Hackersgroep LulzSec gebruikte een eenvoudige SQL injection om toegang
                te krijgen tot meerdere Sony Pictures-databases tegelijk. Ze noemden het
                "de meest amateuristische beveiliging die ze ooit hadden gezien."
            </p>
            <p class="example-impact">Impact: 1 miljoen gebruikersgegevens gelekt, inclusief plaintext wachtwoorden</p>
        </div>

        <div class="example-item">
            <h4>
                <span class="example-year">2012</span>
                Yahoo Voices
            </h4>
            <p>
                SQL injection op Yahoo Voices onthulde 450.000 combinaties van
                gebruikersnamen en wachtwoorden. De wachtwoorden lagen in plaintext opgeslagen
                in de database. De aanvallers publiceerden alles openbaar.
            </p>
            <p class="example-impact">Impact: 450.000 plaintext credentials openbaar gepubliceerd</p>
        </div>

        <div class="example-item">
            <h4>
                <span class="example-year">2019</span>
                7-Eleven Japan
            </h4>
            <p>
                SQL injection via de "wachtwoord vergeten"-functie van de 7pay app gaf
                aanvallers toegang tot klantaccounts. Ze konden rechtstreeks betalingen
                initiëren. De app werd na slechts 3 dagen gesloten.
            </p>
            <p class="example-impact">Impact: ~$500.000 frauduleus overgeboekt van klantrekeningen</p>
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
