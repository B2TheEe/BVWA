#!/usr/bin/env python3
"""
BVWA Documentatie Generator v3.0
Genereert docs/BVWA_Documentatie_v3.0.pdf met reportlab.
"""

import os
from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.units import cm
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle,
    PageBreak, HRFlowable
)
from reportlab.lib.enums import TA_LEFT, TA_CENTER, TA_RIGHT

# ── Kleuren (zelfde als v2.0) ──────────────────────────────────────────────
C_HEADER   = colors.HexColor("#2c3e50")   # donkerblauw
C_RED      = colors.HexColor("#e74c3c")   # kwetsbaar
C_GREEN    = colors.HexColor("#27ae60")   # veilig
C_ORANGE   = colors.HexColor("#e67e22")   # stap-nummers
C_BLUE     = colors.HexColor("#3498db")   # info-box
C_LBLUE    = colors.HexColor("#d6eaf8")   # licht blauw (alternating)
C_LRED     = colors.HexColor("#fdecea")   # licht rood
C_LGREEN   = colors.HexColor("#eafaf1")   # licht groen
C_LGREY    = colors.HexColor("#f8f9fa")   # licht grijs
C_WHITE    = colors.white
C_BLACK    = colors.HexColor("#2c3e50")
C_GREY     = colors.HexColor("#666666")
C_CODEBG   = colors.HexColor("#f4f4f4")

PAGE_W, PAGE_H = A4
MARGIN = 2 * cm

# ── Stijlen ────────────────────────────────────────────────────────────────
styles = getSampleStyleSheet()

def s(name, **kw):
    """Helper: maak ParagraphStyle op basis van name + kwargs."""
    return ParagraphStyle(name, **kw)

ST_BODY       = s("body",      fontName="Helvetica",      fontSize=10, leading=14,
                               textColor=C_BLACK, spaceAfter=6)
ST_BODY_SM    = s("body_sm",   fontName="Helvetica",      fontSize=9,  leading=13,
                               textColor=C_BLACK)
ST_BOLD       = s("bold",      fontName="Helvetica-Bold",  fontSize=10, leading=14,
                               textColor=C_BLACK)
ST_H1         = s("h1",        fontName="Helvetica-Bold",  fontSize=18, leading=24,
                               textColor=C_HEADER, spaceAfter=4)
ST_H2         = s("h2",        fontName="Helvetica-Bold",  fontSize=13, leading=18,
                               textColor=C_HEADER, spaceBefore=10, spaceAfter=4)
ST_H3         = s("h3",        fontName="Helvetica-Bold",  fontSize=11, leading=15,
                               textColor=C_BLACK, spaceBefore=6, spaceAfter=3)
ST_CODE       = s("code",      fontName="Courier",         fontSize=9,  leading=13,
                               textColor=C_BLACK, backColor=C_CODEBG)
ST_WARN       = s("warn",      fontName="Helvetica-Bold",  fontSize=9,  leading=13,
                               textColor=C_WHITE)
ST_INFO       = s("info",      fontName="Helvetica-Bold",  fontSize=9,  leading=13,
                               textColor=C_WHITE)
ST_CENTER     = s("center",    fontName="Helvetica",       fontSize=10, leading=14,
                               alignment=TA_CENTER)
ST_SMALL_GREY = s("sm_grey",   fontName="Helvetica",       fontSize=8,  leading=12,
                               textColor=C_GREY, alignment=TA_CENTER)

# ── Hulpfuncties ───────────────────────────────────────────────────────────

def hr():
    return HRFlowable(width="100%", thickness=1.5, color=C_HEADER, spaceAfter=8)

def sp(h=6):
    return Spacer(1, h)

def p(text, style=None):
    return Paragraph(text, style or ST_BODY)

def colored_box(text, bg_color, text_style=None):
    """Gekleurde box (één cel tabel)."""
    ts = text_style or ST_WARN
    tbl = Table([[Paragraph(text, ts)]], colWidths=[PAGE_W - 2*MARGIN])
    tbl.setStyle(TableStyle([
        ("BACKGROUND", (0,0), (-1,-1), bg_color),
        ("TOPPADDING",    (0,0), (-1,-1), 8),
        ("BOTTOMPADDING", (0,0), (-1,-1), 8),
        ("LEFTPADDING",   (0,0), (-1,-1), 12),
        ("RIGHTPADDING",  (0,0), (-1,-1), 12),
        ("VALIGN",        (0,0), (-1,-1), "MIDDLE"),
    ]))
    return tbl

def code_box(lines):
    """Monospace code-block."""
    text = "<br/>".join(lines)
    tbl = Table([[Paragraph(text, ST_CODE)]], colWidths=[PAGE_W - 2*MARGIN])
    tbl.setStyle(TableStyle([
        ("BACKGROUND",    (0,0), (-1,-1), C_CODEBG),
        ("TOPPADDING",    (0,0), (-1,-1), 8),
        ("BOTTOMPADDING", (0,0), (-1,-1), 8),
        ("LEFTPADDING",   (0,0), (-1,-1), 10),
        ("RIGHTPADDING",  (0,0), (-1,-1), 10),
        ("BOX",           (0,0), (-1,-1), 0.5, C_GREY),
    ]))
    return tbl

def std_table(headers, rows, col_widths=None):
    """Standaard tabel met grijze header en alternerende rijen."""
    avail = PAGE_W - 2*MARGIN
    n = len(headers)
    if col_widths is None:
        col_widths = [avail / n] * n

    header_cells = [Paragraph(h, s("th", fontName="Helvetica-Bold", fontSize=9,
                                    leading=13, textColor=C_WHITE)) for h in headers]
    data = [header_cells]
    for row in rows:
        data.append([Paragraph(str(c), ST_BODY_SM) for c in row])

    tbl = Table(data, colWidths=col_widths)
    style = [
        ("BACKGROUND",    (0,0), (-1,0),  C_HEADER),
        ("TOPPADDING",    (0,0), (-1,-1), 7),
        ("BOTTOMPADDING", (0,0), (-1,-1), 7),
        ("LEFTPADDING",   (0,0), (-1,-1), 10),
        ("RIGHTPADDING",  (0,0), (-1,-1), 10),
        ("VALIGN",        (0,0), (-1,-1), "TOP"),
        ("GRID",          (0,0), (-1,-1), 0.3, colors.HexColor("#dddddd")),
    ]
    for i, _ in enumerate(rows):
        if i % 2 == 1:
            style.append(("BACKGROUND", (0, i+1), (-1, i+1), C_LGREY))
    tbl.setStyle(TableStyle(style))
    return tbl

