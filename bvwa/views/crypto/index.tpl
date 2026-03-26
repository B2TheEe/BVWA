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
