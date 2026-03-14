<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <title>{{.Title}}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .vulnerable { background-color: #ffcccc; padding: 10px; }
        .secure { background-color: #ccffcc; padding: 10px; }
        .warning { color: red; font-weight: bold; }
    </style>
</head>
<body>
    <h1>{{.Title}}</h1>

    <div class="info">
        <h2>OWASP A01:2025 - Broken Access Control</h2>

        <div class="vulnerable">
            <p class="warning">⚠️ KWETSBAAR: Geen toegangscontrole</p>
            <p>Deze pagina is bereikbaar zonder enige rolcontrole.</p>
            <a href="/admin/vulnerable">Probeer kwetsbare versie</a>
        </div>

        <br>

        <div class="secure">
            <p>✅ VEILIG: Met rolcontrole</p>
            <p>Deze pagina vereist een admin-sessie.</p>
            <a href="/admin/secure">Probeer veilige versie</a>
        </div>
    </div>
</body>
</html>
