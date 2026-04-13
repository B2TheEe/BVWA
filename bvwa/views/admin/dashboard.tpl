<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{.Title}} — BVWA</title>
    <link rel="stylesheet" href="/static/css/bvwa.css">
</head>
<body>

<!-- ── HEADER ── -->
<header>
    <a href="/" class="logo">🔐 <span>BVWA</span></a>
    <nav>
        <a href="/">🏠 Home</a>
        <a href="/admin/vulnerable">Kwetsbaar</a>
        <a href="/admin/secure">Veilig</a>
    </nav>
</header>

<!-- ── BREADCRUMB ── -->
<div class="breadcrumb">
    <a href="/">Home</a> › A01 › {{.Title}}
</div>

<!-- ── MAIN ── -->
<div class="container">

    <!-- Module header -->
    <div class="module-header">
        <span class="badge-a01">A01</span>
        <h1>Broken Access Control</h1>
        <button type="button" class="btn-info" id="openInfoBtn">
            ℹ️ Info &amp; CWEs
        </button>
        <button type="button" class="btn-examples" id="openExamplesBtn">
            Echte Voorbeelden
        </button>
        <button type="button" class="btn-help" id="openHelpBtn">Hulp &amp; Commando&rsquo;s</button>
    </div>

    <!-- ── OVERZICHT: twee kaarten ── -->
    {{if .Overview}}
    <div class="cards">

        <!-- KWETSBAAR -->
        <div class="card">
            <div class="card-header vuln">
                ⚠️ Kwetsbare versie
            </div>
            <div class="card-body">
                <p>
                    In dit HR-portaal is elk medewerkersprofiel
                    op te vragen via de <strong>?id=</strong>
                    parameter — zonder authenticatie of
                    autorisatiecheck (IDOR — CWE-639).
                </p>
                <div class="code-block">
<span class="cmt">// KWETSBAAR: geen autorisatiecheck</span>
id := c.GetString(<span class="str">"id"</span>, <span class="str">"2"</span>)
emp := profileDB[id] <span class="cmt">// iedereen leest elk profiel</span>
                </div>
                <a href="/admin/vulnerable?id=2" class="btn btn-red">
                    🔓 Open kwetsbaar portaal
                </a>
            </div>
        </div>

        <!-- VEILIG -->
        <div class="card">
            <div class="card-header safe">
                ✅ Veilige versie
            </div>
            <div class="card-body">
                <p>
                    De veilige versie vereist een actieve sessie
                    <strong>en</strong> verifieert of de aanvrager
                    het eigen profiel opvraagt of admin-rechten
                    heeft.
                </p>
                <div class="code-block">
