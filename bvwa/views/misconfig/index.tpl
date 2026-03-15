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
        .badge-a02 {
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

        /* Header table */
        .header-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 12px;
            margin-bottom: 16px;
        }
        .header-table th {
            background: #ecf0f1;
            padding: 6px 10px;
            text-align: left;
            color: #555;
            font-weight: bold;
        }
        .header-table td {
            padding: 6px 10px;
            border-bottom: 1px solid #f0f0f0;
        }
        .present { color: #27ae60; font-weight: bold; }
        .absent  { color: #e74c3c; font-weight: bold; }

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
</head>
<body>

<!-- ── HEADER ── -->
<header>
    <a href="/" class="logo">🔐 <span>BVWA</span></a>
    <nav>
        <a href="/">🏠 Home</a>
        <a href="/misconfig/vulnerable">Kwetsbaar</a>
        <a href="/misconfig/secure">Veilig</a>
    </nav>
</header>

<!-- ── BREADCRUMB ── -->
<div class="breadcrumb">
    <a href="/">Home</a> › A02 › {{.Title}}
</div>

<!-- ── MAIN ── -->
<div class="container">

    <!-- Module title + Info button -->
    <div class="module-header">
        <span class="badge-a02">A02</span>
        <h1>Security Misconfiguration</h1>
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
                    Geen security headers in de HTTP response.
                    De browser krijgt <strong>geen instructies</strong>
                    over hoe de pagina veilig geladen moet worden.
                </p>

                <table class="header-table">
                    <tr>
                        <th>Header</th>
                        <th>Status</th>
                    </tr>
                    <tr>
                        <td>X-Content-Type-Options</td>
                        <td class="absent">✗ Ontbreekt</td>
                    </tr>
                    <tr>
                        <td>X-Frame-Options</td>
                        <td class="absent">✗ Ontbreekt</td>
                    </tr>
                    <tr>
                        <td>Content-Security-Policy</td>
                        <td class="absent">✗ Ontbreekt</td>
                    </tr>
                    <tr>
                        <td>Strict-Transport-Security</td>
                        <td class="absent">✗ Ontbreekt</td>
                    </tr>
                </table>

                <div class="code-block">
<span class="cmt">// Geen headers — kwetsbaar</span>
<span class="kw">func</span> (c *VulnerableMisconfig) <span class="kw">Get</span>() {
    c.TplName = <span class="str">"misconfig/index.tpl"</span>
}
                </div>
                <a href="/misconfig/vulnerable" class="btn btn-red">
                    🔓 Open kwetsbare versie
                </a>
            </div>
        </div>

        <!-- VEILIG -->
        <div class="card">
            <div class="card-header safe">✅ Veilige versie</div>
            <div class="card-body">
                <p>
                    Alle essentiële security headers worden
                    <strong>per response ingesteld</strong>.
                    De browser weet exact wat wel en niet is
                    toegestaan.
                </p>

                <table class="header-table">
                    <tr>
                        <th>Header</th>
                        <th>Status</th>
                    </tr>
                    <tr>
                        <td>X-Content-Type-Options</td>
                        <td class="present">✓ nosniff</td>
                    </tr>
                    <tr>
                        <td>X-Frame-Options</td>
                        <td class="present">✓ DENY</td>
                    </tr>
                    <tr>
                        <td>Content-Security-Policy</td>
                        <td class="present">✓ default-src 'self'</td>
                    </tr>
                    <tr>
                        <td>Strict-Transport-Security</td>
                        <td class="present">✓ max-age=63072000</td>
                    </tr>
                </table>

                <div class="code-block">
<span class="cmt">// Veilig: headers instellen</span>
h := c.Ctx.ResponseWriter.Header()
h.Set(<span class="str">"X-Content-Type-Options"</span>,
      <span class="str">"nosniff"</span>)
h.Set(<span class="str">"X-Frame-Options"</span>,
      <span class="str">"DENY"</span>)
                </div>
                <a href="/misconfig/secure" class="btn btn-green">
                    🔒 Open veilige versie
                </a>
            </div>
        </div>
    </div>

    <!-- Result box -->
    <div class="result-box">
        <h3>🔍 Huidige pagina: <strong>{{.Title}}</strong></h3>

        {{if eq .Title "Security Misconfiguration (Kwetsbaar)"}}
        <span class="tag-vuln">⚠️ KWETSBAAR</span>
        <p>Deze response bevat <strong>geen security headers</strong>.
           Inspecteer via F12 → Network → Response Headers om dit
           te bevestigen.</p>
        {{else}}
        <span class="tag-safe">✅ VEILIG</span>
        <p>Deze response bevat <strong>alle security headers</strong>.
           Inspecteer via F12 → Network → Response Headers om de
           headers te zien.</p>
        {{end}}

        <div class="tip">
            💡 <strong>Tip:</strong> Open DevTools (F12) →
            Network → klik op dit verzoek → Response Headers
            om het verschil te zien tussen de kwetsbare en
            veilige versie.
        </div>
    </div>

</div>

<!-- ── INFO MODAL ── -->
<div class="modal-overlay" id="infoModal">
    <div class="modal">
        <button class="modal-close" onclick="closeModal()">✕</button>

        <h2>ℹ️ A02:2025 — Security Misconfiguration</h2>
        <p class="subtitle">
            OWASP Top 10:2025 · Positie #2 · 100% van applicaties getroffen
        </p>
        <hr>

        <!-- Wat is het -->
        <div class="info-section">
            <h3>📖 Wat is het?</h3>
            <p>
                Security Misconfiguration treedt op wanneer een
                systeem, applicatie of cloudservice onjuist is
                geconfigureerd vanuit een beveiligingsperspectief.
                Denk aan ontbrekende security headers, standaard
                credentials, onnodige features, of foutmeldingen
                die interne details lekken. Het is de meest
                voorkomende kwetsbaarheid — gevonden in 100% van
                de geteste applicaties.
            </p>
        </div>
        <hr>

        <!-- CWEs -->
        <div class="info-section">
            <h3>🏷️ Gerelateerde CWEs</h3>
            <div class="cwe-list">
                <span class="cwe-tag">CWE-2 — 7PK - Environment</span>
                <span class="cwe-tag">CWE-11 — ASP.NET Misconfiguration: Debug Binary</span>
                <span class="cwe-tag">CWE-13 — ASP.NET Misconfiguration: Password in Config</span>
                <span class="cwe-tag">CWE-15 — External Control of System/Config Setting</span>
                <span class="cwe-tag">CWE-16 — Configuration</span>
                <span class="cwe-tag">CWE-260 — Password in Config File</span>
                <span class="cwe-tag">CWE-315 — Plaintext Storage in Cookie</span>
                <span class="cwe-tag">CWE-520 — .NET Misconfiguration: Use of Impersonation</span>
                <span class="cwe-tag">CWE-526 — Cleartext Storage of Sensitive Info in Env</span>
                <span class="cwe-tag">CWE-537 — Java Runtime Error Message Containing Sensitive Info</span>
                <span class="cwe-tag">CWE-541 — Sensitive Info in Include File</span>
                <span class="cwe-tag">CWE-547 — Use of Hard-coded, Security-relevant Constants</span>v
