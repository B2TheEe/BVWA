<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{.Title}} - BVWA</title>
    <link rel="stylesheet" href="/static/css/bvwa.css">
</head>
<body>

<!-- HEADER -->
<header>
    <a href="/" class="logo">&#x1F510; <span>BVWA</span></a>
    <nav>
        <a href="/">&#x1F3E0; Home</a>
        <a href="/auth/vulnerable">Kwetsbaar</a>
        <a href="/auth/secure">Veilig</a>
    </nav>
</header>

<!-- BREADCRUMB -->
<div class="breadcrumb">
    <a href="/">Home</a> &rsaquo; A07 &rsaquo; {{.Title}}
</div>

<!-- MAIN -->
<div class="container">

    <div class="module-header">
        <span class="badge">A07</span>
        <h1>Authentication Failures</h1>
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
                    Login <strong>zonder rate limiting</strong>,
                    met plaintext wachtwoord vergelijking en
                    geen sessie-vernieuwing na inloggen.
                </p>
                <div class="code-block">// KWETSBAAR: plaintext + geen limiet
storedPass, exists := users[username]
if exists &amp;&amp; storedPass == password {
    c.SetSession("user", username)
    // geen sessie-vernieuwing!
}</div>

                <p style="font-size:13px; color:#e74c3c;
                           font-weight:bold; margin-top:8px;">
                    Probeer: 10x inloggen met fout wachtwoord.
                    Geen blokkering!
                </p>

                <form method="POST" action="/auth/vulnerable">
                    <div class="input-group">
                        <label>Gebruikersnaam:</label>
                        <input type="text" name="username"
                               placeholder="admin">
                    </div>
                    <div class="input-group">
                        <label>Wachtwoord:</label>
                        <input type="password" name="password"
                               placeholder="password123">
                    </div>
                    <button type="submit"
                            class="btn-submit red">
                        Inloggen (kwetsbaar)
                    </button>
                </form>

                <div class="credentials-hint">
                    admin / password123 &nbsp;|&nbsp;
                    user / user123
                </div>
            </div>
        </div>

        <!-- VEILIG -->
        <div class="card">
            <div class="card-header safe">Veilige versie</div>
            <div class="card-body">
                <p>
                    Login <strong>met bcrypt, rate limiting
                    (max 5 pogingen per IP)</strong> en
                    sessie-vernieuwing na inloggen.
                </p>
                <div class="code-block">// VEILIG: bcrypt + rate limiting
if loginAttempts[ip] &gt;= maxAttempts {
    // blokkeer IP
}
err := bcrypt.CompareHashAndPassword(
    hash, []byte(password))
c.DestroySession()
c.SetSession("user", username)</div>

                <p style="font-size:13px; color:#27ae60;
                           font-weight:bold; margin-top:8px;">
                    Probeer: 5x inloggen met fout wachtwoord.
                    Daarna geblokkeerd!
                </p>

                <form method="POST" action="/auth/secure">
                    <div class="input-group">
                        <label>Gebruikersnaam:</label>
                        <input type="text" name="username"
                               placeholder="admin">
                    </div>
                    <div class="input-group">
                        <label>Wachtwoord:</label>
                        <input type="password" name="password"
                               placeholder="password123">
                    </div>
                    <button type="submit"
                            class="btn-submit green">
                        Inloggen (veilig)
                    </button>
                </form>

                <div class="credentials-hint">
                    admin / password123 &nbsp;|&nbsp;
                    user / user123
                </div>
            </div>
        </div>

    </div>

    <!-- Result box -->
    <div class="result-box">
        <h3>Resultaat: <strong>{{.Title}}</strong></h3>

        {{if eq .Title "Login (Kwetsbaar)"}}
        <span class="tag-vuln">KWETSBAAR</span>

        {{if .Success}}
        <div class="msg-success">{{.Success}}</div>
        <p style="margin-top:10px; color:#e74c3c; font-size:13px;">
            Ingelogd! Geen rate limiting - brute force mogelijk.
            Wachtwoord vergeleken als plaintext.
        </p>
        {{else if .Error}}
        <div class="msg-error">{{.Error}}</div>
        {{if .Warning}}
        <p style="color:#e74c3c; font-size:13px; margin-top:6px;">
            {{.Warning}}
        </p>
        {{end}}
        {{else}}
        <p>Voer credentials in om de kwetsbaarheid te testen.</p>
        {{end}}

        {{else}}
        <span class="tag-safe">VEILIG</span>

        {{if .Success}}
        <div class="msg-success">{{.Success}}</div>
        {{if .Info}}
        <p style="color:#27ae60; font-size:13px; margin-top:6px;">
            {{.Info}}
        </p>
        {{end}}
        {{else if .Error}}
        <div class="msg-error">{{.Error}}</div>
        {{else}}
        <p>Voer credentials in. Na 5 foute pogingen wordt
           het IP geblokkeerd.</p>
        {{end}}
        {{end}}

        <div class="tip">
            Tip: Probeer 5x een fout wachtwoord op de veilige
            versie om rate limiting te testen. Gebruik
            admin / password123 om succesvol in te loggen.
        </div>
    </div>

