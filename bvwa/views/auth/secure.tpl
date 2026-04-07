<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>bvwa-auth — authentication gateway (veilig)</title>
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
        <a href="/auth/vulnerable">Kwetsbaar</a>
        <a href="/auth/secure">Veilig</a>
    </nav>
</header>

<div class="breadcrumb">
    <a href="/">Home</a> &rsaquo; A07 &rsaquo; Authentication Failures (Veilig)
</div>

<div class="container">

    <div class="module-header">
        <span class="badge">A07</span>
        <h1>Authentication Failures</h1>
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
            <span class="terminal-title">bvwa-auth v2.0.0 &mdash; Corporate Authentication Gateway [beveiligd]</span>
        </div>

        <div class="terminal-body">
            <div class="terminal-motd">bvwa-auth v2.0.0 [secure build]<br>
Verbonden met auth.bvwa-corp.local &mdash; Niet ingelogd</div>

            {{if .HasOutput}}
            <div class="terminal-entry">
                <div class="terminal-cmd-echo">
                    <span class="ps1">anon@bvwa-corp:~$</span> bvwa-auth {{.Command}}
                </div>
                <pre class="terminal-output">{{.Output}}</pre>
            </div>
            {{end}}
        </div>

        <form method="GET" action="/auth/secure">
            <div class="terminal-input-bar">
                <span class="terminal-ps1">anon@bvwa-corp:~$</span>
                <input type="text" name="cmd" value="" autofocus autocomplete="off"
                       spellcheck="false" placeholder="bvwa-auth ">
                <button type="submit">&#x23CE;</button>
            </div>
        </form>
    </div>

</div>

<!-- ECHTE VOORBEELDEN MODAL -->
<div class="modal-overlay" id="examplesModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeExamplesBtn">X</button>
        <h2>Echte Voorbeelden &mdash; Authentication Failures</h2>
        <p class="subtitle">Historische incidenten door gebrekkige authenticatie en sessiebeheer</p>
        <hr>

        <div class="example-item">
            <h4><span class="example-year">2023</span> 23andMe &mdash; Credential Stuffing</h4>
            <p>Aanvallers gebruikten miljoenen gelekte credentials om bij 23andMe in te loggen.
            Geen rate limiting maakte het mogelijk om automatisch tienduizenden combinaties te
            proberen. Via &ldquo;DNA Relatives&rdquo; konden ze aanvullend data van miljoenen
            andere profielen inzien.</p>
            <p class="example-impact">Impact: 6,9 miljoen profielen blootgesteld, inclusief genetische afkomstdata</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2022</span> Uber &mdash; MFA Fatigue</h4>
            <p>Een aanvaller kocht gelekte credentials en bombardeerde een medewerker meer dan
            een uur met MFA push-notificaties. Tegelijkertijd deed hij zich voor als IT-support.
            Uitgeput accepteerde de medewerker een push-bericht.</p>
            <p class="example-impact">Impact: volledige toegang tot Slack, AWS, HackerOne en interne systemen</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2012</span> Dropbox &mdash; Hergebruikt Wachtwoord</h4>
            <p>Een Dropbox-medewerker hergebruikte zijn LinkedIn-wachtwoord. Na het LinkedIn-lek
            logden aanvallers in met die credentials en stalen adresboeken van gebruikers.</p>
            <p class="example-impact">Impact: 68 miljoen gehashte wachtwoorden gestolen &mdash; pas ontdekt in 2016</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2022</span> Rockstar Games &mdash; GTA 6 Lek</h4>
            <p>Via social engineering werden Slack-credentials gestolen. Geen MFA op Slack
            stond toegang toe tot Confluence en interne servers. GTA 6-broncode en video&rsquo;s
            werden gestolen en openbaar gemaakt.</p>
            <p class="example-impact">Impact: GTA 6 broncode &amp; video&rsquo;s openbaar &mdash; schade honderden miljoenen</p>
        </div>
    </div>
</div>

<!-- INFO MODAL -->
<div class="modal-overlay" id="infoModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeInfoBtn">X</button>
        <h2>A07:2025 &mdash; Authentication Failures</h2>
        <p class="subtitle">OWASP Top 10:2025 &mdash; Positie #7 &mdash; Voorheen: Broken Authentication</p>
        <hr>

        <div class="info-section">
            <h3>Wat is het?</h3>
            <p>Authentication Failures treden op wanneer authenticatie en sessiebeheer onjuist
            zijn ge&iuml;mplementeerd. Een aanvaller kan wachtwoorden automatisch raden,
            gelekte credentials hergebruiken, gebruikers opsporen via foutmeldingen,
            of sessietokens voorspellen en overnemen.</p>
        </div>
        <hr>

        <div class="info-section">
            <h3>Gerelateerde CWEs</h3>
            <div class="cwe-list">
                <span class="cwe-tag">CWE-203 Observable Discrepancy</span>
                <span class="cwe-tag">CWE-204 Observable Response Discrepancy</span>
                <span class="cwe-tag">CWE-256 Plaintext Storage of Password</span>
                <span class="cwe-tag">CWE-287 Improper Authentication</span>
                <span class="cwe-tag">CWE-307 Improper Restriction of Auth Attempts</span>
                <span class="cwe-tag">CWE-330 Use of Insufficiently Random Values</span>
                <span class="cwe-tag">CWE-384 Session Fixation</span>
                <span class="cwe-tag">CWE-521 Weak Password Requirements</span>
                <span class="cwe-tag">CWE-613 Insufficient Session Expiration</span>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de kwetsbare versie onveilig?</h3>
            <div class="vuln-box">
                <ul>
                    <li><strong>CWE-256:</strong> plaintext wachtwoorden &mdash; direct leesbaar bij datalek</li>
                    <li><strong>CWE-307:</strong> geen rate limiting &mdash; brute force en credential stuffing</li>
                    <li><strong>CWE-204:</strong> user enumeration via verschillende foutmeldingen</li>
                    <li><strong>CWE-203:</strong> expliciet enum-endpoint onthult welke gebruikers bestaan</li>
                    <li><strong>CWE-330:</strong> sequentieel sessietoken is voorspelbaar</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de veilige versie correct?</h3>
            <div class="safe-box">
                <ul>
                    <li><strong>bcrypt:</strong> wachtwoorden gehashed &mdash; niet bruikbaar bij lek</li>
                    <li><strong>Rate limiting:</strong> max 5 pogingen per IP</li>
                    <li><strong>Generieke foutmelding:</strong> altijd &ldquo;Authenticatie mislukt&rdquo;</li>
                    <li><strong>Geen enum-endpoint:</strong> <code>enum</code> bestaat niet</li>
                    <li><strong>Willekeurig sessietoken:</strong> CSPRNG &mdash; niet voorspelbaar</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Mitigatie</h3>
            <p>Gebruik bcrypt of Argon2id. Implementeer rate limiting en account lockout.
            Gebruik generieke foutmeldingen. Genereer sessietokens met een CSPRNG.
            Vernieuw sessie-ID na elke login en logout. Overweeg MFA.</p>
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
