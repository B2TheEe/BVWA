<!DOCTYPE html>
<html>
<head><title>{{.Title}}</title>
<style>
  body{font-family:Arial;max-width:800px;margin:40px auto}
  .warn{color:red;font-weight:bold}
  .good{color:green;font-weight:bold}
</style>
</head>
<body>
    <h1>{{.Title}}</h1>
    <p><strong>Methode:</strong> {{.Method}}</p>
    <p><strong>Hash:</strong> <code>{{.Hash}}</code></p>
    {{if .Warning}}
    <p class="warn">⚠️ {{.Warning}}</p>
    {{else}}
    <p class="good">✅ Veilige hashing gebruikt!</p>
    {{end}}
    {{if .SHA}}
    <p><strong>SHA-256 integriteit:</strong> 
       <code>{{.SHA}}</code></p>
    {{end}}
    <br><a href="/">← Terug naar home</a>
</body>
</html>