<span class="cmt">// VEILIG: IDOR-bescherming</span>
<span class="kw">if</span> role != <span class="str">"admin"</span> &amp;&amp; id != sessionUserID {
    <span class="kw">return</span> 403 <span class="cmt">// toegang geweigerd</span>
}
                </div>
                <a href="/admin/secure?id=2" class="btn btn-green">
                    🔒 Open veilig portaal
                </a>
            </div>
        </div>

    </div>
    {{end}}

    <!-- ── PROFIEL WEERGAVE ── -->
    {{if .HasProfile}}
    <div style="max-width:620px; margin:0 auto;">
        <p style="margin-bottom:16px;">
            <a href="{{.BackURL}}"
               style="color:#555; text-decoration:none; font-size:13px;">
                ← Alle medewerkers
            </a>
        </p>
        <div class="result-box" style="padding:28px 32px;">

            <!-- Avatar + naam -->
            <div style="display:flex; align-items:center; gap:16px;
                        margin-bottom:24px; padding-bottom:20px;
                        border-bottom:1px solid #eee;">
                <div style="width:52px; height:52px; border-radius:50%;
                            background:#e8f0fe; display:flex;
                            align-items:center; justify-content:center;
                            font-size:22px; flex-shrink:0;">
                    👤
                </div>
                <div>
                    <div style="font-size:18px; font-weight:600;">
                        {{.Profile.Username}}
                    </div>
                    <div style="font-size:13px; color:#666; margin-top:2px;">
                        {{.Profile.Functie}} &middot; {{.Profile.Afdeling}}
                    </div>
                </div>
            </div>

            <!-- Profiel velden -->
            <table style="width:100%; border-collapse:collapse; font-size:14px;">
                <tr style="border-bottom:1px solid #f0f0f0;">
                    <td style="padding:10px 0; color:#888; width:150px;
                               font-size:13px;">
                        Medewerker ID
                    </td>
                    <td style="padding:10px 0; font-family:monospace;">
                        #{{.Profile.ID}}
                    </td>
                </tr>
                <tr style="border-bottom:1px solid #f0f0f0;">
                    <td style="padding:10px 0; color:#888; font-size:13px;">
                        E-mailadres
                    </td>
                    <td style="padding:10px 0;">{{.Profile.Email}}</td>
                </tr>
                <tr style="border-bottom:1px solid #f0f0f0;">
                    <td style="padding:10px 0; color:#888; font-size:13px;">
                        Afdeling
                    </td>
                    <td style="padding:10px 0;">{{.Profile.Afdeling}}</td>
                </tr>
                <tr>
                    <td style="padding:10px 0; color:#888; font-size:13px;">
                        Functie
                    </td>
                    <td style="padding:10px 0;">{{.Profile.Functie}}</td>
                </tr>
            </table>

            <!-- Vertrouwelijke HR-notities -->
            <div style="margin-top:20px; padding:14px 16px;
                        background:#fffbeb; border:1px solid #f59e0b;
                        border-radius:6px;">
                <div style="font-size:11px; font-weight:700; color:#92400e;
                            text-transform:uppercase; letter-spacing:0.6px;
                            margin-bottom:6px;">
                    HR Notities — Vertrouwelijk
                </div>
                <div style="font-size:14px; color:#78350f; line-height:1.5;">
                    {{.Profile.Notes}}
                </div>
            </div>

        </div>
    </div>
    {{end}}

    <!-- ── 403 VERBODEN ── -->
    {{if .Forbidden}}
    <div class="result-box" style="text-align:center; padding:40px 32px;">
        <div style="font-size:44px; margin-bottom:14px;">🚫</div>
        <h3 style="color:#e74c3c; margin:0 0 8px;">403 — Toegang Geweigerd</h3>
        <p style="color:#666; font-size:14px; margin:0 0 20px;">
            Je hebt geen toestemming om dit medewerkersprofiel te bekijken.
        </p>
        <a href="{{.BackURL}}"
           style="display:inline-block; padding:8px 20px;
                  background:#e74c3c; color:white; border-radius:6px;
                  text-decoration:none; font-size:13px;">
            ← Terug
        </a>
    </div>
    {{end}}

    <!-- ── 404 NIET GEVONDEN ── -->
    {{if .NotFound}}
    <div class="result-box" style="text-align:center; padding:40px 32px;">
        <div style="font-size:44px; margin-bottom:14px;">🔍</div>
        <h3 style="color:#888; margin:0 0 8px;">Profiel niet gevonden</h3>
        <p style="color:#666; font-size:14px; margin:0 0 20px;">
            Er bestaat geen medewerker met dit ID.
        </p>
        <a href="{{.BackURL}}"
           style="display:inline-block; padding:8px 20px;
                  background:#888; color:white; border-radius:6px;
                  text-decoration:none; font-size:13px;">
            ← Terug
        </a>
    </div>
    {{end}}

    <!-- ── 400 ONGELDIG VERZOEK ── -->
    {{if .BadRequest}}
    <div class="result-box" style="text-align:center; padding:40px 32px;">
        <div style="font-size:44px; margin-bottom:14px;">⚠️</div>
        <h3 style="color:#e67e22; margin:0 0 8px;">Ongeldig verzoek</h3>
        <p style="color:#666; font-size:14px; margin:0 0 20px;">
            Het opgegeven ID heeft een ongeldig formaat.
        </p>
        <a href="{{.BackURL}}"
           style="display:inline-block; padding:8px 20px;
                  background:#e67e22; color:white; border-radius:6px;
                  text-decoration:none; font-size:13px;">
            ← Terug
        </a>
    </div>
    {{end}}

