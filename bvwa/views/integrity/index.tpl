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
        .error  { color: darkred; background: #ffe0e0;
                  padding: 10px; border-radius: 6px; }
        .info   { color: darkgreen; background: #e0ffe0;
                  padding: 10px; border-radius: 6px; }
        textarea { width: 100%; height: 80px; font-size: 12px;
                   font-family: monospace; }
        button  { padding: 10px 20px; background: #2c3e50;
                  color: white; border: none;
                  border-radius: 4px; cursor: pointer;
                  margin-top: 8px; }
        .card   { border: 1px solid #ccc; padding: 20px;
                  border-radius: 8px; margin: 10px 0; }
        table   { border-collapse: collapse; width: 100%; }
        td, th  { border: 1px solid #ddd; padding: 8px; }
        th      { background: #f4f4f4; }
    </style>
</head>
<body>
    <h1>{{.Title}}</h1>
    <h2>OWASP A08:2025 — Software/Data Integrity Failures</h2>
    <p>Simulatie: geserialiseerde sessiedata met/zonder
       integriteitscontrole.</p>

    <!-- Stap 1: toon gegenereerde token -->
    {{if .Token}}
    <div class="card">
        <h3>📦 Gegenereerde sessie-token:</h3>
        <textarea id="tokenField">{{.Token}}</textarea>
        <br>
        <em>💡 Tip (kwetsbaar): pas de base64 aan om
            role:"admin" of balance:999999 in te stellen!</em>

        <form method="POST">
            <input type="hidden" name="token"
                   id="submitToken" value="{{.Token}}">
            <button type="submit"
                    onclick="
                      document.getElementById('submitToken')
                        .value =
                      document.getElementById('tokenField')
                        .value">
                Verstuur token →
            </button>
        </form>
    </div>
    {{end}}

    <!-- Stap 2: toon resultaat -->
    {{if .Username}}
    <div class="card">
        <h3>📋 Geaccepteerde sessiedata:</h3>
        <table>
            <tr><th>Veld</th><th>Waarde</th></tr>
            <tr><td>Gebruikersnaam</td>
                <td>{{.Username}}</td></tr>
            <tr><td>Rol</td>
                <td>{{.Role}}</td></tr>
            <tr><td>Saldo</td>
                <td>€{{.Balance}}</td></tr>
        </table>
    </div>
    {{end}}

    {{if .Error}}
    <div class="error">❌ {{.Error}}</div>
    {{end}}

    {{if .Warning}}
    <p class="warn">⚠️ {{.Warning}}</p>
    {{end}}

    {{if .Info}}
    <div class="info">{{.Info}}</div>
    {{end}}

    <br><a href="/">← Terug naar home</a>
</body>
</html>