def module_card(badge, title, description,
                vuln_why, safe_why, routes,
                badge_color=None):
    """OWASP module card: badge + title + beschrijving + kwetsbaar/veilig + routes."""
    avail = PAGE_W - 2*MARGIN
    if badge_color is None:
        badge_color = C_HEADER

    # Badge + titel header
    badge_p  = Paragraph(badge,  s("badge", fontName="Helvetica-Bold", fontSize=11,
                                    leading=14, textColor=C_WHITE))
    title_p  = Paragraph(title,  s("mtitle", fontName="Helvetica-Bold", fontSize=12,
                                    leading=15, textColor=C_WHITE))
    hdr = Table([[badge_p, title_p]], colWidths=[1.5*cm, avail - 1.5*cm])
    hdr.setStyle(TableStyle([
        ("BACKGROUND",    (0,0), (-1,-1), badge_color),
        ("TOPPADDING",    (0,0), (-1,-1), 8),
        ("BOTTOMPADDING", (0,0), (-1,-1), 8),
        ("LEFTPADDING",   (0,0), (-1,-1), 10),
        ("RIGHTPADDING",  (0,0), (-1,-1), 6),
        ("VALIGN",        (0,0), (-1,-1), "MIDDLE"),
    ]))

    # Beschrijving rij
    desc = Table([[Paragraph(description, ST_BODY_SM)]], colWidths=[avail])
    desc.setStyle(TableStyle([
        ("TOPPADDING",    (0,0), (-1,-1), 7),
        ("BOTTOMPADDING", (0,0), (-1,-1), 7),
        ("LEFTPADDING",   (0,0), (-1,-1), 10),
        ("RIGHTPADDING",  (0,0), (-1,-1), 10),
        ("BOX",           (0,0), (-1,-1), 0.3, colors.HexColor("#dddddd")),
    ]))

    # Kwetsbaar / Veilig kolommen
    half = avail / 2
    vw   = s("vhdr",  fontName="Helvetica-Bold", fontSize=9, leading=12,
               textColor=C_WHITE)
    vb   = s("vbody", fontName="Helvetica",      fontSize=9, leading=13,
               textColor=C_BLACK)

    kv_hdr = Table(
        [[Paragraph("Kwetsbaar", vw), Paragraph("Veilig", vw)]],
        colWidths=[half, half]
    )
    kv_hdr.setStyle(TableStyle([
        ("BACKGROUND",    (0,0), (0,0), C_RED),
        ("BACKGROUND",    (1,0), (1,0), C_GREEN),
        ("TOPPADDING",    (0,0), (-1,-1), 6),
        ("BOTTOMPADDING", (0,0), (-1,-1), 6),
        ("LEFTPADDING",   (0,0), (-1,-1), 10),
        ("RIGHTPADDING",  (0,0), (-1,-1), 10),
    ]))

    kv_body = Table(
        [[Paragraph("<b>Waarom kwetsbaar:</b><br/>" + vuln_why, vb),
          Paragraph("<b>Waarom veilig:</b><br/>" + safe_why, vb)]],
        colWidths=[half, half]
    )
    kv_body.setStyle(TableStyle([
        ("BACKGROUND",    (0,0), (0,0), C_LRED),
        ("BACKGROUND",    (1,0), (1,0), C_LGREEN),
        ("TOPPADDING",    (0,0), (-1,-1), 8),
        ("BOTTOMPADDING", (0,0), (-1,-1), 8),
        ("LEFTPADDING",   (0,0), (-1,-1), 10),
        ("RIGHTPADDING",  (0,0), (-1,-1), 10),
        ("VALIGN",        (0,0), (-1,-1), "TOP"),
        ("LINEAFTER",     (0,0), (0,-1), 0.3, colors.HexColor("#dddddd")),
    ]))

    # Routes tabel
    route_rows = [[Paragraph(r, ST_CODE), Paragraph(d, ST_BODY_SM)] for r, d in routes]
    route_data = [
        [Paragraph("Route", s("rh", fontName="Helvetica-Bold", fontSize=9,
                               leading=12, textColor=C_WHITE)),
         Paragraph("Beschrijving", s("rh", fontName="Helvetica-Bold", fontSize=9,
                                      leading=12, textColor=C_WHITE))]
    ] + route_rows
    route_tbl = Table(route_data, colWidths=[avail * 0.4, avail * 0.6])
    rs = [
        ("BACKGROUND",    (0,0), (-1,0),  C_HEADER),
        ("TOPPADDING",    (0,0), (-1,-1), 6),
        ("BOTTOMPADDING", (0,0), (-1,-1), 6),
        ("LEFTPADDING",   (0,0), (-1,-1), 10),
        ("RIGHTPADDING",  (0,0), (-1,-1), 10),
        ("GRID",          (0,0), (-1,-1), 0.3, colors.HexColor("#dddddd")),
    ]
    for i, _ in enumerate(route_rows):
        if i % 2 == 1:
            rs.append(("BACKGROUND", (0, i+1), (-1, i+1), C_LGREY))
    route_tbl.setStyle(TableStyle(rs))

    return [hdr, desc, kv_hdr, kv_body, route_tbl, sp(12)]


# ══════════════════════════════════════════════════════════════════════════════
# CONTENT BUILDERS
# ══════════════════════════════════════════════════════════════════════════════

