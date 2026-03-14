<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <title>{{.Title}}</title>
    <style>
        body { font-family: Arial, sans-serif; 
               max-width: 900px; margin: 40px auto; }
        .card { border: 1px solid #ccc; padding: 15px; 
                margin: 10px 0; border-radius: 8px; }
        .card h3 { margin: 0 0 8px; }
        a.btn { padding: 6px 12px; margin-right: 8px;
                text-decoration: none; border-radius: 4px; 
                color: white; }
        .vuln { background: #e74c3c; }
        .safe { background: #2ecc71; }
        header { background: #2c3e50; color: white; 
                 padding: 20px; border-radius: 8px; 
                 margin-bottom: 20px; }
    </style>
</head>
<body>
    <header>
        <h1>🔐 BVWA</h1>
        <p>Beego Vulnerable Web Application — OWASP Top 10:2025</p>
    </header>

    <div class="card">
        <h3>A01 — Broken Access Control</h3>
        <p>Toegangscontrole wordt niet correct afgedwongen.</p>
        <a class="btn vuln" href="/admin/vulnerable">Kwetsbaar</a>
        <a class="btn safe" href="/admin/secure">Veilig</a>
    </div>

    <div class="card">
        <h3>A02 — Security Misconfiguration</h3>
        <p>Ontbrekende of verkeerde security headers.</p>
        <a class="btn vuln" href="/misconfig/vulnerable">Kwetsbaar</a>
        <a class="btn safe" href="/misconfig/secure">Veilig</a>
    </div>

    <div class="card">
        <h3>A03 — Software Supply Chain Failures</h3>
        <p>Gebruik van verouderde of kwetsbare dependencies.</p>
        <a class="btn vuln" href="/supplychain/vulnerable">Kwetsbaar</a>
        <a class="btn safe" href="/supplychain/secure">Veilig</a>
    </div>

    <div class="card">
        <h3>A04 — (Coming Soon)</h3>
        <p>Wordt nog geïmplementeerd.</p>
    </div>

    <div class="card">
        <h3>A05 — (Coming Soon)</h3>
        <p>Wordt nog geïmplementeerd.</p>
    </div>

    <div class="card">
        <h3>A06 — (Coming Soon)</h3>
        <p>Wordt nog geïmplementeerd.</p>
    </div>
</body>
</html>
