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
        <a href="/exceptions/vulnerable">Kwetsbaar</a>
        <a href="/exceptions/secure">Veilig</a>
    </nav>
</header>

<!-- BREADCRUMB -->
<div class="breadcrumb">
    <a href="/">Home</a> &rsaquo; A10 &rsaquo; {{.Title}}
</div>

<!-- MAIN -->
<div class="container">

    <div class="module-header">
        <span class="badge">A10</span>
        <h1>Mishandling of Exceptional Conditions</h1>
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
                    Fouten worden <strong>genegeerd of lekken
                    interne details</strong>. Ongeldige input
                    wordt stilletjes gecorrigeerd
                    (fail-open gedrag).
                </p>
                <div class="code-block">// KWETSBAAR: fouten genegeerd
id, _ := strconv.Atoi(idStr)
// fout genegeerd met _!
if id &lt; 0 {
    id = 1 // stille correctie
}</div>

                <div class="scenarios">
                    <strong>Test scenarios:</strong>
                    <div class="scenario-item">
                        <button class="scenario-btn"
                                onclick="setVuln('abc')">abc</button>
                        <span class="scenario-desc">Ongeldige tekst</span>
                    </div>
                    <div class="scenario-item">
                        <button class="scenario-btn"
                                onclick="setVuln('-1')">-1</button>
                        <span class="scenario-desc">Negatief ID (fail-open)</span>
                    </div>
                    <div class="scenario-item">
                        <button class="scenario-btn"
                                onclick="setVuln('999')">999</button>
                        <span class="scenario-desc">Niet bestaand ID</span>
                    </div>
                    <div class="scenario-item">
                        <button class="scenario-btn"
                                onclick="setVuln('1')">1</button>
                        <span class="scenario-desc">Geldig ID</span>
                    </div>
                </div>

                <form method="GET" action="/exceptions/vulnerable"
                      id="vulnForm">
                    <div class="input-group">
                        <label>Product ID:</label>
                        <input type="text" name="id"
                               id="vulnInput"
                               placeholder="1, 2, 3, abc, -1, 999">
                    </div>
                    <button type="submit" class="btn-submit red">
                        Zoeken (kwetsbaar)
                    </button>
                </form>
            </div>
        </div>

        <!-- VEILIG -->
        <div class="card">
            <div class="card-header safe">Veilige versie</div>
            <div class="card-body">
                <p>
                    Elke fout wordt <strong>correct
                    afgehandeld</strong> met generieke meldingen.
                    Geen interne details gelekt.
                    Fail-closed principe.
                </p>
                <div class="code-block">// VEILIG: correcte foutafhandeling
