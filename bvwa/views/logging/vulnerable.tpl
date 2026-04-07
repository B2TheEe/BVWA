<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>bvwa-auditd — audit daemon (kwetsbaar)</title>
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
            background: #238636;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 5px 14px;
            font-size: 13px;
            font-weight: bold;
            cursor: pointer;
        }
        .terminal-input-bar button:hover { background: #2ea043; }
    </style>
</head>
<body>

<header>
    <a href="/" class="logo">&#x1F510; <span>BVWA</span></a>
    <nav>
        <a href="/">&#x1F3E0; Home</a>
        <a href="/logging/vulnerable">Kwetsbaar</a>
        <a href="/logging/secure">Veilig</a>
    </nav>
</header>

<div class="breadcrumb">
    <a href="/">Home</a> &rsaquo; A09 &rsaquo; Security Logging &amp; Alerting Failures (Kwetsbaar)
</div>

<div class="container">

    <div class="module-header">
        <span class="badge">A09</span>
        <h1>Security Logging &amp; Alerting Failures</h1>
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
            <span class="terminal-title">bvwa-auditd v1.0.0 &mdash; Security Audit Daemon</span>
        </div>

        <div class="terminal-body">
            <div class="terminal-motd">bvwa-auditd v1.0.0<br>
Verbonden met auditd.bvwa-corp.local &mdash; Welkom, operator</div>

            {{if .HasOutput}}
            <div class="terminal-entry">
                <div class="terminal-cmd-echo">
                    <span class="ps1">operator@bvwa-corp:~$</span> bvwa-auditd {{.Command}}
                </div>
                <pre class="terminal-output">{{.Output}}</pre>
            </div>
            {{end}}
        </div>

        <form method="GET" action="/logging/vulnerable">
            <div class="terminal-input-bar">
                <span class="terminal-ps1">operator@bvwa-corp:~$</span>
                <input type="text" name="cmd" value="" autofocus autocomplete="off"
                       spellcheck="false" placeholder="bvwa-auditd ">
                <button type="submit">&#x23CE;</button>
            </div>
        </form>
    </div>

</div>

<!-- ECHTE VOORBEELDEN MODAL -->
<div class="modal-overlay" id="examplesModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeExamplesBtn">X</button>
        <h2>Echte Voorbeelden &mdash; Security Logging &amp; Alerting Failures</h2>
        <p class="subtitle">Historische incidenten waarbij ontbrekende of gebrekkige logging aanvallen onzichtbaar maakte</p>
        <hr>

        <div class="example-item">
            <h4><span class="example-year">2017</span> Equifax &mdash; 76 Dagen Onopgemerkt</h4>
            <p>Aanvallers exploiteerden een Apache Struts-kwetsbaarheid. Een verlopen SSL-inspectiecertificaat
            (19 maanden verlopen) zorgde ervoor dat beveiligingstools versleuteld verkeer niet konden
            analyseren. Meer dan 700 databasezoekopdrachten bleven volledig onopgemerkt gedurende 76 dagen.</p>
            <p class="example-impact">Impact: 147 miljoen SSN's en geboortedata gelekt &mdash; boete van $575 miljoen</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2013</span> Target &mdash; Genegeerde FireEye Alerts</h4>
            <p>FireEye detecteerde de Citadel-malware en stuurde automatische alerts naar Target's team.
            Het team beoordeelde de alerts als vals-positief en schakelde de automatische reactiefunctie
            bewust uit. 40 miljoen betaalkaarten werden gestolen terwijl de alerts werden genegeerd.</p>
            <p class="example-impact">Impact: 40 miljoen betaalkaarten + 70 miljoen klantrecords &mdash; $162 miljoen schade</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2014</span> Yahoo &mdash; 2 Jaar Onopgemerkt</h4>
            <p>Aanvallers hadden 2&ndash;3 jaar onbeperkte toegang tot Yahoo's systemen. De breuk van
            2013&ndash;2014 betrof 3 miljard accounts maar werd pas in 2016 ontdekt &mdash; via een externe
            melding, niet door Yahoo's eigen monitoring.</p>
            <p class="example-impact">Impact: 3 miljard accounts &mdash; grootste datalek ooit; Yahoo-verkoop $350M goedkoper</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2019</span> Capital One &mdash; 700 Queries Zonder Alert</h4>
            <p>De aanvaller voerde meer dan 700 opeenvolgende AWS S3 ListBucket-commando's uit over meerdere
            dagen zonder &eacute;&eacute;n alert te triggeren. Er was een WAF aanwezig maar geen alerting op
            ongebruikelijke toegangspatronen.</p>
            <p class="example-impact">Impact: 106 miljoen records gestolen &mdash; boete van $80 miljoen</p>
        </div>
    </div>
</div>

<!-- INFO MODAL -->
<div class="modal-overlay" id="infoModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeInfoBtn">X</button>
        <h2>A09:2025 &mdash; Security Logging &amp; Alerting Failures</h2>
        <p class="subtitle">OWASP Top 10:2025 &mdash; Positie #9 &mdash; Lichte naamswijziging om alerting te benadrukken</p>
        <hr>

        <div class="info-section">
            <h3>Wat is het?</h3>
            <p>Security Logging and Alerting Failures treden op wanneer applicaties beveiligingsgebeurtenissen
            niet correct registreren of er geen alerts worden gegenereerd bij verdachte activiteit.
            Hierdoor blijven aanvallen onopgemerkt en kan een incident niet worden gereconstrueerd.</p>
        </div>
        <hr>

        <div class="info-section">
            <h3>Gerelateerde CWEs</h3>
            <div class="cwe-list">
                <span class="cwe-tag">CWE-117 Improper Output Neutralization for Logs</span>
                <span class="cwe-tag">CWE-223 Omission of Security-Relevant Information from Logs</span>
                <span class="cwe-tag">CWE-532 Insertion of Sensitive Information into Log File</span>
                <span class="cwe-tag">CWE-778 Insufficient Logging</span>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de kwetsbare versie onveilig?</h3>
            <div class="vuln-box">
                <ul>
                    <li><strong>CWE-532:</strong> wachtwoorden worden in plaintext opgeslagen in het auditlog &mdash; zichtbaar voor iedereen met leestoegang</li>
                    <li><strong>CWE-223:</strong> geen alerting bij herhaalde mislukte loginpogingen &mdash; brute force volledig onzichtbaar</li>
                    <li><strong>CWE-117:</strong> invoer niet gesaniteerd &mdash; log-injectie mogelijk via speciale tekens</li>
                    <li><strong>Geen detectie:</strong> een aanvaller kan onbeperkt proberen zonder ooit een alert te triggeren</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de veilige versie correct?</h3>
            <div class="safe-box">
                <ul>
                    <li><strong>CWE-532 mitigatie:</strong> wachtwoorden worden als <code>***REDACTED***</code> gelogd</li>
                    <li><strong>CWE-223 mitigatie:</strong> BRUTE FORCE-alert na 3 mislukte pogingen van hetzelfde IP</li>
                    <li><strong>CWE-117 mitigatie:</strong> control characters gestript uit invoer v&oacute;&oacute;r logging</li>
                    <li><strong>Gestructureerde logs:</strong> timestamp, level, gebruiker en IP in elk log-entry</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Mitigatie</h3>
            <p>Log alle authenticatiepogingen maar nooit de wachtwoorden zelf. Implementeer alerting
            bij verdachte patronen. Saniteer invoer v&oacute;&oacute;r opname in logs. Gebruik
            gestructureerde logging met timestamp, level, gebruiker en IP. Bewaar logs minimaal 90 dagen.</p>
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
