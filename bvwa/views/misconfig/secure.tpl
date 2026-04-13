<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Security Misconfiguration (Veilig) — BVWA</title>
    <link rel="stylesheet" href="/static/css/bvwa.css">
</head>
<body>

<header>
    <a href="/" class="logo">&#x1F510; <span>BVWA</span></a>
    <nav>
        <a href="/">&#x1F3E0; Home</a>
        <a href="/misconfig/vulnerable">Kwetsbaar</a>
        <a href="/misconfig/secure">Veilig</a>
    </nav>
</header>

<div class="breadcrumb">
    <a href="/">Home</a> &rsaquo; A02 &rsaquo; Security Misconfiguration (Veilig)
</div>

<div class="container">

    <div class="module-header">
        <span class="badge">A02</span>
        <h1>Security Misconfiguration</h1>
        <button type="button" class="btn-info" id="openInfoBtn">Info &amp; CWEs</button>
        <button type="button" class="btn-examples" id="openExamplesBtn">Echte Voorbeelden</button>
        <button type="button" class="btn-help" id="openHelpBtn">Hulp &amp; Commando&rsquo;s</button>
    </div>

    <div class="cards">

        <!-- Veilig: console uitgeschakeld -->
        <div class="card">
            <div class="card-header safe">Debug Console — Uitgeschakeld</div>
            <div class="card-body">
                <p>
                    Het diagnostics-endpoint is in de veilige versie
                    <strong>niet bereikbaar</strong>. Debug-functionaliteit
                    hoort nooit openbaar toegankelijk te zijn in productie.
                </p>
                <div class="code-block">// VEILIG: debug endpoint verwijderd
// Gebruik authenticatie + IP-allowlist
// als diagnostics echt nodig is</div>
            </div>
        </div>

        <!-- Veilig: security headers -->
        <div class="card">
            <div class="card-header safe">Security Headers — Aanwezig</div>
            <div class="card-body">
                <p>
                    Alle essenti&euml;le security headers worden per response
                    ingesteld. Inspecteer via F12 &rarr; Network &rarr;
                    Response Headers om ze te zien.
                </p>

                <table class="header-table">
                    <tr>
                        <th>Header</th>
                        <th>Waarde</th>
                    </tr>
                    <tr>
                        <td>X-Content-Type-Options</td>
                        <td class="cell-present">nosniff</td>
                    </tr>
                    <tr>
                        <td>X-Frame-Options</td>
                        <td class="cell-present">DENY</td>
                    </tr>
                    <tr>
                        <td>Content-Security-Policy</td>
                        <td class="cell-present">default-src 'self'</td>
                    </tr>
                    <tr>
                        <td>Strict-Transport-Security</td>
                        <td class="cell-present">max-age=63072000</td>
                    </tr>
                    <tr>
                        <td>Referrer-Policy</td>
                        <td class="cell-present">strict-origin-when-cross-origin</td>
                    </tr>
                    <tr>
                        <td>Permissions-Policy</td>
                        <td class="cell-present">geolocation=(), microphone=()</td>
                    </tr>
                    <tr>
                        <td>X-Powered-By</td>
                        <td class="cell-absent">Ontbreekt (bewust verwijderd)</td>
                    </tr>
                    <tr>
                        <td>Server</td>
                        <td class="cell-absent">Ontbreekt (bewust verwijderd)</td>
                    </tr>
                </table>

                <div class="code-block">// VEILIG: security headers instellen
h := c.Ctx.ResponseWriter.Header()
h.Set("X-Content-Type-Options", "nosniff")
h.Set("X-Frame-Options", "DENY")
h.Set("Content-Security-Policy", "default-src 'self'")
h.Set("Strict-Transport-Security", "max-age=63072000; includeSubDomains")</div>
            </div>
        </div>

    </div>

    <div class="result-box">
        <h3>&#x1F50D; Huidige pagina: <strong>Security Misconfiguration (Veilig)</strong></h3>
        <span class="tag-safe">VEILIG</span>
        <p>
            De debug console is uitgeschakeld en alle security headers zijn
            aanwezig. Vergelijk de Response Headers via F12 &rarr; Network
            met de kwetsbare versie om het verschil te zien.
        </p>
    </div>

</div>

<!-- ECHTE VOORBEELDEN MODAL -->
<div class="modal-overlay" id="examplesModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeExamplesBtn">X</button>
        <h2>Echte Voorbeelden — Security Misconfiguration</h2>
        <p class="subtitle">Historische incidenten veroorzaakt door verkeerde configuratie</p>
        <hr>

        <div class="example-item">
            <h4><span class="example-year">2019</span> Capital One — Misconfigured AWS WAF</h4>
            <p>Een oud-Amazon medewerker exploiteerde een verkeerd geconfigureerde AWS WAF via SSRF.
            De WAF had te ruime permissies waardoor IAM-credentials konden worden gestolen.</p>
            <p class="example-impact">Impact: 106 miljoen klantgegevens gelekt &mdash; boete van $80 miljoen</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2021</span> Microsoft Exchange ProxyLogon</h4>
            <p>Verkeerd geconfigureerde Exchange-servers (CVE-2021-26855) werden massaal aangevallen.
            Aanvallers installeerden web shells voor persistente toegang.</p>
            <p class="example-impact">Impact: 250.000+ servers gecompromitteerd in de eerste dagen</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2020</span> SolarWinds — Standaard Wachtwoord op GitHub</h4>
            <p>Het FTP-wachtwoord "solarwinds123" stond maanden openbaar op GitHub zonder dat
            iemand het opmerkte.</p>
            <p class="example-impact">Impact: 18.000+ organisaties gecompromitteerd</p>
        </div>
    </div>
