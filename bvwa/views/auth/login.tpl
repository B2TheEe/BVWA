<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <title>{{.Title}}</title>
    <style>
        body  { font-family: Arial; max-width: 600px;
                margin: 40px auto; }
        .warn { color: red; font-weight: bold; }
        .good { color: green; font-weight: bold; }
        .info { color: blue; }
        input { padding: 8px; width: 100%;
                margin: 6px 0; box-sizing: border-box; }
        button { padding: 10px 20px; background: #2c3e50;
                 color: white; border: none;
                 border-radius: 4px; cursor: pointer; }
        .card  { border: 1px solid #ccc; padding: 20px;
                 border-radius: 8px; }
    </style>
</head>
<body>
    <h1>{{.Title}}</h1>
    <h2>OWASP A07:2025 — Authentication Failures</h2>

    <div class="card">
        <form method="POST">
            <label>Gebruikersnaam:</label>
            <input type="text" name="username"
                   placeholder="admin">
            <label>Wachtwoord:</label>
            <input type="password" name="password"
                   placeholder="password123">
            <br><br>
            <button type="submit">Inloggen</button>
        </form>
    </div>

    {{if .Success}}
    <p class="good">✅ {{.Success}}</p>
    {{end}}

    {{if .Error}}
    <p class="warn">❌ {{.Error}}</p>
    {{end}}

    {{if .Warning}}
    <p class="warn">⚠️ {{.Warning}}</p>
    {{end}}

    {{if .Info}}
    <p class="info">ℹ️ {{.Info}}</p>
    {{end}}

    <br>
    <p><strong>Test credentials:</strong>
       gebruikersnaam: <code>admin</code> |
       wachtwoord: <code>password123</code></p>
    <p><em>Probeer 5x in te loggen met een fout wachtwoord
       op de veilige versie om rate limiting te testen.</em></p>

    <br><a href="/">← Terug naar home</a>
</body>
</html>
