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

        /* Scorebalk */
        .score-bar-wrap {
            background: white;
            border-radius: 10px;
            padding: 20px 24px;
            margin-bottom: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .score-label {
            font-size: 15px;
            font-weight: bold;
            color: #2c3e50;
            white-space: nowrap;
        }
        .score-count {
            font-size: 22px;
            font-weight: bold;
            color: #e67e22;
        }
        .progress-track {
            flex: 1;
            background: #ecf0f1;
            border-radius: 20px;
            height: 14px;
            overflow: hidden;
        }
        .progress-fill {
            height: 100%;
            background: #e67e22;
            border-radius: 20px;
            transition: width 0.4s ease;
        }

        /* Submit box */
        .submit-card {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-bottom: 24px;
        }
        .submit-card .card-header {
            background: #2c3e50;
            color: white;
            padding: 14px 20px;
            font-weight: bold;
            font-size: 15px;
        }
        .submit-card .card-body {
            padding: 20px;
            display: flex;
            gap: 10px;
            align-items: flex-end;
        }
        .submit-card .card-body .input-group {
            flex: 1;
            margin-bottom: 0;
        }
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
            font-family: monospace;
        }
        .input-group input:focus {
            outline: none;
            border-color: #3498db;
        }
        .btn-submit {
            padding: 10px 24px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: bold;
            color: white;
            cursor: pointer;
            background: #e67e22;
            white-space: nowrap;
        }
        .btn-submit:hover { background: #ca6f1e; }

        .msg-success {
            background: #eafaf1;
            border: 1px solid #27ae60;
            border-radius: 6px;
            padding: 10px 16px;
            font-size: 14px;
            color: #1e8449;
            margin-top: 10px;
        }
        .msg-error {
            background: #fdecea;
            border: 1px solid #e74c3c;
            border-radius: 6px;
            padding: 10px 16px;
            font-size: 14px;
            color: #c0392b;
            margin-top: 10px;
        }
        .msg-info {
            background: #eaf4fb;
            border: 1px solid #3498db;
            border-radius: 6px;
            padding: 10px 16px;
            font-size: 14px;
            color: #1a5276;
            margin-top: 10px;
        }

        /* Challenge grid */
        .challenges {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        @media (max-width: 640px) {
            .challenges { grid-template-columns: 1fr; }
            .submit-card .card-body { flex-direction: column; }
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
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .card-header.solved  { background: #27ae60; }
        .card-header.unsolved { background: #7f8c8d; }
        .card-header .status-icon { font-size: 18px; }
        .card-body { padding: 20px; }
        .card-body p {
            font-size: 14px;
            color: #555;
            line-height: 1.6;
            margin-bottom: 10px;
        }

        .hint-box {
            background: #f8f9fa;
            border-left: 3px solid #e67e22;
            border-radius: 0 6px 6px 0;
            padding: 10px 14px;
            font-size: 13px;
            color: #555;
            margin-top: 10px;
        }
        .hint-box strong { color: #e67e22; }

        .tag-solved {
            display: inline-block;
            background: #eafaf1;
            color: #27ae60;
            font-weight: bold;
            font-size: 12px;
            padding: 3px 10px;
            border-radius: 20px;
        }
        .tag-open {
            display: inline-block;
            background: #f8f9fa;
            color: #7f8c8d;
            font-weight: bold;
            font-size: 12px;
            padding: 3px 10px;
            border-radius: 20px;
        }

        footer {
            text-align: center;
            padding: 20px;
            color: #aaa;
            font-size: 12px;
            margin-top: 40px;
        }

        /* Modal */
        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
            justify-content: center;
            align-items: flex-start;
            padding: 40px 20px;
            overflow-y: auto;
        }
        .modal-overlay.active { display: flex; }
        .modal {
            background: white;
            border-radius: 12px;
            padding: 30px;
            max-width: 600px;
            width: 100%;
            position: relative;
        }
        .modal h2 { font-size: 20px; color: #2c3e50; margin-bottom: 6px; }
        .modal .subtitle { font-size: 13px; color: #888; margin-bottom: 16px; }
        .modal hr { border: none; border-top: 1px solid #ecf0f1; margin: 16px 0; }
        .modal-close {
            position: absolute;
            top: 16px; right: 16px;
            background: #ecf0f1;
            border: none;
            border-radius: 50%;
            width: 30px; height: 30px;
            font-weight: bold;
            cursor: pointer;
            font-size: 14px;
            color: #2c3e50;
        }
        .modal-close:hover { background: #e74c3c; color: white; }
        .info-section h3 { font-size: 15px; color: #2c3e50; margin-bottom: 8px; }
        .info-section p  { font-size: 14px; color: #555; line-height: 1.6; }
        .info-section ul { padding-left: 18px; font-size: 14px; color: #555; line-height: 1.8; }

        .tip {
            background: #fef9e7;
            border: 1px solid #f39c12;
            border-radius: 6px;
            padding: 12px 16px;
            font-size: 13px;
            color: #7d6608;
            margin-top: 16px;
        }
    </style>
</head>
<body>

<header>
    <a class="logo" href="/dashboard">BVW<span>A</span></a>
    <nav>
        <a href="/dashboard">Dashboard</a>
        <a href="/ctf">CTF</a>
        <a href="/logout">Uitloggen</a>
    </nav>
</header>

<div class="breadcrumb">
    <a href="/dashboard">Home</a> &rsaquo; CTF Scorebord
</div>

<div class="container">

    <!-- Module header -->
    <div class="module-header">
        <span class="badge">CTF</span>
        <h1>Capture The Flag</h1>
        <button class="btn-info" id="openInfoBtn">Info</button>
    </div>

    <!-- Scorebalk -->
    <div class="score-bar-wrap">
        <div>
            <div class="score-label">Gevonden flags</div>
            <div class="score-count" id="scoreCount">{{.SolvedCount}} / {{.Total}}</div>
        </div>
        <div class="progress-track">
            <div class="progress-fill" id="progressFill"
                 style="width: {{.Percent}}%"></div>
        </div>
    </div>

    <!-- Submit box -->
    <div class="submit-card">
        <div class="card-header">Flag submitten</div>
        <div class="card-body">
            <div class="input-group">
                <label for="flagInput">Gevonden flag:</label>
                <input type="text" id="flagInput" placeholder="BVWA{...}" autocomplete="off">
            </div>
            <button class="btn-submit" onclick="submitFlag()">Submitten</button>
        </div>
        <div id="submitResult" style="padding: 0 20px 16px;"></div>
    </div>

    <!-- Challenge kaarten -->
    <div class="challenges">
        {{range .Challenges}}
        <div class="card" id="card-{{.flag}}">
            {{if index $.SolvedMap .flag}}
            <div class="card-header solved">
                {{.name}}
                <span class="status-icon">&#10003;</span>
            </div>
            <div class="card-body">
                <span class="tag-solved">Opgelost</span>
                <p>Goed gedaan! Je hebt deze kwetsbaarheid gevonden.</p>
                <div class="hint-box">
                    <strong>Hint:</strong> {{.hint}}
                </div>
            </div>
            {{else}}
            <div class="card-header unsolved">
                {{.name}}
                <span class="status-icon">&#63;</span>
            </div>
            <div class="card-body">
                <span class="tag-open">Nog open</span>
                <p>Vind de kwetsbaarheid en submit de flag.</p>
                <div class="hint-box">
                    <strong>Hint:</strong> {{.hint}}
                </div>
            </div>
            {{end}}
        </div>
        {{end}}
    </div>

    <div class="tip">
        Tip: Flags hebben het formaat <strong>BVWA{...}</strong>. Verken de kwetsbare versies van
        elke module — kijk in paginabron, cookies, response headers en network requests.
    </div>

</div>

<!-- INFO MODAL -->
<div class="modal-overlay" id="infoModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeInfoBtn">X</button>
        <h2>Capture The Flag — BVWA</h2>
        <p class="subtitle">Vind verborgen flags in de kwetsbare modules van de applicatie</p>
        <hr>

        <div class="info-section">
            <h3>Wat is CTF?</h3>
            <p>
                Capture The Flag (CTF) is een leervorm waarbij je kwetsbaarheden exploiteert
                om verborgen "flags" te vinden. In BVWA zijn flags verstopt in de kwetsbare
                versies van elke module. Ze hebben altijd het formaat <strong>BVWA{...}</strong>.
            </p>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waar zoek ik?</h3>
            <ul>
                <li>Paginabron (HTML comments)</li>
                <li>Cookies (Developer Tools → Application)</li>
                <li>Response headers (Developer Tools → Network)</li>
                <li>Server responses bij specifieke input</li>
                <li>Publiek toegankelijke bestanden</li>
            </ul>
        </div>
        <hr>

        <div class="info-section">
            <h3>Modules met een flag</h3>
            <ul>
                <li><strong>Access Control</strong> — bekijk de paginabron als niet-admin</li>
                <li><strong>Cryptografie</strong> — inspecteer je cookies na inloggen</li>
                <li><strong>SQL Injection</strong> — probeer een UNION payload</li>
                <li><strong>Insecure Design</strong> — is er een verborgen API-endpoint?</li>
                <li><strong>Data Integrity</strong> — upload een onverwacht bestandstype</li>
                <li><strong>Authentication</strong> — probeer meer dan 10 keer in te loggen</li>
                <li><strong>Misconfiguratie</strong> — zijn er openbare statische bestanden?</li>
            </ul>
        </div>
    </div>
</div>

<footer>
    BVWA is uitsluitend bedoeld voor educatieve doeleinden —
    gebruik alleen in een geïsoleerde testomgeving.
</footer>

<script type="text/javascript">
async function submitFlag() {
    const flag = document.getElementById('flagInput').value.trim();
    const resultEl = document.getElementById('submitResult');

    if (!flag) {
        resultEl.innerHTML = '<div class="msg-error">Voer een flag in.</div>';
        return;
    }

    const res = await fetch('/ctf/submit', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'flag=' + encodeURIComponent(flag)
    });
    const data = await res.json();

    if (data.status === 'correct') {
        resultEl.innerHTML = '<div class="msg-success">Correct! Flag gevonden: <strong>' + data.name + '</strong></div>';
        document.getElementById('flagInput').value = '';
        setTimeout(() => location.reload(), 1200);
    } else if (data.status === 'already_found') {
        resultEl.innerHTML = '<div class="msg-info">Al gevonden: <strong>' + data.name + '</strong></div>';
    } else if (data.status === 'unauthorized') {
        resultEl.innerHTML = '<div class="msg-error">Je bent niet ingelogd.</div>';
    } else {
        resultEl.innerHTML = '<div class="msg-error">Onjuiste flag — probeer opnieuw.</div>';
    }
}

document.getElementById('flagInput').addEventListener('keydown', function(e) {
    if (e.key === 'Enter') submitFlag();
});

document.getElementById('openInfoBtn').addEventListener('click', function() {
    document.getElementById('infoModal').classList.add('active');
});
document.getElementById('closeInfoBtn').addEventListener('click', function() {
    document.getElementById('infoModal').classList.remove('active');
});
document.getElementById('infoModal').addEventListener('click', function(e) {
    if (e.target === this) this.classList.remove('active');
});
</script>

</body>
</html>
