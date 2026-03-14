<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <title>{{.Title}}</title>
    <style>
        body { font-family: Arial; max-width: 800px;
               margin: 40px auto; }
        .warn { color: red; font-weight: bold; }
        .good { color: green; font-weight: bold; }
        input { padding: 8px; width: 300px; }
        button { padding: 8px 16px; }
        .info { background: #f0f0f0; padding: 10px;
                border-radius: 6px; margin: 10px 0; }
    </style>
</head>
<body>
    <h1>{{.Title}}</h1>
    <h2>OWASP A06:2025 — Insecure Design</h2>
    <p>Simulatie: Wachtwoord reset zonder/met rate limiting.</p>

    <form method="GET">
        <label>E-mailadres:</label><br>
        <input type="text" name="email"
               placeholder="gebruiker@example.com">
        <button type="submit">Reset aanvragen</button>
    </form>

    {{if .Message}}
    <div class="info">
        <p>📧 {{.Message}}</p>
    </div>
    {{end}}

    {{if .Warning}}
    <p class="warn">⚠️ {{.Warning}}</p>
    {{end}}

    {{if .Info}}
    <p class="good">✅ {{.Info}}</p>
    {{end}}

    <br><a href="/">← Terug naar home</a>
</body>
</html>
