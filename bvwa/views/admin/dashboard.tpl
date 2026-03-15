<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{.Title}} — BVWA</title>
    <style>
        /* ── Reset & Base ── */
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: Arial, sans-serif;
            background: #f0f2f5;
            color: #333;
        }

        /* ── Header (zelfde als homepage) ── */
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

        /* ── Page Container ── */
        .container {
            max-width: 960px;
            margin: 30px auto;
            padding: 0 20px;
        }

        /* ── Module Badge + Title ── */
        .module-header {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 20px;
        }
        .badge-a01 {
            background: #e67e22;
            color: white;
            font-weight: bold;
            font-size: 13px;
            padding: 6px 14px;
            border-radius: 20px;
        }
        .module-header h1 {
            font-size: 24px;
            color: #2c3e50;
        }

        /* ── INFO Button & Modal ── */
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

        /* Modal Overlay */
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
        .modal h2 {
            color: #2c3e50;
            margin-bottom: 6px;
            font-size: 20px;
        }
        .modal .subtitle {
            color: #7f8c8d;
            font-size: 13px;
            margin-bottom: 20px;
        }
        .modal hr { border: none; border-top: 1px solid #ecf0f1; margin: 16px 0; }

        /* CWE Tags */
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

        /* Info Sections */
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
        .vuln-box ul, .safe-box ul {
            margin: 6px 0 0 18px;
        }
        .vuln-box li, .safe-box li {
            margin-bottom: 4px;
        }

        /* ── Cards ── */
        .cards { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
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
            display: flex;
            align-items: center;
            gap: 8px;
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

        /* Buttons */
        .btn {
            display: inline-block;
            padding: 10px 22px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 14px;
            font-weight: bold;
            color: white;
            border: none;
            cursor: pointer;
            width: 100%;
            text-align: center;
        }
        .btn-red   { background: #e74c3c; }
        .btn-red:hover { background: #c0392b; }
        .btn-green { background: #27ae60; }
        .btn-green:hover { background: #1e8449; }

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

        /* ── Result box (na klik) ── */
        .result-box {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-top: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .result-box h3 { margin-bottom: 10px; color: #2c3e50; }
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

        /* ── Footer ── */
        footer {
            text-align: center;
            padding: 20px;
            color: #aaa;
            font-size: 12px;
            margin-top: 40px;
        }
    </style>
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
