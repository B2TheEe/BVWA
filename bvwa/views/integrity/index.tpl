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
        <a href="/integrity/vulnerable">Kwetsbaar</a>
        <a href="/integrity/secure">Veilig</a>
    </nav>
</header>

<!-- BREADCRUMB -->
<div class="breadcrumb">
    <a href="/">Home</a> &rsaquo; A08 &rsaquo; {{.Title}}
</div>

<!-- MAIN -->
<div class="container">

    <div class="module-header">
        <span class="badge">A08</span>
        <h1>Software/Data Integrity Failures</h1>
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
                    Geserialiseerde sessiedata wordt
                    <strong>zonder handtekening</strong>
                    opgeslagen. Een aanvaller kan de base64
                    aanpassen om zijn rol of saldo te
                    wijzigen.
                </p>
                <div class="code-block">// KWETSBAAR: geen handtekening
encoded := base64.Encode(sessionJSON)
// aanvaller kan dit zelf aanpassen!
decoded := base64.Decode(token)
json.Unmarshal(decoded, &amp;session)
// data blind vertrouwd!</div>

                {{if .Token}}
                <div class="token-box">
                    <span class="token-label">// Gegenereerde token (aanpasbaar!):</span>
                    {{.Token}}
                </div>
                {{end}}

                <form method="POST" action="/integrity/vulnerable">
                    <div class="input-group">
                        <label>Pas de token aan en verstuur:</label>
                        <textarea name="token"
                                  placeholder="Plak hier de token en pas aan...">{{.Token}}</textarea>
                    </div>
                    <button type="submit" class="btn-submit red">
                        Verstuur token (kwetsbaar)
                    </button>
                </form>

                <p style="font-size:12px; color:#e74c3c;
                           margin-top:8px;">
                    Tip: Decodeer de base64, verander role naar
                    "admin" en balance naar 999999, encodeer terug.
                </p>
            </div>
        </div>

        <!-- VEILIG -->
        <div class="card">
            <div class="card-header safe">Veilige versie</div>
            <div class="card-body">
                <p>
                    Geserialiseerde data is beveiligd met een
                    <strong>HMAC-SHA256 handtekening</strong>.
                    Elke wijziging in de data wordt
                    gedetecteerd en geweigerd.
                </p>
                <div class="code-block">// VEILIG: HMAC-SHA256 handtekening
mac := hmac.New(sha256.New, secret)
mac.Write([]byte(encoded))
signature := base64.Encode(mac.Sum(nil))
token := encoded + "." + signature
// wijziging = andere handtekening = geweigerd!</div>

                {{if .Token}}
                <div class="token-box">
                    <span class="token-label">// Gesigneerde token (data.handtekening):</span>
                    {{.Token}}
                </div>
                {{end}}

                <form method="POST" action="/integrity/secure">
                    <div class="input-group">
                        <label>Pas de token aan en test verificatie:</label>
                        <textarea name="token"
                                  placeholder="Plak hier de token en pas aan...">{{.Token}}</textarea>
                    </div>
                    <button type="submit" class="btn-submit green">
                        Verstuur token (veilig)
                    </button>
                </form>

                <p style="font-size:12px; color:#27ae60;
                           margin-top:8px;">
                    Tip: Pas de token aan — de HMAC-verificatie
                    zal de manipulatie detecteren.
                </p>
            </div>
        </div>

    </div>

    <!-- Result box -->
    <div class="result-box">
        <h3>Resultaat: <strong>{{.Title}}</strong></h3>

        {{if eq .Title "Data Integrity (Kwetsbaar)"}}
        <span class="tag-vuln">KWETSBAAR</span>

        {{if .Username}}
        <p style="margin-bottom:10px; color:#e74c3c;">
            Data geaccepteerd zonder verificatie:
        </p>
        <table class="data-table">
            <tr><th>Veld</th><th>Waarde</th></tr>
            <tr><td>Gebruikersnaam</td><td>{{.Username}}</td></tr>
            <tr><td>Rol</td><td>{{.Role}}</td></tr>
            <tr><td>Saldo</td><td>EUR {{.Balance}}</td></tr>
        </table>
        <p style="color:#e74c3c; font-size:13px; margin-top:8px;">
            Gemanipuleerde data is geaccepteerd! Een aanvaller
            kan zijn rol naar "admin" zetten.
        </p>
        {{else if .Error}}
        <div class="msg-error">{{.Error}}</div>
        {{else}}
        <p>
            Klik op "Verstuur token" om de kwetsbare versie
            te testen. Pas de base64 data aan voor manipulatie.
        </p>
        {{end}}

        {{else}}
        <span class="tag-safe">VEILIG</span>

        {{if .Username}}
        <div class="msg-success">
            Handtekening geldig - data is niet gemanipuleerd!
        </div>
        <table class="data-table" style="margin-top:10px;">
            <tr><th>Veld</th><th>Waarde</th></tr>
            <tr><td>Gebruikersnaam</td><td>{{.Username}}</td></tr>
            <tr><td>Rol</td><td>{{.Role}}</td></tr>
            <tr><td>Saldo</td><td>EUR {{.Balance}}</td></tr>
        </table>
        {{else if .Error}}
        <div class="msg-error">{{.Error}}</div>
        <p style="color:#e74c3c; font-size:13px; margin-top:8px;">
            Gemanipuleerde data gedetecteerd en geweigerd!
            De HMAC-handtekening klopt niet meer.
        </p>
        {{else}}
        <p>
            Klik op "Verstuur token" om de veilige versie
            te testen. Pas de token aan om manipulatie
            te simuleren.
        </p>
        {{end}}
        {{end}}

        <div class="tip">
            Tip: Kopieer de token van de GET-pagina, pas de
            base64 data aan (verander role of balance), en
            verstuur opnieuw. Vergelijk het gedrag van beide
            versies.
        </div>
    </div>