def build_cover():
    avail = PAGE_W - 2*MARGIN

    title_tbl = Table(
        [[Paragraph("BVWA", s("ct", fontName="Helvetica-Bold", fontSize=32,
                               leading=38, textColor=C_WHITE, alignment=TA_CENTER))]],
        colWidths=[avail]
    )
    title_tbl.setStyle(TableStyle([
        ("BACKGROUND",    (0,0), (-1,-1), C_HEADER),
        ("TOPPADDING",    (0,0), (-1,-1), 20),
        ("BOTTOMPADDING", (0,0), (-1,-1), 20),
    ]))

    sub1 = Table(
        [[Paragraph("Beego Vulnerable Web Application",
                     s("s1", fontName="Helvetica-Bold", fontSize=18,
                        leading=24, textColor=C_WHITE, alignment=TA_CENTER))]],
        colWidths=[avail]
    )
    sub1.setStyle(TableStyle([
        ("BACKGROUND",    (0,0), (-1,-1), C_RED),
        ("TOPPADDING",    (0,0), (-1,-1), 10),
        ("BOTTOMPADDING", (0,0), (-1,-1), 10),
    ]))

    sub2 = Table(
        [[Paragraph("OWASP Top 10:2025  |  Versie 3.0  |  April 2026",
                     s("s2", fontName="Helvetica-Bold", fontSize=14,
                        leading=20, textColor=C_WHITE, alignment=TA_CENTER))]],
        colWidths=[avail]
    )
    sub2.setStyle(TableStyle([
        ("BACKGROUND",    (0,0), (-1,-1), C_BLUE),
        ("TOPPADDING",    (0,0), (-1,-1), 10),
        ("BOTTOMPADDING", (0,0), (-1,-1), 10),
    ]))

    warn = colored_box(
        "WAARSCHUWING: BVWA is uitsluitend bedoeld voor educatieve doeleinden. "
        "Gebruik het NOOIT in productie of op een publiek toegankelijke server. "
        "Draai het uitsluitend in een geisoleerde, lokale testomgeving.",
        C_RED
    )

    return [sp(80), title_tbl, sub1, sub2, sp(16), warn, PageBreak()]


def build_toc():
    items = [
        ("1.", "Projectoverzicht & Nieuw in v3.0"),
        ("2.", "Installatie & Configuratie"),
        ("3.", "Projectstructuur"),
        ("4.", "OWASP Top 10:2025 Modules (A01–A10)"),
        ("5.", "CTF Modus"),
        ("6.", "Login & Dashboard"),
        ("7.", "Error Pages"),
        ("8.", "Test Credentials"),
        ("9.", "Technologieen"),
        ("10.", "Disclaimer"),
    ]
    avail = PAGE_W - 2*MARGIN
    rows = []
    for i, (num, title) in enumerate(items):
        bg = C_LGREY if i % 2 == 1 else C_WHITE
        rows.append((num, title, bg))

    tbl_data = [[Paragraph(n, ST_BODY), Paragraph(t, ST_BODY)] for n, t, _ in rows]
    tbl = Table(tbl_data, colWidths=[1.2*cm, avail - 1.2*cm])
    ts = [
        ("TOPPADDING",    (0,0), (-1,-1), 8),
        ("BOTTOMPADDING", (0,0), (-1,-1), 8),
        ("LEFTPADDING",   (0,0), (-1,-1), 10),
        ("RIGHTPADDING",  (0,0), (-1,-1), 10),
        ("LINEBELOW",     (0,0), (-1,-1), 0.3, colors.HexColor("#dddddd")),
    ]
    for i, (_, _, bg) in enumerate(rows):
        ts.append(("BACKGROUND", (0,i), (-1,i), bg))
    tbl.setStyle(TableStyle(ts))

    return [
        p("Inhoudsopgave", ST_H1), hr(), sp(4), tbl, PageBreak()
    ]


def build_section1():
    avail = PAGE_W - 2*MARGIN

    intro = p(
        "BVWA (Beego Vulnerable Web Application) is een opzettelijk kwetsbare webapplicatie "
        "gebouwd met het Go Beego framework, gebaseerd op de OWASP Top 10:2025. Elke module "
        "toont een kwetsbare en een veilige implementatie met uitleg via een Info &amp; CWEs knop. "
        "Versie 3.0 voegt realistische scenario's, een volledig CTF-systeem en een "
        "gestandaardiseerde 'Hulp &amp; Commando's' knop toe aan alle modules."
    )

    github = colored_box(
        "GitHub: https://github.com/B2TheEe/BVWA",
        C_BLUE, ST_INFO
    )

    nieuw_rows = [
        ("Realistische scenario's",
         "Elk OWASP-module heeft nu een eigen fictiefbedrijfsscenario "
         "(bvwa-bank, bvwa-passwd, bvwa-pkg, bvwa-auth, NovaPay etc.)"),
        ("CTF Modus",
         "10 verborgen flags (een per module). Scoreboard op /ctf, "
         "indienen via /ctf/submit. Formaat: BVWA{...}"),
        ("Hulp & Commando's knop",
         "Alle 19 views hebben nu een uniforme paarse 'Hulp & Commando's' knop "
         "met module-specifieke commando's en testdata"),
        ("Echte Voorbeelden knop",
         "Elke module toont historische incidenten (data-lekken, hacks) "
         "passend bij de OWASP-categorie"),
        ("CLI-interface modules",
         "A03/A04/A06/A07/A08/A09/A10 gebruiken een interactieve terminal-interface "
         "waarmee studenten commando's uitvoeren"),
        ("Uniforme header",
         "Alle modules hebben dezelfde BVWA-header met navigatie"),
        ("Info & CWEs knop",
         "Elke module heeft een modal met uitleg en alle relevante CWEs"),
        ("Inject simulatie",
         "SQL injection via in-memory simulatie zonder echte database"),
        ("Security log terminal",
         "A09 toont live security logs in terminal-stijl"),
        ("Error pages",
         "Aangepaste 400, 403, 404 en 500 errorpagina's"),
    ]

    tbl = std_table(
        ["Feature", "Beschrijving"],
        nieuw_rows,
        col_widths=[avail*0.3, avail*0.7]
    )

    return [
        p("1. Projectoverzicht &amp; Nieuw in v3.0", ST_H1), hr(),
        intro, sp(8),
        github, sp(12),
        p("Nieuw in versie 3.0:", ST_H2), sp(4),
        tbl, PageBreak()
    ]


