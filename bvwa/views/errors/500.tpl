<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <title>500 - Interne Serverfout - BVWA</title>
    <link rel="stylesheet" href="/static/css/bvwa.css">
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
        <div class="error-code">500</div>
        <span class="error-badge">Interne Serverfout</span>
        <h1 class="error-title">Er ging iets mis aan onze kant.</h1>
        <p class="error-desc">
            Er is een onverwachte fout opgetreden.
            Probeer het later opnieuw of ga terug
            naar de homepage.
        </p>
        <div class="security-note">
            &#x1F512; <strong>Security note (OWASP A10):</strong>
            Een veilige applicatie toont geen interne
            foutdetails. Stack traces en systeeminformatie
            worden alleen intern gelogd.
        </div>
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
