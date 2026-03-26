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
        <a href="/admin/vulnerable">Kwetsbaar</a>
        <a href="/admin/secure">Veilig</a>
    </nav>
</header>

<!-- ── BREADCRUMB ── -->
<div class="breadcrumb">
    <a href="/">Home</a> › A01 › {{.Title}}
</div>

<!-- ── MAIN ── -->
<div class="container">

    <!-- Module Title + Info Button -->
    <div class="module-header">
        <span class="badge-a01">A01</span>
        <h1>Broken Access Control</h1>
        <button class="btn-info" onclick="openModal()">
            ℹ️ Info & CWEs
        </button>
    </div>

    <!-- Cards: Kwetsbaar & Veilig -->
    <div class="cards">

        <!-- KWETSBAAR -->
        <div class="card">
            <div class="card-header vuln">
                ⚠️ Kwetsbare versie
            </div>
            <div class="card-body">
                <p>
                    Deze pagina is bereikbaar <strong>zonder enige
                    rolcontrole</strong>. Elke bezoeker — ook zonder
                    account — kan de admin-pagina openen.
                </p>
                <div class="code-block">
<span class="cmt">// Geen sessiecheck — iedereen door!</span>
<span class="kw">func</span> (c *VulnerableAdmin) <span class="kw">Get</span>() {
    c.TplName = <span class="str">"admin/dashboard.tpl"</span>
}
                </div>
                <a href="/admin/vulnerable" class="btn btn-red">
                    🔓 Open kwetsbare versie
                </a>
            </div>
        </div>

        <!-- VEILIG -->
        <div class="card">
            <div class="card-header safe">
                ✅ Veilige versie
            </div>
            <div class="card-body">
                <p>
                    Deze pagina controleert of de gebruiker een
                    actieve <strong>admin-sessie</strong> heeft.
                    Zonder geldige sessie volgt een redirect.
                </p>
                <div class="code-block">
<span class="cmt">// Sessiecheck vóór toegang</span>
role := c.GetSession(<span class="str">"role"</span>)
<span class="kw">if</span> role == <span class="kw">nil</span> {
    c.Redirect(<span class="str">"/login"</span>, 302)
    <span class="kw">return</span>
}
                </div>
                <a href="/admin/secure" class="btn btn-green">
                    🔒 Open veilige versie
                </a>
            </div>
        </div>
    </div>

    <!-- Result display -->
    {{if .Title}}
    <div class="result-box">
        <h3>Huidige pagina</h3>
        {{if eq .Title "Admin Dashboard (Kwetsbaar)"}}
        <span class="tag-vuln">⚠️ KWETSBAAR</span>
        <p>Je hebt toegang gekregen <strong>zonder sessie of
           rolcontrole</strong>. In een echte applicatie zou een
           aanvaller hiermee volledige beheerderstoegang hebben.</p>
        {{else}}
        <span class="tag-safe">✅ VEILIG</span>
        <p>Toegang <strong>alleen met geldige admin-sessie</strong>.
           Zonder sessie word je automatisch doorgestuurd.</p>
        {{end}}
    </div>
    {{end}}

</div><!-- /container -->

