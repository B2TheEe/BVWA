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

<!-- ECHTE VOORBEELDEN MODAL -->
<div class="modal-overlay" id="examplesModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeExamplesBtn">X</button>

        <h2>Echte Voorbeelden — Logging &amp; Alerting Failures</h2>
        <p class="subtitle">
            Historische incidenten waarbij ontbrekende logging aanvallen onzichtbaar maakte
        </p>
        <hr>

        <div class="example-item">
            <h4>
                <span class="example-year">2017</span>
                Equifax &mdash; 76 Dagen Onopgemerkt
            </h4>
            <p>
                Aanvallers exploiteerden een Apache Struts-kwetsbaarheid. Een verlopen
                SSL-inspectiecertificaat (19 maanden verlopen) zorgde ervoor dat beveiligingstools
                versleuteld verkeer niet konden analyseren. Hierdoor bleven 700 zoekopdrachten
                door de database volledig onopgemerkt gedurende 76 dagen.
            </p>
            <p class="example-impact">Impact: 147 miljoen SSN's en geboortedata gelekt &mdash; boete van $575 miljoen</p>
        </div>

        <div class="example-item">
            <h4>
                <span class="example-year">2013</span>
                Target &mdash; Genegeerde FireEye Alerts
            </h4>
            <p>
                FireEye's beveiligingssysteem detecteerde de Citadel-malware en stuurde
                automatische alerts naar Target's beveiligingsteam in Bangalore. Het team
                beoordeelde de alerts als vals-positief en schakelde de automatische
                reactiefunctie bewust uit. 40 miljoen betaalkaarten werden gestolen.
            </p>
            <p class="example-impact">Impact: 40 miljoen betaalkaarten + 70 miljoen klantrecords &mdash; $162 miljoen schade</p>
        </div>

        <div class="example-item">
            <h4>
                <span class="example-year">2014</span>
                Yahoo &mdash; 2 Jaar Onopgemerkt
            </h4>
            <p>
                Aanvallers hadden 2&ndash;3 jaar onbeperkte toegang tot Yahoo's systemen
                voordat de breuk werd ontdekt. De breuk van 2013&ndash;2014 betrof 3 miljard
                accounts maar werd pas in 2016 ontdekt &mdash; via een externe melding,
                niet door Yahoo's eigen monitoring.
            </p>
            <p class="example-impact">Impact: 3 miljard accounts &mdash; grootste datalek ooit; Yahoo-verkoop $350M goedkoper</p>
        </div>

        <div class="example-item">
            <h4>
                <span class="example-year">2019</span>
                Capital One &mdash; 700 Queries Zonder Alert
            </h4>
            <p>
                De aanvaller voerde meer dan 700 opeenvolgende AWS S3 ListBucket-commando's
                uit over meerdere dagen zonder &eacute;&eacute;n alert te triggeren. Er was
                wel een WAF aanwezig, maar die genereerde geen alerting op ongebruikelijke
                toegangspatronen. De breuk werd uiteindelijk gemeld via een GitHub-vondst.
            </p>
            <p class="example-impact">Impact: 106 miljoen records gestolen &mdash; boete van $80 miljoen</p>
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
