<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>bvwa-pkg — package manager</title>
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
        <a href="/supplychain/vulnerable">Kwetsbaar</a>
        <a href="/supplychain/secure">Veilig</a>
    </nav>
</header>

<div class="breadcrumb">
    <a href="/">Home</a> &rsaquo; A03 &rsaquo; Software Supply Chain Failures (Kwetsbaar)
</div>

<div class="container">

    <div class="module-header">
        <span class="badge">A03</span>
        <h1>Software Supply Chain Failures</h1>
        <button type="button" class="btn-info" id="openInfoBtn">Info &amp; CWEs</button>
        <button type="button" class="btn-examples" id="openExamplesBtn">Echte Voorbeelden</button>
        <button type="button" class="btn-help" id="openHelpBtn">Hulp &amp; Commando&rsquo;s</button>
    </div>

    <div class="terminal-panel">
        <div class="terminal-topbar">
            <div class="terminal-dots">
                <div class="terminal-dot dot-red"></div>
                <div class="terminal-dot dot-yellow"></div>
                <div class="terminal-dot dot-green"></div>
            </div>
            <span class="terminal-title">bvwa-pkg v3.2.1 &mdash; package manager (debug build)</span>
        </div>

        <div class="terminal-body">
            <div class="terminal-motd">bvwa-pkg v3.2.1<br>
Connected to registry.bvwa.local</div>

            {{if .HasOutput}}
            <div class="terminal-entry">
                <div class="terminal-cmd-echo">
                    <span class="ps1">user@bvwa-server:~$</span> bvwa-pkg {{.Command}}
                </div>
                <pre class="terminal-output">{{.Output}}</pre>
            </div>
            {{end}}
        </div>

        <form method="GET" action="/supplychain/vulnerable">
            <div class="terminal-input-bar">
                <span class="terminal-ps1">user@bvwa-server:~$</span>
                <input type="text" name="cmd" value="" autofocus autocomplete="off" spellcheck="false" placeholder="bvwa-pkg ">
                <button type="submit">&#x23CE;</button>
            </div>
        </form>
    </div>

</div>

<!-- ECHTE VOORBEELDEN MODAL -->
<div class="modal-overlay" id="examplesModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeExamplesBtn">X</button>
        <h2>Echte Voorbeelden &mdash; Software Supply Chain Failures</h2>
        <p class="subtitle">Historische incidenten waarbij de supplychain als aanvalsvector diende</p>
        <hr>

        <div class="example-item">
            <h4><span class="example-year">2020</span> SolarWinds SUNBURST</h4>
            <p>Aanvallers infiltreerden het buildsysteem van SolarWinds en voegden de SUNBURST-backdoor toe
            aan een legitieme software-update van Orion. De update werd digitaal ondertekend met een
            geldig certificaat. Slachtoffers installeerden de update vrijwillig.</p>
            <p class="example-impact">Impact: 18.000+ organisaties, inclusief US Treasury en NATO &mdash; grootste supplychain-aanval ooit</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2024</span> XZ Utils Backdoor (CVE-2024-3094)</h4>
            <p>"Jia Tan" bouwde gedurende 2 jaar vertrouwen op als open-source maintainer van xz-utils.
            Vlak voor de release voegde hij een verborgen backdoor toe in liblzma die SSH-authenticatie
            zou omzeilen. Toevallig ontdekt door een Microsoft-engineer die een vertraging van 500ms
            in SSH opmerkte.</p>
            <p class="example-impact">Impact: Bijna alle Linux-servers wereldwijd kwetsbaar &mdash; ontdekt op het nippertje</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2018</span> Event-Stream npm Package</h4>
            <p>Een aanvaller nam de maintainer-rol over van de populaire npm-package "event-stream"
            (11 miljoen downloads/week) en voegde verborgen code toe die de Copay Bitcoin-wallet
            aanviel om private keys te stelen.</p>
            <p class="example-impact">Impact: Miljoenen npm-installaties getroffen; Bitcoin-wallets gecompromitteerd</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2021</span> CodeCov Supply Chain Aanval</h4>
            <p>Aanvallers wijzigden het Docker-image van CodeCov en voegden code toe die environment
            variables uit CI/CD-omgevingen stal. Duizenden bedrijven stuurden onbewust hun secrets
            naar de aanvallers.</p>
            <p class="example-impact">Impact: Twilio, Twitch en HashiCorp onder de getroffen bedrijven</p>
        </div>
    </div>
</div>