def build_section2():
    avail = PAGE_W - 2*MARGIN

    vereisten = std_table(
        ["Tool", "Versie", "Website"],
        [
            ("Go",       "1.24+",           "golang.org"),
            ("MySQL",    "5.7+ (optioneel)", "mysql.com"),
            ("Beego",    "v2.x",            "beego.vip"),
            ("bee CLI",  "v2.x",            "github.com/beego/bee"),
            ("bcrypt",   "golang.org/x/crypto", "pkg.go.dev"),
        ],
        col_widths=[avail*0.25, avail*0.35, avail*0.4]
    )

    steps = [
        ("1", "Clone project",
         "git clone https://github.com/B2TheEe/BVWA.git\ncd BVWA"),
        ("2", "Dependencies",
         "go mod tidy\ngo get golang.org/x/crypto/bcrypt"),
        ("3", "Bee CLI",
         "go install github.com/beego/bee/v2@latest"),
        ("4", "Database (optioneel)",
         "mysql -u root -p\nCREATE DATABASE bvwa;"),
        ("5", "Configureer app.conf",
         "Pas db_user, db_pass en db_name aan\n(optioneel — app draait standaard in-memory)"),
        ("6", "Start app",
         "bee run"),
        ("7", "Open browser",
         "http://127.0.0.1:8080"),
    ]

    step_rows = []
    for num, title, cmd in steps:
        num_p  = Paragraph(num,   s("sn", fontName="Helvetica-Bold", fontSize=11,
                                     leading=14, textColor=C_WHITE, alignment=TA_CENTER))
        body   = Paragraph(
            f"<b>{title}</b><br/><font name='Courier' size='8'>"
            + cmd.replace("\n", "<br/>") + "</font>",
            s("sb", fontName="Helvetica", fontSize=9, leading=13, textColor=C_BLACK)
        )
        step_rows.append([num_p, body])

    steps_tbl = Table(step_rows, colWidths=[1.2*cm, avail - 1.2*cm])
    steps_tbl.setStyle(TableStyle([
        ("BACKGROUND",    (0,0), (0,-1), C_ORANGE),
        ("BACKGROUND",    (1,0), (1,-1), C_WHITE),
        ("TOPPADDING",    (0,0), (-1,-1), 8),
        ("BOTTOMPADDING", (0,0), (-1,-1), 8),
        ("LEFTPADDING",   (0,0), (-1,-1), 8),
        ("RIGHTPADDING",  (0,0), (-1,-1), 8),
        ("VALIGN",        (0,0), (-1,-1), "TOP"),
        ("LINEBELOW",     (0,0), (-1,-1), 0.5, C_LGREY),
    ]))

    conf_lines = [
        "appname = bvwa",
        "httpport = 8080",
        "runmode = dev",
        "sessionon = true",
        "sessionname = bvwasession",
        "",
        "db_user = root",
        "db_pass = jouwwachtwoord",
        "db_host = 127.0.0.1",
        "db_port = 3306",
        "db_name = bvwa",
    ]

    return [
        p("2. Installatie &amp; Configuratie", ST_H1), hr(),
        p("Vereisten:", ST_H2), sp(4), vereisten, sp(12),
        p("Installatiestappen:", ST_H2), sp(4), steps_tbl, sp(12),
        p("conf/app.conf:", ST_H2), sp(4),
        code_box(conf_lines),
        PageBreak()
    ]


def build_section3():
    avail = PAGE_W - 2*MARGIN
    half  = (avail - 0.4*cm) / 2

    col_left = [
        "bvwa/",
        "|- conf/app.conf",
        "|- controllers/",
        "|  |- access_control.go   (A01)",
        "|  |- security_misconfig.go(A02)",
        "|  |- supply_chain.go     (A03)",
        "|  |- crypto.go           (A04)",
        "|  |- injection.go        (A05)",
        "|  |- insecure_design.go  (A06)",
        "|  |- auth.go             (A07)",
        "|  |- integrity.go        (A08)",
        "|  |- logging.go          (A09)",
        "|  |- exceptions.go       (A10)",
        "|  |- ctf.go         (CTF Modus)",
        "|  |- home.go         (Homepage)",
        "|  |- login.go  (Login+Dashboard)",
        "|- routers/router.go",
        "|- static/css/bvwa.css",
        "|- static/js/modal.js",
        "|- static/js/ctf.js",
        "|- tests/security.log",
        "|- main.go",
        "|- go.mod",
        "|- security.log",
        "|- README.md",
    ]

    col_right = [
        "|- views/",
        "|  |- home/index.tpl",
        "|  |- admin/dashboard.tpl       (A01)",
        "|  |- misconfig/index.tpl       (A02)",
        "|  |- misconfig/vulnerable.tpl",
        "|  |- misconfig/secure.tpl",
        "|  |- supplychain/index.tpl     (A03)",
        "|  |- supplychain/vulnerable.tpl",
        "|  |- supplychain/secure.tpl",
        "|  |- crypto/index.tpl          (A04)",
        "|  |- crypto/vulnerable.tpl",
        "|  |- crypto/secure.tpl",
        "|  |- injection/sql.tpl         (A05)",
        "|  |- injection/xss.tpl         (A05)",
        "|  |- design/index.tpl          (A06)",
        "|  |- design/vulnerable.tpl",
        "|  |- design/secure.tpl",
        "|  |- auth/login.tpl            (A07)",
        "|  |- auth/vulnerable.tpl",
        "|  |- auth/secure.tpl",
        "|  |- integrity/index.tpl       (A08)",
        "|  |- integrity/vulnerable.tpl",
        "|  |- integrity/secure.tpl",
        "|  |- logging/index.tpl         (A09)",
        "|  |- logging/vulnerable.tpl",
        "|  |- logging/secure.tpl",
        "|  |- exceptions/index.tpl      (A10)",
        "|  |- exceptions/vulnerable.tpl",
        "|  |- exceptions/secure.tpl",
        "|  |- ctf/index.tpl        (CTF Modus)",
        "|  |- login/index.tpl",
        "|  |- login/register.tpl",
        "|  |- login/dashboard.tpl",
        "|  |- errors/400.tpl",
        "|  |- errors/403.tpl",
        "|  |- errors/404.tpl",
        "|  |- errors/500.tpl",
    ]

    def mini_code(lines):
        text = "<br/>".join(lines)
        st = s("mc", fontName="Courier", fontSize=8, leading=11, textColor=C_BLACK)
        tbl = Table([[Paragraph(text, st)]], colWidths=[half])
        tbl.setStyle(TableStyle([
            ("BACKGROUND",    (0,0), (-1,-1), C_CODEBG),
            ("TOPPADDING",    (0,0), (-1,-1), 8),
            ("BOTTOMPADDING", (0,0), (-1,-1), 8),
            ("LEFTPADDING",   (0,0), (-1,-1), 8),
            ("RIGHTPADDING",  (0,0), (-1,-1), 8),
            ("BOX",           (0,0), (-1,-1), 0.5, C_GREY),
        ]))
        return tbl

    two_col = Table(
        [[mini_code(col_left), mini_code(col_right)]],
        colWidths=[half, half],
        hAlign="LEFT"
    )
    two_col.setStyle(TableStyle([
        ("VALIGN",       (0,0), (-1,-1), "TOP"),
        ("LEFTPADDING",  (0,0), (-1,-1), 0),
        ("RIGHTPADDING", (0,0), (-1,-1), 0),
        ("TOPPADDING",   (0,0), (-1,-1), 0),
        ("BOTTOMPADDING",(0,0), (-1,-1), 0),
        ("INNERGRID",    (0,0), (-1,-1), 0, colors.white),
    ]))

    return [
        p("3. Projectstructuur", ST_H1), hr(),
        two_col,
        PageBreak()
    ]