id, err := strconv.Atoi(idStr)
if err != nil {
    // 400 Bad Request + generieke melding
    return ErrInvalidInput
}
// fail-closed: bij twijfel weigeren</div>

                <div class="scenarios">
                    <strong>Test scenarios:</strong>
                    <div class="scenario-item">
                        <button class="scenario-btn"
                                onclick="setSecure('abc')">abc</button>
                        <span class="scenario-desc">400 Bad Request</span>
                    </div>
                    <div class="scenario-item">
                        <button class="scenario-btn"
                                onclick="setSecure('-1')">-1</button>
                        <span class="scenario-desc">400 - negatief geweigerd</span>
                    </div>
                    <div class="scenario-item">
                        <button class="scenario-btn"
                                onclick="setSecure('999')">999</button>
                        <span class="scenario-desc">404 Not Found</span>
                    </div>
                    <div class="scenario-item">
                        <button class="scenario-btn"
                                onclick="setSecure('1')">1</button>
                        <span class="scenario-desc">200 OK - geldig</span>
                    </div>
                </div>

                <form method="GET" action="/exceptions/secure"
                      id="secureForm">
                    <div class="input-group">
                        <label>Product ID:</label>
                        <input type="text" name="id"
                               id="secureInput"
                               placeholder="1, 2, 3, abc, -1, 999">
                    </div>
                    <button type="submit" class="btn-submit green">
                        Zoeken (veilig)
                    </button>
                </form>
            </div>
        </div>

    </div>

    <!-- Result box -->
    <div class="result-box">
        <h3>Resultaat: <strong>{{.Title}}</strong></h3>

        {{if eq .Title "Exception Handling (Kwetsbaar)"}}
        <span class="tag-vuln">KWETSBAAR</span>

        {{if .Product}}
        <div class="msg-success">
            Product gevonden: <strong>{{.Product}}</strong>
        </div>
        {{end}}

        {{if .Error}}
        <div class="msg-error">{{.Error}}</div>
        <p style="color:#e74c3c; font-size:13px; margin-top:6px;">
            Interne databasedetails zichtbaar voor aanvaller!
        </p>
        {{end}}

        {{if .Warning}}
        <div style="background:#fff3cd; border:1px solid #ffc107;
                    border-radius:6px; padding:12px 16px;
                    font-size:14px; color:#856404; margin-top:10px;">
            <strong>Fail-open gedetecteerd:</strong>
            {{.Warning}}
        </div>
        {{end}}

        {{if .ShowHint}}
        <p style="margin-top:10px;">
            Voer een product ID in om de kwetsbaarheid te testen.
        </p>
        <p style="font-size:12px; color:#888; margin-top:6px;">
            Producten: 1=Laptop, 2=Telefoon, 3=Tablet
        </p>
        {{end}}

        {{else}}
        <span class="tag-safe">VEILIG</span>

        {{if .Product}}
        <div class="msg-success">
            Product gevonden: <strong>{{.Product}}</strong>
        </div>
        {{end}}

        {{if .Error}}
        <div class="msg-safe-error">{{.Error}}</div>
        <p style="color:#27ae60; font-size:13px; margin-top:6px;">
            Generieke melding - geen interne details gelekt.
        </p>
        {{end}}

        {{if .ShowHint}}
        <p style="margin-top:10px;">
            Voer een product ID in om correcte foutafhandeling
            te testen.
        </p>
        <p style="font-size:12px; color:#888; margin-top:6px;">
            Producten: 1=Laptop, 2=Telefoon, 3=Tablet
        </p>
        {{end}}

        {{end}}

        <div class="tip">
            Tip: Vergelijk het gedrag van beide versies met
            input: abc (tekst), -1 (negatief), 999 (niet gevonden)
            en 1 (geldig). Let op de foutmeldingen.
        </div>
    </div>

</div>