<!-- ── INFO MODAL ── -->
<div class="modal-overlay" id="infoModal">
    <div class="modal">
        <button class="modal-close" onclick="closeModal()">✕</button>

        <h2>ℹ️ A01:2025 — Broken Access Control</h2>
        <p class="subtitle">
            OWASP Top 10:2025 · Positie #1 · 100% van applicaties getroffen
        </p>
        <hr>

        <!-- Wat is het -->
        <div class="info-section">
            <h3>📖 Wat is het?</h3>
            <p>
                Broken Access Control treedt op wanneer een applicatie
                niet correct afdwingt <em>wat gebruikers mogen doen</em>.
                Authenticatie (wie ben jij?) slaagt, maar autorisatie
                (wat mag jij?) faalt. Gebruikers kunnen zo buiten hun
                bedoelde rechten handelen en toegang krijgen tot
                ongeautoriseerde functies of data.
            </p>
        </div>
        <hr>

        <!-- CWEs -->
        <div class="info-section">
            <h3>🏷️ Gerelateerde CWEs</h3>
            <div class="cwe-list">
                <span class="cwe-tag">CWE-22 — Path Traversal</span>
                <span class="cwe-tag">CWE-23 — Relative Path Traversal</span>
                <span class="cwe-tag">CWE-35 — Path Traversal</span>
                <span class="cwe-tag">CWE-59 — Link Following</span>
                <span class="cwe-tag">CWE-200 — Info Exposure</span>
                <span class="cwe-tag">CWE-201 — Sensitive Data in Sent Data</span>
                <span class="cwe-tag">CWE-219 — File in Web Root</span>
                <span class="cwe-tag">CWE-264 — Permissions/Privileges</span>
                <span class="cwe-tag">CWE-275 — Permission Issues</span>
                <span class="cwe-tag">CWE-276 — Incorrect Default Permissions</span>
                <span class="cwe-tag">CWE-284 — Improper Access Control</span>
                <span class="cwe-tag">CWE-285 — Improper Authorization</span>
                <span class="cwe-tag">CWE-352 — CSRF</span>
                <span class="cwe-tag">CWE-359 — Privacy Violation</span>
                <span class="cwe-tag">CWE-377 — Insecure Temp File</span>
                <span class="cwe-tag">CWE-402 — Transmission of Private Resources</span>
                <span class="cwe-tag">CWE-425 — Direct Request (Forced Browsing)</span>
                <span class="cwe-tag">CWE-441 — Unintended Proxy</span>
                <span class="cwe-tag">CWE-497 — Exposure of System Data</span>
                <span class="cwe-tag">CWE-538 — File/Path in Error Message</span>
                <span class="cwe-tag">CWE-540 — Source Code in Package</span>
                <span class="cwe-tag">CWE-548 — Directory Listing</span>
                <span class="cwe-tag">CWE-552 — Files Accessible to External Parties</span>
                <span class="cwe-tag">CWE-566 — Authorization Bypass via User-Controlled SQL</span>
                <span class="cwe-tag">CWE-601 — Open Redirect</span>
                <span class="cwe-tag">CWE-639 — IDOR</span>
                <span class="cwe-tag">CWE-651 — Exposure of WSDL</span>
                <span class="cwe-tag">CWE-668 — Exposure to Wrong Sphere</span>
                <span class="cwe-tag">CWE-706 — Incorrect Resource Resolution</span>
                <span class="cwe-tag">CWE-862 — Missing Authorization</span>
                <span class="cwe-tag">CWE-863 — Incorrect Authorization</span>
                <span class="cwe-tag">CWE-913 — Improper Control of Dynamically-Managed Code</span>
                <span class="cwe-tag">CWE-922 — Insecure Storage of Sensitive Info</span>
                <span class="cwe-tag">CWE-1275 — Sensitive Cookie without SameSite</span>
            </div>
        </div>
        <hr>

        <!-- Waarom kwetsbaar -->
        <div class="info-section">
            <h3>🔴 Waarom is de kwetsbare versie onveilig?</h3>
            <div class="vuln-box">
                De kwetsbare controller voert <strong>geen enkele
                controle</strong> uit vóór het tonen van de
                admin-pagina:
                <ul>
                    <li>Er wordt niet gecontroleerd of de gebruiker
                        is ingelogd</li>
                    <li>Er wordt niet gecontroleerd of de gebruiker
                        de rol "admin" heeft</li>
                    <li>Elke bezoeker met de URL heeft directe
                        toegang (Forced Browsing — CWE-425)</li>
                    <li>Een aanvaller hoeft alleen de URL te raden
                        om volledige beheerderstoegang te krijgen</li>
                </ul>
            </div>
        </div>
        <hr>

        <!-- Waarom veilig -->
        <div class="info-section">
            <h3>🟢 Waarom is de veilige versie correct?</h3>
            <div class="safe-box">
                De veilige controller past
                <strong>server-side autorisatie</strong> toe:
                <ul>
                    <li>Controleert eerst of er een sessie bestaat
                        (<code>GetSession("role")</code>)</li>
                    <li>Controleert of de sessiewaarde gelijk is
                        aan <code>"admin"</code></li>
                    <li>Bij ontbrekende of verkeerde sessie:
                        redirect naar login (fail-closed)</li>
                    <li>Sessie wordt server-side beheerd — niet
                        manipuleerbaar door de client</li>
                    <li>Type assertion voorkomt nil pointer
                        crashes</li>
                </ul>
            </div>
        </div>
        <hr>

        <!-- Mitigatie -->
        <div class="info-section">
            <h3>🛡️ Mitigatie</h3>
            <p>
                Implementeer toegangscontrole server-side voor
                elke beveiligde route. Gebruik het
                <em>deny-by-default</em> principe: weiger toegang
                tenzij expliciet toegestaan. Log alle
                autorisatiefouten en stel alerts in bij herhaalde
                schendingen.
            </p>
        </div>

    </div><!-- /modal -->
</div><!-- /modal-overlay -->

<footer>
    ⚠️ BVWA is uitsluitend bedoeld voor educatieve doeleinden —
    gebruik alleen in een geïsoleerde testomgeving.
</footer>

<script>
    function openModal()  {
        document.getElementById('infoModal')
            .classList.add('active');
        document.body.style.overflow = 'hidden';
    }
    function closeModal() {
        document.getElementById('infoModal')
            .classList.remove('active');
        document.body.style.overflow = '';
    }
    // Sluit modal bij klik buiten het modal venster
    document.getElementById('infoModal')
        .addEventListener('click', function(e) {
        if (e.target === this) closeModal();
    });
    // Sluit modal met Escape toets
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') closeModal();
    });
</script>

</body>
</html>
