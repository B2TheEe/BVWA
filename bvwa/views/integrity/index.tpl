<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{.Title}} - BVWA</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #f0f2f5; }

        header {
            background: #2c3e50;
            color: white;
            padding: 16px 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        header .logo {
            font-size: 22px;
            font-weight: bold;
            text-decoration: none;
            color: white;
        }
        header .logo span { color: #e67e22; }
        header nav a {
            color: #ecf0f1;
            text-decoration: none;
            margin-left: 20px;
            font-size: 14px;
        }
        header nav a:hover { color: #e67e22; }

        .breadcrumb {
            background: #34495e;
            padding: 8px 30px;
            font-size: 13px;
            color: #bdc3c7;
        }
        .breadcrumb a { color: #e67e22; text-decoration: none; }
        .breadcrumb a:hover { text-decoration: underline; }

        .container {
            max-width: 960px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .module-header {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 20px;
        }
        .badge {
            background: #e67e22;
            color: white;
            font-weight: bold;
            font-size: 13px;
            padding: 6px 14px;
            border-radius: 20px;
            white-space: nowrap;
        }
        .module-header h1 { font-size: 24px; color: #2c3e50; }
        .btn-info {
            margin-left: auto;
            background: #3498db;
            color: white;
            border: none;
            padding: 9px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            white-space: nowrap;
        }
        .btn-info:hover { background: #2980b9; }

        .cards {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        @media (max-width: 640px) {
            .cards { grid-template-columns: 1fr; }
        }

        .card {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .card-header {
            padding: 14px 20px;
            font-weight: bold;
            font-size: 15px;
            color: white;
        }
        .card-header.vuln { background: #e74c3c; }
        .card-header.safe { background: #27ae60; }
        .card-body { padding: 20px; }
        .card-body p {
            font-size: 14px;
            color: #555;
            line-height: 1.6;
            margin-bottom: 14px;
        }

        .code-block {
            background: #1e1e1e;
            color: #d4d4d4;
            font-family: monospace;
            font-size: 12px;
            padding: 14px;
            border-radius: 6px;
            overflow-x: auto;
            margin: 10px 0;
            line-height: 1.8;
            white-space: pre;
        }

        .token-box {
            background: #1e1e1e;
            color: #ce9178;
            font-family: monospace;
            font-size: 11px;
            padding: 10px 14px;
            border-radius: 6px;
            margin: 10px 0;
            word-break: break-all;
            line-height: 1.7;
        }
        .token-label {
            color: #6a9955;
            display: block;
            margin-bottom: 4px;
            font-size: 11px;
        }

        .input-group { margin-bottom: 14px; }
        .input-group label {
            display: block;
            font-size: 13px;
            font-weight: bold;
            color: #555;
            margin-bottom: 6px;
        }
        .input-group textarea {
            width: 100%;
            padding: 9px 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 12px;
            font-family: monospace;
            height: 70px;
            resize: vertical;
        }
        .input-group textarea:focus {
            outline: none;
            border-color: #3498db;
        }

        .btn-submit {
            display: block;
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: bold;
            color: white;
            cursor: pointer;
            margin-top: 10px;
        }
        .btn-submit.red   { background: #e74c3c; }
        .btn-submit.red:hover   { background: #c0392b; }
        .btn-submit.green { background: #27ae60; }
        .btn-submit.green:hover { background: #1e8449; }

        .result-box {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-top: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .result-box h3 { margin-bottom: 12px; color: #2c3e50; }

        .tag-vuln {
            display: inline-block;
            background: #fdecea;
            color: #e74c3c;
            font-weight: bold;
            font-size: 12px;
            padding: 3px 10px;
            border-radius: 20px;
            margin-bottom: 10px;
        }
        .tag-safe {
            display: inline-block;
            background: #eafaf1;
            color: #27ae60;
            font-weight: bold;
            font-size: 12px;
            padding: 3px 10px;
            border-radius: 20px;
            margin-bottom: 10px;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
            margin: 10px 0;
        }
        .data-table th {
            background: #ecf0f1;
            padding: 8px 12px;
            text-align: left;
            color: #555;
            font-weight: bold;
        }
        .data-table td {
            padding: 8px 12px;
            border-bottom: 1px solid #f0f0f0;
        }

        .msg-success {
            background: #eafaf1;
            border: 1px solid #27ae60;
            border-radius: 6px;
            padding: 12px 16px;
            font-size: 14px;
            color: #1e8449;
            margin-top: 10px;
        }
        .msg-error {
            background: #fdecea;
            border: 1px solid #e74c3c;
            border-radius: 6px;
            padding: 12px 16px;
            font-size: 14px;
            color: #c0392b;
            margin-top: 10px;
            font-weight: bold;
        }
        .tip {
            background: #eaf4fb;
            border: 1px solid #aed6f1;
            border-radius: 6px;
            padding: 12px 16px;
            font-size: 13px;
            color: #2471a3;
            margin-top: 12px;
        }

        .modal-overlay {
            display: none;
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.55);
            z-index: 9999;
            overflow-y: auto;
            padding: 40px 20px;
        }
        .modal {
            background: white;
            border-radius: 10px;
            max-width: 720px;
            width: 100%;
            margin: 0 auto;
            padding: 30px;
            position: relative;
            box-shadow: 0 8px 40px rgba(0,0,0,0.3);
        }
        .modal-close {
            position: absolute;
            top: 14px; right: 18px;
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: #666;
            line-height: 1;
        }
        .modal-close:hover { color: #e74c3c; }
        .modal h2 {
            color: #2c3e50;
            margin-bottom: 6px;
            font-size: 20px;
            padding-right: 30px;
        }
        .modal .subtitle {
            color: #7f8c8d;
            font-size: 13px;
            margin-bottom: 20px;
        }
        .modal hr {
            border: none;
            border-top: 1px solid #ecf0f1;
            margin: 16px 0;
        }
        .cwe-list {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin: 10px 0 16px;
        }
        .cwe-tag {
            background: #eaf4fb;
            border: 1px solid #aed6f1;
            color: #2471a3;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }
        .info-section { margin-bottom: 16px; }
        .info-section h3 {
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #7f8c8d;
            margin-bottom: 8px;
        }
        .info-section p {
            font-size: 14px;
            line-height: 1.7;
            color: #444;
        }
        .vuln-box {
            background: #fdf2f2;
            border-left: 4px solid #e74c3c;
            padding: 12px 16px;
            border-radius: 0 6px 6px 0;
            font-size: 14px;
            line-height: 1.7;
            color: #444;
        }
        .safe-box {
            background: #f2fdf5;
            border-left: 4px solid #2ecc71;
            padding: 12px 16px;
            border-radius: 0 6px 6px 0;
            font-size: 14px;
            line-height: 1.7;
            color: #444;
        }
        .vuln-box ul, .safe-box ul { margin: 8px 0 0 20px; }
        .vuln-box li, .safe-box li { margin-bottom: 5px; }

        footer {
            text-align: center;
            padding: 20px;
            color: #aaa;
            font-size: 12px;
            margin-top: 40px;
        }
    </style>
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
