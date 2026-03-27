<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Server Diagnostics — bvwa-server</title>
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
        .terminal-dot {
            width: 12px; height: 12px;
            border-radius: 50%;
        }
        .dot-red    { background: #ff5f57; }
        .dot-yellow { background: #febc2e; }
        .dot-green  { background: #28c840; }
        .terminal-title {
            color: #8b949e;
            font-size: 13px;
            margin-left: 6px;
        }
        .terminal-body {
            padding: 20px 24px;
            min-height: 260px;
            color: #e6edf3;
            font-size: 13.5px;
            line-height: 1.65;
        }
        .terminal-motd {
            color: #6e7681;
            margin-bottom: 18px;
            font-size: 13px;
        }
        .terminal-entry { margin-bottom: 12px; }
        .terminal-cmd-echo {
            color: #58a6ff;
        }
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
            font-family: inherit;
        }
        .terminal-input-bar button:hover { background: #2ea043; }
    </style>
</head>
<body>

<header>
    <a href="/" class="logo">&#x1F510; <span>BVWA</span></a>
    <nav>
        <a href="/">&#x1F3E0; Home</a>
        <a href="/misconfig/vulnerable">Kwetsbaar</a>
        <a href="/misconfig/secure">Veilig</a>
    </nav>
</header>

<div class="breadcrumb">
    <a href="/">Home</a> &rsaquo; A02 &rsaquo; Security Misconfiguration (Kwetsbaar)
</div>

<div class="container">

    <div class="module-header">
        <span class="badge">A02</span>
        <h1>Security Misconfiguration</h1>
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
            <span class="terminal-title">bvwa-server &mdash; diagnostic console</span>
        </div>

        <div class="terminal-body">
            <div class="terminal-motd">Last login: Thu Mar 27 08:42:13 2026 from 172.18.0.1<br>
bvwa-server diagnostic interface v1.0 &mdash; authorized access only</div>

            {{if .HasOutput}}
            <div class="terminal-entry">
                <div class="terminal-cmd-echo">
                    <span class="ps1">root@bvwa-server:~#</span> {{.Command}}
                </div>
                <pre class="terminal-output">{{.Output}}</pre>
            </div>
            {{end}}
        </div>

        <form method="GET" action="/misconfig/vulnerable">
            <div class="terminal-input-bar">
                <span class="terminal-ps1">root@bvwa-server:~#</span>
                <input type="text" name="cmd" value="" autofocus autocomplete="off" spellcheck="false">
                <button type="submit">&#x23CE;</button>
            </div>
        </form>
    </div>

</div>

<!-- ECHTE VOORBEELDEN MODAL -->
<div class="modal-overlay" id="examplesModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeExamplesBtn">X</button>
        <h2>Echte Voorbeelden — Security Misconfiguration</h2>
        <p class="subtitle">Historische incidenten veroorzaakt door verkeerde configuratie</p>
        <hr>

        <div class="example-item">
            <h4><span class="example-year">2019</span> Capital One — Misconfigured AWS WAF</h4>
            <p>Een oud-Amazon medewerker exploiteerde een verkeerd geconfigureerde AWS Web Application
            Firewall via SSRF. De WAF had te ruime permissies, waardoor de AWS metadata-service
            bereikbaar was en IAM-credentials konden worden gestolen.</p>
            <p class="example-impact">Impact: 106 miljoen klantgegevens gelekt &mdash; boete van $80 miljoen</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2021</span> Microsoft Exchange ProxyLogon</h4>
            <p>Verkeerd geconfigureerde Exchange-servers met standaard open poorten (CVE-2021-26855)
            werden massaal aangevallen. Aanvallers installeerden web shells voor persistente toegang.</p>
            <p class="example-impact">Impact: 250.000+ servers gecompromitteerd in de eerste dagen</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2022</span> Twitch Datalek</h4>
            <p>Een anonieme aanvaller publiceerde 125 GB aan Twitch-data waaronder volledige broncode,
            interne tools en uitbetalingsgegevens van streamers. Oorzaak: misconfigureerde
            serverinstellingen zonder adequate toegangscontroles.</p>
            <p class="example-impact">Impact: Broncode en interne tools volledig openbaar</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2020</span> SolarWinds — Standaard Wachtwoord op GitHub</h4>
            <p>Een stagiair had het FTP-wachtwoord "solarwinds123" gepubliceerd op een openbare
            GitHub-repository. Het wachtwoord stond maanden openbaar zonder dat iemand het opmerkte.</p>
            <p class="example-impact">Impact: 18.000+ organisaties gecompromitteerd</p>
        </div>
    </div>
</div>

<!-- INFO MODAL -->
<div class="modal-overlay" id="infoModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeInfoBtn">X</button>
        <h2>A02:2025 — Security Misconfiguration</h2>
        <p class="subtitle">OWASP Top 10:2025 &mdash; Positie #2 &mdash; 100% van applicaties getroffen</p>
        <hr>

        <div class="info-section">
            <h3>Wat is het?</h3>
            <p>Security Misconfiguration treedt op wanneer een systeem, applicatie of cloudservice
            onjuist is geconfigureerd vanuit een beveiligingsperspectief. Blootgestelde debug-endpoints,
            standaard credentials, onnodige features en ontbrekende security headers zijn
            veelvoorkomende voorbeelden.</p>
        </div>
        <hr>

        <div class="info-section">
            <h3>Gerelateerde CWEs</h3>
            <div class="cwe-list">
                <span class="cwe-tag">CWE-16 Configuration</span>
                <span class="cwe-tag">CWE-260 Password in Config File</span>
                <span class="cwe-tag">CWE-526 Sensitive Info in Environment</span>
                <span class="cwe-tag">CWE-614 Sensitive Cookie Without Secure Attribute</span>
                <span class="cwe-tag">CWE-942 Permissive Cross-domain Policy</span>
                <span class="cwe-tag">CWE-1021 Improper Restriction of Rendered UI Layers</span>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de kwetsbare versie onveilig?</h3>
            <div class="vuln-box">
                <ul>
                    <li><strong>Geen authenticatie</strong> op het diagnostics-endpoint &mdash; iedereen kan commando's uitvoeren</li>
                    <li><strong>Geen security headers</strong> &mdash; geen CSP, geen X-Frame-Options, geen HSTS</li>
                    <li><strong>Debug-informatie in headers</strong> &mdash; X-Powered-By en Server lekken versie-info</li>
                    <li><strong>Credentials in omgeving</strong> &mdash; DB_PASSWORD en SECRET_KEY uitleesbaar via <code>env</code></li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Mitigatie</h3>
            <p>Verwijder of blokkeer debug-endpoints in productie. Stel security headers in via
            middleware. Gebruik secrets management (Vault, AWS Secrets Manager) in plaats van
            omgevingsvariabelen. Valideer configuratie via geautomatiseerde scans.</p>
        </div>
    </div>
</div>

<footer>
    BVWA is uitsluitend bedoeld voor educatieve doeleinden &mdash;
    gebruik alleen in een gei&euml;soleerde testomgeving.
</footer>

<script type="text/javascript" src="/static/js/modal.js"></script>

</body>
</html>