def build_section4():
    avail = PAGE_W - 2*MARGIN
    elems = [p("4. OWASP Top 10:2025 Modules", ST_H1), hr(), sp(6)]

    modules = [
        dict(
            badge="A01",
            title="Broken Access Control",
            description=(
                "Toegangscontrole wordt niet afgedwongen. Gebruikers kunnen buiten hun "
                "bedoelde rechten handelen. Dit module demonstreert IDOR (Insecure Direct "
                "Object Reference, CWE-639) via het MegaCorp HR-portaal: medewerkerprofielen "
                "zijn opvraagbaar via de ?id= parameter zonder autorisatiecheck."
            ),
            vuln_why=(
                "Geen sessie-/rolcontrole. Elke bezoeker heeft directe toegang via URL. "
                "Sequentieel ophogen van ?id= onthult alle profielen inclusief "
                "vertrouwelijke HR-notities (salaris, BSN, ziekteverlof)."
            ),
            safe_why=(
                "Server-side rolcontrole met GetSession(). Fail-closed: geen sessie = "
                "redirect naar login. Admins mogen alle profielen zien; gewone gebruikers "
                "alleen hun eigen profiel."
            ),
            routes=[
                ("/admin/vulnerable", "Kwetsbaar — geen autorisatiecheck"),
                ("/admin/secure",     "Veilig — met sessie- en rolcontrole"),
            ]
        ),
        dict(
            badge="A02",
            title="Security Misconfiguration",
            description=(
                "Ontbrekende of verkeerde beveiligingsconfiguratie. 100% van applicaties "
                "getroffen. Dit module simuleert een blootgesteld debug-console waarmee "
                "shell-commando's worden uitgevoerd en omgevingsvariabelen worden gelekt."
            ),
            vuln_why=(
                "Geen authenticatie op debug-endpoint. Response headers lekken serverinfo "
                "(X-Powered-By, Server). Omgevingsvariabelen zoals DB_PASSWORD en "
                "SECRET_KEY zijn via 'env' op te vragen. Commando's: hostname, whoami, "
                "env, cat bvwa.conf, cat secret.txt, ps, ifconfig."
            ),
            safe_why=(
                "Debug-console volledig uitgeschakeld. Vier security-headers per response: "
                "X-Content-Type-Options: nosniff, X-Frame-Options: DENY, "
                "Content-Security-Policy, Strict-Transport-Security. "
                "Geen serverinfo in headers."
            ),
            routes=[
                ("/misconfig/vulnerable", "Kwetsbaar — blootgesteld debug-console"),
                ("/misconfig/secure",     "Veilig — security headers, geen debug"),
            ]
        ),
        dict(
            badge="A03",
            title="Software Supply Chain Failures",
            description=(
                "Kwetsbaarheden via externe dependencies: niet-geverifieerde packages, "
                "kwaadaardige postinstall-hooks. Dit module simuleert bvwa-pkg, een "
                "fictieve package manager zonder integriteitscontrole."
            ),
            vuln_why=(
                "Checksum-verificatie uitgeschakeld (--no-verify). Security-audit "
                "overgeslagen (--no-audit). Installatie van bvwa-logger@2.1.3 voert een "
                "kwaadaardig postinstall-hook uit die telemetrie leakt inclusief de CTF-flag. "
                "Commando's: list, info, install, search, verify (uitgeschakeld), audit (overgeslagen)."
            ),
            safe_why=(
                "Checksum-verificatie ingeschakeld: SHA-256 hash van package vergeleken met "
                "registry. Gemanipuleerde packages worden geweigerd. Audit toont "
                "integriteitsstatus van alle geinstalleerde packages."
            ),
            routes=[
                ("/supplychain/vulnerable", "Kwetsbaar — geen checksum verificatie"),
                ("/supplychain/secure",     "Veilig — SHA-256 integriteitscontrole"),
            ]
        ),
        dict(
            badge="A04",
            title="Cryptographic Failures",
            description=(
                "Zwakke of ontbrekende versleuteling. Vroeger: Sensitive Data Exposure. "
                "Dit module simuleert bvwa-passwd, een fictieve credential manager die "
                "MD5-hashing en Base64-only tokens gebruikt."
            ),
            vuln_why=(
                "MD5 voor wachtwoorden: geen salt, deterministisch, triviaal te brute-forcen "
                "(50+ miljard/sec op GPU). Base64-only auth-tokens zonder handtekening: "
                "payload leesbaar in DevTools. Rainbow table voor veelgebruikte hashes. "
                "Commando's: login, hash, crack, token, decode, whoami, users."
            ),
            safe_why=(
                "bcrypt: ingebouwde salt, opzettelijk traag (~100ms), aanpasbare cost factor, "
                "timing-safe vergelijking. HMAC-SHA256 gesigneerde tokens: formaat "
                "base64_payload.hex_signature. Token-manipulatie detecteerbaar."
            ),
            routes=[
                ("/crypto/vulnerable", "Kwetsbaar — MD5 + Base64-token"),
                ("/crypto/secure",     "Veilig — bcrypt + HMAC-SHA256"),
            ]
        ),
        dict(
            badge="A05",
            title="Injection (SQL &amp; XSS)",
            description=(
                "Gebruikersinput als code uitgevoerd. SQL Injection en Cross-Site Scripting. "
                "SQL-scenario: MegaCorp Medewerkersdirectory. XSS-scenario: BvwAshop Productzoeker."
            ),
            vuln_why=(
                "SQL: directe string-concatenatie in query — aanvaller omzeilt WHERE-conditie "
                "en krijgt alle records terug. "
                "XSS: str2html rendert raw HTML input van gebruiker — script-tags worden "
                "uitgevoerd, sessiecookies uitleesbaar."
            ),
            safe_why=(
                "SQL: geparametriseerde queries met ? placeholder — input nooit als SQL "
                "uitgevoerd. "
                "XSS: Beego escapet automatisch via {{.Variable}} — "
                "&lt; wordt &amp;lt;, scripts worden als tekst weergegeven."
            ),
            routes=[
                ("/injection/sql/vulnerable", "SQL — Kwetsbaar (string concatenatie)"),
                ("/injection/sql/secure",     "SQL — Veilig (geparametriseerde query)"),
                ("/injection/xss/vulnerable", "XSS — Kwetsbaar (str2html)"),
                ("/injection/xss/secure",     "XSS — Veilig (automatisch escapen)"),
            ]
        ),
        dict(
            badge="A06",
            title="Insecure Design",
            description=(
                "Fundamentele ontwerpfouten in architectuur. Beveiliging moet ingebakken zijn, "
                "niet achteraf toegevoegd. Dit module simuleert bvwa-bank: een online "
                "overboekingssysteem met een business logic flaw — negatieve bedragen worden "
                "zonder validatie verwerkt."
            ),
            vuln_why=(
                "Geen validatie op het teken van het overboekingsbedrag (CWE-840). "
                "Geen overdraft-check (CWE-841). Negatieve bedragen zorgen voor geld dat "
                "omgekeerd stroomt. Blootgesteld debug-endpoint op /api/v1/debug. "
                "Commando's: balance, transfer, history, accounts."
            ),
            safe_why=(
                "Server-side validatie: bedrag moet &gt; 0 zijn. Overdraft-check voorkomt "
                "overboeking boven het saldo. Generieke foutmeldingen. "
                "Debug-endpoint uitgeschakeld in veilige versie."
            ),
            routes=[
                ("/design/vulnerable", "Kwetsbaar — geen bedragvalidatie (bvwa-bank)"),
                ("/design/secure",     "Veilig — bedrag &gt; 0 + overdraft-check"),
                ("/api/v1/debug",      "Debug endpoint — intentioneel blootgesteld (A06)"),
            ]
        ),
        dict(
            badge="A07",
            title="Authentication Failures",
            description=(
                "Zwakke authenticatie en sessiebeheer. Vroeger: Broken Authentication. "
                "Dit module simuleert bvwa-auth, een fictief corporate authentication gateway "
                "kwetsbaar voor credential stuffing en brute force."
            ),
            vuln_why=(
                "Plaintext wachtwoord-vergelijking (CWE-256). User enumeration via "
                "verschillende foutmeldingen (CWE-204). Geen rate limiting (CWE-307). "
                "Voorspelbare sequentiele sessie-tokens (sess_00042, CWE-330). "
                "Commando's: login &lt;user&gt; &lt;pass&gt;, enum &lt;user&gt;, session, help."
            ),
            safe_why=(
                "bcrypt wachtwoord-hashing met MinCost. Rate limiting: max 5 pogingen "
                "per IP. Generieke foutmeldingen (geen user enumeration). "
                "Cryptografisch willekeurige sessie-tokens. DestroySession() bij login."
            ),
            routes=[
                ("/auth/vulnerable", "Kwetsbaar — geen beveiliging (bvwa-auth)"),
                ("/auth/secure",     "Veilig — bcrypt + rate limiting"),
            ]
        ),
        dict(
            badge="A08",
            title="Software/Data Integrity Failures",
            description=(
                "Geserialiseerde data zonder integriteitscontrole. Omvat insecure "
                "deserialization. Dit module simuleert bvwa-deploy, een CI/CD "
                "deployment-systeem met aanpasbare deployment-tokens."
            ),
            vuln_why=(
                "Deployment-tokens zijn Base64-JSON zonder handtekening (CWE-345/CWE-502). "
                "Aanvaller kan token decoderen, role:admin instellen, opnieuw encoderen "
                "en een geautoriseerde deployment uitvoeren. "
                "Commando's: token, decode, encode, deploy."
            ),
            safe_why=(
                "HMAC-SHA256 handtekening op alle tokens. Token-formaat: "
                "base64_payload.hex_signature. Timing-safe vergelijking via hmac.Equal(). "
                "Fail-closed: ongeldige handtekening = deployment geweigerd."
            ),
            routes=[
                ("/integrity/vulnerable", "Kwetsbaar — geen handtekening (bvwa-deploy)"),
                ("/integrity/secure",     "Veilig — HMAC-SHA256"),
            ]
        ),
        dict(
            badge="A09",
            title="Security Logging &amp; Alerting Failures",
            description=(
                "Beveiligingsgebeurtenissen niet gelogd of verkeerd gelogd. Aanvallen "
                "blijven onopgemerkt. Dit module simuleert bvwa-auditd, een "
                "security audit daemon."
            ),
            vuln_why=(
                "Wachtwoorden opgeslagen in plaintext in logs (CWE-532). "
                "Geen alertering bij brute force-pogingen (CWE-223). "
                "Ongescapede gebruikersinput in logregels (CWE-117). "
                "Commando's: view, search, login, alert (nep)."
            ),
            safe_why=(
                "Wachtwoorden vervangen door ***REDACTED***. Brute force-detectie: "
                "ALERT na 4 mislukte pogingen van hetzelfde IP. "
                "Input gesaniteerd in logs. Correcte log-niveaus: INFO, WARN, ALERT."
            ),
            routes=[
                ("/logging/vulnerable", "Kwetsbaar — plaintext wachtwoorden in logs"),
                ("/logging/secure",     "Veilig — redacted + brute force alert"),
            ]
        ),
        dict(
            badge="A10",
            title="Mishandling of Exceptional Conditions",
            description=(
                "Onjuiste foutafhandeling. 24 gerelateerde CWEs. Fail-open gedrag en "
                "info-lekkage. Dit module simuleert NovaPay DiagTool, een fictief fintech "
                "diagnostics platform."
            ),
            vuln_why=(
                "Fouten genegeerd met _ (CWE-391). Negatieve bedragen niet gevalideerd. "
                "Fail-open bij authenticatie-paniek (CWE-636). "
                "Interne database-details gelekt via exception-messages (CWE-209). "
                "Commando's: status, check, pay, config, txlog."
            ),
            safe_why=(
                "Alle fouten afgehandeld. Generieke foutmeldingen naar gebruiker. "
                "Fail-closed principe bij elke fout. "
                "Interne logging zonder lekkage naar buitenkant. "
                "Strikte inputvalidatie op alle bedragen."
            ),
            routes=[
                ("/exceptions/vulnerable", "Kwetsbaar — fail-open (NovaPay DiagTool)"),
                ("/exceptions/secure",     "Veilig — fail-closed"),
            ]
        ),
    ]

    for mod in modules:
        elems += module_card(**mod)

    elems.append(PageBreak())
    return elems


