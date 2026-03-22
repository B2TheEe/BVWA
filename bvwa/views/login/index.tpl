<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <title>{{.Title}}</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: Arial, sans-serif;
            background: #f0f2f5;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        header {
            background: #2c3e50;
            color: white;
            padding: 16px 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        header .logo {
            font-size: 22px;
            font-weight: bold;
            text-decoration: none;
            color: white;
        }
        header .logo span { color: #e67e22; }
        header nav a {
            color: #ecf0f1;
            text-decoration: none;
            margin-left: 20px;
            font-size: 14px;
        }
        header nav a:hover { color: #e67e22; }

        .main {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }
        .login-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            padding: 40px;
            width: 100%;
            max-width: 420px;
        }
        .login-card .lock-icon {
            text-align: center;
            font-size: 48px;
            margin-bottom: 10px;
        }
        .login-card h1 {
            text-align: center;
            color: #2c3e50;
            font-size: 22px;
            margin-bottom: 4px;
        }
        .login-card .subtitle {
            text-align: center;
            color: #7f8c8d;
            font-size: 13px;
            margin-bottom: 28px;
        }
        label {
            display: block;
            font-size: 13px;
            font-weight: bold;
            color: #555;
            margin-bottom: 6px;
        }
        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 11px 14px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            margin-bottom: 18px;
            transition: border-color 0.2s;
        }
        input:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52,152,219,0.15);
        }
        .btn-login {
            width: 100%;
            padding: 12px;
            background: #2c3e50;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-login:hover { background: #1a252f; }
        .error-box {
            background: #fdecea;
            border: 1px solid #f5c6c6;
            color: #c0392b;
            padding: 10px 14px;
            border-radius: 6px;
            font-size: 13px;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .success-box {
            background: #eafaf1;
            border: 1px solid #27ae60;
            color: #1e8449;
            padding: 10px 14px;
            border-radius: 6px;
            font-size: 13px;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .credentials-hint {
            margin-top: 24px;
            background: #f8f9fa;
            border-radius: 6px;
            padding: 14px;
            font-size: 12px;
            color: #666;
        }
        .credentials-hint strong {
            display: block;
            margin-bottom: 6px;
            color: #444;
        }
        .credentials-hint code {
            background: #e9ecef;
            padding: 2px 6px;
            border-radius: 3px;
            font-size: 11px;
        }
        .register-link {
            margin-top: 20px;
            text-align: center;
            font-size: 13px;
            color: #7f8c8d;
        }
        .register-link a {
            color: #e67e22;
            text-decoration: none;
            font-weight: bold;
        }
        .register-link a:hover { text-decoration: underline; }
        footer {
            text-align: center;
            padding: 16px;
            color: #aaa;
            font-size: 12px;
        }
    </style>
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