</div><!-- /container -->

<!-- ── ECHTE VOORBEELDEN MODAL ── -->
<div class="modal-overlay" id="examplesModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeExamplesBtn">✕</button>

        <h2>Echte Voorbeelden — Broken Access Control</h2>
        <p class="subtitle">
            Historische incidenten waarbij gebrekkige toegangscontrole grote schade veroorzaakte
        </p>
        <hr>

        <div class="example-item">
            <h4>
                <span class="example-year">2019</span>
                Facebook — IDOR op privéfoto's
            </h4>
            <p>
                Een IDOR-kwetsbaarheid in de Facebook foto-API stelde aanvallers in staat
                privéfoto's van willekeurige gebruikers op te halen door de gebruiker-ID
                in het API-verzoek te wijzigen. Geen verdere autorisatiecheck vond plaats.
            </p>
            <p class="example-impact">Impact: 6,8 miljoen gebruikers getroffen — privéfoto's toegankelijk voor derden</p>
        </div>

        <div class="example-item">
            <h4>
                <span class="example-year">2021</span>
                Peloton — Onbeveiligde API
            </h4>
            <p>
                Pelotons API gaf gebruikersprofieldata terug voor elk account — inclusief
                privé-ingestelde profielen — zonder enige authenticatie. Iedereen met een
                user-ID kon naam, leeftijd, locatie en trainingsdata opvragen.
            </p>
            <p class="example-impact">Impact: ~4 miljoen gebruikersprofielen onbeschermd — Peloton wachtte maanden met patchen</p>
        </div>

        <div class="example-item">
            <h4>
                <span class="example-year">2022</span>
                Optus Australië — Ongeauthenticeerde API
            </h4>
            <p>
                Een niet-beveiligd API-endpoint gaf klantgegevens terug zonder
                authenticatie of autorisatiecontrole. Een aanvaller kon volgnummers
                sequentieel ophogen om record na record op te vragen, inclusief
                paspoort- en rijbewijsnummers.
            </p>
            <p class="example-impact">Impact: 9,8 miljoen Australische klanten — grootste datalek in Australische geschiedenis</p>
        </div>

        <div class="example-item">
            <h4>
                <span class="example-year">2023</span>
                T-Mobile — API IDOR
            </h4>
            <p>
                Via een IDOR-fout in T-Mobiles API konden aanvallers accountgegevens
                van willekeurige klanten inzien door de klant-ID in het request te
                manipuleren. De API controleerde niet of de ingelogde gebruiker
                recht had op de opgevraagde gegevens.
            </p>
            <p class="example-impact">Impact: 37 miljoen klantrecords gelekt — namen, adressen, telefoonnummers</p>
        </div>

    </div>
</div><!-- /examplesModal -->

