<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{.Title}} — BVWA</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #f0f2f5; }

        /* ── Header ── */
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

        /* ── Breadcrumb ── */
        .breadcrumb {
            background: #34495e;
            padding: 8px 30px;
            font-size: 13px;
            color: #bdc3c7;
        }
        .breadcrumb a { color: #e67e22; text-decoration: none; }
        .breadcrumb a:hover { text-decoration: underline; }

        /* ── Container ── */
        .container {
            max-width: 960px;
            margin: 30px auto;
            padding: 0 20px;
        }

        /* ── Module header ── */
        .module-header {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 20px;
        }
        .badge-a03 {
            background: #e67e22;
            color: white;
            font-weight: bold;
            font-size: 13px;
            padding: 6px 14px;
            border-radius: 20px;
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
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .btn-info:hover { background: #2980b9; }

        /* ── Cards ── */
        .cards {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        @media (max-width: 640px) { .cards { grid-template-columns: 1fr; } }
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
            margin-bottom: 16px;
        }

        /* Dependency table */
        .dep-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 12px;
            margin-bottom: 16px;
        }
        .dep-table th {
            background: #ecf0f1;
            padding: 6px 10px;
            text-align: left;
            color: #555;
            font-weight: bold;
        }
        .dep-table td {
            padding: 6px 10px;
            border-bottom: 1px solid #f0f0f0;
        }
        .unsafe { color: #e74c3c; font-weight: bold; }
        .safe-v  { color: #27ae60; font-weight: bold; }

        /* Hash display */
        .hash-box {
            background: #1e1e1e;
            color: #d4d4d4;
            font-family: monospace;
            font-size: 11px;
            padding: 10px 14px;
            border-radius: 6px;
            margin: 10px 0;
            word-break: break-all;
            line-height: 1.6;
        }
        .hash-box .label {
            color: #6a9955;
            display: block;
            margin-bottom: 4px;
        }
        .hash-value { color: #ce9178; }

        /* Code block */
        .code-block {
            background: #1e1e1e;
            color: #d4d4d4;
            font-family: monospace;
            font-size: 12px;
            padding: 14px;
            border-radius: 6px;
            overflow-x: auto;
            margin: 10px 0;
            line-height: 1.6;
        }
        .code-block .kw  { color: #569cd6; }
        .code-block .str { color: #ce9178; }
        .code-block .cmt { color: #6a9955; }

        /* Buttons */
        .btn {
            display: inline-block;
            padding: 10px 22px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 14px;
            font-weight: bold;
            color: white;
            width: 100%;
            text-align: center;
        }
        .btn-red   { background: #e74c3c; }
        .btn-red:hover { background: #c0392b; }
        .btn-green { background: #27ae60; }
        .btn-green:hover { background: #1e8449; }

        /* Result box */
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
        .tip {
            background: #eaf4fb;
            border: 1px solid #aed6f1;
            border-radius: 6px;
            padding: 12px 16px;
            font-size: 13px;
            color: #2471a3;
            margin-top: 12px;
        }

        /* ── Modal ── */
        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.55);
            z-index: 1000;
            justify-content: center;
            align-items: flex-start;
            padding: 40px 20px;
            overflow-y: auto;
        }
        .modal-overlay.active { display: flex; }
        .modal {
            background: white;
            border-radius: 10px;
            max-width: 720px;
            width: 100%;
            padding: 30px;
            position: relative;
            box-shadow: 0 8px 40px rgba(0,0,0,0.3);
        }
        .modal-close {
            position: absolute;
            top: 14px; right: 18px;
            background: none;
            border: none;
            font-size: 22px;
            cursor: pointer;
            color: #666;
        }
        .modal-close:hover { color: #e74c3c; }
        .modal h2 { color: #2c3e50; margin-bottom: 6px; font-size: 20px; }
        .modal .subtitle { color: #7f8c8d; font-size: 13px; margin-bottom: 20px; }
        .modal hr { border: none; border-top: 1px solid #ecf0f1; margin: 16px 0; }
        .cwe-list { display: flex; flex-wrap: wrap; gap: 8px; margin: 10px 0 16px; }
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
            font-size: 14px;
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
        .vuln-box ul, .safe-box ul { margin: 6px 0 0 18px; }
        .vuln-box li, .safe-box li { margin-bottom: 4px; }

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

<!-- ── HEADER ── -->
<header>
    <a href="/" class="logo">🔐 <span>BVWA</span></a>
    <nav>
        <a href="/">🏠 Home</a>
        <a href="/supplychain/vulnerable">Kwetsbaar</a>
        <a href="/supplychain/secure">Veilig</a>
    </nav>
</header>

<!-- ── BREADCRUMB ── -->
<div class="breadcrumb">
    <a href="/">Home</a> › A03 › {{.Title}}
</div>

<!-- ── MAIN ── -->
<div class="container">

    <!-- Module title + Info button -->
    <div class="module-header">
        <span class="badge-a03">A03</span>
        <h1>Software Supply Chain Failures</h1>
        <button class="btn-info" onclick="openModal()">
            ℹ️ Info & CWEs
        </button>
    </div>

    <!-- Cards -->
    <div class="cards">

        <!-- KWETSBAAR -->
        <div class="card">
            <div class="card-header vuln">⚠️ Kwetsbare versie</div>
            <div class="card-body">
                <p>
                    Gebruik van <strong>verouderde, onveilige
                    dependency</strong>: MD5 voor het hashen van
                    gevoelige data. MD5 is gekraakt en kwetsbaar
                    voor collision- en rainbow table aanvallen.
                </p>

                <table class="dep-table">
                    <tr>
                        <th>Package</th>
                        <th>Status</th>
                    </tr>
                    <tr>
                        <td>crypto/md5</td>
                        <td class="unsafe">⚠️ Onveilig (gekraakt)</td>
                    </tr>
                    <tr>
                        <td>Output lengte</td>
                        <td class="unsafe">128-bit (te kort)</td>
                    </tr>
                    <tr>
                        <td>Collision resistant</td>
                        <td class="unsafe">✗ Nee</td>
                    </tr>
                </table>

                {{if .Hash}}
                <div class="hash-box">
                    <span class="label">// MD5 hash output:</span>
                    <span class="hash-value">{{.Hash}}</span>
                </div>
                {{end}}

                <div class="code-block">
<span class="cmt">// KWETSBAAR: verouderd algoritme</span>
<span class="kw">import</span> <span class="str">"crypto/md5"</span>
hash := md5.Sum([]<span class="kw">byte</span>(password))
                </div>
                <a href="/supplychain/vulnerable" class="btn btn-red">
                    🔓 Open kwetsbare versie
                </a>
            </div>
        </div>

        <!-- VEILIG -->
        <div class="card">
            <div class="card-header safe">✅ Veilige versie</div>
            <div class="card-body">
                <p>
                    Gebruik van <strong>moderne, veilige
                    dependency</strong>: SHA-256 voor hashing.
                    SHA-256 is collision-resistant en voldoet aan
                    huidige beveiligingsstandaarden.
                </p>

                <table class="dep-table">
                    <tr>
                        <th>Package</th>
                        <th>Status</th>
                    </tr>
                    <tr>
                        <td>crypto/sha256</td>
                        <td class="safe-v">✓ Veilig (modern)</td>
                    </tr>
                    <tr>
                        <td>Output lengte</td>
                        <td class="safe-v">256-bit (sterk)</td>
                    </tr>
                    <tr>
                        <td>Collision resistant</td>
                        <td class="safe-v">✓ Ja</td>
                    </tr>
                </table>

                {{if .Hash}}
                <div class="hash-box">
                    <span class="label">// SHA-256 hash output:</span>
                    <span class="hash-value">{{.Hash}}</span>
                </div>
                {{end}}

                <div class="code-block">
<span class="cmt">// VEILIG: modern algoritme</span>
<span class="kw">import</span> <span class="str">"crypto/sha256"</span>
hash := sha256.Sum256([]<span class="kw">byte</span>(password))
                </div>
                <a href="/supplychain/secure" class="btn btn-green">
                    🔒 Open veilige versie
                </a>
            </div>
        </div>
    </div>

    <!-- Result box -->
    <div class="result-box">
        <h3>🔍 Huidige pagina: <strong>{{.Title}}</strong></h3>

        {{if eq .Title "Supply Chain (Kwetsbaar - MD5)"}}
        <span class="tag-vuln">⚠️ KWETSBAAR</span>
        <p>
            De hash is gegenereerd met <strong>MD5</strong> —
            een gebroken algoritme. Een aanvaller kan via
            rainbow tables het originele wachtwoord terugvinden.
        </p>
        {{else}}
        <span class="tag-safe">✅ VEILIG</span>
        <p>
            De hash is gegenereerd met <strong>SHA-256</strong>
            — een modern, veilig algoritme. Gebruik in productie
            bcrypt voor wachtwoorden.
        </p>
        {{end}}

        <div class="tip">
            💡 <strong>Extra tip:</strong> Controleer regelmatig
            je dependencies met
            <code>go list -m -u all</code> en
            <code>go mod verify</code> voor verouderde of
            gecompromitteerde packages.
        </div>
    </div>

</div>

<!-- ── INFO MODAL ── -->
<div class="modal-overlay" id="infoModal">
    <div class="modal">
        <button class="modal-close" onclick="closeModal()">✕</button>

        <h2>ℹ️ A03:2025 — Software Supply Chain Failures</h2>
        <p class="subtitle">
            OWASP Top 10:2025 · Positie #3 · Nieuw in 2021, uitgebreid in 2025
        </p>
        <hr>

        <!-- Wat is het -->
        <div class="info-section">
            <h3>📖 Wat is het?</h3>
            <p>
                Software Supply Chain Failures treden op wanneer
                kwetsbaarheden of kwaadaardige code binnensluipen
                via externe componenten die je vertrouwt —
                open-source libraries, build-tools, CI/CD-pipelines,
                of update-processen. Anders dan A02 (configuratie)
                gaat het hier om de <em>herkomst en integriteit</em>
                van de software zelf.
            </p>
        </div>
        <hr>

        <!-- CWEs -->
        <div class="info-section">
            <h3>🏷️ Gerelateerde CWEs</h3>
            <div class="cwe-list">
                <span class="cwe-tag">CWE-829 — Inclusion of Functionality from Untrusted Control Sphere</span>
                <span class="cwe-tag">CWE-494 — Download of Code Without Integrity Check</span>
                <span class="cwe-tag">CWE-502 — Deserialization of Untrusted Data</span>
                <span class="cwe-tag">CWE-345 — Insufficient Verification of Data Authenticity</span>
                <span class="cwe-tag">CWE-346 — Origin Validation Error</span>
                <span class="cwe-tag">CWE-347 — Improper Verification of Cryptographic Signature</span>
                <span class="cwe-tag">CWE-353 — Missing Support for Integrity Check</span>
                <span class="cwe-tag">CWE-539 — Use of Persistent Cookies Containing Sensitive Info</span>
                <span class="cwe-tag">CWE-327 — Use of Broken or Risky Cryptographic Algorithm</span>
                <span class="cwe-tag">CWE-328 — Use of Weak Hash</span>
                <span class="cwe-tag">CWE-916 — Use of Password Hash With Insufficient Computational Effort</span>
                <span class="cwe-tag">CWE-1104 — Use of Unmaintained Third-Party Components</span>
            </div>
        </div>
        <hr>

        <!-- Waarom kwetsbaar -->
        <div class="info-section">
            <h3>🔴 Waarom is de kwetsbare versie onveilig?</h3>
            <div class="vuln-box">
                De kwetsbare versie gebruikt
                <strong>crypto/md5</strong> — een verouderde
                dependency:
                <ul>
                    <li><strong>MD5 is gekraakt:</strong> collision
                        aanvallen zijn praktisch uitvoerbaar —
                        twee verschillende inputs kunnen dezelfde
                        hash produceren (CWE-328)</li>
                    <li><strong>Rainbow tables:</strong> MD5 hashes
                        van veelgebruikte wachtwoorden zijn al
                        voorberekend en openbaar beschikbaar</li>
                    <li><strong>Te snel:</strong> MD5 kan miljarden
                        keren per seconde berekend worden op GPU —
                        brute force is triviaal</li>
                    <li><strong>Geen salt:</strong> dezelfde input
                        geeft altijd dezelfde output (deterministisch)</li>
                    <li>Valt onder CWE-327: gebruik van een gebroken
                        cryptografisch algoritme</li>
                </ul>
            </div>
        </div>
        <hr>

        <!-- Waarom veilig -->
        <div class="info-section">
            <h3>🟢 Waarom is de veilige versie correct?</h3>
            <div class="safe-box">
                De veilige versie gebruikt
                <strong>crypto/sha256</strong> — een moderne
                dependency:
                <ul>
                    <li><strong>SHA-256 is collision-resistant:</strong>
                        geen praktische collision aanvallen bekend</li>
                    <li><strong>256-bit output:</strong> astronomisch
                        grote zoekruimte voor brute force</li>
                    <li><strong>go mod verify:</strong> verificatie
                        dat packages niet gemanipuleerd zijn na
                        download</li>
                    <li><strong>Regelmatig updaten:</strong>
                        <code>go list -m -u all</code> toont
                        beschikbare updates voor alle dependencies</li>
                    <li>In productie: gebruik <strong>bcrypt</strong>
                        voor wachtwoorden (heeft ingebouwde salt
                        en is opzettelijk traag)</li>
                </ul>
            </div>
        </div>
        <hr>

        <!-- Mitigatie -->
        <div class="info-section">
            <h3>🛡️ Mitigatie</h3>
            <p>
                Gebruik alleen ondertekende packages van
                vertrouwde bronnen. Controleer de integriteit
                van dependencies met <code>go mod verify</code>.
                Houd een software bill of materials (SBOM) bij.
                Gebruik Dependabot of Renovate voor automatische
                dependency-updates. Scan je supply chain met tools
                zoals <em>govulncheck</em> voor bekende CVEs in
                Go modules.
            </p>
        </div>

    </div>
</div>

<footer>
    ⚠️ BVWA is uitsluitend bedoeld voor educatieve doeleinden —
    gebruik alleen in een geïsoleerde testomgeving.
</footer>

<script type="text/javascript" src="/static/js/modal.js"></script>

</body>
</html>