def build_section5():
    """CTF Modus — nieuw in v3.0."""
    avail = PAGE_W - 2*MARGIN

    intro = p(
        "BVWA heeft een ingebouwd CTF-systeem (Capture The Flag). In elke module is een "
        "verborgen flag verstopt. Studenten vinden de flag door de kwetsbare versie te "
        "exploiteren. De flags worden ingediend via het scoreboard."
    )

    routes = std_table(
        ["Route", "Methode", "Beschrijving"],
        [
            ("/ctf",        "GET",  "CTF-scoreboard met voortgangsbalk en challenge-overzicht"),
            ("/ctf/submit", "POST", "Flag indienen (veld: flag). Redirect naar /ctf na verwerking"),
        ],
        col_widths=[avail*0.3, avail*0.15, avail*0.55]
    )

    flags = [
        ("A01", "BVWA{1D0R_4cc3ss_2026}",          "/admin/vulnerable?id=1",
         "Vraag het admin-profiel op via IDOR — flag staat in de X-CTF-Flag response header"),
        ("A02", "BVWA{M1scC0nf1g_D1r_2026}",        "/misconfig/vulnerable",
         "Voer 'cat secret.txt' of 'env' uit in de debug-console"),
        ("A03", "BVWA{Supp1y_Ch41n_2026}",           "/supplychain/vulnerable",
         "Installeer bvwa-logger@2.1.3 — flag verschijnt in de postinstall-telemetrie"),
        ("A04", "BVWA{We4k_3ncrypt10n_2026}",        "/crypto/vulnerable",
         "Doe 'token' en vervolgens 'decode' — flag zit in de Base64-payload"),
        ("A05 SQL", "BVWA{SQLi_D1r3ct0ry_2026}",    "/injection/sql/vulnerable",
         "Gebruik payload \\' OR '1'='1 — flag staat in het e-mailadres van db_admin"),
        ("A05 XSS", "BVWA{XSS_R3fl3ct3d_2026}",     "/injection/xss/vulnerable",
         "Voer een XSS-payload in — flag staat in de X-CTF-Flag response header"),
        ("A06", "BVWA{N3g4t1ve_Tr4nsf3r_2026}",     "/design/vulnerable",
         "Gebruik 'transfer NL91ABNA... -500' — negatief bedrag triggert de flag"),
        ("A07", "BVWA{Brute_F0rc3_2026}",            "/auth/vulnerable",
         "Brute force het admin-account — flag verschijnt na succesvolle login"),
        ("A08", "BVWA{1nt3gr1ty_Ch3ck_2026}",        "/integrity/vulnerable",
         "Decodeer token, zet role op admin, encodeer opnieuw en voer 'deploy' uit"),
        ("A09", "BVWA{S3ns1tive_L0g_2026}",          "/logging/vulnerable",
         "Bekijk de logs via 'view' — flag staat in een logregel met plaintext wachtwoord"),
        ("A10", "BVWA{F41l_0p3n_Exc3pt10n_2026}",   "/exceptions/vulnerable",
         "Stuur een negatief bedrag via 'pay' — exception leakt de flag"),
    ]

    st_flag = s("flag_cell", fontName="Courier", fontSize=8, leading=12, textColor=C_BLACK)
    st_hdr  = s("fhdr", fontName="Helvetica-Bold", fontSize=9, leading=12, textColor=C_WHITE)
    st_cell = s("fcell", fontName="Helvetica", fontSize=9, leading=13, textColor=C_BLACK)

    flag_data = [[Paragraph("Module", st_hdr),
                  Paragraph("Flag", st_hdr),
                  Paragraph("Locatie/Hint", st_hdr)]]
    for i, (m, f, _, h) in enumerate(flags):
        flag_data.append([
            Paragraph(m,  st_cell),
            Paragraph(f,  st_flag),
            Paragraph(h,  st_cell),
        ])

    flag_tbl = Table(flag_data, colWidths=[avail*0.1, avail*0.38, avail*0.52])
    fts = [
        ("BACKGROUND",    (0,0), (-1,0),  C_HEADER),
        ("TOPPADDING",    (0,0), (-1,-1), 7),
        ("BOTTOMPADDING", (0,0), (-1,-1), 7),
        ("LEFTPADDING",   (0,0), (-1,-1), 8),
        ("RIGHTPADDING",  (0,0), (-1,-1), 8),
        ("VALIGN",        (0,0), (-1,-1), "TOP"),
        ("GRID",          (0,0), (-1,-1), 0.3, colors.HexColor("#dddddd")),
    ]
    for i in range(len(flags)):
        if i % 2 == 1:
            fts.append(("BACKGROUND", (0, i+1), (-1, i+1), C_LGREY))
    flag_tbl.setStyle(TableStyle(fts))

    tip = colored_box(
        "Tip: Alle flags hebben het formaat BVWA{...}. Kijk in HTML-commentaar, "
        "response headers (F12 → Network → Response Headers), cookies en log-output.",
        C_BLUE, ST_INFO
    )

    return [
        p("5. CTF Modus", ST_H1), hr(),
        intro, sp(8),
        p("Routes:", ST_H2), sp(4), routes, sp(10),
        p("Flags &amp; Hints:", ST_H2), sp(4), flag_tbl, sp(10),
        tip,
        PageBreak()
    ]


