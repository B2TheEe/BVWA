<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{.Title}} - BVWA</title>
    <link rel="stylesheet" href="/static/css/bvwa.css">
    <style>
        .employee-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 12px;
            font-size: 13px;
        }
        .employee-table th {
            background: #2c3e50;
            color: #fff;
            padding: 8px 12px;
            text-align: left;
        }
        .employee-table td {
            padding: 7px 12px;
            border-bottom: 1px solid #e0e0e0;
        }
        .employee-table tr:nth-child(even) td {
            background: #f8f9fa;
        }
        .employee-table tr.hidden-row td {
            background: #fdecea;
            color: #c0392b;
            font-weight: bold;
        }
        .injection-banner {
            background: #c0392b;
            color: #fff;
            border-radius: 6px;
            padding: 10px 14px;
            margin-bottom: 12px;
            font-size: 13px;
            font-weight: bold;
        }
        .query-display {
            background: #1e1e1e;
            color: #f8f8f2;
            border-radius: 6px;
            padding: 10px 14px;
            font-family: monospace;
            font-size: 12px;
            overflow-x: auto;
            margin: 8px 0;
            word-break: break-all;
        }
    </style>
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
        <h1>MegaCorp Medewerkersdirectory</h1>
        <button type="button" class="btn-info" id="openInfoBtn">
            Info &amp; CWEs
        </button>
        <button type="button" class="btn-examples" id="openExamplesBtn">
            Echte Voorbeelden
        </button>
        <button type="button" class="btn-help" id="openHelpBtn">Hulp &amp; Commando&rsquo;s</button>
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
                    manipuleren en toegang krijgen tot data
                    buiten de bedoelde scope.
                </p>

                <div class="code-block">
<span class="ccmt">// KWETSBAAR: string concatenatie</span>
query := fmt.Sprintf(
    <span class="cstr">"SELECT ... FROM employees WHERE name LIKE '%%%s%%'"</span>,
    name) <span class="ccmt">// naam direct ingeplakt — gevaarlijk!</span>
                </div>

                <form method="GET" action="/injection/sql/vulnerable">
                    <div class="input-group">
                        <label>Zoek medewerker op naam:</label>
                        <input type="text" name="name"
                               value="{{.Name}}"
                               placeholder="Bijv. alice">
                    </div>
                    <button type="submit" class="btn-submit red">
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
    <span class="cstr">"SELECT ... FROM employees WHERE name LIKE ?"</span>,
    "%"+name+"%").Values(&amp;result)
                </div>

                <form method="GET" action="/injection/sql/secure">
                    <div class="input-group">
                        <label>Zoek medewerker op naam:</label>
                        <input type="text" name="name"
                               value="{{.Name}}"
                               placeholder="Bijv. alice">
                    </div>
                    <button type="submit" class="btn-submit green">
                        Zoeken (veilig)
                    </button>
                </form>
            </div>
        </div>

    </div>

    <!-- Result box -->
    <div class="result-box">
        <h3>
            {{if eq .Title "SQL Injection (Kwetsbaar)"}}
            <span class="tag-vuln">KWETSBAAR</span>
            {{else}}
            <span class="tag-safe">VEILIG</span>
            {{end}}
            Resultaat &mdash; MegaCorp Medewerkersdirectory
        </h3>

        {{if .Name}}

        {{if .Query}}
        <p style="font-size:13px; color:#888; margin-bottom:4px;">Uitgevoerde query:</p>
        <div class="query-display">{{.Query}}</div>
        {{end}}

        {{if .Injected}}
        <div class="injection-banner">
            SQL injection geslaagd &mdash; WHERE-conditie omzeild, alle records teruggegeven
        </div>
        {{end}}

        {{if .Results}}
        <table class="employee-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Naam</th>
                    <th>Afdeling</th>
                    <th>Functie</th>
                    <th>E-mail</th>
                </tr>
            </thead>
            <tbody>
                {{range .Results}}
                <tr {{if eq .ID 0}}class="hidden-row"{{end}}>
                    <td>{{.ID}}</td>
                    <td>{{.Name}}</td>
                    <td>{{.Department}}</td>
                    <td>{{.Role}}</td>
                    <td>{{.Email}}</td>
                </tr>
                {{end}}
            </tbody>
        </table>
        {{else}}
        <p style="color:#888; font-style:italic; margin-top:10px;">
            Geen medewerkers gevonden voor &ldquo;{{.Name}}&rdquo;.
        </p>
        {{end}}

        {{else}}
        <p style="color:#888;">Voer een naam in om de directory te doorzoeken.</p>
        {{end}}

        <div class="tip">
            Tip: Gebruik altijd geparametriseerde queries of een ORM.
            Vergelijk de resultaten tussen de kwetsbare en veilige versie.
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
                <span class="cwe-tag">CWE-89 SQL Injection</span>
                <span class="cwe-tag">CWE-90 LDAP Injection</span>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de kwetsbare versie onveilig?</h3>
            <div class="vuln-box">
                De kwetsbare versie gebruikt
                <strong>string concatenatie</strong> (CWE-89):
                <ul>
                    <li><strong>WHERE omzeild:</strong>
                        speciale tekens breken de querystructuur open</li>
                    <li><strong>Alle records blootgesteld:</strong>
                        aanvaller krijgt toegang tot de volledige tabel</li>
                    <li><strong>Verborgen accounts:</strong>
                        systeemaccounts die normaal onzichtbaar zijn
                        worden teruggegeven</li>
                    <li><strong>Data manipulatie:</strong>
                        stacked queries kunnen data wijzigen of verwijderen</li>
                    <li><strong>Authenticatie bypass:</strong>
                        inloggen zonder geldig wachtwoord</li>
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
            </p>
        </div>

    </div>