<!-- ── INFO MODAL ── -->
<div class="modal-overlay" id="infoModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeInfoBtn">✕</button>

        <h2>ℹ️ A01:2025 — Broken Access Control</h2>
        <p class="subtitle">
            OWASP Top 10:2025 · Positie #1 · Meest voorkomende kwetsbaarheid
        </p>
        <hr>

        <!-- Wat is het -->
        <div class="info-section">
            <h3>📖 Wat is het?</h3>
            <p>
                Broken Access Control treedt op wanneer een applicatie
                niet correct afdwingt <em>wat gebruikers mogen doen</em>.
                Dit demo toont <strong>IDOR (Insecure Direct Object
                Reference, CWE-639)</strong>: een aanvaller manipuleert
                een object-ID (zoals <code>?id=2</code>) om data van
                andere gebruikers op te vragen zonder autorisatiecheck.
            </p>
        </div>
        <hr>

        <!-- CWEs -->
        <div class="info-section">
            <h3>🏷️ Gerelateerde CWEs</h3>
            <div class="cwe-list">
                <span class="cwe-tag">CWE-22 — Path Traversal</span>
                <span class="cwe-tag">CWE-200 — Info Exposure</span>
                <span class="cwe-tag">CWE-264 — Permissions/Privileges</span>
                <span class="cwe-tag">CWE-284 — Improper Access Control</span>
                <span class="cwe-tag">CWE-285 — Improper Authorization</span>
                <span class="cwe-tag">CWE-352 — CSRF</span>
                <span class="cwe-tag">CWE-425 — Direct Request (Forced Browsing)</span>
                <span class="cwe-tag">CWE-566 — Authorization Bypass via User-Controlled SQL</span>
                <span class="cwe-tag">CWE-601 — Open Redirect</span>
                <span class="cwe-tag">CWE-639 — IDOR</span>
                <span class="cwe-tag">CWE-862 — Missing Authorization</span>
                <span class="cwe-tag">CWE-863 — Incorrect Authorization</span>
            </div>
        </div>
        <hr>

        <!-- Waarom kwetsbaar -->
        <div class="info-section">
            <h3>🔴 Waarom is de kwetsbare versie onveilig?</h3>
            <div class="vuln-box">
                De kwetsbare controller bevat een klassieke
                <strong>IDOR-fout</strong>:
                <ul>
                    <li>De <code>?id=</code> parameter wordt direct
                        gebruikt om een profiel op te zoeken</li>
                    <li>Er vindt <strong>geen authenticatiecheck</strong>
                        plaats — ook anonieme bezoekers kunnen profielen
                        opvragen</li>
                    <li>Er vindt <strong>geen autorisatiecheck</strong>
                        plaats — elke ID geeft toegang, ook die van
                        andere medewerkers</li>
                    <li>Sequentieel ophogen van de ID onthult alle
                        gebruikersdata inclusief vertrouwelijke HR-notities</li>
                </ul>
            </div>
        </div>
        <hr>

        <!-- Waarom veilig -->
        <div class="info-section">
            <h3>🟢 Waarom is de veilige versie correct?</h3>
            <div class="safe-box">
                De veilige controller past twee lagen toe:
                <ul>
                    <li><strong>Authenticatie:</strong> actieve sessie
                        vereist via <code>GetSession("role")</code> —
                        anders redirect naar login</li>
                    <li><strong>Autorisatie:</strong> gevraagde ID wordt
                        vergeleken met <code>sessionUserID</code> —
                        mismatch levert 403 op</li>
                    <li><strong>Admin-bypass:</strong> beheerders mogen
                        alle profielen inzien (expliciete uitzondering)</li>
                    <li><strong>Fail-closed:</strong> bij twijfel wordt
                        toegang geweigerd, niet verleend</li>
                </ul>
            </div>
        </div>
        <hr>

        <!-- Mitigatie -->
        <div class="info-section">
            <h3>🛡️ Mitigatie</h3>
            <p>
                Controleer altijd server-side of de aanvrager bevoegd
                is om het gevraagde object te zien. Gebruik het
                <em>deny-by-default</em> principe. Overweeg niet-
                sequentiële ID's (UUIDs) zodat enumeration moeilijker
                wordt, maar vertrouw hier <strong>niet</strong> op als
                enige beveiliging. Log alle autorisatiefouten.
            </p>
        </div>

    </div><!-- /modal -->
</div><!-- /modal-overlay -->

<footer>
    ⚠️ BVWA is uitsluitend bedoeld voor educatieve doeleinden —
    gebruik alleen in een geïsoleerde testomgeving.
</footer>

<!-- ── HULP MODAL ── -->
<div class="modal-overlay" id="helpModal">
    <div class="modal">
        <button type="button" class="modal-close" id="closeHelpBtn">✕</button>

        <h2>Hulp — A01 Broken Access Control</h2>
        <p class="subtitle">
            Beschikbare URL-parameters en test-scenario's voor dit HR-portaal
        </p>
        <hr>

        <div class="info-section">
            <h3>URL-parameter</h3>
            <p>
                Dit portaal gebruikt de <code>?id=</code> parameter om een
                medewerkersprofiel op te vragen:
            </p>
            <div class="code-block">/admin/vulnerable?id=&lt;nummer&gt;