</div>

<!-- INFO MODAL -->
<div class="modal-overlay" id="infoModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeInfoBtn">X</button>
        <h2>A02:2025 — Security Misconfiguration</h2>
        <p class="subtitle">OWASP Top 10:2025 &mdash; Positie #2 &mdash; 100% van applicaties getroffen</p>
        <hr>

        <div class="info-section">
            <h3>Wat is het?</h3>
            <p>Security Misconfiguration treedt op wanneer een systeem onjuist is geconfigureerd.
            Blootgestelde debug-endpoints, ontbrekende security headers, standaard credentials
            en onnodige features zijn de meest voorkomende oorzaken.</p>
        </div>
        <hr>

        <div class="info-section">
            <h3>Gerelateerde CWEs</h3>
            <div class="cwe-list">
                <span class="cwe-tag">CWE-16 Configuration</span>
                <span class="cwe-tag">CWE-260 Password in Config File</span>
                <span class="cwe-tag">CWE-526 Sensitive Info in Environment</span>
                <span class="cwe-tag">CWE-614 Sensitive Cookie Without Secure Attribute</span>
                <span class="cwe-tag">CWE-942 Permissive Cross-domain Policy</span>
                <span class="cwe-tag">CWE-1021 Improper Restriction of Rendered UI Layers</span>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Mitigatie</h3>
            <div class="safe-box">
                <ul>
                    <li>Verwijder debug-endpoints in productie of beveilig ze met auth + IP-allowlist</li>
                    <li>Stel security headers in via centrale middleware</li>
                    <li>Verwijder X-Powered-By en Server headers</li>
                    <li>Gebruik secrets management voor credentials (nooit in omgevingsvariabelen)</li>
                    <li>Automatiseer configuratiecontroles in CI/CD</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<footer>
    BVWA is uitsluitend bedoeld voor educatieve doeleinden &mdash;
    gebruik alleen in een gei&euml;soleerde testomgeving.
</footer>

<!-- HULP MODAL -->
<div class="modal-overlay" id="helpModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeHelpBtn">X</button>
        <h2>Hulp — A02 Security Misconfiguration (Veilig)</h2>
        <p class="subtitle">Wat te inspecteren op de veilige versie</p>
        <hr>

        <div class="info-section">
            <h3>Debug console — uitgeschakeld</h3>
            <p>De veilige versie heeft <strong>geen terminal</strong>. Het diagnostics-endpoint is volledig
            verwijderd. Op de <a href="/misconfig/vulnerable" style="color:#3b82f6;">kwetsbare versie</a>
            zijn de volgende commando's beschikbaar:</p>
            <table style="width:100%; border-collapse:collapse; font-size:14px; margin-top:8px;">
                <thead>
                    <tr style="background:#f6f8fa; text-align:left;">
                        <th style="padding:8px 12px; border-bottom:1px solid #e0e0e0;">Commando</th>
                        <th style="padding:8px 12px; border-bottom:1px solid #e0e0e0;">Wat het lekte</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">env</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">DB-credentials en CTF-flag in omgevingsvariabelen</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">cat bvwa.conf</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">Volledige databaseconfiguratie inclusief wachtwoord</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">cat secret.txt</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">Direct de CTF-flag</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace;">whoami / id</td>
                        <td style="padding:8px 12px;">Server draaide als <code>root</code></td>
                    </tr>
                </tbody>
            </table>
        </div>
        <hr>

        <div class="info-section">
            <h3>Security headers — inspecteren via DevTools</h3>
            <p>Open <strong>F12 &rarr; Network &rarr; klik op de pagina-request &rarr; Response Headers</strong>
            om te controleren welke headers aanwezig zijn. Vergelijk kwetsbaar vs. veilig:</p>
            <table style="width:100%; border-collapse:collapse; font-size:14px; margin-top:8px;">
                <thead>
                    <tr style="background:#f6f8fa; text-align:left;">
                        <th style="padding:8px 12px; border-bottom:1px solid #e0e0e0;">Header</th>
                        <th style="padding:8px 12px; border-bottom:1px solid #e0e0e0;">Kwetsbaar</th>
                        <th style="padding:8px 12px; border-bottom:1px solid #e0e0e0;">Veilig</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">X-CTF-Flag</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0; color:#e74c3c;">Aanwezig (CTF-flag zichtbaar)</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0; color:#27ae60;">Afwezig</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">X-Powered-By</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0; color:#e74c3c;">Go/1.21 Beego/2.0.7 (debug)</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0; color:#27ae60;">Afwezig</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">Content-Security-Policy</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0; color:#e74c3c;">Afwezig</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0; color:#27ae60;">default-src 'self'</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace;">X-Frame-Options</td>
                        <td style="padding:8px 12px; color:#e74c3c;">Afwezig</td>
                        <td style="padding:8px 12px; color:#27ae60;">DENY</td>
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
