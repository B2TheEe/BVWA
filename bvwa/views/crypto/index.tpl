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

        .crypto-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 12px;
            margin-bottom: 14px;
        }
        .crypto-table th {
            background: #ecf0f1;
            padding: 6px 10px;
            text-align: left;
            color: #555;
            font-weight: bold;
        }
        .crypto-table td {
            padding: 6px 10px;
            border-bottom: 1px solid #f0f0f0;
        }
        .cell-unsafe { color: #e74c3c; font-weight: bold; }
        .cell-safe   { color: #27ae60; font-weight: bold; }

        .hash-box {
            background: #1e1e1e;
            color: #d4d4d4;
            font-family: monospace;
            font-size: 11px;
            padding: 10px 14px;
            border-radius: 6px;
            margin: 10px 0;
            word-break: break-all;
            line-height: 1.7;
        }
        .hash-label {
            color: #6a9955;
            display: block;
            margin-bottom: 4px;
        }
        .hash-value { color: #ce9178; }

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

        .btn-link {
            display: block;
            padding: 10px 22px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 14px;
            font-weight: bold;
            color: white;
            text-align: center;
            margin-top: 10px;
        }
        .btn-red   { background: #e74c3c; }
        .btn-red:hover   { background: #c0392b; }
        .btn-green { background: #27ae60; }
        .btn-green:hover { background: #1e8449; }

        .result-box {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-top: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .result-box h3 { margin-bottom: 12px; color: #2c3e50; }
        .result-box p  { font-size: 14px; color: #555; line-height: 1.6; }

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
        <a href="/crypto/vulnerable">Kwetsbaar</a>
        <a href="/crypto/secure">Veilig</a>
    </nav>
</header>

<!-- BREADCRUMB -->
<div class="breadcrumb">
    <a href="/">Home</a> &rsaquo; A04 &rsaquo; {{.Title}}
</div>

<!-- MAIN -->
<div class="container">

    <div class="module-header">
        <span class="badge">A04</span>
        <h1>Cryptographic Failures</h1>
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
                    Wachtwoord gehasht met <strong>MD5</strong>
                    - een gebroken algoritme dat in milliseconden
                    gekraakt kan worden via rainbow tables.
                </p>

                <table class="crypto-table">
                    <tr>
                        <th>Eigenschap</th>
                        <th>Waarde</th>
                    </tr>
                    <tr>
                        <td>Algoritme</td>
                        <td class="cell-unsafe">MD5 (gebroken)</td>
                    </tr>
                    <tr>
                        <td>Output</td>
                        <td class="cell-unsafe">128-bit</td>
                    </tr>
                    <tr>
                        <td>Salt</td>
                        <td class="cell-unsafe">Geen</td>
                    </tr>
                    <tr>
                        <td>Brute force</td>
                        <td class="cell-unsafe">Triviaal snel</td>
                    </tr>
                </table>

                {{if .Hash}}
                <div class="hash-box">
                    <span class="hash-label">// MD5 hash van "geheim123":</span>
                    <span class="hash-value">{{.Hash}}</span>
                </div>
                {{end}}

                <div class="code-block">// KWETSBAAR: MD5
hash := md5.Sum([]byte(password))
fmt.Sprintf("%x", hash)</div>

                <a href="/crypto/vulnerable" class="btn-link btn-red">
                    Open kwetsbare versie
                </a>
            </div>
        </div>

        <!-- VEILIG -->
        <div class="card">
            <div class="card-header safe">Veilige versie</div>
            <div class="card-body">
                <p>
                    Wachtwoord gehasht met <strong>bcrypt</strong>
                    - opzettelijk traag, met ingebouwde salt,
                    speciaal ontworpen voor wachtwoorden.
                </p>

                <table class="crypto-table">
                    <tr>
                        <th>Eigenschap</th>
                        <th>Waarde</th>
                    </tr>
                    <tr>
                        <td>Algoritme</td>
                        <td class="cell-safe">bcrypt (sterk)</td>
                    </tr>
                    <tr>
                        <td>Output</td>
                        <td class="cell-safe">60 tekens</td>
                    </tr>
                    <tr>
                        <td>Salt</td>
                        <td class="cell-safe">Ingebouwd</td>
                    </tr>
                    <tr>
                        <td>Brute force</td>
                        <td class="cell-safe">Zeer traag</td>
                    </tr>
                </table>

                {{if .Hash}}
                <div class="hash-box">
                    <span class="hash-label">// bcrypt hash van "geheim123":</span>
                    <span class="hash-value">{{.Hash}}</span>
                </div>
                {{end}}

                <div class="code-block">// VEILIG: bcrypt
hash, _ := bcrypt.GenerateFromPassword(
    []byte(password),
    bcrypt.DefaultCost)</div>

                <a href="/crypto/secure" class="btn-link btn-green">
                    Open veilige versie
                </a>
            </div>
        </div>

    </div>

    <!-- Result box -->
    <div class="result-box">
        <h3>Huidige pagina: <strong>{{.Title}}</strong></h3>

        {{if eq .Title "Cryptographic Failures (Kwetsbaar)"}}
        <span class="tag-vuln">KWETSBAAR</span>
        <p>
            Hash gegenereerd met <strong>MD5</strong>. Een
            aanvaller kan via rainbow tables het originele
            wachtwoord in seconden terugvinden.
        </p>
        {{else}}
        <span class="tag-safe">VEILIG</span>
        <p>
            Hash gegenereerd met <strong>bcrypt</strong>.
            Elke hash is uniek door de ingebouwde random salt.
            bcrypt is opzettelijk traag.
        </p>
        {{end}}

        {{if .SHA}}
        <div class="hash-box" style="margin-top:12px;">
            <span class="hash-label">// SHA-256 integriteitscheck:</span>
            <span class="hash-value">{{.SHA}}</span>
        </div>
        {{end}}

        <div class="tip">
            Gebruik <strong>bcrypt</strong> of
            <strong>Argon2</strong> voor wachtwoorden.
            Gebruik <strong>SHA-256</strong> voor integriteit.
            Gebruik <strong>nooit</strong> MD5 of SHA-1.
        </div>
    </div>

</div>

<!-- INFO MODAL -->
<div class="modal-overlay" id="infoModal">
    <div class="modal">
        <button type="button" class="modal-close"
                id="closeInfoBtn">X</button>

        <h2>A04:2025 - Cryptographic Failures</h2>
        <p class="subtitle">
            OWASP Top 10:2025 - Positie #4 -
            Voorheen: Sensitive Data Exposure
        </p>
        <hr>

        <div class="info-section">
            <h3>Wat is het?</h3>
            <p>
                Cryptographic Failures treden op wanneer
                gevoelige data niet of onvoldoende versleuteld
                wordt. Denk aan zwakke algoritmes (MD5, SHA-1,
                DES), hardcoded sleutels, ontbrekende TLS, of
                verkeerde toepassing van cryptografie.
            </p>
        </div>
        <hr>

        <div class="info-section">
            <h3>Gerelateerde CWEs</h3>
            <div class="cwe-list">
                <span class="cwe-tag">CWE-261 Weak Cryptography for Passwords</span>
                <span class="cwe-tag">CWE-296 Improper Chain of Trust</span>
                <span class="cwe-tag">CWE-310 Cryptographic Issues</span>
                <span class="cwe-tag">CWE-319 Cleartext Transmission</span>
                <span class="cwe-tag">CWE-321 Hard-coded Cryptographic Key</span>
                <span class="cwe-tag">CWE-322 Key Exchange Without Auth</span>
                <span class="cwe-tag">CWE-323 Reusing Nonce/Key-pair</span>
                <span class="cwe-tag">CWE-324 Key Past Expiration Date</span>
                <span class="cwe-tag">CWE-325 Missing Cryptographic Step</span>
                <span class="cwe-tag">CWE-326 Inadequate Encryption Strength</span>
                <span class="cwe-tag">CWE-327 Broken/Risky Crypto Algorithm</span>
                <span class="cwe-tag">CWE-328 Use of Weak Hash (MD5/SHA-1)</span>
                <span class="cwe-tag">CWE-329 No Random IV with CBC</span>
                <span class="cwe-tag">CWE-330 Insufficiently Random Values</span>
                <span class="cwe-tag">CWE-331 Insufficient Entropy</span>
                <span class="cwe-tag">CWE-335 Incorrect Seed Usage in PRNG</span>
                <span class="cwe-tag">CWE-336 Same Seed in PRNG</span>
                <span class="cwe-tag">CWE-337 Predictable Seed in PRNG</span>
                <span class="cwe-tag">CWE-338 Cryptographically Weak PRNG</span>
                <span class="cwe-tag">CWE-340 Predictable Numbers</span>
                <span class="cwe-tag">CWE-347 Improper Signature Verification</span>
                <span class="cwe-tag">CWE-523 Unprotected Transport of Credentials</span>
                <span class="cwe-tag">CWE-757 Less-Secure Algorithm Selection</span>
                <span class="cwe-tag">CWE-759 One-Way Hash Without Salt</span>
                <span class="cwe-tag">CWE-760 Hash with Predictable Salt</span>
                <span class="cwe-tag">CWE-780 RSA Without OAEP</span>
                <span class="cwe-tag">CWE-818 Insufficient Transport Layer Protection</span>
                <span class="cwe-tag">CWE-916 Insufficient Password Hash Effort</span>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de kwetsbare versie onveilig?</h3>
            <div class="vuln-box">
                De kwetsbare versie gebruikt
                <strong>MD5</strong> voor wachtwoord-hashing
                (CWE-328):
                <ul>
                    <li><strong>MD5 is gekraakt:</strong>
                        collision aanvallen zijn praktisch
                        uitvoerbaar</li>
                    <li><strong>Rainbow tables:</strong>
                        miljarden voorberekende hashes gratis
                        online beschikbaar</li>
                    <li><strong>Geen salt:</strong> zelfde input
                        geeft altijd zelfde hash (CWE-759)</li>
                    <li><strong>Te snel:</strong> 50+ miljard
                        hashes/seconde op GPU mogelijk</li>
                    <li><strong>128-bit output:</strong> te kort
                        voor moderne veiligheidseisen</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de veilige versie correct?</h3>
            <div class="safe-box">
                De veilige versie gebruikt
                <strong>bcrypt</strong> - speciaal voor
                wachtwoorden:
                <ul>
                    <li><strong>Ingebouwde salt:</strong>
                        elke hash uniek, rainbow tables
                        nutteloos</li>
                    <li><strong>Opzettelijk traag:</strong>
                        ~100ms per hash met cost=10</li>
                    <li><strong>Aanpasbare cost factor:</strong>
                        schaalbaar met snellere hardware</li>
                    <li><strong>Timing-safe vergelijking</strong>
                        via CompareHashAndPassword()</li>
                    <li><strong>Alternatief:</strong> Argon2id
                        voor nieuwe applicaties</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Mitigatie</h3>
            <p>
                Gebruik bcrypt of Argon2id voor wachtwoorden.
                Gebruik AES-256-GCM voor symmetrische encryptie.
                Gebruik SHA-256/SHA-3 voor hashing.
                Gebruik TLS 1.3 voor alle dataverkeer.
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
