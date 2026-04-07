<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>bvwa-bank — overboekingssysteem (veilig)</title>
    <link rel="stylesheet" href="/static/css/bvwa.css">
    <style>
        .terminal-panel {
            background: #0d1117;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 24px rgba(0,0,0,0.35);
            margin-bottom: 24px;
            font-family: 'Courier New', Courier, monospace;
        }
        .terminal-topbar {
            background: #1a2634;
            padding: 10px 16px;
            display: flex;
            align-items: center;
            gap: 8px;
            border-bottom: 1px solid #1f4068;
        }
        .terminal-dots { display: flex; gap: 6px; }
        .terminal-dot { width: 12px; height: 12px; border-radius: 50%; }
        .dot-red    { background: #ff5f57; }
        .dot-yellow { background: #febc2e; }
        .dot-green  { background: #28c840; }
        .terminal-title { color: #58a6ff; font-size: 13px; margin-left: 6px; }
        .terminal-body {
            padding: 20px 24px;
            min-height: 260px;
            color: #e6edf3;
            font-size: 13.5px;
            line-height: 1.65;
        }
        .terminal-motd { color: #3fb950; margin-bottom: 18px; font-size: 13px; }
        .terminal-entry { margin-bottom: 12px; }
        .terminal-cmd-echo { color: #58a6ff; }
        .terminal-cmd-echo .ps1 { color: #3fb950; }
        .terminal-output {
            white-space: pre-wrap;
            color: #e6edf3;
            word-break: break-all;
            margin-top: 2px;
        }
        .terminal-input-bar {
            display: flex;
            align-items: center;
            background: #0f1a26;
            padding: 10px 24px;
            border-top: 1px solid #1f4068;
            gap: 8px;
        }
        .terminal-ps1 {
            color: #3fb950;
            font-family: 'Courier New', Courier, monospace;
            font-size: 13.5px;
            white-space: nowrap;
            flex-shrink: 0;
        }
        .terminal-input-bar input[type=text] {
            flex: 1;
            background: transparent;
            border: none;
            outline: none;
            color: #e6edf3;
            font-family: 'Courier New', Courier, monospace;
            font-size: 13.5px;
            caret-color: #3fb950;
        }
        .terminal-input-bar button {
            background: #1f4068;
            color: #58a6ff;
            border: none;
            border-radius: 6px;
            padding: 5px 14px;
            font-size: 13px;
            font-weight: bold;
            cursor: pointer;
        }
        .terminal-input-bar button:hover { background: #2a5a8f; }
    </style>
</head>
<body>

<header>
    <a href="/" class="logo">&#x1F510; <span>BVWA</span></a>
    <nav>
        <a href="/">&#x1F3E0; Home</a>
        <a href="/design/vulnerable">Kwetsbaar</a>
        <a href="/design/secure">Veilig</a>
    </nav>
</header>

<div class="breadcrumb">
    <a href="/">Home</a> &rsaquo; A06 &rsaquo; Insecure Design (Veilig)
</div>

<div class="container">

    <div class="module-header">
        <span class="badge">A06</span>
        <h1>Insecure Design</h1>
        <button type="button" class="btn-info" id="openInfoBtn">Info &amp; CWEs</button>
        <button type="button" class="btn-examples" id="openExamplesBtn">Echte Voorbeelden</button>
    </div>

    <div class="terminal-panel">
        <div class="terminal-topbar">
            <div class="terminal-dots">
                <div class="terminal-dot dot-red"></div>
                <div class="terminal-dot dot-yellow"></div>
                <div class="terminal-dot dot-green"></div>
            </div>
            <span class="terminal-title">bvwa-bank v2.0.0 &mdash; Online Overboekingssysteem [beveiligd]</span>
        </div>

        <div class="terminal-body">
            <div class="terminal-motd">bvwa-bank v2.0.0 [secure build]<br>
Verbonden met bvwa-bank.nl &mdash; Welkom, BVWA Demo User</div>

            {{if .HasOutput}}
            <div class="terminal-entry">
                <div class="terminal-cmd-echo">
                    <span class="ps1">user@bvwa-bank:~$</span> bvwa-bank {{.Command}}
                </div>
                <pre class="terminal-output">{{.Output}}</pre>
            </div>
            {{end}}
        </div>

        <form method="GET" action="/design/secure">
            <div class="terminal-input-bar">
                <span class="terminal-ps1">user@bvwa-bank:~$</span>
                <input type="text" name="cmd" value="" autofocus autocomplete="off"
                       spellcheck="false" placeholder="bvwa-bank ">
                <button type="submit">&#x23CE;</button>
            </div>
        </form>
    </div>

</div>

<!-- ECHTE VOORBEELDEN MODAL -->
<div class="modal-overlay" id="examplesModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeExamplesBtn">X</button>
        <h2>Echte Voorbeelden &mdash; Insecure Design</h2>
        <p class="subtitle">Historische incidenten door fundamentele ontwerpfouten in beveiliging</p>
        <hr>

        <div class="example-item">
            <h4><span class="example-year">2019</span> Instagram &mdash; SMS Reset Brute Force</h4>
            <p>De 6-cijferige SMS-resetcode van Instagram had geen rate limiting.
            Een beveiligingsonderzoeker kon alle 1 miljoen combinaties uitproberen
            via de web-API. Elk willekeurig account kon worden overgenomen zonder
            verdere verificatie van de eigenaar.</p>
            <p class="example-impact">Impact: elk account kwetsbaar voor overname &mdash; bug bounty van $30.000</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2012</span> Citibank &mdash; Negatieve Overboeking</h4>
            <p>Een ontwerpfout in Citibanks ACH-verwerkingssysteem stond toe dat
            negatieve bedragen werden ingediend als geldige transacties. Aanvallers
            konden geld van andere rekeningen laten overboeken naar hun eigen rekening
            door simpelweg een negatief bedrag als afschrijving in te vullen.</p>
            <p class="example-impact">Impact: miljoenen dollars schade &mdash; ontwerp vertrouwde op client-validatie</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2021</span> Parler &mdash; Geen Rate Limiting op API</h4>
            <p>Door het ontbreken van rate limiting en sequenti&euml;le media-ID&rsquo;s
            werden alle 70 TB aan content gescraped &mdash; inclusief GPS-co&ouml;rdinaten
            in metadata van foto&rsquo;s en verwijderde berichten.</p>
            <p class="example-impact">Impact: 70 TB data inclusief GPS-metadata van 68.000 verwijderde berichten</p>
        </div>

        <div class="example-item">
            <h4><span class="example-year">2023</span> T-Mobile &mdash; Onveilig API-ontwerp</h4>
            <p>Een API-endpoint bij T-Mobile vereiste geen authenticatie voor klantgegevens.
            Door sequenti&euml;le ID&rsquo;s te itereren waren de gegevens van 37 miljoen
            abonnees opvraagbaar &mdash; het achtste datalek in vijf jaar.</p>
            <p class="example-impact">Impact: 37 miljoen klantrecords blootgesteld &mdash; $350 miljoen schikking</p>
        </div>
    </div>
</div>

<!-- INFO MODAL -->
<div class="modal-overlay" id="infoModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeInfoBtn">X</button>
        <h2>A06:2025 &mdash; Insecure Design</h2>
        <p class="subtitle">OWASP Top 10:2025 &mdash; Positie #6 &mdash; Nieuw in 2021</p>
        <hr>

        <div class="info-section">
            <h3>Wat is het?</h3>
            <p>Insecure Design omvat risico&rsquo;s die voortkomen uit fundamentele ontwerpfouten
            in architectuur en werkstromen &mdash; v&oacute;&oacute;rdat er ook maar &eacute;&eacute;n
            regel code is geschreven. Anders dan implementatiefouten gaat het hier om het ontbreken
            van beveiligingsoverwegingen op architectuurniveau. De oplossing is niet een patch,
            maar een herontwerp.</p>
        </div>
        <hr>

        <div class="info-section">
            <h3>Gerelateerde CWEs</h3>
            <div class="cwe-list">
                <span class="cwe-tag">CWE-640 Weak Password Recovery</span>
                <span class="cwe-tag">CWE-642 External Control of Critical State Data</span>
                <span class="cwe-tag">CWE-799 Improper Control of Interaction Frequency</span>
                <span class="cwe-tag">CWE-840 Business Logic Errors</span>
                <span class="cwe-tag">CWE-841 Improper Behavioral Workflow</span>
                <span class="cwe-tag">CWE-1021 Improper Restriction of Rendered UI Layers</span>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de kwetsbare versie onveilig?</h3>
            <div class="vuln-box">
                <ul>
                    <li><strong>CWE-840:</strong> negatief bedrag nooit als misbruikscenario overwogen</li>
                    <li><strong>CWE-841:</strong> workflow controleert niet of de transactie financi&euml;el zinvol is</li>
                    <li><strong>CWE-642:</strong> critieke state (bedrag) volledig door de gebruiker bepaald</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Waarom is de veilige versie correct?</h3>
            <div class="safe-box">
                <ul>
                    <li><strong>Bedragvalidatie:</strong> server weigert elk bedrag &le; 0</li>
                    <li><strong>Overdraft-check:</strong> transfer geblokkeerd bij onvoldoende saldo</li>
                    <li><strong>Fail-closed:</strong> bij ongeldige input wordt de transactie geweigerd</li>
                    <li><strong>Threat modeling:</strong> misbruikscenario&rsquo;s meegenomen in het ontwerp</li>
                </ul>
            </div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Mitigatie</h3>
            <p>Gebruik threat modeling tijdens de ontwerpfase. Valideer alle business-logica
            server-side. Documenteer en test expliciete misbruikscenario&rsquo;s als onderdeel
            van het acceptatieproces.</p>
        </div>
    </div>
</div>

<footer>
    BVWA is uitsluitend bedoeld voor educatieve doeleinden &mdash;
    gebruik alleen in een ge&iuml;soleerde testomgeving.
</footer>

<script type="text/javascript" src="/static/js/modal.js"></script>

</body>
</html>
