<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <title>404 - Pagina niet gevonden - BVWA</title>
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

        .error-container {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }
        .error-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            padding: 50px 40px;
            text-align: center;
            max-width: 500px;
            width: 100%;
        }
        .error-code {
            font-size: 96px;
            font-weight: bold;
            color: #e74c3c;
            line-height: 1;
            margin-bottom: 10px;
        }
        .error-title {
            font-size: 24px;
            color: #2c3e50;
            margin-bottom: 12px;
            font-weight: bold;
        }
        .error-desc {
            font-size: 15px;
            color: #7f8c8d;
            line-height: 1.7;
            margin-bottom: 30px;
        }
        .error-badge {
            display: inline-block;
            background: #fdecea;
            color: #e74c3c;
            font-size: 12px;
            font-weight: bold;
            padding: 4px 14px;
            border-radius: 20px;
            margin-bottom: 24px;
        }
        .btn-home {
            display: inline-block;
            background: #2c3e50;
            color: white;
            text-decoration: none;
            padding: 12px 28px;
            border-radius: 6px;
            font-size: 15px;
            font-weight: bold;
            margin-right: 10px;
        }
        .btn-home:hover { background: #1a252f; }
        .btn-back {
            display: inline-block;
            background: #ecf0f1;
            color: #2c3e50;
            text-decoration: none;
            padding: 12px 28px;
            border-radius: 6px;
            font-size: 15px;
            font-weight: bold;
        }
        .btn-back:hover { background: #bdc3c7; }

        footer {
            text-align: center;
            padding: 16px;
            color: #aaa;
            font-size: 12px;
        }
    </style>
</head>
<body>

<header>
    <a href="/" class="logo">&#x1F510; <span>BVWA</span></a>
    <nav>
        <a href="/">&#x1F3E0; Home</a>
    </nav>
</header>

<div class="error-container">
    <div class="error-card">
        <div class="error-code">404</div>
        <span class="error-badge">Pagina niet gevonden</span>
        <h1 class="error-title">Oeps! Deze pagina bestaat niet.</h1>
        <p class="error-desc">
            De pagina die je probeert te bereiken bestaat niet
            of is verplaatst. Controleer de URL of ga terug
            naar de homepage.
        </p>
        <a href="/" class="btn-home">&#x1F3E0; Naar home</a>
        <a href="javascript:history.back()"
           class="btn-back">&#x2190; Terug</a>
    </div>
</div>

<footer>
    BVWA - Uitsluitend voor educatieve doeleinden
</footer>

</body>
</html>
