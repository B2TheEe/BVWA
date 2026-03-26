<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <title>{{.Title}}</title>
    <link rel="stylesheet" href="/static/css/bvwa.css">
</head>
<body>

<header>
    <a href="/" class="logo">🔐 <span>BVWA</span></a>
    <nav>
        <a href="/">🏠 Home</a>
        <a href="/register">Registreren</a>
    </nav>
</header>

<div class="main">
    <div class="login-card">
        <div class="lock-icon">🔒</div>
        <h1>Inloggen</h1>
        <p class="subtitle">Beego Vulnerable Web Application</p>

        {{if .Error}}
        <div class="error-box">❌ {{.Error}}</div>
        {{end}}

        {{if .Success}}
        <div class="success-box">✅ {{.Success}}</div>
        {{end}}

        <form method="POST" action="/login">
            <label for="username">Gebruikersnaam</label>
            <input type="text" id="username" name="username"
                   placeholder="admin" autocomplete="username">

            <label for="password">Wachtwoord</label>
            <input type="password" id="password" name="password"
                   placeholder="••••••••"
                   autocomplete="current-password">

            <button type="submit" class="btn-login">
                Inloggen →
            </button>
        </form>

        <div class="register-link">
            Nog geen account? <a href="/register">Registreer hier</a>
        </div>

        <div class="credentials-hint">
            <strong>🧪 Test credentials:</strong>
            Admin: <code>admin</code> / <code>password123</code><br>
            User: &nbsp;<code>user</code> &nbsp;/ <code>user123</code>
        </div>
    </div>
</div>

<footer>
    ⚠️ Uitsluitend voor educatieve doeleinden
</footer>
<script type="text/javascript" src="/static/js/modal.js"></script>
</body>
</html>