</div>

<footer>
    BVWA is uitsluitend bedoeld voor educatieve doeleinden -
    gebruik alleen in een geisoleerde testomgeving.
</footer>

<!-- HULP MODAL -->
<div class="modal-overlay" id="helpModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeHelpBtn">X</button>
        <h2>Hulp — A05 SQL Injection</h2>
        <p class="subtitle">Testinvoer voor het zoekveld van de MegaCorp Medewerkersdirectory</p>
        <hr>

        <div class="info-section">
            <h3>Normale zoekopdrachten</h3>
            <table style="width:100%; border-collapse:collapse; font-size:14px;">
                <thead>
                    <tr style="background:#f6f8fa; text-align:left;">
                        <th style="padding:8px 12px; border-bottom:1px solid #e0e0e0;">Invoer in zoekveld</th>
                        <th style="padding:8px 12px; border-bottom:1px solid #e0e0e0;">Verwacht resultaat</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">alice</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">Alice Jansen (Finance)</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">sven</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">Sven Bakker (IT)</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">bob</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">Bob de Vries (HR)</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">carol</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">Carol Peters (IT)</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace;">dave</td>
                        <td style="padding:8px 12px;">Dave Smit (Sales)</td>
                    </tr>
                </tbody>
            </table>
        </div>
        <hr>

        <div class="info-section">
            <h3>SQL injection payloads (kwetsbare versie)</h3>
            <table style="width:100%; border-collapse:collapse; font-size:14px;">
                <thead>
                    <tr style="background:#f6f8fa; text-align:left;">
                        <th style="padding:8px 12px; border-bottom:1px solid #e0e0e0;">Payload</th>
                        <th style="padding:8px 12px; border-bottom:1px solid #e0e0e0;">Wat het doet</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">' OR '1'='1</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">WHERE-conditie omzeild — alle records teruggegeven inclusief verborgen account</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">' OR 1=1--</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">Zelfde effect, rest van query als commentaar behandeld</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">1=1</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">Kortere variant — geeft alle records terug</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace;">union select</td>
                        <td style="padding:8px 12px;">UNION-gebaseerde injectie — herkend als aanvalspayload</td>
                    </tr>
                </tbody>
            </table>
            <p style="font-size:13px; color:#888; margin-top:8px;">
                Op de <strong>veilige versie</strong> worden dezelfde payloads als letterlijke zoektermen behandeld — geen resultaten.
            </p>
        </div>
        <hr>

        <div class="info-section">
            <h3>CTF-tip</h3>
            <p>Gebruik een SQL injection payload op de <strong>kwetsbare versie</strong>. Het verborgen
            systeemaccount <code>db_admin</code> wordt teruggegeven — de CTF-flag staat in het
            e-mailadresveld van dit record.</p>
        </div>

    </div>
</div>

<style>
.btn-help {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 6px 14px;
    background: #7c3aed;
    color: white;
    border: none;
    border-radius: 6px;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    transition: background 0.15s;
}
.btn-help:hover { background: #6d28d9; }
</style>

<script type="text/javascript" src="/static/js/modal.js"></script>
<script>
(function () {
    var openBtn  = document.getElementById('openHelpBtn');
    var closeBtn = document.getElementById('closeHelpBtn');
    var overlay  = document.getElementById('helpModal');
    if (openBtn)  openBtn.onclick = function (e) { e.preventDefault(); overlay.style.display = 'block'; document.body.style.overflow = 'hidden'; };
    if (closeBtn) closeBtn.onclick = function (e) { e.preventDefault(); overlay.style.display = 'none'; document.body.style.overflow = ''; };
    if (overlay)  overlay.onclick = function (e) { if (e.target === overlay) { overlay.style.display = 'none'; document.body.style.overflow = ''; } };
})();
</script>

</body>
</html>
