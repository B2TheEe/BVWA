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
    </style>
</head>
<body>
    <h1>{{.Title}}</h1>
    <form method="GET">
        <label>Input:</label><br>
        <input type="text" name="input"
               placeholder="Probeer: &lt;script&gt;alert('XSS')&lt;/script&gt;">
        <button type="submit">Versturen</button>
    </form>

    {{if .RawInput}}
    <!-- KWETSBAAR: raw HTML — nooit doen in productie! -->
    <p><strong>Output (onveilig):</strong></p>
    <div id="output">{{str2html .RawInput}}</div>
    <p class="warn">⚠️ {{.Warning}}</p>
    {{end}}

    {{if .SafeInput}}
    <!-- VEILIG: Beego escaped automatisch -->
    <p><strong>Output (veilig, geëscaped):</strong></p>
    <div>{{.SafeInput}}</div>
    <p class="good">✅ {{.Info}}</p>
    {{end}}

    <br><a href="/">← Terug naar home</a>
</body>
</html>
