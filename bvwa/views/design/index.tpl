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
        <a href="/design/vulnerable">Kwetsbaar</a>
        <a href="/design/secure">Veilig</a>
    </nav>
</header>

<!-- BREADCRUMB -->
<div class="breadcrumb">
    <a href="/">Home</a> &rsaquo; A06 &rsaquo; {{.Title}}
</div>

<!-- MAIN -->
<div class="container">

    <div class="module-header">
        <span class="badge">A06</span>
        <h1>Insecure Design</h1>
        <button type="button" class="btn-info" id="openInfoBtn">
            Info &amp; CWEs
        </button>
    </div>

    <div class="cards">

        <!-- KWETSBAAR -->
        <div class="card">
            <div class="card-header vuln">Kwetsbare versie</div>
            <div class="card-body">
                <p>
                    Wachtwoord reset <strong>zonder rate
                    limiting of verificatie</strong>. Geen
                    limiet op het aantal verzoeken.
                </p>
                <div class="code-block">// KWETSBAAR: geen limiet
if email != "" {
    message = "Reset verstuurd naar: " + email
    // geen check, geen rate limiting!
}</div>

                <p style="font-size:13px; color:#e74c3c;
                           font-weight:bold; margin-top:8px;">
                    Probeer: verstuur 10x een reset voor
                    hetzelfde adres.
                </p>

                <form method="GET" action="/design/vulnerable">
                    <div class="input-group">
                        <label>E-mailadres:</label>
                        <input type="text" name="email"
                               value="{{.Email}}"
                               placeholder="slachtoffer@example.com">
                    </div>
                    <button type="submit" class="btn-submit red">
                        Reset aanvragen (kwetsbaar)
                    </button>
                </form>
            </div>
        </div>

        <!-- VEILIG -->
        <div class="card">
            <div class="card-header safe">Veilige versie</div>
            <div class="card-body">
                <p>
                    Wachtwoord reset <strong>met rate limiting
                    (max 3 pogingen)</strong> en
                    token-gebaseerde verificatie.
                </p>
                <div class="code-block">// VEILIG: rate limiting
resetAttempts[email]++
if resetAttempts[email] &gt; 3 {
    // blokkeer het verzoek
    warning = "Geblokkeerd!"
}</div>

                <p style="font-size:13px; color:#27ae60;
                           font-weight:bold; margin-top:8px;">
                    Probeer: verstuur meer dan 3x een reset.
                    Daarna wordt het geblokkeerd.
                </p>

                <form method="GET" action="/design/secure">
                    <div class="input-group">
                        <label>E-mailadres:</label>
                        <input type="text" name="email"
                               value="{{.Email}}"
                               placeholder="gebruiker@example.com">
                    </div>
                    <button type="submit" class="btn-submit green">
                        Reset aanvragen (veilig)
                    </button>
                </form>
            </div>
        </div>

    </div>

    <!-- Result box -->
    <div class="result-box">
        <h3>Resultaat: <strong>{{.Title}}</strong></h3>

        {{if eq .Title "Insecure Design (Kwetsbaar)"}}
        <span class="tag-vuln">KWETSBAAR</span>
        {{if .Message}}
        <div class="msg-success">{{.Message}}</div>
        <p style="margin-top:10px; color:#e74c3c; font-size:13px;">
            Geen limiet! Een aanvaller kan dit onbeperkt
            herhalen voor spam of user enumeration.
        </p>
        {{else}}
        <p>Voer een e-mailadres in om de kwetsbaarheid te testen.</p>
        {{end}}

        {{else}}
        <span class="tag-safe">VEILIG</span>
        {{if .Warning}}
        <div class="msg-blocked">{{.Warning}}</div>
        {{else if .Message}}
        <div class="msg-success">{{.Message}}</div>
        {{else}}
        <p>Voer een e-mailadres in. Na 3 pogingen wordt
           het geblokkeerd door rate limiting.</p>
        {{end}}
        {{if .Info}}
        <p style="margin-top:10px; color:#27ae60;
                  font-size:13px; font-weight:bold;">
            {{.Info}}
        </p>
        {{end}}
        {{end}}

        <div class="tip">
            Tip: Gebruik hetzelfde e-mailadres meerdere keren
            op de veilige versie om rate limiting te zien.
            De teller reset bij herstart van de server.
        </div>
    </div>

</div>

