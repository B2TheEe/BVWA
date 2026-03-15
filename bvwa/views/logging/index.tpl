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

        .input-group { margin-bottom: 14px; }
        .input-group label {
            display: block;
            font-size: 13px;
            font-weight: bold;
            color: #555;
            margin-bottom: 6px;
        }
        .input-group input {
            width: 100%;
            padding: 9px 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 13px;
        }
        .input-group input:focus {
            outline: none;
            border-color: #3498db;
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

        .credentials-hint {
            background: #f8f9fa;
            border-radius: 6px;
            padding: 10px 14px;
            font-size: 12px;
            color: #666;
            margin-top: 10px;
        }

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
        }

        /* Log terminal */
        .log-terminal {
            background: #0d0d0d;
            border-radius: 8px;
            padding: 16px;
            margin-top: 14px;
            min-height: 120px;
            max-height: 280px;
            overflow-y: auto;
            font-family: monospace;
            font-size: 12px;
            line-height: 1.7;
        }
        .log-entry { margin-bottom: 2px; }
        .log-info    { color: #4fc3f7; }
        .log-warning { color: #ffcc02; }
        .log-critical { color: #ff5252; font-weight: bold; }
        .log-alert   { color: #ff9800; font-weight: bold; }
        .log-empty   { color: #555; font-style: italic; }

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
</head>
<body>

<!-- HEADER -->
<header>
    <a href="/" class="logo">&#x1F510; <span>BVWA</span></a>
    <nav>
        <a href="/">&#x1F3E0; Home</a>
        <a href="/logging/vulnerable">Kwetsbaar</a>
        <a href="/logging/secure">Veilig</a>
    </nav>
</header>

<!-- BREADCRUMB -->
<div class="breadcrumb">
    <a href="/">Home</a> &rsaquo; A09 &rsaquo; {{.Title}}
</div>

<!-- MAIN -->
<div class="container">

    <div class="module-header">
        <span class="badge">A09</span>
        <h1>Security Logging &amp; Alerting Failures</h1>
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
                    Login <strong>zonder logging</strong>
                    van beveiligingsgebeurtenissen. Mislukte
                    pogingen worden niet bijgehouden —
                    brute force is ondetecteerbaar.
                </p>
                <div class="code-block">// KWETSBAAR: geen logging
if username == "admin" &amp;&amp; password == pass {
    // ingelogd - NIET gelogd!
} else {
    // mislukt - NIET gelogd!
    // aanvaller kan onbeperkt proberen
}</div>

                <p style="font-size:13px; color:#e74c3c;
                           font-weight:bold; margin-top:8px;">
                    Probeer: 5x inloggen met fout wachtwoord.
                    Niets wordt gelogd!
                </p>

                <form method="POST" action="/logging/vulnerable">
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
                    <button type="submit" class="btn-submit red">
                        Inloggen (kwetsbaar)
                    </button>
                </form>

                <div class="credentials-hint">
                    admin / password123 &nbsp;|&nbsp; fout / wachtwoord
                </div>
            </div>
        </div>

        <!-- VEILIG -->
        <div class="card">
            <div class="card-header safe">Veilige versie</div>
            <div class="card-body">
                <p>
                    Login <strong>met volledige security
                    logging</strong>. Elke poging wordt
                    gelogd. Na 3 mislukte pogingen wordt
                    een CRITICAL alert gegenereerd.
                </p>
                <div class="code-block">// VEILIG: uitgebreide logging
logSecurityEvent("INFO",
    "Succesvolle login", ip, username)
// of bij mislukking:
logSecurityEvent("WARNING",
    "Mislukte login", ip, username)
// bij herhaalde pogingen:
logSecurityEvent("CRITICAL",
    "Mogelijke brute force", ip, user)</div>

                <p style="font-size:13px; color:#27ae60;
                           font-weight:bold; margin-top:8px;">
                    Probeer: 3x inloggen met fout wachtwoord.
                    Zie de CRITICAL alert verschijnen!
                </p>

                <form method="POST" action="/logging/secure">
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
                    <button type="submit" class="btn-submit green">
                        Inloggen (veilig)
                    </button>
                </form>

                <div class="credentials-hint">
                    admin / password123 &nbsp;|&nbsp; fout / wachtwoord
                </div>
            </div>
        </div>

    </div>

    <!-- Result box -->
    <div class="result-box">
        <h3>Resultaat: <strong>{{.Title}}</strong></h3>

        {{if eq .Title "Logging & Alerting (Kwetsbaar)"}}
        <span class="tag-vuln">KWETSBAAR</span>

        {{if .Success}}
        <div class="msg-success">{{.Success}}</div>
        {{else if .Error}}
        <div class="msg-error">{{.Error}}</div>
        {{else}}
        <p>Voer credentials in om te testen.
           Niets wordt gelogd!</p>
        {{end}}

        <div class="log-terminal">
            <div class="log-entry log-empty">
                (geen logs beschikbaar - kwetsbare versie
                logt niets)
            </div>
        </div>
        <p style="color:#e74c3c; font-size:13px; margin-top:8px;">
            Een aanvaller kan onbeperkt brute forcen zonder
            dat er iemand een alert ontvangt.
        </p>

        {{else}}
        <span class="tag-safe">VEILIG</span>

        {{if .Success}}
        <div class="msg-success">{{.Success}}</div>
        {{else if .Error}}
        <div class="msg-error">{{.Error}}</div>
        {{else}}
        <p>Voer credentials in. Alle pogingen worden
           gelogd. Na 3 mislukte pogingen: CRITICAL alert!</p>
        {{end}}

        <div class="log-terminal">
            {{if .Logs}}
            {{range .Logs}}
            <div class="log-entry
                {{if contains . "CRITICAL"}}log-critical
                {{else if contains . "WARNING"}}log-warning
                {{else if contains . "ALERT"}}log-alert
                {{else}}log-info{{end}}">
                {{.}}
            </div>
            {{end}}
            {{else}}
            <div class="log-entry log-empty">
                (nog geen logs - voer een loginpoging in)
            </div>
            {{end}}
        </div>
        {{end}}

        <div class="tip">
            Tip: Probeer 3x in te loggen met een fout
            wachtwoord op de veilige versie om de CRITICAL
            alert te triggeren. Bekijk security.log voor
            de volledige loggeschiedenis.
        </div>
    </div>

</div>

<!-- INFO MODAL -->
<div class="modal-overlay" id="infoModal">
    <div class="modal">
        <button type="button" class="modal-close"
                id="closeInfoBtn">X</button>

        <h2>A09:2025 - Security Logging &amp; Alerting Failures</h2>
        <p class="subtitle">
            OWASP Top 10:2025 - Positie #9 -
            Lichte naamswijziging om alerting te benadrukken
        </p>
        <hr>

        <div class="info-section">
            <h3>Wat is het?</h3>
            <p>
                Security Logging and Alerting Failures treden
                op wanneer applicaties beveiligingsgebeurtenissen
                niet correct registreren of er geen alerts
                worden gegenereerd bij verdachte activiteit.
                Hierdoor blijven aanvallen onopgemerkt, kan
                een incident niet worden gereconstrueerd en
                missen security teams de signalen om tijdig
                in te grijpen.
            </p>
        </div>
        <hr>

        <div class="info-section">
            <h3>Gerelateerde CWEs</h3>
            <div class="cwe-list">
                <span class="cwe-tag">CWE-117 Improper Output Neutralization for Logs</span>
                <span class="cwe-tag">CWE-223 Omission of Security-relevant Information</span>
                <span class="cwe-tag">CWE-532 Insertion of Sensitive Info into Log File</span>
                <span class="cwe-tag">CWE-778 Insufficient Logging</span>
                <span class="cwe-tag">CWE-779 Logging of Excessive Data</span>
                <span class="cwe-tag">CWE-1263 Insufficient Visual Distinction of Homoglyphs</span>
                <span class="cwe-tag">CWE-1295 Debug Messages Revealing Unnecessary Information</span>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de kwetsbare versie onveilig?</h3>
            <div class="vuln-box">
                De kwetsbare versie heeft
                <strong>geen security logging</strong>
                (CWE-778):
                <ul>
                    <li><strong>Geen audit trail:</strong>
                        bij een incident is niet te
                        reconstrueren wat er is gebeurd</li>
                    <li><strong>Brute force ondetecteerbaar:</strong>
                        een aanvaller kan duizenden
                        wachtwoorden proberen zonder alarm</li>
                    <li><strong>Geen alerting:</strong>
                        security teams ontvangen geen
                        notificatie bij verdachte activiteit</li>
                    <li><strong>Compliance probleem:</strong>
                        GDPR, ISO27001 en PCI-DSS vereisen
                        logging van beveiligingsgebeurtenissen</li>
                    <li><strong>Late detectie:</strong>
                        aanvallen worden gemiddeld pas na
                        207 dagen ontdekt zonder logging</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de veilige versie correct?</h3>
            <div class="safe-box">
                De veilige versie implementeert
                <strong>uitgebreide security logging</strong>:
                <ul>
                    <li><strong>Alle events gelogd:</strong>
                        succesvolle en mislukte logins
                        worden beide geregistreerd</li>
                    <li><strong>Gestructureerde logs:</strong>
                        timestamp, level, event, IP en
                        gebruiker in elk log-entry</li>
                    <li><strong>Alerting (CWE-223 fix):</strong>
                        CRITICAL alert na 3 mislukte pogingen
                        — mogelijke brute force aanval</li>
                    <li><strong>Persistent logging:</strong>
                        logs worden naar security.log
                        geschreven voor audit trail</li>
                    <li><strong>Log levels:</strong> INFO,
                        WARNING, CRITICAL voor prioritering
                        door security teams</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Mitigatie</h3>
            <p>
                Log alle authenticatiepogingen, autorisatiefouten
                en invoervalidatiefouten. Gebruik gestructureerde
                logging met tijdstempel, IP, gebruiker en
                actie. Implementeer alerting bij verdachte
                patronen. Stuur logs naar een centrale SIEM.
                Bewaar logs minimaal 90 dagen. Log nooit
                gevoelige data zoals wachtwoorden (CWE-532).
                Gebruik log management tools zoals ELK of
                Splunk.
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