</div>

<!-- ECHTE VOORBEELDEN MODAL -->
<div class="modal-overlay" id="examplesModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeExamplesBtn">X</button>

        <h2>Echte Voorbeelden — Data Integrity Failures</h2>
        <p class="subtitle">
            Historische incidenten waarbij manipulatie van data of software onopgemerkt bleef
        </p>
        <hr>

        <div class="example-item">
            <h4>
                <span class="example-year">2020</span>
                SolarWinds SUNBURST — Gesigneerde Backdoor
            </h4>
            <p>
                De SUNBURST-backdoor werd digitaal ondertekend met een geldig SolarWinds-
                certificaat. Er waren geen runtime-integriteitscontroles op het uitgevoerde
                binaire bestand. Beveiligingstools vertrouwden de handtekening en lieten de
                backdoor passeren. Negen maanden lang bleef de aanval volledig onopgemerkt.
            </p>
            <p class="example-impact">Impact: 18.000+ organisaties gecompromitteerd; 9 maanden onopgemerkt actief</p>
        </div>

        <div class="example-item">
            <h4>
                <span class="example-year">2019</span>
                ASUS Live Update — Operation ShadowHammer
            </h4>
            <p>
                Aanvallers compromitteerden de ASUS-updateserver en signeerden backdoored
                firmware-updates met een legitiem ASUS-certificaat. De updates werden via
                het officiële ASUS Live Update-kanaal verspreid. De backdoor zocht naar
                specifieke MAC-adressen van doelwitten.
            </p>
            <p class="example-impact">Impact: 500.000&ndash;1 miljoen apparaten ge&iuml;nfecteerd; backdoor aanwezig op Kaspersky-servers</p>
        </div>

        <div class="example-item">
            <h4>
                <span class="example-year">2021</span>
                PHP Git Repository Compromise
            </h4>
            <p>
                Aanvallers compromitteerden de php.net git-server en pushten twee commits
                die een backdoor in de PHP-broncode zouden toevoegen. De commits leken op
                normale bugfixes. Omdat commits niet cryptografisch werden gesigneerd,
                was manipulatie aanvankelijk niet zichtbaar.
            </p>
            <p class="example-impact">Impact: Potentieel alle PHP-servers wereldwijd kwetsbaar; op tijd ontdekt</p>
        </div>

        <div class="example-item">
            <h4>
                <span class="example-year">2022</span>
                PyPI Kwaadaardige Packages
            </h4>
            <p>
                Duizenden kwaadaardige PyPI-packages met typosquatted namen (bijv.
                "requets" i.p.v. "requests") bevatten datadiefstalcode. Bij installatie
                stuurden ze credentials en environment variables naar externe servers.
                PyPI heeft geen verplichte integriteitsverificatie bij download.
            </p>
            <p class="example-impact">Impact: Tienduizenden installaties van malafide packages &mdash; aanhoudend probleem</p>
        </div>

    </div>
</div>

