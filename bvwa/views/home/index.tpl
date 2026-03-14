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
        .badge { display: inline-block; background: #e67e22;
                 color: white; border-radius: 4px;
                 padding: 2px 8px; font-size: 12px;
                 margin-bottom: 6px; }
    </style>
</head>
<body>
    <header>
        <h1>🔐 BVWA</h1>
        <p>Beego Vulnerable Web Application — OWASP Top 10:2025</p>
    </header>

    <div class="card">
        <span class="badge">A01</span>
        <h3>Broken Access Control</h3>
        <p>Toegangscontrole wordt niet correct afgedwongen.</p>
        <a class="btn vuln" href="/admin/vulnerable">Kwetsbaar</a>
        <a class="btn safe" href="/admin/secure">Veilig</a>
    </div>

    <div class="card">
        <span class="badge">A02</span>
        <h3>Security Misconfiguration</h3>
        <p>Ontbrekende of verkeerde security headers.</p>
        <a class="btn vuln" href="/misconfig/vulnerable">Kwetsbaar</a>
        <a class="btn safe" href="/misconfig/secure">Veilig</a>
    </div>

    <div class="card">
        <span class="badge">A03</span>
        <h3>Software Supply Chain Failures</h3>
        <p>Gebruik van verouderde of kwetsbare dependencies.</p>
        <a class="btn vuln" href="/supplychain/vulnerable">Kwetsbaar</a>
        <a class="btn safe" href="/supplychain/secure">Veilig</a>
    </div>

    <div class="card">
        <span class="badge">A04</span>
        <h3>Cryptographic Failures</h3>
        <p>Zwakke of ontbrekende versleuteling van gevoelige data.</p>
        <a class="btn vuln" href="/crypto/vulnerable">Kwetsbaar</a>
        <a class="btn safe" href="/crypto/secure">Veilig</a>
    </div>

    <div class="card">
        <span class="badge">A05</span>
        <h3>Injection</h3>
        <p>SQL Injection en XSS via ongesaniteerde gebruikersinput.</p>
        <a class="btn vuln" href="/injection/sql/vulnerable">SQL Kwetsbaar</a>
        <a class="btn safe" href="/injection/sql/secure">SQL Veilig</a>
        <a class="btn vuln" href="/injection/xss/vulnerable">XSS Kwetsbaar</a>
        <a class="btn safe" href="/injection/xss/secure">XSS Veilig</a>
    </div>

    <div class="card">
        <span class="badge">A06</span>
        <h3>Insecure Design</h3>
        <p>Ontbrekende beveiligingscontroles in het applicatieontwerp.</p>
        <a class="btn vuln" href="/design/vulnerable">Kwetsbaar</a>
        <a class="btn safe" href="/design/secure">Veilig</a>
    </div>
    
    <div class="card">
    <span class="badge">A07</span>
    <h3>Authentication Failures</h3>
    <p>Zwakke login, geen rate limiting, slechte sessiebeheer.</p>
    <a class="btn vuln" href="/auth/vulnerable">Kwetsbaar</a>
    <a class="btn safe" href="/auth/secure">Veilig</a>
    </div>
    
    <div class="card">
    <span class="badge">A08</span>
    <h3>Software/Data Integrity Failures</h3>
    <p>Gemanipuleerde geserialiseerde data zonder
       integriteitscontrole.</p>
    <a class="btn vuln" href="/integrity/vulnerable">Kwetsbaar</a>
    <a class="btn safe" href="/integrity/secure">Veilig</a>
    </div>

    <footer style="margin-top:30px; color:#888; font-size:13px;">
        <p>⚠️ BVWA is uitsluitend bedoeld voor educatieve doeleinden.
           Gebruik alleen in een geïsoleerde testomgeving.</p>
    </footer>
</body>
</html>