def build_section6():
    avail = PAGE_W - 2*MARGIN

    body = p(
        "BVWA heeft een volledig login-systeem met sessies. Na succesvol inloggen wordt de "
        "gebruiker doorgestuurd naar een dashboard met een overzicht van alle 10 OWASP-modules "
        "en de CTF-voortgang."
    )

    routes = std_table(
        ["Route", "Beschrijving"],
        [
            ("/login",     "Login pagina (GET = formulier, POST = verwerking)"),
            ("/register",  "Registratie pagina voor nieuwe gebruikers"),
            ("/dashboard", "Dashboard na inloggen — overzicht alle modules + CTF widget"),
            ("/logout",    "Sessie vernietigen en redirect naar /"),
        ],
        col_widths=[avail*0.25, avail*0.75]
    )

    note = p(
        "De /admin/secure route (A01) stuurt niet-geauthenticeerde gebruikers door naar /login. "
        "Na inloggen als admin wordt de sessie vernieuwd en de rol 'admin' ingesteld."
    )

    return [
        p("6. Login &amp; Dashboard", ST_H1), hr(),
        body, sp(8),
        routes, sp(10),
        note,
        PageBreak()
    ]


def build_section7():
    avail = PAGE_W - 2*MARGIN

    body = p(
        "BVWA heeft aangepaste errorpagina's die consistent zijn met de rest van de applicatie. "
        "Ze zijn geregistreerd via beego.ErrorHandler() in main.go."
    )

    tbl = std_table(
        ["Code", "Naam", "Bestand", "Kleur"],
        [
            ("400", "Bad Request",           "views/errors/400.tpl", "Blauw (#3498db)"),
            ("403", "Forbidden",             "views/errors/403.tpl", "Paars (#8e44ad)"),
            ("404", "Not Found",             "views/errors/404.tpl", "Rood (#e74c3c)"),
            ("500", "Internal Server Error", "views/errors/500.tpl", "Oranje (#e67e22)"),
        ],
        col_widths=[avail*0.1, avail*0.25, avail*0.35, avail*0.3]
    )

    note = p(
        "De 500-errorpagina bevat een security-notitie die verwijst naar A10 (Mishandling of "
        "Exceptional Conditions). De 403-pagina verwijst naar A01 (Broken Access Control)."
    )

    reg = code_box([
        'beego.ErrorHandler("404", page404)',
        'beego.ErrorHandler("500", page500)',
        'beego.ErrorHandler("403", page403)',
        'beego.ErrorHandler("400", page400)',
    ])

    return [
        p("7. Error Pages", ST_H1), hr(),
        body, sp(8),
        tbl, sp(10),
        note, sp(8),
        p("main.go registratie:", ST_H2), sp(4), reg,
        PageBreak()
    ]


