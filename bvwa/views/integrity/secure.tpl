<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>bvwa-deploy — deployment pipeline (veilig)</title>
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
            background: #1a2634;
            padding: 10px 16px;
            display: flex;
            align-items: center;
            gap: 8px;
            border-bottom: 1px solid #1f4068;
        }
        .terminal-dots { display: flex; gap: 6px; }
        .terminal-dot { width: 12px; height: 12px; border-radius: 50%; }
        .dot-red    { background: #ff5f57; }
        .dot-yellow { background: #febc2e; }
        .dot-green  { background: #28c840; }
        .terminal-title { color: #58a6ff; font-size: 13px; margin-left: 6px; }
        .terminal-body {
            padding: 20px 24px;
            min-height: 260px;
            color: #e6edf3;
            font-size: 13.5px;
            line-height: 1.65;
        }
        .terminal-motd { color: #3fb950; margin-bottom: 18px; font-size: 13px; }
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
            background: #0f1a26;
            padding: 10px 24px;
            border-top: 1px solid #1f4068;
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
            background: #1f4068;
            color: #58a6ff;
            border: none;
            border-radius: 6px;
            padding: 5px 14px;
            font-size: 13px;
            font-weight: bold;
            cursor: pointer;
        }
        .terminal-input-bar button:hover { background: #2a5a8f; }
    </style>
</head>
<body>

<header>
    <a href="/" class="logo">&#x1F510; <span>BVWA</span></a>
    <nav>
        <a href="/">&#x1F3E0; Home</a>
        <a href="/integrity/vulnerable">Kwetsbaar</a>
        <a href="/integrity/secure">Veilig</a>
    </nav>
</header>

<div class="breadcrumb">
    <a href="/">Home</a> &rsaquo; A08 &rsaquo; Software/Data Integrity Failures (Veilig)
</div>

<div class="container">

    <div class="module-header">
        <span class="badge">A08</span>
        <h1>Software/Data Integrity Failures</h1>
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
            <span class="terminal-title">bvwa-deploy v2.0.0 &mdash; CI/CD Deployment Pipeline [beveiligd]</span>
        </div>

        <div class="terminal-body">
            <div class="terminal-motd">bvwa-deploy v2.0.0 [secure build]<br>
Verbonden met deploy.bvwa-corp.local &mdash; Welkom, deployer</div>

            {{if .HasOutput}}
            <div class="terminal-entry">
                <div class="terminal-cmd-echo">
                    <span class="ps1">deployer@bvwa-corp:~$</span> bvwa-deploy {{.Command}}
                </div>
                <pre class="terminal-output">{{.Output}}</pre>
            </div>
            {{end}}
        </div>

        <form method="GET" action="/integrity/secure">
            <div class="terminal-input-bar">
                <span class="terminal-ps1">deployer@bvwa-corp:~$</span>
                <input type="text" name="cmd" value="" autofocus autocomplete="off"
                       spellcheck="false" placeholder="bvwa-deploy ">
                <button type="submit">&#x23CE;</button>
            </div>
        </form>
    </div>

</div>

<!-- COMMANDO'S MODAL -->
<div class="modal-overlay" id="helpModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeHelpBtn">X</button>
        <h2>Commando&rsquo;s &mdash; bvwa-deploy (veilig)</h2>
        <p class="subtitle">Beschikbare commando&rsquo;s voor de beveiligde CI/CD deployment pipeline</p>
        <hr>

        <div class="info-section">
            <h3>token</h3>
            <div class="safe-box">
                <code>token</code>
                <p>Toon het huidige gesigneerde deployment-token. Het token heeft het
                formaat <code>&lt;base64-payload&gt;.&lt;hmac-sha256-hex&gt;</code>.
                De handtekening is cryptografisch gekoppeld aan de payload en kan niet
                worden vervalst zonder de server-sleutel
                (<strong>CWE-347 mitigatie</strong>).</p>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>decode</h3>
            <div class="safe-box">
                <code>decode &lt;token&gt;</code>
                <p>Decodeer de payload van een token (het deel v&oacute;&oacute;r de punt).
                Toont de JSON-inhoud. Gebruik <code>verify</code> om de handtekening
                apart te controleren.</p>
                <p><em>Voorbeeld:</em><br>
                <code>decode &lt;token uit &lsquo;token&rsquo; commando&gt;</code></p>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>verify</h3>
            <div class="safe-box">
                <code>verify &lt;token&gt;</code>
                <p>Verifieer de HMAC-SHA256-handtekening van een token. Geeft
                <em>GELDIG</em> of <em>ONGELDIG</em> terug. Probeer een gemanipuleerde
                payload door te sturen &mdash; de handtekening zal niet meer kloppen.</p>
                <p><em>Voorbeelden:</em><br>
                <code>verify &lt;geldig token&gt;</code><br>
                <code>verify &lt;aangepaste base64&gt;.&lt;originele handtekening&gt;</code></p>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>deploy</h3>
            <div class="safe-box">
                <code>deploy &lt;token&gt;</code>
                <p>Voer een deployment uit. De server verifieert eerst de
                HMAC-SHA256-handtekening via timing-safe vergelijking
                (<code>hmac.Equal()</code>). Bij een ongeldige handtekening wordt
                het artifact geweigerd en vindt er <strong>geen</strong> deployment
                plaats (fail-closed).</p>
                <p><em>Voorbeeld:</em><br>
                <code>deploy &lt;geldig gesigneerd token&gt;</code></p>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>help</h3>
            <div class="safe-box">
                <code>help</code>
                <p>Toon het ingebouwde overzicht van beschikbare commando&rsquo;s.
                Het <code>encode</code>-commando bestaat niet in deze versie &mdash;
                tokens kunnen alleen server-side worden aangemaakt.</p>
            </div>
        </div>
    </div>
</div>

<!-- ECHTE VOORBEELDEN MODAL -->
<div class="modal-overlay" id="examplesModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeExamplesBtn">X</button>
        <h2>Echte Voorbeelden &mdash; Software/Data Integrity Failures</h2>
        <p class="subtitle">Historische incidenten waarbij manipulatie van data of software onopgemerkt bleef</p>
        <hr>

        <div class="example-item">
            <h4><span class="example-year">2020</span> SolarWinds SUNBURST &mdash; Gesigneerde Backdoor</h4>
            <p>De SUNBURST-backdoor werd digitaal ondertekend met een geldig SolarWinds-certificaat
            en verspreid via het offici&euml;le updatekanaal. Er waren geen runtime-integriteitscontroles
            op het uitgevoerde binary. Beveiligingstools vertrouwden de handtekening en lieten de
            backdoor passeren. Negen maanden lang bleef de aanval volledig onopgemerkt.</p>
            <p class="example-impact">Impact: 18.000+ organisaties gecompromitteerd, waaronder NASA, DoJ en Microsoft</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2019</span> ASUS Live Update &mdash; Operation ShadowHammer</h4>
            <p>Aanvallers compromitteerden de ASUS-updateserver en signeerden backdoored firmware
            met een legitiem ASUS-certificaat. De updates werden via het offici&euml;le updatekanaal
            verspreid naar honderdduizenden apparaten. De backdoor zocht specifiek naar
            MAC-adressen van doelwitten.</p>
            <p class="example-impact">Impact: 500.000&ndash;1 miljoen apparaten ge&iuml;nfecteerd</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2021</span> PHP Git Repository Compromise</h4>
            <p>Aanvallers compromitteerden de php.net git-server en pushten twee commits met een
            verborgen backdoor in de PHP-broncode. De commits leken op normale bugfixes van bekende
            ontwikkelaars. Omdat commits niet gesigneerd waren, was manipulatie aanvankelijk
            niet zichtbaar.</p>
            <p class="example-impact">Impact: potentieel alle PHP-servers wereldwijd kwetsbaar &mdash; op tijd ontdekt</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2022</span> PyPI &mdash; Kwaadaardige Packages</h4>
            <p>Duizenden kwaadaardige PyPI-packages met typosquatted namen (bijv. &ldquo;requets&rdquo;
            i.p.v. &ldquo;requests&rdquo;) bevatten datadiefstalcode. Bij installatie stuurden ze
            credentials en environment variables naar externe servers. PyPI heeft geen verplichte
            integriteitsverificatie bij download.</p>
            <p class="example-impact">Impact: tienduizenden installaties van malafide packages &mdash; aanhoudend probleem</p>
        </div>
    </div>
</div>

<!-- INFO MODAL -->
<div class="modal-overlay" id="infoModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeInfoBtn">X</button>
        <h2>A08:2025 &mdash; Software/Data Integrity Failures</h2>
        <p class="subtitle">OWASP Top 10:2025 &mdash; Positie #8 &mdash; Omvat insecure deserialization en CI/CD integriteitsfouten</p>
        <hr>

        <div class="info-section">
            <h3>Wat is het?</h3>
            <p>Software and Data Integrity Failures treden op wanneer code, data of
            software-updates worden verwerkt zonder hun integriteit te verifi&euml;ren.
            Dit kan leiden tot privilege escalation, remote code execution of datavervalsing.
            Het omvat zowel insecure deserialization als onveilige CI/CD-pipelines.</p>
        </div>
        <hr>

        <div class="info-section">
            <h3>Gerelateerde CWEs</h3>
            <div class="cwe-list">
                <span class="cwe-tag">CWE-345 Insufficient Verification of Data Authenticity</span>
                <span class="cwe-tag">CWE-347 Improper Verification of Cryptographic Signature</span>
                <span class="cwe-tag">CWE-353 Missing Support for Integrity Check</span>
                <span class="cwe-tag">CWE-494 Download of Code Without Integrity Check</span>
                <span class="cwe-tag">CWE-502 Deserialization of Untrusted Data</span>
                <span class="cwe-tag">CWE-565 Reliance on Cookies Without Validation</span>
                <span class="cwe-tag">CWE-829 Inclusion from Untrusted Control Sphere</span>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de kwetsbare versie onveilig?</h3>
            <div class="vuln-box">
                <ul>
                    <li><strong>CWE-345/502:</strong> deployment-token is Base64-only JSON &mdash; geen handtekening, geen verificatie</li>
                    <li><strong>Blind vertrouwen:</strong> server verwerkt elke aangeboden Base64 zonder te controleren of het origineel is</li>
                    <li><strong>Privilege escalation:</strong> aanvaller past <code>role</code> aan van <code>"user"</code> naar <code>"admin"</code></li>
                    <li><strong>Base64 is geen beveiliging:</strong> het is codering, niet encryptie &mdash; triviaal omkeerbaar</li>
                    <li><strong>Geen detectie:</strong> manipulatie is onzichtbaar voor de server</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de veilige versie correct?</h3>
            <div class="safe-box">
                <ul>
                    <li><strong>CWE-347 mitigatie:</strong> HMAC-SHA256-handtekening is cryptografisch gekoppeld aan de payload</li>
                    <li><strong>Elke wijziging detecteerbaar:</strong> ook 1 bit verschil geeft een compleet andere handtekening</li>
                    <li><strong>Geheime sleutel:</strong> zonder de server-sleutel is een geldige handtekening onvervalsbaar</li>
                    <li><strong>Timing-safe vergelijking:</strong> <code>hmac.Equal()</code> voorkomt timing attacks</li>
                    <li><strong>Fail-closed:</strong> ongeldige handtekening &rarr; deployment geweigerd</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Mitigatie</h3>
            <p>Vertrouw nooit geserialiseerde client-side data zonder integriteitsverificatie.
            Gebruik HMAC of digitale handtekeningen voor alle tokens. Implementeer
            integriteitscontroles in CI/CD-pipelines. Gebruik signed packages en controleer
            checksums bij downloads.</p>
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
