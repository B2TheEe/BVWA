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

        .scenarios {
            background: #f8f9fa;
            border-radius: 6px;
            padding: 12px 14px;
            margin: 10px 0;
            font-size: 12px;
        }
        .scenarios strong {
            display: block;
            margin-bottom: 6px;
            color: #444;
            font-size: 13px;
        }
        .scenario-item {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 4px;
        }
        .scenario-btn {
            background: #ecf0f1;
            border: 1px solid #bdc3c7;
            border-radius: 4px;
            padding: 2px 8px;
            font-size: 11px;
            font-family: monospace;
            cursor: pointer;
            color: #2c3e50;
        }
        .scenario-btn:hover {
            background: #3498db;
            color: white;
            border-color: #3498db;
        }
        .scenario-desc {
            color: #666;
            font-size: 11px;
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
        .msg-safe-error {
            background: #fff3cd;
            border: 1px solid #ffc107;
            border-radius: 6px;
            padding: 12px 16px;
            font-size: 14px;
            color: #856404;
            margin-top: 10px;
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

        /* Modal */
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
