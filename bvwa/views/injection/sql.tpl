<!DOCTYPE html>
<html lang="nl">
<head>
    <title>{{.Title}}</title>
    <style>
        body { font-family: Arial; max-width: 800px; 
               margin: 40px auto; }
        .warn { color: red; font-weight: bold; }
        .good { color: green; font-weight: bold; }
        input { padding: 8px; width: 300px; }
        button { padding: 8px 16px; }
        code { background: #f4f4f4; padding: 4px 8px; 
               display: block; margin: 10px 0; }
    </style>
</head>
<body>
    <h1>{{.Title}}</h1>
    <form method="GET">
        <label>Gebruikersnaam:</label><br>
        <input type="text" name="username" 
               value="{{.Username}}" 
               placeholder="Probeer: ' OR '1'='1">
        <button type="submit">Zoeken</button>
    </form>
    {{if .Query}}
    <p><strong>Uitgevoerde query:</strong></p>
    <code>{{.Query}}</code>
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