</div>

<!-- ECHTE VOORBEELDEN MODAL -->
<div class="modal-overlay" id="examplesModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeExamplesBtn">X</button>

        <h2>Echte Voorbeelden — Authentication Failures</h2>
        <p class="subtitle">
            Historische incidenten door gebrekkige authenticatie en sessiebeheer
        </p>
        <hr>

        <div class="example-item">
            <h4>
                <span class="example-year">2012</span>
                Dropbox — Hergebruikt Wachtwoord
            </h4>
            <p>
                Een Dropbox-medewerker hergebruikte zijn LinkedIn-wachtwoord voor zijn
                werk-account. Nadat LinkedIn was gelekt in 2012 gebruikten aanvallers
                die credentials om in te loggen bij Dropbox. Vervolgens werd het
                adresboek van gebruikers gestolen en gebruikt voor spam.
            </p>
            <p class="example-impact">Impact: 68 miljoen gehashte credentials gestolen &mdash; ontdekt pas in 2016</p>
        </div>

        <div class="example-item">
            <h4>
                <span class="example-year">2022</span>
                Uber — MFA Fatigue Aanval
            </h4>
            <p>
                Een aanvaller kocht gelekte credentials en stuurde vervolgens meer dan
                een uur lang MFA push-notificaties naar een Uber-medewerker. Tegelijkertijd
                deed de aanvaller zich via WhatsApp voor als Uber IT-support. Uitgeput
                accepteerde de medewerker uiteindelijk een push-bericht.
            </p>
            <p class="example-impact">Impact: Volledige toegang tot interne systemen, Slack, AWS en HackerOne</p>
        </div>

        <div class="example-item">
            <h4>
                <span class="example-year">2023</span>
                23andMe — Credential Stuffing
            </h4>
            <p>
                Aanvallers gebruikten miljoenen credentials uit eerdere datalekken
                (credential stuffing) om in te loggen bij 23andMe-accounts. Via de
                "DNA Relatives"-functie konden ze data van veel meer profielen inzien
                dan alleen de gecompromitteerde accounts. Geen rate limiting aanwezig.
            </p>
            <p class="example-impact">Impact: 6,9 miljoen profielen blootgesteld, inclusief genetische data</p>
        </div>

        <div class="example-item">
            <h4>
                <span class="example-year">2022</span>
                Rockstar Games / GTA 6
            </h4>
            <p>
                Een 18-jarige hacker gebruikte social engineering om Slack-credentials
                van een medewerker te stelen. Rockstar had geen MFA op Slack ingesteld.
                Via Slack werd toegang verkregen tot Confluence en interne servers,
                van waaruit GTA 6-broncode en video's werden gestolen.
            </p>
            <p class="example-impact">Impact: GTA 6 broncode en video's openbaar &mdash; geschatte schade van honderden miljoenen</p>
        </div>

    </div>
</div>

