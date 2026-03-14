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
        .info   { background: #e0ffe0; padding: 10px;
                  border-radius: 6px; color: darkgreen; }
        .error  { background: #ffe0e0; padding: 10px;
                  border-radius: 6px; color: darkred; }
        input   { padding: 8px; width: 200px; }
        button  { padding: 8px 16px; background: #2c3e50;
                  color: white; border: none;
                  border-radius: 4px; cursor: pointer; }
        .card   { border: 1px solid #ccc; padding: 20px;
                  border-radius: 8px; margin: 10px 0; }
        .tips   { background: #f9f9f9; padding: 15px;
                  border-radius: 6px; font-size: 13px; }
    </style>
</head>
<body>
    <h1>{{.Title}}</h1>
    <h2>OWASP A10:2025 — Mishandling of Exceptional Conditions</h2>
    <p>Simulatie: product opzoeken met/zonder correcte
       foutafhandeling.</p>

    <div class="card">
        <form method="GET">
            <label>Product ID:</label>
            <input type="text" name="id"
                   placeholder="1, 2, 3, abc, -1, 999">
            <button type="submit">Zoeken</button>
        </form>
    </div>

    <div class="tips">
        <strong>💡 Test scenarios:</strong>
        <ul>
            <li><code>1</code>, <code>2</code>,
                <code>3</code> → geldig product</li>
            <li><code>999</code> → niet gevonden</li>
            <li><code>abc</code> → ongeldige invoer</li>
            <li><code>-1</code> → negatief ID</li>
            <li>(leeg) → geen invoer</li>
        </ul>
    </div>

    {{if .Product}}
    <div class="card">
        <h3>✅ Product gevonden:</h3>
        <p><strong>{{.Product}}</strong></p>
    </div>
    {{end}}

    {{if .Error}}
    <div class="error">❌ {{.Error}}</div>
    {{end}}

    {{if .Warning}}
    <p class="warn">⚠️ {{.Warning}}</p>
    {{end}}

    {{if .Info}}
    <div class="info">✅ {{.Info}}</div>
    {{end}}

    <br><a href="/">← Terug naar home</a>
</body>
</html>
