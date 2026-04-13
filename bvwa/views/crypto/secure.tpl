<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>bvwa-passwd — credential manager (veilig)</title>
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
            background: #1a2634;
            padding: 10px 16px;
            display: flex;
            align-items: center;
            gap: 8px;
            border-bottom: 1px solid #1f4068;
        }
        .terminal-dots { display: flex; gap: 6px; }
        .terminal-dot { width: 12px; height: 12px; border-radius: 50%; }
        .dot-red    { background: #ff5f57; }
        .dot-yellow { background: #febc2e; }
        .dot-green  { background: #28c840; }
        .terminal-title { color: #58a6ff; font-size: 13px; margin-left: 6px; }
        .terminal-body {
            padding: 20px 24px;
            min-height: 260px;
            color: #e6edf3;
            font-size: 13.5px;
            line-height: 1.65;
        }
        .terminal-motd { color: #3fb950; margin-bottom: 18px; font-size: 13px; }
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
            background: #0f1a26;
            padding: 10px 24px;
            border-top: 1px solid #1f4068;
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
            background: #1f6feb;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 5px 14px;
            font-size: 13px;
            font-weight: bold;
            cursor: pointer;
        }
        .terminal-input-bar button:hover { background: #388bfd; }
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
    <a href="/">Home</a> &rsaquo; A04 &rsaquo; Cryptographic Failures (Veilig)
</div>

<div class="container">

    <div class="module-header">
        <span class="badge">A04</span>
        <h1>Cryptographic Failures</h1>
        <button type="button" class="btn-info" id="openInfoBtn">Info &amp; CWEs</button>
        <button type="button" class="btn-examples" id="openExamplesBtn">Echte Voorbeelden</button>
        <button type="button" class="btn-help" id="openHelpBtn">Hulp &amp; Commando&rsquo;s</button>
    </div>

    <div class="terminal-panel">
        <div class="terminal-topbar">
            <div class="terminal-dots">
                <div class="terminal-dot dot-red"></div>
                <div class="terminal-dot dot-yellow"></div>
                <div class="terminal-dot dot-green"></div>
            </div>
            <span class="terminal-title">bvwa-passwd v2.0.0 &mdash; Internal Credential Manager [secure build]</span>
        </div>

        <div class="terminal-body">
            <div class="terminal-motd">bvwa-passwd v2.0.0 [secure]<br>
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

        <form method="GET" action="/crypto/secure">
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
            direct herkenbaar. In 2016 bleek de werkelijke omvang 117 miljoen accounts te zijn.</p>
            <p class="example-impact">Impact: 117 miljoen accounts blootgesteld &mdash; wachtwoorden in dagen gekraakt</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2013</span> Adobe Datalek</h4>
            <p>Adobe sloeg 153 miljoen wachtwoorden op met 3DES-encryptie in ECB-modus.
            Hetzelfde wachtwoord gaf altijd dezelfde output, waardoor patronen zichtbaar waren.
            Bovendien lagen wachtwoordhints in plaintext naast de encrypted wachtwoorden.</p>
            <p class="example-impact">Impact: 153 miljoen accounts &mdash; honderden miljoenen euro&rsquo;s schade</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2015</span> Ashley Madison</h4>
            <p>De site gebruikte een mix van bcrypt (betalende leden) en MD5 (gratis accounts).
            De 11 miljoen MD5-hashes werden binnen 10 dagen volledig gekraakt via GPU-clusters.
            De bcrypt-hashes hielden volledig stand &mdash; het verschil is dramatisch.</p>
            <p class="example-impact">Impact: 37 miljoen profielen gelekt &mdash; MD5-hashes in 10 dagen gekraakt, bcrypt niet</p>
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
            <h3>Mitigaties in deze veilige versie</h3>
            <div class="safe-box">
                <ul>
                    <li><strong>bcrypt (cost=10)</strong> voor wachtwoorden &mdash; ingebouwde salt, intentioneel traag, resistent tegen GPU-aanvallen</li>
                    <li><strong>HMAC-SHA256 gesigneerde tokens</strong> &mdash; payload leesbaar maar cryptografisch beveiligd tegen vervalsing</li>
                    <li><strong>Geen gevoelige data</strong> in het token &mdash; _ctx-veld verwijderd uit payload</li>
                    <li><strong>Autorisatiecheck</strong> op gebruikerslijst &mdash; vereist geldig admin-token (CWE-862 mitigatie)</li>
                    <li><strong>Uniforme responsetijden</strong> bij login &mdash; user enumeration via timing-aanvallen voorkomen</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Algoritme vergelijking</h3>
            <div class="cwe-list">
                <span class="cwe-tag" style="background:#da3633">MD5 &mdash; VERBODEN voor wachtwoorden</span>
                <span class="cwe-tag" style="background:#da3633">SHA-1 &mdash; VERBODEN voor wachtwoorden</span>
                <span class="cwe-tag" style="background:#9e6a03">SHA-256 &mdash; OK voor integriteit, NIET voor wachtwoorden</span>
                <span class="cwe-tag" style="background:#238636">bcrypt &mdash; AANBEVOLEN voor wachtwoorden</span>
                <span class="cwe-tag" style="background:#238636">Argon2id &mdash; AANBEVOLEN voor wachtwoorden</span>
                <span class="cwe-tag" style="background:#238636">HMAC-SHA256 &mdash; AANBEVOLEN voor tokens/MACs</span>
            </div>
        </div>
    </div>
</div>

<footer>
    BVWA is uitsluitend bedoeld voor educatieve doeleinden &mdash;
    gebruik alleen in een ge&iuml;soleerde testomgeving.
</footer>

<!-- HULP MODAL -->
<div class="modal-overlay" id="helpModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeHelpBtn">X</button>
        <h2>Hulp — A04 Cryptographic Failures (Veilig)</h2>
        <p class="subtitle">Beschikbare <code>bvwa-passwd</code>-commando's op het veilige credential management systeem</p>
        <hr>

        <div class="info-section">
            <h3>Commando's</h3>
            <table style="width:100%; border-collapse:collapse; font-size:14px;">
                <thead>
                    <tr style="background:#f6f8fa; text-align:left;">
                        <th style="padding:8px 12px; border-bottom:1px solid #e0e0e0;">Commando</th>
                        <th style="padding:8px 12px; border-bottom:1px solid #e0e0e0;">Wat het doet</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">help</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">Lijst alle commando's</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">login &lt;user&gt; &lt;pass&gt;</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">Inloggen — gebruikt <strong style="color:#27ae60;">bcrypt (cost=10)</strong></td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">token</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">Huidig auth-token tonen — <strong style="color:#27ae60;">HMAC-SHA256 gesigneerd</strong></td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">whoami</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">Sessie-informatie tonen — geen interne velden, geen CTF-flag</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">hash &lt;waarde&gt;</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">SHA-256 hash berekenen (voor data-integriteit, niet wachtwoorden)</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">verify &lt;token&gt;</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">HMAC-SHA256 handtekening van een token verifi&euml;ren</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">crack &lt;hash&gt;</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">Uitgeschakeld in deze build — bcrypt is niet kwetsbaar voor rainbow tables</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace;">users &lt;token&gt;</td>
                        <td style="padding:8px 12px;">Gebruikerslijst — <strong style="color:#27ae60;">vereist geldig admin-token</strong> (geen MD5-hashes teruggegeven)</td>
                    </tr>
                </tbody>
            </table>
        </div>
        <hr>

        <div class="info-section">
            <h3>Aanbevolen testvolgorde</h3>
            <ol style="font-size:14px; padding-left:20px; line-height:2;">
                <li><code>login admin password123</code> — log in en ontvang een HMAC-gesigneerd token</li>
                <li><code>token</code> — bekijk de structuur: <code>&lt;payload&gt;.&lt;handtekening&gt;</code></li>
                <li><code>verify &lt;token&gt;</code> — verifi&euml;er de handtekening van het token</li>
                <li><code>whoami</code> — sessie-info zonder interne velden</li>
                <li><code>users</code> — zie de toegangsweigering zonder token</li>
                <li><code>users &lt;token&gt;</code> — toegang met geldig token (geen hashes zichtbaar)</li>
                <li><code>crack test</code> — zie dat crack uitgeschakeld is</li>
            </ol>
        </div>
        <hr>

        <div class="info-section">
            <h3>Vergelijking met de kwetsbare versie</h3>
            <table style="width:100%; border-collapse:collapse; font-size:14px;">
                <thead>
                    <tr style="background:#f6f8fa; text-align:left;">
                        <th style="padding:8px 12px; border-bottom:1px solid #e0e0e0;">Onderdeel</th>
                        <th style="padding:8px 12px; border-bottom:1px solid #e0e0e0;">Kwetsbaar</th>
                        <th style="padding:8px 12px; border-bottom:1px solid #e0e0e0;">Veilig</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">Wachtwoord-hashing</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0; color:#e74c3c;">MD5 zonder salt</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0; color:#27ae60;">bcrypt (cost=10)</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">Auth-token</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0; color:#e74c3c;">Base64-only, vervalsbaar</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0; color:#27ae60;">HMAC-SHA256 gesigneerd</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">users-commando</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0; color:#e74c3c;">Geen auth, hashes zichtbaar</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0; color:#27ae60;">Token vereist, geen hashes</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px;">crack-commando</td>
                        <td style="padding:8px 12px; color:#e74c3c;">Rainbow table beschikbaar</td>
                        <td style="padding:8px 12px; color:#27ae60;">Uitgeschakeld</td>
                    </tr>
                </tbody>
            </table>
        </div>

    </div>
</div>

<style>
.btn-help {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 6px 14px;
    background: #7c3aed;
    color: white;
    border: none;
    border-radius: 6px;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    transition: background 0.15s;
}
.btn-help:hover { background: #6d28d9; }
</style>

<script type="text/javascript" src="/static/js/modal.js"></script>
<script>
(function () {
    var openBtn  = document.getElementById('openHelpBtn');
    var closeBtn = document.getElementById('closeHelpBtn');
    var overlay  = document.getElementById('helpModal');
    if (openBtn)  openBtn.onclick = function (e) { e.preventDefault(); overlay.style.display = 'block'; document.body.style.overflow = 'hidden'; };
    if (closeBtn) closeBtn.onclick = function (e) { e.preventDefault(); overlay.style.display = 'none'; document.body.style.overflow = ''; };
    if (overlay)  overlay.onclick = function (e) { if (e.target === overlay) { overlay.style.display = 'none'; document.body.style.overflow = ''; } };
})();
</script>

</body>
</html>