<!-- INFO MODAL -->
<div class="modal-overlay" id="infoModal">
    <div class="modal">
        <button type="button" class="modal-close"
                id="closeInfoBtn">X</button>

        <h2>A10:2025 - Mishandling of Exceptional Conditions</h2>
        <p class="subtitle">
            OWASP Top 10:2025 - Positie #10 -
            Omvat 24 CWEs rond onjuiste foutafhandeling
        </p>
        <hr>

        <div class="info-section">
            <h3>Wat is het?</h3>
            <p>
                Mishandling of Exceptional Conditions omvat
                beveiligingszwakheden die ontstaan door onjuiste
                foutafhandeling, logicafouten en fail-open gedrag.
                Een applicatie is kwetsbaar als fouten worden
                genegeerd, interne details lekken via
                foutmeldingen, of het systeem bij een fout
                toegang verleent in plaats van weigert.
            </p>
        </div>
        <hr>

        <div class="info-section">
            <h3>Gerelateerde CWEs</h3>
            <div class="cwe-list">
                <span class="cwe-tag">CWE-390 Detection of Error Condition Without Action</span>
                <span class="cwe-tag">CWE-391 Unchecked Error Condition</span>
                <span class="cwe-tag">CWE-392 Missing Report of Error Condition</span>
                <span class="cwe-tag">CWE-393 Return of Wrong Status Code</span>
                <span class="cwe-tag">CWE-394 Unexpected Status Code or Return Value</span>
                <span class="cwe-tag">CWE-395 Use of NullPointerException Catch to Detect Null</span>
                <span class="cwe-tag">CWE-396 Declaration of Catch for Generic Exception</span>
                <span class="cwe-tag">CWE-397 Declaration of Throws for Generic Exception</span>
                <span class="cwe-tag">CWE-544 Missing Standardized Error Handling Mechanism</span>
                <span class="cwe-tag">CWE-617 Reachable Assertion</span>
                <span class="cwe-tag">CWE-636 Not Failing Securely (Fail Open)</span>
                <span class="cwe-tag">CWE-639 Authorization Bypass Through User-Controlled Key</span>
                <span class="cwe-tag">CWE-691 Insufficient Control Flow Management</span>
                <span class="cwe-tag">CWE-696 Incorrect Behavior Order</span>
                <span class="cwe-tag">CWE-698 Execution After Redirect (EAR)</span>
                <span class="cwe-tag">CWE-703 Improper Check of Exceptional Conditions</span>
                <span class="cwe-tag">CWE-754 Improper Check for Unusual Conditions</span>
                <span class="cwe-tag">CWE-755 Improper Handling of Exceptional Conditions</span>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de kwetsbare versie onveilig?</h3>
            <div class="vuln-box">
                De kwetsbare versie heeft meerdere fouten:
                <ul>
                    <li><strong>Fouten genegeerd (CWE-391):</strong>
                        id, _ := strconv.Atoi() - de fout
                        wordt weggegooid met _</li>
                    <li><strong>Fail-open (CWE-636):</strong>
                        negatief ID wordt stilletjes naar 1
                        gecorrigeerd - aanvaller krijgt altijd
                        een resultaat</li>
                    <li><strong>Info-lekkage:</strong>
                        interne database-details, tabelnamen
                        en queries zichtbaar in foutmelding</li>
                    <li><strong>Verkeerde HTTP status:</strong>
                        altijd 200 OK, ook bij fouten</li>
                    <li><strong>Geen logging:</strong>
                        fouten worden niet intern gelogd</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de veilige versie correct?</h3>
            <div class="safe-box">
                De veilige versie past het
                <strong>fail-closed principe</strong> toe:
                <ul>
                    <li><strong>Fouten altijd afgehandeld
                        (CWE-391 fix):</strong>
                        elke error wordt gecontroleerd - geen
                        _ negatie</li>
                    <li><strong>Fail-closed (CWE-636 fix):</strong>
                        bij ongeldige input wordt toegang
                        geweigerd</li>
                    <li><strong>Generieke foutmeldingen:</strong>
                        geen interne details of paden zichtbaar</li>
                    <li><strong>Juiste HTTP statuscodes:</strong>
                        400 bad input, 404 niet gevonden</li>
                    <li><strong>Interne logging:</strong>
                        fouten intern gelogd zonder te tonen</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Mitigatie</h3>
            <p>
                Implementeer het fail-closed principe: bij een
                fout altijd toegang weigeren. Gebruik specifieke
                fout-types. Stuur generieke meldingen naar
                gebruikers en log details intern. Retourneer
                altijd de juiste HTTP statuscodes. Vermijd het
                onderdrukken van fouten met _.
            </p>
        </div>

    </div>
</div>

<footer>
    BVWA is uitsluitend bedoeld voor educatieve doeleinden -
    gebruik alleen in een geisoleerde testomgeving.
</footer>

<script type="text/javascript">
function setVuln(val) {
    document.getElementById('vulnInput').value = val;
}
function setSecure(val) {
    document.getElementById('secureInput').value = val;
}
</script>

<!-- Stap 3: extern modal.js -->
<script type="text/javascript" src="/static/js/modal.js"></script>

</body>
</html>
