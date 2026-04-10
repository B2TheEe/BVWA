<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaPay DiagTool — beheerterminal (kwetsbaar)</title>
    <link rel="stylesheet" href="/static/css/bvwa.css">
    <style>
        .terminal-panel {
            background: #0d1117;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 24px rgba(0,0,0,0.35);
            margin-bottom: 24px;
            font-family: 'Courier New', Courier, monospace;
        }
        .terminal-topbar {
            background: #21262d;
            padding: 10px 16px;
            display: flex;
            align-items: center;
            gap: 8px;
            border-bottom: 1px solid #30363d;
        }
        .terminal-dots { display: flex; gap: 6px; }
        .terminal-dot { width: 12px; height: 12px; border-radius: 50%; }
        .dot-red    { background: #ff5f57; }
        .dot-yellow { background: #febc2e; }
        .dot-green  { background: #28c840; }
        .terminal-title { color: #8b949e; font-size: 13px; margin-left: 6px; }
        .terminal-body {
            padding: 20px 24px;
            min-height: 260px;
            color: #e6edf3;
            font-size: 13.5px;
            line-height: 1.65;
        }
        .terminal-motd { color: #6e7681; margin-bottom: 18px; font-size: 13px; }
        .terminal-entry { margin-bottom: 12px; }
        .terminal-cmd-echo { color: #58a6ff; }
        .terminal-cmd-echo .ps1 { color: #3fb950; }
        .terminal-output {
            white-space: pre-wrap;
            color: #e6edf3;
            word-break: break-all;
            margin-top: 2px;
        }
        .terminal-input-bar {
            display: flex;
            align-items: center;
            background: #161b22;
            padding: 10px 24px;
            border-top: 1px solid #21262d;
            gap: 8px;
        }
        .terminal-ps1 {
            color: #3fb950;
            font-family: 'Courier New', Courier, monospace;
            font-size: 13.5px;
            white-space: nowrap;
            flex-shrink: 0;
        }
        .terminal-input-bar input[type=text] {
            flex: 1;
            background: transparent;
            border: none;
            outline: none;
            color: #e6edf3;
            font-family: 'Courier New', Courier, monospace;
            font-size: 13.5px;
            caret-color: #3fb950;
        }
        .terminal-input-bar button {
            background: #b91c1c;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 5px 14px;
            font-size: 13px;
            font-weight: bold;
            cursor: pointer;
        }
        .terminal-input-bar button:hover { background: #dc2626; }
    </style>
</head>
<body>

<header>
    <a href="/" class="logo">&#x1F510; <span>BVWA</span></a>
    <nav>
        <a href="/">&#x1F3E0; Home</a>
        <a href="/exceptions/vulnerable">Kwetsbaar</a>
        <a href="/exceptions/secure">Veilig</a>
    </nav>
</header>

<div class="breadcrumb">
    <a href="/">Home</a> &rsaquo; A10 &rsaquo; Mishandling of Exceptional Conditions (Kwetsbaar)
</div>

<div class="container">

    <div class="module-header">
        <span class="badge">A10</span>
        <h1>Mishandling of Exceptional Conditions</h1>
        <button type="button" class="btn-info" id="openInfoBtn">Info &amp; CWEs</button>
        <button type="button" class="btn-examples" id="openExamplesBtn">Echte Voorbeelden</button>
    </div>

    <div class="terminal-panel">
        <div class="terminal-topbar">
            <div class="terminal-dots">
                <div class="terminal-dot dot-red"></div>
                <div class="terminal-dot dot-yellow"></div>
                <div class="terminal-dot dot-green"></div>
            </div>
            <span class="terminal-title">NovaPay DiagTool v1.0 &mdash; Beheerterminal [KWETSBAAR]</span>
        </div>

        <div class="terminal-body">
            <div class="terminal-motd">NovaPay DiagTool v1.0<br>
Verbonden met prod-api-01.novapay.local &mdash; Welkom, operator</div>

            {{if .HasOutput}}
            <div class="terminal-entry">
                <div class="terminal-cmd-echo">
                    <span class="ps1">operator@novapay:~$</span> novadiag {{.Command}}
                </div>
                <pre class="terminal-output">{{.Output}}</pre>
            </div>
            {{end}}
        </div>

        <form method="GET" action="/exceptions/vulnerable">
            <div class="terminal-input-bar">
                <span class="terminal-ps1">operator@novapay:~$</span>
                <input type="text" name="cmd" value="" autofocus autocomplete="off"
                       spellcheck="false" placeholder="novadiag ">
                <button type="submit">&#x23CE;</button>
            </div>
        </form>
    </div>

</div>

<!-- ECHTE VOORBEELDEN MODAL -->
<div class="modal-overlay" id="examplesModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeExamplesBtn">X</button>
        <h2>Echte Voorbeelden &mdash; Mishandling of Exceptional Conditions</h2>
        <p class="subtitle">Incidenten waarbij foute foutafhandeling catastrofale gevolgen had</p>
        <hr>

        <div class="example-item">
            <h4><span class="example-year">2014</span> Heartbleed &mdash; OpenSSL CVE-2014-0160</h4>
            <p>De heartbeat-extensie controleerde de opgegeven lengte niet (CWE-126 buffer over-read).
            Aanvallers konden 64 KB servergeheugen per verzoek uitlezen &mdash; inclusief prive-sleutels
            en wachtwoorden. Geen exception, geen log, geen spoor van de aanval.</p>
            <p class="example-impact">Impact: 17&ndash;25% van alle HTTPS-servers kwetsbaar; private keys van miljoenen sites gelekt</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2012</span> Knight Capital &mdash; $440 Miljoen in 45 Minuten</h4>
            <p>Een deploymentfout activeerde verouderde testcode op productieservers. Foutafhandeling
            ontbrak volledig: het systeem bleef 45 minuten lang automatisch handelen terwijl het
            geld verloor. Geen enkel alarm stopte het proces tijdig.</p>
            <p class="example-impact">Impact: $440 miljoen verlies in 45 minuten &mdash; bedrijf ging bijna failliet</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">1985</span> Therac-25 &mdash; Dodelijke Race Condition</h4>
            <p>Een medisch bestralingsapparaat negeerde foutcondities stilletjes (fail-open).
            Bepaalde toetsaanslagsequenties zorgden dat een foutmelding werd weggecijferd terwijl
            het apparaat in de gevaarlijkste modus bleef draaien.</p>
            <p class="example-impact">Impact: minimaal 3 doden, 3 zwaargewonden &mdash; een van de ergste software-rampen</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2017</span> Cloudbleed &mdash; Cloudflare Buffer Over-read</h4>
            <p>Een buffer over-read in Cloudflares HTML-parser zorgde dat HTTP-responses willekeurig
            geheugen van andere klanten bevatten. Wachtwoorden en auth-tokens lekten mee in responses
            die door zoekmachines werden gecached.</p>
            <p class="example-impact">Impact: miljoenen pagina's getroffen; gecachte gevoelige data via Google bereikbaar</p>
        </div>
    </div>
</div>

<!-- INFO MODAL -->
<div class="modal-overlay" id="infoModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeInfoBtn">X</button>
        <h2>A10:2025 &mdash; Mishandling of Exceptional Conditions</h2>
        <p class="subtitle">OWASP Top 10:2025 &mdash; Positie #10 &mdash; 24 CWEs rond onjuiste foutafhandeling</p>
        <hr>

        <div class="info-section">
            <h3>Wat is het?</h3>
            <p>Mishandling of Exceptional Conditions ontstaat wanneer een applicatie fouten negeert,
            interne details lekt via foutmeldingen, of bij een fout toegang verleent in plaats van weigert
            (fail-open). Dit geeft aanvallers informatie of onbedoelde toegang tot systemen.</p>
        </div>
        <hr>

        <div class="info-section">
            <h3>Gerelateerde CWEs</h3>
            <div class="cwe-list">
                <span class="cwe-tag">CWE-209 Generation of Error Message Containing Sensitive Information</span>
                <span class="cwe-tag">CWE-390 Detection of Error Condition Without Action</span>
                <span class="cwe-tag">CWE-391 Unchecked Error Condition</span>
                <span class="cwe-tag">CWE-636 Not Failing Securely (Fail Open)</span>
                <span class="cwe-tag">CWE-754 Improper Check for Unusual or Exceptional Conditions</span>
                <span class="cwe-tag">CWE-755 Improper Handling of Exceptional Conditions</span>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de kwetsbare versie onveilig?</h3>
            <div class="vuln-box">
                <ul>
                    <li><strong>CWE-636 (fail-open):</strong> <code>check auth</code> gooit een paniek maar verleent alsnog toegang &mdash; de panic wordt afgevangen maar de fout genegeerd</li>
                    <li><strong>CWE-209 (info lekkage):</strong> <code>check db</code> toont de volledige connection string inclusief wachtwoord; <code>status</code> lekt interne paden</li>
                    <li><strong>CWE-391 (fout genegeerd):</strong> <code>pay abc alice</code> gebruikt <code>amount, _ :=</code> &mdash; de parsefout wordt weggegooid, bedrag wordt €0 en de betaling gaat door</li>
                    <li><strong>Geen validatie:</strong> <code>pay -100 alice</code> &mdash; negatieve bedragen worden niet geweigerd</li>
                    <li><strong>Config blootgesteld:</strong> <code>config</code> toont DB-wachtwoord, JWT-secret en API-sleutels</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de veilige versie correct?</h3>
            <div class="safe-box">
                <ul>
                    <li><strong>CWE-636 fix (fail-closed):</strong> <code>check auth</code> weigert toegang bij een fout &mdash; geen stacktrace, geen details</li>
                    <li><strong>CWE-209 fix:</strong> <code>check db</code> toont een generieke foutmelding met referentiecode; <code>status</code> geeft alleen &ldquo;OK&rdquo;</li>
                    <li><strong>CWE-391 fix:</strong> <code>pay abc alice</code> controleert de <code>err</code> expliciet en weigert de transactie</li>
                    <li><strong>Validatie:</strong> negatieve en nul-bedragen worden geweigerd voor verwerking</li>
                    <li><strong>Config geblokkeerd:</strong> <code>config</code> geeft &ldquo;Toegang geweigerd&rdquo;</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Mitigatie</h3>
            <p>Pas het fail-closed principe toe: weiger bij twijfel. Handel elke <code>err</code> expliciet af &mdash;
            gebruik nooit <code>_</code> voor foutwaarden in productie. Stuur generieke meldingen naar gebruikers
            en log details intern. Stel nooit configuratie of interne paden bloot via API-responses of terminalexit.</p>
        </div>
    </div>
</div>

<footer>
    BVWA is uitsluitend bedoeld voor educatieve doeleinden &mdash;
    gebruik alleen in een ge&iuml;soleerde testomgeving.
</footer>

<script type="text/javascript" src="/static/js/modal.js"></script>

</body>
</html>