<!-- INFO MODAL -->
<div class="modal-overlay" id="infoModal">
    <div class="modal">
        <button type="button" class="modal-close"
                id="closeInfoBtn">X</button>

        <h2>A08:2025 - Software/Data Integrity Failures</h2>
        <p class="subtitle">
            OWASP Top 10:2025 - Positie #8 -
            Omvat insecure deserialization en CI/CD integriteitsfouten
        </p>
        <hr>

        <div class="info-section">
            <h3>Wat is het?</h3>
            <p>
                Software and Data Integrity Failures gaan over
                aannames over software-updates, kritieke data
                en CI/CD-pipelines zonder hun integriteit te
                verifiëren. Het omvat situaties waarbij code
                of data van onbetrouwbare bronnen wordt
                verwerkt zonder te controleren of het
                gemanipuleerd is. Dit kan leiden tot remote
                code execution, privilege escalation of
                datavervalsing.
            </p>
        </div>
        <hr>

        <div class="info-section">
            <h3>Gerelateerde CWEs</h3>
            <div class="cwe-list">
                <span class="cwe-tag">CWE-345 Insufficient Verification of Data Authenticity</span>
                <span class="cwe-tag">CWE-346 Origin Validation Error</span>
                <span class="cwe-tag">CWE-347 Improper Verification of Cryptographic Signature</span>
                <span class="cwe-tag">CWE-353 Missing Support for Integrity Check</span>
                <span class="cwe-tag">CWE-354 Improper Validation of Integrity Check Value</span>
                <span class="cwe-tag">CWE-426 Untrusted Search Path</span>
                <span class="cwe-tag">CWE-494 Download of Code Without Integrity Check</span>
                <span class="cwe-tag">CWE-502 Deserialization of Untrusted Data</span>
                <span class="cwe-tag">CWE-565 Reliance on Cookies Without Validation</span>
                <span class="cwe-tag">CWE-784 Reliance on Cookies Without Validation and Integrity</span>
                <span class="cwe-tag">CWE-829 Inclusion from Untrusted Control Sphere</span>
                <span class="cwe-tag">CWE-830 Inclusion of Web Functionality from Untrusted Source</span>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de kwetsbare versie onveilig?</h3>
            <div class="vuln-box">
                De kwetsbare versie accepteert geserialiseerde
                data <strong>zonder integriteitscontrole</strong>
                (CWE-502):
                <ul>
                    <li><strong>Blind vertrouwen:</strong>
                        base64-encoded JSON wordt direct
                        gedeserialiseerd zonder verificatie</li>
                    <li><strong>Privilege escalation:</strong>
                        aanvaller wijzigt role van "user"
                        naar "admin" in de base64 data</li>
                    <li><strong>Financiele fraude:</strong>
                        aanvaller verhoogt balance van 100
                        naar 999999 (CWE-345)</li>
                    <li><strong>Eenvoudig te exploiteren:</strong>
                        base64 is geen encryptie - gewoon
                        decoderen, aanpassen, encoderen</li>
                    <li><strong>Geen detectie:</strong>
                        manipulatie is onzichtbaar voor
                        de server</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de veilige versie correct?</h3>
            <div class="safe-box">
                De veilige versie gebruikt
                <strong>HMAC-SHA256 handtekeningen</strong>
                (CWE-345 fix):
                <ul>
                    <li><strong>Cryptografische binding:</strong>
                        de handtekening is mathematisch
                        gekoppeld aan de exacte data-inhoud</li>
                    <li><strong>Elke wijziging detecteerbaar:</strong>
                        ook 1 bit verschil geeft een
                        compleet andere handtekening</li>
                    <li><strong>Geheime sleutel:</strong>
                        zonder de server-side sleutel kan
                        een aanvaller geen geldige
                        handtekening maken</li>
                    <li><strong>Timing-safe vergelijking:</strong>
                        hmac.Equal() voorkomt timing attacks</li>
                    <li><strong>Fail-closed:</strong>
                        ongeldige handtekening = verzoek
                        geweigerd, geen data verwerkt</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Mitigatie</h3>
            <p>
                Vertrouw nooit geserialiseerde data van
                clients zonder integriteitsverificatie.
                Gebruik digitale handtekeningen (HMAC, JWT
                met RS256) voor alle client-side data.
                Implementeer integriteitscontroles in
                CI/CD-pipelines. Gebruik signed packages
                en verify checksums bij downloads. Overweeg
                server-side sessies in plaats van
                client-side tokens voor gevoelige data.
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