def build_section8():
    avail = PAGE_W - 2*MARGIN

    tbl = std_table(
        ["Gebruikersnaam", "Wachtwoord", "Rol", "Gebruik"],
        [
            ("admin",   "password123", "Administrator", "Login, A07, A09"),
            ("user",    "user123",     "Gebruiker",     "Login (beperkte rechten)"),
        ],
        col_widths=[avail*0.2, avail*0.2, avail*0.2, avail*0.4]
    )

    a07 = std_table(
        ["Gebruikersnaam", "Wachtwoord", "Rol", "Gebruik"],
        [
            ("admin",   "admin123",   "admin",   "A07 kwetsbaar — hoofd-target credential stuffing"),
            ("support", "support",    "support", "A07 kwetsbaar — zwak wachtwoord"),
            ("backup",  "backup2026", "backup",  "A07 kwetsbaar — service-account"),
        ],
        col_widths=[avail*0.2, avail*0.2, avail*0.2, avail*0.4]
    )

    warn = colored_box(
        "Deze credentials zijn uitsluitend voor testdoeleinden. "
        "Gebruik ze nooit in een productieomgeving.",
        C_RED
    )

    return [
        p("8. Test Credentials", ST_H1), hr(),
        p("Algemene inloggegevens:", ST_H2), sp(4), tbl, sp(12),
        p("A07-specifieke accounts (bvwa-auth module):", ST_H2), sp(4), a07, sp(12),
        warn,
        PageBreak()
    ]


def build_section9():
    avail = PAGE_W - 2*MARGIN

    tbl = std_table(
        ["Technologie", "Versie", "Gebruik"],
        [
            ("Go",           "1.24+",             "Programmeertaal"),
            ("Beego",        "v2.x",              "Web framework (MVC)"),
            ("MySQL",        "5.7+ (optioneel)",  "Database (ORM) — app draait standaard in-memory"),
            ("bcrypt",       "golang.org/x/crypto", "Wachtwoord hashing (A04, A07)"),
            ("HMAC-SHA256",  "crypto/hmac",        "Data integriteit (A08)"),
            ("SHA-256",      "crypto/sha256",      "Hashing (A03, A04)"),
            ("bee CLI",      "v2.x",               "Development en hot-reload"),
            ("reportlab",    "Python",             "PDF documentatie generatie"),
        ],
        col_widths=[avail*0.22, avail*0.25, avail*0.53]
    )

    return [
        p("9. Technologieen", ST_H1), hr(),
        tbl,
        PageBreak()
    ]


def build_section10():
    warn = colored_box(
        "BVWA is een educatief project. Het is opzettelijk kwetsbaar gebouwd om "
        "beveiligingsconcepten te demonstreren. Het gebruik van BVWA buiten een "
        "geisoleerde testomgeving is uitdrukkelijk verboden. De auteurs aanvaarden "
        "geen enkele verantwoordelijkheid voor schade of misbruik voortvloeiend "
        "uit dit project. Gebruik altijd verantwoord en ethisch — uitsluitend op "
        "systemen waarvoor je toestemming hebt.",
        C_RED
    )

    footer_tbl = Table(
        [[Paragraph(
            "© 2026 BVWA Project  |  MIT License  |  Versie 3.0  |  "
            "Uitsluitend voor educatieve doeleinden",
            ST_SMALL_GREY
        )]],
        colWidths=[PAGE_W - 2*MARGIN]
    )

    return [
        p("10. Disclaimer", ST_H1), hr(),
        warn, sp(20),
        footer_tbl
    ]


# ══════════════════════════════════════════════════════════════════════════════
# MAIN
# ══════════════════════════════════════════════════════════════════════════════

def main():
    out_path = os.path.join(os.path.dirname(__file__), "BVWA_Documentatie_v3.0.pdf")
    doc = SimpleDocTemplate(
        out_path,
        pagesize=A4,
        leftMargin=MARGIN,
        rightMargin=MARGIN,
        topMargin=MARGIN,
        bottomMargin=MARGIN,
    )

    story = []
    story += build_cover()
    story += build_toc()
    story += build_section1()
    story += build_section2()
    story += build_section3()
    story += build_section4()
    story += build_section5()
    story += build_section6()
    story += build_section7()
    story += build_section8()
    story += build_section9()
    story += build_section10()

    doc.build(story)
    print(f"✓ PDF gegenereerd: {out_path}")


if __name__ == "__main__":
    main()
