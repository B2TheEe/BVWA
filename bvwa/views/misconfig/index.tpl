<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{.Title}} — BVWA</title>
    <link rel="stylesheet" href="/static/css/bvwa.css">
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
        <button type="button" class="btn-examples" id="openExamplesBtn">
            Echte Voorbeelden
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

<!-- ECHTE VOORBEELDEN MODAL -->
<div class="modal-overlay" id="examplesModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeExamplesBtn">X</button>

        <h2>Echte Voorbeelden — Security Misconfiguration</h2>
        <p class="subtitle">
            Historische incidenten veroorzaakt door verkeerde configuratie
        </p>
        <hr>

        <div class="example-item">
            <h4>
                <span class="example-year">2019</span>
                Capital One — Misconfigured AWS WAF
            </h4>
            <p>
                Een oud-Amazon medewerker exploiteerde een verkeerd geconfigureerde AWS
                Web Application Firewall via SSRF (Server-Side Request Forgery). De WAF
                had te ruime permissies, waardoor de AWS metadata-service bereikbaar was
                en IAM-credentials konden worden gestolen.
            </p>
            <p class="example-impact">Impact: 106 miljoen klantgegevens gelekt &mdash; boete van $80 miljoen</p>
        </div>

        <div class="example-item">
            <h4>
                <span class="example-year">2021</span>
                Microsoft Exchange ProxyLogon
            </h4>
            <p>
                Verkeerd geconfigureerde Exchange-servers met standaard open poorten
                (CVE-2021-26855) werden massaal aangevallen. Aanvallers installeerden
                web shells voor persistente toegang. Overheidsinstanties, defensiebedrijven
                en Fortune 500-bedrijven werden getroffen wereldwijd.
            </p>
            <p class="example-impact">Impact: 250.000+ servers gecompromitteerd in de eerste dagen</p>
        </div>

        <div class="example-item">
            <h4>
                <span class="example-year">2021</span>
                Twitch Datalek
            </h4>
            <p>
                Een anonieme aanvaller publiceerde 125 GB aan Twitch-data, waaronder
                volledige broncode, interne tools, uitbetalingsgegevens van streamers en
                beveiligingsrapporten. Oorzaak: misconfigureerde serverinstellingen zonder
                adequate toegangscontroles.
            </p>
            <p class="example-impact">Impact: Broncode, verdiensten van creators en interne tools openbaar</p>
        </div>

        <div class="example-item">
            <h4>
                <span class="example-year">2020</span>
                SolarWinds — Standaard Wachtwoord op GitHub
            </h4>
            <p>
                Een stagiair had het FTP-wachtwoord "solarwinds123" gepubliceerd op
                een openbare GitHub-repository. Dit was onderdeel van bredere
                misconfiguraties die bijdroegen aan de grootste supplychain-aanval ooit.
                Het wachtwoord stond maanden openbaar zonder dat iemand het opmerkte.
            </p>
            <p class="example-impact">Impact: 18.000+ organisaties gecompromitteerd, waaronder de Amerikaanse overheid</p>
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