/admin/secure?id=&lt;nummer&gt;</div>
        </div>
        <hr>

        <div class="info-section">
            <h3>Bekende medewerker-ID's</h3>
            <table style="width:100%; border-collapse:collapse; font-size:14px; margin-top:6px;">
                <thead>
                    <tr style="background:#f6f8fa; text-align:left;">
                        <th style="padding:8px 12px; border-bottom:1px solid #e0e0e0;">?id=</th>
                        <th style="padding:8px 12px; border-bottom:1px solid #e0e0e0;">Medewerker</th>
                        <th style="padding:8px 12px; border-bottom:1px solid #e0e0e0;">Afdeling</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">1</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">admin</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">IT</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">2</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">alice</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">Finance</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">3</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">bob</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">Operations</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace;">4</td>
                        <td style="padding:8px 12px;">carol</td>
                        <td style="padding:8px 12px;">Sales</td>
                    </tr>
                </tbody>
            </table>
        </div>
        <hr>

        <div class="info-section">
            <h3>Test-scenario's</h3>
            <table style="width:100%; border-collapse:collapse; font-size:14px; margin-top:6px;">
                <thead>
                    <tr style="background:#f6f8fa; text-align:left;">
                        <th style="padding:8px 12px; border-bottom:1px solid #e0e0e0;">URL</th>
                        <th style="padding:8px 12px; border-bottom:1px solid #e0e0e0;">Verwacht resultaat</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">?id=1</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">Admin-profiel met vertrouwelijke HR-notities</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">?id=2</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">Profiel van alice (standaard inloggebruiker)</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">?id=3</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">Profiel van bob — BSN en ziekteverlof zichtbaar</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">?id=4</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">Profiel van carol — bonuspercentage zichtbaar</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">?id=999</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">Medewerker niet gevonden</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace;">?id=abc</td>
                        <td style="padding:8px 12px;">Ongeldig formaat</td>
                    </tr>
                </tbody>
            </table>
        </div>
        <hr>

        <div class="info-section">
            <h3>Inloggegevens (veilige versie)</h3>
            <p>De veilige versie vereist een actieve sessie. Log in via
            <a href="/login" style="color:#3b82f6;">/login</a> met:</p>
            <table style="width:100%; border-collapse:collapse; font-size:14px; margin-top:6px;">
                <thead>
                    <tr style="background:#f6f8fa; text-align:left;">
                        <th style="padding:8px 12px; border-bottom:1px solid #e0e0e0;">Gebruiker</th>
                        <th style="padding:8px 12px; border-bottom:1px solid #e0e0e0;">Wachtwoord</th>
                        <th style="padding:8px 12px; border-bottom:1px solid #e0e0e0;">Rol</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">admin</td>
                        <td style="padding:8px 12px; font-family:monospace; border-bottom:1px solid #f0f0f0;">password123</td>
                        <td style="padding:8px 12px; border-bottom:1px solid #f0f0f0;">Admin — mag alle profielen zien</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 12px; font-family:monospace;">user</td>
                        <td style="padding:8px 12px; font-family:monospace;">user123</td>
                        <td style="padding:8px 12px;">Medewerker — alleen eigen profiel</td>
                    </tr>
                </tbody>
            </table>
        </div>

    </div><!-- /modal -->
</div><!-- /helpModal -->

<style>
.btn-help {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 6px 14px;
    background: #7c3aed;
    color: white;
    border: none;
    border-radius: 6px;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    transition: background 0.15s;
}
.btn-help:hover { background: #6d28d9; }
</style>

<script type="text/javascript" src="/static/js/modal.js"></script>
<script>
(function () {
    var openBtn  = document.getElementById('openHelpBtn');
    var closeBtn = document.getElementById('closeHelpBtn');
    var overlay  = document.getElementById('helpModal');
    if (openBtn)  openBtn.onclick = function (e) { e.preventDefault(); overlay.style.display = 'block'; document.body.style.overflow = 'hidden'; };
    if (closeBtn) closeBtn.onclick = function (e) { e.preventDefault(); overlay.style.display = 'none'; document.body.style.overflow = ''; };
    if (overlay)  overlay.onclick = function (e) { if (e.target === overlay) { overlay.style.display = 'none'; document.body.style.overflow = ''; } };
})();
</script>

</body>
</html>
