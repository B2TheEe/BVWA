<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <title>{{.Title}}</title>
    <style>
        body    { font-family: Arial; max-width: 850px;
                  margin: 40px auto; }
        .warn   { color: red; font-weight: bold; }
        .good   { color: green; font-weight: bold; }
        .info   { color: blue; }
        .error  { background: #ffe0e0; padding: 10px;
                  border-radius: 6px; color: darkred; }
        .success{ background: #e0ffe0; padding: 10px;
                  border-radius: 6px; color: darkgreen; }
        input   { padding: 8px; width: 100%;
                  margin: 6px 0; box-sizing: border-box; }
        button  { padding: 10px 20px; background: #2c3e50;
                  color: white; border: none;
                  border-radius: 4px; cursor: pointer; }
        .card   { border: 1px solid #ccc; padding: 20px;
                  border-radius: 8px; margin: 10px 0; }
        .logbox { background: #1e1e1e; color: #00ff00;
                  font-family: monospace; font-size: 12px;
                  padding: 15px; border-radius: 6px;
                  min-height: 100px; max-height: 250px;
                  overflow-y: auto; }
        .logbox p { margin: 4px 0; }
    </style>
</head>
<body>
    <h1>{{.Title}}</h1>
    <h2>OWASP A09:2025 — Security Logging & Alerting Failures</h2>
    <p>Simulatie: login met/zonder security logging en alerting.</p>

    <div class="card">
        <form method="POST">
            <label>Gebruikersnaam:</label>
            <input type="text" name="username"
                   placeholder="admin">
            <label>Wachtwoord:</label>
            <input type="password" name="password"
                   placeholder="password123">
            <button type="submit">Inloggen</button>
        </form>
    </div>

    {{if .Success}}
    <div class="success">✅ {{.Success}}</div>
    {{end}}

    {{if .Error}}
    <div class="error">❌ {{.Error}}</div>
    {{end}}

    {{if .Warning}}
    <p class="warn">⚠️ {{.Warning}}</p>
    {{end}}

    {{if .Info}}
    <p class="info">ℹ️ {{.Info}}</p>
    {{end}}

    <!-- Log weergave -->
    <div class="card">
        <h3>📋 Security Logs:</h3>
        <div class="logbox">
            {{range .Logs}}
            <p>{{.}}</p>
            {{else}}
            <p>(geen logs beschikbaar)</p>
            {{end}}
        </div>
    </div>

    <p><strong>Test credentials:</strong>
       gebruiker: <code>admin</code> |
       wachtwoord: <code>password123</code></p>
    <p><em>Probeer 3x in te loggen met een fout wachtwoord
       op de veilige versie om de alert te triggeren.</em></p>

    <br><a href="/">← Terug naar home</a>
</body>
</html>
