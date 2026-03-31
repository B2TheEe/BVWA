<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>bvwa-passwd — credential manager (kwetsbaar)</title>
    <link rel="stylesheet" href="/static/css/bvwa.css">
    <style>
        .terminal-panel {
            background: #0d1117;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 24px rgba(0,0,0,0.35);
            margin-bottom: 24px;
            font-family: 'Courier New', Courier, monospace;
        }
        .terminal-topbar {
            background: #21262d;
            padding: 10px 16px;
            display: flex;
            align-items: center;
            gap: 8px;
            border-bottom: 1px solid #30363d;
        }
        .terminal-dots { display: flex; gap: 6px; }
        .terminal-dot { width: 12px; height: 12px; border-radius: 50%; }
        .dot-red    { background: #ff5f57; }
        .dot-yellow { background: #febc2e; }
        .dot-green  { background: #28c840; }
        .terminal-title { color: #8b949e; font-size: 13px; margin-left: 6px; }
        .terminal-body {
            padding: 20px 24px;
            min-height: 260px;
            color: #e6edf3;
            font-size: 13.5px;
            line-height: 1.65;
        }
        .terminal-motd { color: #6e7681; margin-bottom: 18px; font-size: 13px; }
        .terminal-entry { margin-bottom: 12px; }
        .terminal-cmd-echo { color: #58a6ff; }
        .terminal-cmd-echo .ps1 { color: #3fb950; }
        .terminal-output {
            white-space: pre-wrap;
            color: #e6edf3;
            word-break: break-all;
            margin-top: 2px;
        }
        .terminal-input-bar {
            display: flex;
            align-items: center;
            background: #161b22;
            padding: 10px 24px;
            border-top: 1px solid #21262d;
            gap: 8px;
        }
        .terminal-ps1 {
            color: #3fb950;
            font-family: 'Courier New', Courier, monospace;
            font-size: 13.5px;
            white-space: nowrap;
            flex-shrink: 0;
        }
        .terminal-input-bar input[type=text] {
            flex: 1;
            background: transparent;
            border: none;
            outline: none;
            color: #e6edf3;
            font-family: 'Courier New', Courier, monospace;
            font-size: 13.5px;
            caret-color: #3fb950;
        }
        .terminal-input-bar button {
            background: #238636;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 5px 14px;
            font-size: 13px;
            font-weight: bold;
            cursor: pointer;
        }
        .terminal-input-bar button:hover { background: #2ea043; }
    </style>
</head>
<body>

<header>
    <a href="/" class="logo">&#x1F510; <span>BVWA</span></a>
    <nav>
        <a href="/">&#x1F3E0; Home</a>
        <a href="/crypto/vulnerable">Kwetsbaar</a>
        <a href="/crypto/secure">Veilig</a>
    </nav>
</header>

<div class="breadcrumb">
    <a href="/">Home</a> &rsaquo; A04 &rsaquo; Cryptographic Failures (Kwetsbaar)
</div>

<div class="container">

    <div class="module-header">
        <span class="badge">A04</span>
        <h1>Cryptographic Failures</h1>
        <button type="button" class="btn-info" id="openInfoBtn">Info &amp; CWEs</button>
        <button type="button" class="btn-examples" id="openExamplesBtn">Echte Voorbeelden</button>
    </div>

    <div class="terminal-panel">
        <div class="terminal-topbar">
            <div class="terminal-dots">
                <div class="terminal-dot dot-red"></div>
                <div class="terminal-dot dot-yellow"></div>
                <div class="terminal-dot dot-green"></div>
            </div>
            <span class="terminal-title">bvwa-passwd v1.2.0 &mdash; Internal Credential Manager (debug build)</span>
        </div>

        <div class="terminal-body">
            <div class="terminal-motd">bvwa-passwd v1.2.0<br>
Connected to bvwa-corp.local</div>

            {{if .HasOutput}}
            <div class="terminal-entry">
                <div class="terminal-cmd-echo">
                    <span class="ps1">user@bvwa-corp:~$</span> bvwa-passwd {{.Command}}
                </div>
                <pre class="terminal-output">{{.Output}}</pre>
            </div>
            {{end}}
        </div>

        <form method="GET" action="/crypto/vulnerable">
            <div class="terminal-input-bar">
                <span class="terminal-ps1">user@bvwa-corp:~$</span>
                <input type="text" name="cmd" value="" autofocus autocomplete="off" spellcheck="false" placeholder="bvwa-passwd ">
                <button type="submit">&#x23CE;</button>
            </div>
        </form>
    </div>

</div>

<!-- ECHTE VOORBEELDEN MODAL -->
<div class="modal-overlay" id="examplesModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeExamplesBtn">X</button>
        <h2>Echte Voorbeelden &mdash; Cryptographic Failures</h2>
        <p class="subtitle">Historische datalekken veroorzaakt door zwakke of verkeerde cryptografie</p>
        <hr>

        <div class="example-item">
            <h4><span class="example-year">2012</span> LinkedIn Wachtwoordlek</h4>
            <p>6,5 miljoen SHA-1 wachtwoordhashes zonder salt werden gestolen en gepubliceerd
            op een Russisch forum. Omdat er geen salt werd gebruikt, waren identieke wachtwoorden
            direct herkenbaar. In 2016 bleek de werkelijke omvang 117 miljoen accounts te zijn.
            Populaire wachtwoorden werden binnen uren gekraakt.</p>
            <p class="example-impact">Impact: 117 miljoen accounts blootgesteld &mdash; wachtwoorden in dagen gekraakt</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2013</span> Adobe Datalek</h4>
            <p>Adobe sloeg 153 miljoen wachtwoorden op met 3DES-encryptie in ECB-modus &mdash;
            dit is encryptie, geen hashing. Hetzelfde wachtwoord gaf altijd dezelfde output,
            waardoor patronen zichtbaar waren. Bovendien lagen wachtwoordhints in plaintext
            naast de encrypted wachtwoorden.</p>
            <p class="example-impact">Impact: 153 miljoen accounts &mdash; honderden miljoenen euro&rsquo;s schade</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2009</span> RockYou Wachtwoorddatabase</h4>
            <p>De socialemediadienst RockYou sloeg 32 miljoen wachtwoorden op in volledig
            plaintext in een MySQL-database. Een SQL injection onthulde alles. De RockYou.txt
            wordlist die hieruit ontstond wordt vandaag nog steeds standaard gebruikt in
            penetratietests.</p>
            <p class="example-impact">Impact: 32 miljoen plaintext wachtwoorden &mdash; RockYou.txt is nu de standaard pentest-wordlist</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2015</span> Ashley Madison</h4>
            <p>De overspelsite gebruikte een mix van bcrypt (voor betalende leden) en MD5
            (voor gratis accounts). De 11 miljoen MD5-hashes werden binnen 10 dagen volledig
            gekraakt via GPU-clusters. De bcrypt-hashes hielden stand &mdash; het verschil
            is dramatisch.</p>
            <p class="example-impact">Impact: 37 miljoen profielen gelekt &mdash; MD5-hashes in 10 dagen volledig gekraakt</p>
        </div>
    </div>
</div>

<!-- INFO MODAL -->
<div class="modal-overlay" id="infoModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeInfoBtn">X</button>
        <h2>A04:2025 &mdash; Cryptographic Failures</h2>
        <p class="subtitle">OWASP Top 10:2025 &mdash; Positie #4 &mdash; Voorheen: Sensitive Data Exposure</p>
        <hr>

        <div class="info-section">
            <h3>Wat is het?</h3>
            <p>Cryptographic Failures treden op wanneer gevoelige data niet of onvoldoende
            versleuteld wordt. Denk aan zwakke algoritmes (MD5, SHA-1, DES), hardcoded sleutels,
            ontbrekende TLS, of verkeerde toepassing van cryptografie (zoals Base64 als
            &ldquo;encryptie&rdquo;).</p>
        </div>
        <hr>

        <div class="info-section">
            <h3>Gerelateerde CWEs</h3>
            <div class="cwe-list">
                <span class="cwe-tag">CWE-325 Missing Cryptographic Step</span>
                <span class="cwe-tag">CWE-327 Broken/Risky Crypto Algorithm</span>
                <span class="cwe-tag">CWE-328 Use of Weak Hash (MD5/SHA-1)</span>
                <span class="cwe-tag">CWE-347 Improper Signature Verification</span>
                <span class="cwe-tag">CWE-759 One-Way Hash Without Salt</span>
                <span class="cwe-tag">CWE-760 Hash with Predictable Salt</span>
                <span class="cwe-tag">CWE-862 Missing Authorization</span>
                <span class="cwe-tag">CWE-916 Insufficient Password Hash Effort</span>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de kwetsbare versie onveilig?</h3>
            <div class="vuln-box">
                <ul>
                    <li><strong>MD5-hashing</strong> zonder salt (CWE-328/759) &mdash; rainbow tables kraken hashes in milliseconden</li>
                    <li><strong>Base64-token</strong> zonder handtekening (CWE-325) &mdash; kan door iedereen worden gelezen &eacute;n vervalst</li>
                    <li><strong>Gevoelige velden</strong> in het token (_ctx) worden uitgelezen zonder auth-check</li>
                    <li><strong>Wachtwoordhashlijst</strong> toegankelijk zonder autorisatie (CWE-862)</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Mitigatie</h3>
            <div class="safe-box">
                <ul>
                    <li>Gebruik <strong>bcrypt</strong> of <strong>Argon2id</strong> voor wachtwoorden (ingebouwde salt + key stretching)</li>
                    <li>Gebruik <strong>HMAC-SHA256</strong> voor gesigneerde tokens &mdash; payload leesbaar maar niet vervalsbaar</li>
                    <li>Sla <strong>geen gevoelige data</strong> op in client-side tokens</li>
                    <li>Beveilig alle gevoelige endpoints met <strong>autorisatiecontrole</strong></li>
                </ul>
            </div>
        </div>
    </div>
</div>

<footer>
    BVWA is uitsluitend bedoeld voor educatieve doeleinden &mdash;
    gebruik alleen in een ge&iuml;soleerde testomgeving.
</footer>

<script type="text/javascript" src="/static/js/modal.js"></script>

</body>
</html>
