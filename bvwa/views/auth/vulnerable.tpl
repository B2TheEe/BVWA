<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>bvwa-auth — authentication gateway (kwetsbaar)</title>
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
        <a href="/auth/vulnerable">Kwetsbaar</a>
        <a href="/auth/secure">Veilig</a>
    </nav>
</header>

<div class="breadcrumb">
    <a href="/">Home</a> &rsaquo; A07 &rsaquo; Authentication Failures (Kwetsbaar)
</div>

<div class="container">

    <div class="module-header">
        <span class="badge">A07</span>
        <h1>Authentication Failures</h1>
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
            <span class="terminal-title">bvwa-auth v1.0.0 &mdash; Corporate Authentication Gateway</span>
        </div>

        <div class="terminal-body">
            <div class="terminal-motd">bvwa-auth v1.0.0<br>
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

        <form method="GET" action="/auth/vulnerable">
            <div class="terminal-input-bar">
                <span class="terminal-ps1">anon@bvwa-corp:~$</span>
                <input type="text" name="cmd" value="" autofocus autocomplete="off"
                       spellcheck="false" placeholder="bvwa-auth ">
                <button type="submit">&#x23CE;</button>
            </div>
        </form>
    </div>

</div>

<!-- COMMANDO'S MODAL -->
<div class="modal-overlay" id="helpModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeHelpBtn">X</button>
        <h2>Commando&rsquo;s &mdash; bvwa-auth (kwetsbaar)</h2>
        <p class="subtitle">Beschikbare commando&rsquo;s voor de kwetsbare authenticatie-gateway</p>
        <hr>

        <div class="info-section">
            <h3>login</h3>
            <div class="vuln-box">
                <code>login &lt;gebruiker&gt; &lt;wachtwoord&gt;</code>
                <p>Authenticeer als een gebruiker. Geeft een andere foutmelding terug
                afhankelijk van of de gebruiker bestaat of het wachtwoord onjuist is
                (<strong>CWE-204 &mdash; user enumeration</strong>). Bij succes wordt
                een voorspelbaar sessietoken (<code>sess_00042</code>) teruggegeven.</p>
                <p><em>Voorbeelden:</em><br>
                <code>login admin admin123</code><br>
                <code>login admin fout</code><br>
                <code>login niemand test</code></p>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>enum</h3>
            <div class="vuln-box">
                <code>enum &lt;gebruiker&gt;</code>
                <p>Controleer expliciet of een gebruiker bestaat in het systeem
                (<strong>CWE-203 &mdash; user enumeration endpoint</strong>). Geeft
                &ldquo;BESTAAT&rdquo; of &ldquo;NIET GEVONDEN&rdquo; terug.</p>
                <p><em>Voorbeelden:</em><br>
                <code>enum admin</code><br>
                <code>enum support</code><br>
                <code>enum backup</code></p>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>session</h3>
            <div class="vuln-box">
                <code>session</code>
                <p>Toon het huidige sessietoken. Het token is sequentieel en daardoor
                voorspelbaar (<strong>CWE-330</strong>): het volgende token is
                waarschijnlijk <code>sess_00043</code>.</p>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>help</h3>
            <div class="vuln-box">
                <code>help</code>
                <p>Toon het ingebouwde overzicht van beschikbare commando&rsquo;s.</p>
            </div>
        </div>
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
            <p>Aanvallers gebruikten miljoenen gelekte credentials uit eerdere datalekken om
            bij 23andMe in te loggen. Geen rate limiting op het login-endpoint maakte het
            mogelijk om automatisch tienduizenden combinaties te proberen. Via de
            &ldquo;DNA Relatives&rdquo;-functie konden ze aanvullend data van miljoenen
            andere profielen inzien.</p>
            <p class="example-impact">Impact: 6,9 miljoen profielen blootgesteld, inclusief genetische afkomstdata</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2022</span> Uber &mdash; MFA Fatigue</h4>
            <p>Een aanvaller kocht gelekte credentials en stuurde vervolgens meer dan een uur
            lang MFA push-notificaties. Tegelijkertijd deed hij zich via WhatsApp voor als
            Uber IT-support. Uitgeput accepteerde de medewerker uiteindelijk een
            push-bericht. Geen rate limiting op MFA-verzoeken.</p>
            <p class="example-impact">Impact: volledige toegang tot Slack, AWS, HackerOne en interne systemen</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2012</span> Dropbox &mdash; Hergebruikt Wachtwoord</h4>
            <p>Een Dropbox-medewerker hergebruikte zijn LinkedIn-wachtwoord voor zijn
            Dropbox-werkaccount. Na het LinkedIn-lek in 2012 logden aanvallers in met die
            credentials. Via het interne account werden gebruikers-adresboeken gestolen
            en misbruikt voor spam.</p>
            <p class="example-impact">Impact: 68 miljoen gehashte wachtwoorden gestolen &mdash; pas ontdekt in 2016</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2022</span> Rockstar Games &mdash; GTA 6 Lek</h4>
            <p>Een 18-jarige hacker gebruikte social engineering om Slack-credentials te
            stelen. Rockstar had geen MFA op Slack ingesteld. Via Slack werd toegang
            verkregen tot Confluence en interne servers, van waaruit GTA 6-broncode
            en video&rsquo;s werden gestolen.</p>
            <p class="example-impact">Impact: GTA 6 broncode &amp; video&rsquo;s openbaar &mdash; geschatte schade honderden miljoenen</p>
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
            <p>Authentication Failures treden op wanneer authenticatie en sessiebeheer
            onjuist zijn ge&iuml;mplementeerd. Een aanvaller kan wachtwoorden automatisch
            raden (brute force), gelekte credentials hergebruiken (credential stuffing),
            gebruikers opsporen via verschillende foutmeldingen (user enumeration),
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
                    <li><strong>CWE-256 &mdash; Plaintext wachtwoorden:</strong>
                        directe vergelijking zonder hashing &mdash; bij datalek direct leesbaar</li>
                    <li><strong>CWE-307 &mdash; Geen rate limiting:</strong>
                        onbeperkt inlogpogingen &mdash; brute force en credential stuffing mogelijk</li>
                    <li><strong>CWE-204 &mdash; User enumeration:</strong>
                        verschillende foutmeldingen onthullen of een gebruiker bestaat</li>
                    <li><strong>CWE-203 &mdash; Explicit enumeration endpoint:</strong>
                        <code>enum</code>-commando geeft direct aan of een gebruiker bestaat</li>
                    <li><strong>CWE-330 &mdash; Voorspelbaar sessietoken:</strong>
                        sequentieel token kan worden geraden door een aanvaller</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de veilige versie correct?</h3>
            <div class="safe-box">
                <ul>
                    <li><strong>bcrypt:</strong> wachtwoorden als bcrypt-hash &mdash; niet bruikbaar bij lek</li>
                    <li><strong>Rate limiting:</strong> max 5 pogingen per IP, daarna geblokkeerd</li>
                    <li><strong>Generieke foutmelding:</strong> altijd &ldquo;Authenticatie mislukt&rdquo; &mdash; geen enumeration</li>
                    <li><strong>Geen enum-endpoint:</strong> <code>enum</code> bestaat niet in de veilige versie</li>
                    <li><strong>Willekeurig sessietoken:</strong> CSPRNG &mdash; niet voorspelbaar</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Mitigatie</h3>
            <p>Gebruik bcrypt of Argon2id voor wachtwoordopslag. Implementeer rate limiting
            en account lockout. Gebruik altijd generieke foutmeldingen. Genereer sessietokens
            met een CSPRNG. Vernieuw sessie-ID na elke login en logout. Overweeg MFA.</p>
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
