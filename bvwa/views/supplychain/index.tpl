<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{.Title}} — BVWA</title>
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
        <button type="button" class="btn-info" id="openInfoBtn">
            ℹ️ Info &amp; CWEs
        </button>
        <button type="button" class="btn-examples" id="openExamplesBtn">
            Echte Voorbeelden
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

<!-- ECHTE VOORBEELDEN MODAL -->
<div class="modal-overlay" id="examplesModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeExamplesBtn">✕</button>

        <h2>Echte Voorbeelden — Software Supply Chain Failures</h2>
        <p class="subtitle">
            Historische incidenten waarbij de supplychain als aanvalsvector diende
        </p>
        <hr>

        <div class="example-item">
            <h4>
                <span class="example-year">2020</span>
                SolarWinds SUNBURST
            </h4>
            <p>
                Aanvallers infiltreerden het buildsysteem van SolarWinds en voegden de
                SUNBURST-backdoor toe aan een legitieme software-update van Orion. De update
                werd digitaal ondertekend met een geldig certificaat. Slachtoffers installeerden
                de update vrijwillig, waarna aanvallers 9 maanden onopgemerkt actief waren.
            </p>
            <p class="example-impact">Impact: 18.000+ organisaties, inclusief US Treasury en NATO &mdash; grootste supplychain-aanval ooit</p>
        </div>

        <div class="example-item">
            <h4>
                <span class="example-year">2024</span>
                XZ Utils Backdoor (CVE-2024-3094)
            </h4>
            <p>
                "Jia Tan" bouwde gedurende 2 jaar vertrouwen op als open-source maintainer
                van xz-utils. Vlak voor de release voegde hij een verborgen backdoor toe in
                liblzma die via systemd SSH-authenticatie zou omzeilen. Toevallig ontdekt
                door Microsoft-engineer Andres Freund, die een vertraging van 500ms in SSH
                opmerkte.
            </p>
            <p class="example-impact">Impact: Bijna alle Linux-servers wereldwijd kwetsbaar &mdash; ontdekt op het nippertje</p>
        </div>

        <div class="example-item">
            <h4>
                <span class="example-year">2018</span>
                Event-Stream npm Package
            </h4>
            <p>
                Een aanvaller nam de maintainer-rol over van de populaire npm-package
                "event-stream" (11 miljoen downloads/week) door aan te bieden het onderhoud
                over te nemen. De nieuwe versie bevatte verborgen code die specifiek de
                Copay Bitcoin-wallet aanviel om private keys te stelen.
            </p>
            <p class="example-impact">Impact: Miljoenen npm-installaties getroffen; Bitcoin-wallets gecompromitteerd</p>
        </div>

        <div class="example-item">
            <h4>
                <span class="example-year">2021</span>
                CodeCov Supplychain Aanval
            </h4>
            <p>
                Aanvallers wijzigden het Docker-image van CodeCov (code coverage tool) en
                voegden code toe die environment variables uit CI/CD-omgevingen stal.
                Duizenden bedrijven die CodeCov integreerden in hun pipelines stuurden
                onbewust hun secrets (API keys, tokens) naar de aanvallers.
            </p>
            <p class="example-impact">Impact: Twilio, Twitch en HashiCorp onder de getroffen bedrijven</p>
        </div>

    </div>
</div>

<!-- ── INFO MODAL ── -->
<div class="modal-overlay" id="infoModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeInfoBtn">✕</button>

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