<!-- INFO MODAL -->
<div class="modal-overlay" id="infoModal">
    <div class="modal">
        <button type="button" class="modal-close"
                id="closeInfoBtn">X</button>

        <h2>A06:2025 - Insecure Design</h2>
        <p class="subtitle">
            OWASP Top 10:2025 - Positie #6 -
            Nieuw in 2021, uitgebreid in 2025
        </p>
        <hr>

        <div class="info-section">
            <h3>Wat is het?</h3>
            <p>
                Insecure Design focust op risicos die voortkomen
                uit ontwerpfouten in de architectuur en werkstromen.
                Anders dan implementatiefouten gaat het hier om
                fundamentele beveiligingsfouten in het ontwerp zelf.
                Beveiliging moet vanaf het begin ingebakken zijn,
                niet achteraf worden toegevoegd.
            </p>
        </div>
        <hr>

        <div class="info-section">
            <h3>Gerelateerde CWEs</h3>
            <div class="cwe-list">
                <span class="cwe-tag">CWE-73 External Control of File Name or Path</span>
                <span class="cwe-tag">CWE-183 Permissive List of Allowed Inputs</span>
                <span class="cwe-tag">CWE-209 Error Message with Sensitive Info</span>
                <span class="cwe-tag">CWE-256 Plaintext Storage of a Password</span>
                <span class="cwe-tag">CWE-257 Passwords in Recoverable Format</span>
                <span class="cwe-tag">CWE-266 Incorrect Privilege Assignment</span>
                <span class="cwe-tag">CWE-269 Improper Privilege Management</span>
                <span class="cwe-tag">CWE-280 Insufficient Permissions Handling</span>
                <span class="cwe-tag">CWE-311 Missing Encryption of Sensitive Data</span>
                <span class="cwe-tag">CWE-312 Cleartext Storage of Sensitive Info</span>
                <span class="cwe-tag">CWE-434 Unrestricted File Upload</span>
                <span class="cwe-tag">CWE-444 Inconsistent HTTP Request Interpretation</span>
                <span class="cwe-tag">CWE-451 UI Misrepresentation</span>
                <span class="cwe-tag">CWE-501 Trust Boundary Violation</span>
                <span class="cwe-tag">CWE-522 Insufficiently Protected Credentials</span>
                <span class="cwe-tag">CWE-598 GET Request with Sensitive Query Strings</span>
                <span class="cwe-tag">CWE-602 Client-Side Security Enforcement</span>
                <span class="cwe-tag">CWE-642 External Control of Critical State Data</span>
                <span class="cwe-tag">CWE-799 Improper Control of Interaction Frequency</span>
                <span class="cwe-tag">CWE-807 Reliance on Untrusted Inputs</span>
                <span class="cwe-tag">CWE-840 Business Logic Errors</span>
                <span class="cwe-tag">CWE-841 Improper Behavioral Workflow</span>
                <span class="cwe-tag">CWE-1021 Improper Restriction of Rendered UI Layers</span>
                <span class="cwe-tag">CWE-1173 Improper Use of Validation Framework</span>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de kwetsbare versie onveilig?</h3>
            <div class="vuln-box">
                De kwetsbare versie heeft
                <strong>geen rate limiting</strong> (CWE-799):
                <ul>
                    <li><strong>Onbeperkte verzoeken:</strong>
                        aanvaller kan duizenden reset-mails
                        sturen (email flooding)</li>
                    <li><strong>User enumeration:</strong>
                        testen welke adressen een reset-mail
                        ontvangen onthult geldige accounts</li>
                    <li><strong>Geen verificatie:</strong>
                        geen bewijs dat aanvrager eigenaar is</li>
                    <li><strong>Geen token expiry:</strong>
                        reset-links verlopen niet en kunnen
                        later misbruikt worden</li>
                    <li>Valt onder CWE-840: Business Logic Error
                        - ontwerp houdt geen rekening met
                        misbruikscenarios</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de veilige versie correct?</h3>
            <div class="safe-box">
                De veilige versie implementeert
                <strong>secure design principes</strong>:
                <ul>
                    <li><strong>Rate limiting:</strong>
                        maximaal 3 reset-verzoeken per adres</li>
                    <li><strong>Token-gebaseerd:</strong>
                        elke reset-link bevat een uniek token</li>
                    <li><strong>Fail-closed:</strong>
                        bij te veel pogingen wordt toegang
                        geweigerd, niet verleend</li>
                    <li><strong>Generieke responses:</strong>
                        geen aanwijzing of een adres bestaat</li>
                    <li><strong>Threat modeling:</strong>
                        ontwerp houdt rekening met misbruik</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Mitigatie</h3>
            <p>
                Gebruik threat modeling tijdens het ontwerp.
                Implementeer rate limiting, CAPTCHA en
                token-gebaseerde verificatie. Volg het principe
                van least privilege. Documenteer
                beveiligingseisen als user stories. Betrek
                security experts vroeg in het ontwerpproces.
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
