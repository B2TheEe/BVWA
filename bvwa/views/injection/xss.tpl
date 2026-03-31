<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{.Title}} - BVWA</title>
    <link rel="stylesheet" href="/static/css/bvwa.css">
    <style>
        .search-output {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 14px 16px;
            margin-top: 10px;
            min-height: 48px;
            font-size: 14px;
        }
        .search-output.vuln {
            border-color: #e74c3c;
            background: #fdecea;
        }
        .search-output.safe {
            border-color: #27ae60;
            background: #eafaf1;
        }
        .product-list {
            margin-top: 10px;
            font-size: 13px;
            color: #555;
        }
        .product-list li {
            padding: 4px 0;
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
    <a href="/">Home</a> &rsaquo; A05 &rsaquo; XSS Injection &rsaquo; {{.Title}}
</div>

<!-- MAIN -->
<div class="container">

    <div class="module-header">
        <span class="badge">A05</span>
        <h1>BvwAshop Productzoeker</h1>
        <button type="button" class="btn-info" id="openInfoBtn">
            Info &amp; CWEs
        </button>
        <button type="button" class="btn-examples" id="openExamplesBtn">
            Echte Voorbeelden
        </button>
    </div>

    <!-- Sub-navigation -->
    <div class="sub-nav">
        <a href="/injection/sql/vulnerable">SQL Kwetsbaar</a>
        <a href="/injection/sql/secure">SQL Veilig</a>
        <a href="/injection/xss/vulnerable"
           {{if eq .Title "XSS Injection (Kwetsbaar)"}}class="active-vuln"{{end}}>
            XSS Kwetsbaar
        </a>
        <a href="/injection/xss/secure"
           {{if eq .Title "XSS Injection (Veilig)"}}class="active-safe"{{end}}>
            XSS Veilig
        </a>
    </div>

    <!-- Cards -->
    <div class="cards">

        <!-- KWETSBAAR -->
        <div class="card">
            <div class="card-header vuln">Kwetsbare versie</div>
            <div class="card-body">
                <p>
                    De zoekterm wordt <strong>als raw HTML</strong>
                    in de pagina weergegeven. Een aanvaller kan
                    markup of scripts injecteren die in de browser
                    van het slachtoffer worden uitgevoerd.
                </p>

                <div class="code-block">
<span class="ccmt">// KWETSBAAR: raw HTML output</span>
<span class="ccmt">// Template: {{"{{"}}str2html .RawInput{{"}}"}}</span>
<span class="ccmt">// Input wordt NIET geescaped!</span>
                </div>

                <form method="GET" action="/injection/xss/vulnerable">
                    <div class="input-group">
                        <label>Zoek een product:</label>
                        <input type="text" name="q"
                               placeholder="Zoekterm...">
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
                    De zoekterm wordt <strong>automatisch geescaped</strong>
                    door Beego&rsquo;s template engine.
                    Speciale tekens worden omgezet naar HTML-entities.
                </p>

                <div class="code-block">
<span class="ccmt">// VEILIG: Beego escapet automatisch</span>
<span class="ccmt">// Template: {{"{{"}} .SafeInput {{"}}"}}</span>
<span class="ccmt">// &lt; wordt &amp;lt;, &gt; wordt &amp;gt;</span>
                </div>

                <form method="GET" action="/injection/xss/secure">
                    <div class="input-group">
                        <label>Zoek een product:</label>
                        <input type="text" name="q"
                               placeholder="Zoekterm...">
                    </div>
                    <button type="submit" class="btn-submit green">
                        Zoeken (veilig)
                    </button>
                </form>
            </div>
        </div>

    </div>

    <!-- Output box -->
    <div class="output-box">
        <h3>
            {{if eq .Title "XSS Injection (Kwetsbaar)"}}
            <span class="tag-vuln">KWETSBAAR</span>
            {{else}}
            <span class="tag-safe">VEILIG</span>
            {{end}}
            Zoekresultaten &mdash; BvwAshop
        </h3>

        {{if eq .Title "XSS Injection (Kwetsbaar)"}}

        {{if .RawInput}}
        <p style="font-size:14px; margin-bottom:6px;">
            Zoekresultaten voor:
        </p>
        <div class="search-output vuln">
            {{str2html .RawInput}}
        </div>
        <p style="color:#e74c3c; font-size:12px; margin-top:6px;">
            De zoekterm wordt als HTML gerenderd &mdash; inspecteer de paginabron (Ctrl+U).
        </p>
        {{else}}
        <p style="color:#888; font-style:italic;">
            Voer een zoekterm in om de productzoeker te gebruiken.
        </p>
        <ul class="product-list">
            <li>Laptop Pro 15"</li>
            <li>Draadloze muis</li>
            <li>USB-C Hub</li>
            <li>Mechanisch toetsenbord</li>
        </ul>
        {{end}}

        {{else}}

        {{if .SafeInput}}
        <p style="font-size:14px; margin-bottom:6px;">
            Zoekresultaten voor:
        </p>
        <div class="search-output safe">
            {{.SafeInput}}
        </div>
        <p style="color:#27ae60; font-size:12px; margin-top:6px;">
            Speciale tekens zijn geescaped en worden als tekst weergegeven.
        </p>
        {{else}}
        <p style="color:#888; font-style:italic;">
            Voer een zoekterm in om de productzoeker te gebruiken.
        </p>
        <ul class="product-list">
            <li>Laptop Pro 15"</li>
            <li>Draadloze muis</li>
            <li>USB-C Hub</li>
            <li>Mechanisch toetsenbord</li>
        </ul>
        {{end}}

        {{end}}

        <div class="tip">
            Tip: Bekijk de paginabron (Ctrl+U) om het verschil
            te zien tussen de kwetsbare en veilige versie.
        </div>
    </div>

</div>

<!-- ECHTE VOORBEELDEN MODAL -->
<div class="modal-overlay" id="examplesModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeExamplesBtn">X</button>

        <h2>Echte Voorbeelden — Cross-Site Scripting (XSS)</h2>
        <p class="subtitle">
            Historische incidenten waarbij XSS grote schade aanrichtte
        </p>
        <hr>

        <div class="example-item">
            <h4>
                <span class="example-year">2005</span>
                MySpace Samy Worm
            </h4>
            <p>
                Samy Kamkar ontdekte een stored XSS-kwetsbaarheid in MySpace en schreef
                een worm die zichzelf automatisch verspreide. Elk profiel dat zijn profiel
                bezocht voegde hem toe als vriend en kopieerde de worm naar hun eigen profiel.
                Hij werd later gearresteerd door de Secret Service.
            </p>
            <p class="example-impact">Impact: 1 miljoen profielen besmet in minder dan 20 uur</p>
        </div>

        <div class="example-item">
            <h4>
                <span class="example-year">2010</span>
                Twitter "onmouseover" Worm
            </h4>
            <p>
                Een stored XSS-kwetsbaarheid in de URL-verwerking van tweets zorgde ervoor
                dat kwaadaardige code werd uitgevoerd zodra een gebruiker over een tweet
                bewoog. Tweets werden automatisch geretweeted, popups verschenen en gebruikers
                werden omgeleid naar externe sites.
            </p>
            <p class="example-impact">Impact: Tienduizenden accounts automatisch gecompromitteerd voor patch</p>
        </div>

        <div class="example-item">
            <h4>
                <span class="example-year">2018</span>
                British Airways — Magecart Aanval
            </h4>
            <p>
                De Magecart-groep injecteerde 22 regels JavaScript op de BA-betaalpagina
                via een XSS-kwetsbaarheid. Het script stuurde ingevoerde betalingsgegevens
                in realtime naar een server van de aanvallers. De aanval bleef 15 dagen
                actief onopgemerkt.
            </p>
            <p class="example-impact">Impact: 500.000 klanten getroffen &mdash; GDPR-boete van &pound;20 miljoen</p>
        </div>

        <div class="example-item">
            <h4>
                <span class="example-year">2015</span>
                eBay Stored XSS
            </h4>
            <p>
                Meerdere stored XSS-kwetsbaarheden in productomschrijvingen op eBay lieten
                aanvallers actieve scripts insluiten. Bezoekers van die listings werden
                automatisch omgeleid naar phishing-pagina's die eruitzagen als de echte
                eBay-inlogpagina.
            </p>
            <p class="example-impact">Impact: Miljoenen gebruikers potentieel blootgesteld aan credential-diefstal</p>
        </div>

    </div>
</div>

<!-- INFO MODAL -->
<div class="modal-overlay" id="infoModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeInfoBtn">X</button>

        <h2>A05:2025 - Injection (XSS)</h2>
        <p class="subtitle">
            OWASP Top 10:2025 - Positie #5 - Cross-Site Scripting
        </p>
        <hr>

        <div class="info-section">
            <h3>Wat is het?</h3>
            <p>
                Cross-Site Scripting (XSS) treedt op wanneer een
                applicatie onbetrouwbare data in een webpagina
                opneemt zonder correcte validatie of escaping.
                Een aanvaller kan scripts injecteren die worden
                uitgevoerd in de browser van het slachtoffer,
                wat kan leiden tot sessiediefstal, phishing of
                malware-verspreiding.
            </p>
        </div>
        <hr>

        <div class="info-section">
            <h3>Gerelateerde CWEs</h3>
            <div class="cwe-list">
                <span class="cwe-tag">CWE-79 Cross-site Scripting (XSS)</span>
                <span class="cwe-tag">CWE-80 Basic XSS</span>
                <span class="cwe-tag">CWE-83 XSS in Attributes</span>
                <span class="cwe-tag">CWE-20 Improper Input Validation</span>
                <span class="cwe-tag">CWE-116 Improper Encoding/Escaping of Output</span>
                <span class="cwe-tag">CWE-184 Incomplete List of Disallowed Inputs</span>
                <span class="cwe-tag">CWE-693 Protection Mechanism Failure</span>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de kwetsbare versie onveilig?</h3>
            <div class="vuln-box">
                De kwetsbare versie gebruikt
                <strong>str2html</strong> — raw HTML output
                (CWE-79):
                <ul>
                    <li><strong>Script executie:</strong>
                        script-tags worden door de browser uitgevoerd</li>
                    <li><strong>Cookie diefstal:</strong>
                        aanvaller kan sessiecookies uitlezen via <code>document.cookie</code></li>
                    <li><strong>Keylogging:</strong>
                        alle toetsaanslagen kunnen worden onderschept</li>
                    <li><strong>Phishing:</strong>
                        de pagina kan volledig worden overschreven</li>
                    <li><strong>Malware:</strong>
                        drive-by downloads via script injection</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de veilige versie correct?</h3>
            <div class="safe-box">
                De veilige versie gebruikt
                <strong>automatische escaping</strong>
                van Beego:
                <ul>
                    <li><strong>HTML entities:</strong>
                        <code>&lt;</code> wordt <code>&amp;lt;</code>,
                        <code>&gt;</code> wordt <code>&amp;gt;</code></li>
                    <li><strong>Scripts geblokkeerd:</strong>
                        script-tags worden als tekst
                        weergegeven, niet uitgevoerd</li>
                    <li><strong>Beego default:</strong>
                        <code>{{"{{"}} .Variable {{"}}"}}</code> escapet
                        automatisch — altijd veilig</li>
                    <li><strong>str2html bewust vermijden:</strong>
                        gebruik alleen als de bron 100%
                        vertrouwd is</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Mitigatie</h3>
            <p>
                Gebruik altijd context-aware output encoding.
                Valideer input server-side. Implementeer een
                strikte Content-Security-Policy. Gebruik
                HTTPOnly en Secure cookies. Vermijd
                str2html/innerHTML tenzij absoluut noodzakelijk
                met vertrouwde bronnen.
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