<!-- INFO MODAL -->
<div class="modal-overlay" id="infoModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeInfoBtn">X</button>
        <h2>A03:2025 &mdash; Software Supply Chain Failures</h2>
        <p class="subtitle">OWASP Top 10:2025 &mdash; Positie #3 &mdash; Nieuw in 2021, uitgebreid in 2025</p>
        <hr>

        <div class="info-section">
            <h3>Wat is het?</h3>
            <p>Supply Chain Failures treden op wanneer kwetsbaarheden of kwaadaardige code binnensluipen
            via externe componenten: open-source libraries, build-tools, CI/CD-pipelines, of
            update-processen. Het gaat om de <em>herkomst en integriteit</em> van de software zelf.</p>
        </div>
        <hr>

        <div class="info-section">
            <h3>Gerelateerde CWEs</h3>
            <div class="cwe-list">
                <span class="cwe-tag">CWE-494 — Download of Code Without Integrity Check</span>
                <span class="cwe-tag">CWE-345 — Insufficient Verification of Data Authenticity</span>
                <span class="cwe-tag">CWE-347 — Improper Verification of Cryptographic Signature</span>
                <span class="cwe-tag">CWE-353 — Missing Support for Integrity Check</span>
                <span class="cwe-tag">CWE-829 — Inclusion from Untrusted Control Sphere</span>
                <span class="cwe-tag">CWE-1104 — Use of Unmaintained Third-Party Components</span>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de kwetsbare versie onveilig?</h3>
            <div class="vuln-box">
                <ul>
                    <li><strong>Geen checksum verificatie</strong> &mdash; packages worden geinstalleerd zonder integriteitscontrole (CWE-494)</li>
                    <li><strong>Postinstall hooks</strong> worden uitgevoerd zonder validatie &mdash; willekeurige code kan draaien</li>
                    <li><strong>Geen audit</strong> &mdash; gecompromitteerde packages blijven onopgemerkt</li>
                    <li><strong>Deprecated dependencies</strong> &mdash; geen waarschuwing bij verouderde packages</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Mitigatie</h3>
            <div class="safe-box">
                <ul>
                    <li>Verifieer checksums v&oacute;&oacute;r installatie (<code>go mod verify</code>, <code>npm ci</code>)</li>
                    <li>Gebruik een software bill of materials (SBOM)</li>
                    <li>Scan dependencies met <code>govulncheck</code> of <code>npm audit</code></li>
                    <li>Automatiseer updates met Dependabot of Renovate</li>
                    <li>Vertrouw alleen ondertekende packages van bekende bronnen</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<footer>
    BVWA is uitsluitend bedoeld voor educatieve doeleinden &mdash;
    gebruik alleen in een gei&euml;soleerde testomgeving.
</footer>

<!-- HULP MODAL -->
<div class="modal-overlay" id="helpModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeHelpBtn">X</button>
        <h2>Hulp — A03 Supply Chain (Kwetsbaar)</h2>
        <p class="subtitle">Beschikbare <code>bvwa-pkg</code>-commando's op dit kwetsbare package registry</p>
        <hr>

        <div class="info-section">
            <h3>Commando's</h3>
            <table style="width:100%; border-collapse:collapse; font-size:14px;">
                <thead>
                    <tr style="background:#f6f8fa; text-align:left;">
                        <th style="padding:8px 12px; border-bottom:1px solid #e0e0e0;">Commando</th>
                        <th style="padding:8px 12px; border-bottom:1px solid #e0e0e0;">Wat het doet</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">list</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">Beschikbare packages tonen</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">info &lt;pkg&gt;</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">Details van een package tonen (checksum, auteur, dependencies)</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">install &lt;pkg&gt;</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">Package installeren <strong style="color:#e74c3c;">(checksum overgeslagen!)</strong></td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">verify &lt;pkg&gt;</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">Verificatie uitgeschakeld in deze build</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">audit</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">Security audit overgeslagen in deze build</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace;">search &lt;term&gt;</td>
                        <td style="padding:8px 12px;">Zoek packages op naam of beschrijving</td>
                    </tr>
                </tbody>
            </table>
        </div>
        <hr>

        <div class="info-section">
            <h3>Beschikbare packages</h3>
            <table style="width:100%; border-collapse:collapse; font-size:14px;">
                <thead>
                    <tr style="background:#f6f8fa; text-align:left;">
                        <th style="padding:8px 12px; border-bottom:1px solid #e0e0e0;">Package</th>
                        <th style="padding:8px 12px; border-bottom:1px solid #e0e0e0;">Versie</th>
                        <th style="padding:8px 12px; border-bottom:1px solid #e0e0e0;">Status</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">bvwa-utils</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">1.2.0</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0; color:#27ae60;">OK</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">bvwa-logger</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">2.1.3</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0; color:#e74c3c;">Getamperd — bevat postinstall hook met CTF-flag</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">bvwa-crypto</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">0.9.1</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0; color:#e67e22;">Deprecated</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace;">bvwa-auth</td>
                        <td style="padding:8px 12px;">1.0.4</td>
                        <td style="padding:8px 12px; color:#27ae60;">OK</td>
                    </tr>
                </tbody>
            </table>
        </div>
        <hr>

        <div class="info-section">
            <h3>CTF-tip</h3>
            <p>Voer <code>install bvwa-logger</code> uit. De malicieuze postinstall hook lekt de CTF-flag
            als onderdeel van de telemetrie-output.</p>
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