<!-- INFO MODAL -->
<div class="modal-overlay" id="infoModal">
    <div class="modal">
        <button type="button" class="modal-close"
                id="closeInfoBtn">X</button>

        <h2>A07:2025 - Authentication Failures</h2>
        <p class="subtitle">
            OWASP Top 10:2025 - Positie #7 -
            Voorheen: Broken Authentication
        </p>
        <hr>

        <div class="info-section">
            <h3>Wat is het?</h3>
            <p>
                Authentication Failures treden op wanneer een
                applicatie authenticatie- en sessiebeheer
                onjuist implementeert. Een aanvaller kan
                wachtwoorden kraken, sessies overnemen of
                authenticatie volledig omzeilen via zwakke
                implementaties van login, logout of
                wachtwoordherstel.
            </p>
        </div>
        <hr>

        <div class="info-section">
            <h3>Gerelateerde CWEs</h3>
            <div class="cwe-list">
                <span class="cwe-tag">CWE-255 Credentials Management Errors</span>
                <span class="cwe-tag">CWE-259 Use of Hard-coded Password</span>
                <span class="cwe-tag">CWE-287 Improper Authentication</span>
                <span class="cwe-tag">CWE-288 Authentication Bypass Using Alternate Path</span>
                <span class="cwe-tag">CWE-290 Authentication Bypass by Spoofing</span>
                <span class="cwe-tag">CWE-294 Authentication Bypass by Capture-replay</span>
                <span class="cwe-tag">CWE-295 Improper Certificate Validation</span>
                <span class="cwe-tag">CWE-297 Improper Validation of Certificate with Host Mismatch</span>
                <span class="cwe-tag">CWE-300 Channel Accessible by Non-Endpoint</span>
                <span class="cwe-tag">CWE-302 Authentication Bypass by Assumed-Immutable Data</span>
                <span class="cwe-tag">CWE-304 Missing Critical Step in Authentication</span>
                <span class="cwe-tag">CWE-306 Missing Authentication for Critical Function</span>
                <span class="cwe-tag">CWE-307 Improper Restriction of Excessive Auth Attempts</span>
                <span class="cwe-tag">CWE-346 Origin Validation Error</span>
                <span class="cwe-tag">CWE-384 Session Fixation</span>
                <span class="cwe-tag">CWE-521 Weak Password Requirements</span>
                <span class="cwe-tag">CWE-613 Insufficient Session Expiration</span>
                <span class="cwe-tag">CWE-620 Unverified Password Change</span>
                <span class="cwe-tag">CWE-640 Weak Password Recovery Mechanism</span>
                <span class="cwe-tag">CWE-798 Use of Hard-coded Credentials</span>
                <span class="cwe-tag">CWE-940 Improper Verification of Communication Channel</span>
                <span class="cwe-tag">CWE-1216 Lockout Mechanism Errors</span>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de kwetsbare versie onveilig?</h3>
            <div class="vuln-box">
                De kwetsbare versie heeft meerdere fouten:
                <ul>
                    <li><strong>Plaintext vergelijking (CWE-256):
                        </strong> wachtwoorden opgeslagen als
                        plaintext - bij datalek direct leesbaar</li>
                    <li><strong>Geen rate limiting (CWE-307):
                        </strong> onbeperkte loginpogingen -
                        brute force en credential stuffing mogelijk</li>
                    <li><strong>Geen sessie-vernieuwing (CWE-384):
                        </strong> dezelfde sessie-ID voor en na
                        login - session fixation mogelijk</li>
                    <li><strong>Info-lekkage:</strong>
                        foutmelding geeft aan of gebruiker
                        bestaat - user enumeration</li>
                    <li><strong>Geen MFA:</strong> enkelfactor
                        authenticatie kwetsbaar voor
                        gestolen credentials</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de veilige versie correct?</h3>
            <div class="safe-box">
                De veilige versie implementeert correcte
                authenticatie:
                <ul>
                    <li><strong>bcrypt hashing:</strong>
                        wachtwoorden als bcrypt hash opgeslagen -
                        bij datalek niet direct bruikbaar</li>
                    <li><strong>Rate limiting per IP (CWE-307 fix):
                        </strong> max 5 pogingen, daarna geblokkeerd</li>
                    <li><strong>Sessie-vernieuwing (CWE-384 fix):
                        </strong> DestroySession() voor nieuwe
                        sessie na login</li>
                    <li><strong>Generieke foutmelding:</strong>
                        geen aanwijzing of gebruiker bestaat</li>
                    <li><strong>Timing-safe vergelijking:</strong>
                        bcrypt.CompareHashAndPassword() voorkomt
                        timing attacks</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Mitigatie</h3>
            <p>
                Gebruik bcrypt of Argon2 voor wachtwoorden.
                Implementeer MFA. Voeg rate limiting toe op
                alle auth-endpoints. Vernieuw sessie-IDs na
                login en logout. Gebruik generieke foutmeldingen.
                Log alle authenticatiegebeurtenissen.
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
