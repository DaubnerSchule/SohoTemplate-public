// Protokoll-Vorlage HTBLA Wels, Abteilung für Informationstechnologie.
// Nachbau von original/Protokoll_1.docx (Deckblatt + Folgeseiten).
//
// Alle Maße stammen aus dem Word-Dokument (twips / 20 = pt) bzw. wurden an
// der Referenz-Darstellung nachgemessen.

// ---------------------------------------------------------------- Schriften
// Jeweils das Word-Original zuerst, danach metrisch kompatible Ersatzschriften.
#let schrift-arial = ("Arial", "Liberation Sans")
#let schrift-cambria = ("Cambria", "Caladea", "Liberation Serif")
#let schrift-aptos = ("Aptos", "Liberation Sans")
#let schrift-aptos-display = ("Aptos Display", "Aptos", "Liberation Sans")

#let blau = rgb("#0F4761")

// --------------------------------------------------------------- Seitenmaße
#let rand = 72pt // 1440 twips
#let kopf-abstand = 35.4pt // w:header 708
#let fuss-abstand = 35.4pt // w:footer 708

// ------------------------------------------------------ Deckblatt-Konstanten
#let dick = 1.5pt // w:sz 12
#let duenn = 0.5pt // w:sz 4
#let zelle-x = 3.5pt // tblCellMar 70
// Zeilenhöhe Arial 10pt "einfach" wie Word: Ascent + Descent + Zeilenabstand.
#let zeile = 11.494pt
// Spalten (Gitterlinien des Word-Tisches, 9490 twips gesamt). Die letzte,
// 0pt breite Spalte trägt nur unsichtbare Platzhalter für Mindesthöhen.
#let spalten = (93.7pt, 143.55pt, 70.35pt, 76.4pt, 90.5pt, 0pt)
// Jahrgang- und Abgabe-Zelle sind in Word 2054 twips breit.
#let schmal = 102.7pt - 2 * zelle-x

#let _wert(x) = if x == none { none } else { strong[#x] }
#let _zeilen(xs) = if type(xs) == array { xs } else if xs == none { () } else { (xs,) }

#let deckblatt(
  nr: none,
  fach: none,
  titel: none,
  katalog-nr: none,
  verfasser: none,
  jahrgang: none,
  gruppenmitglieder: (),
  uebungsdaten: (),
  abgabe-datum: none,
  uebungsleiter: none,
  note-protokoll: none,
  note-nachbesprechung: none,
  software: (),
  hardware: (),
  anmerkungen: none,
) = {
  set text(font: schrift-arial, size: 10pt, top-edge: 0.938em, bottom-edge: -0.2119em)
  set par(leading: 0pt, spacing: 0pt, justify: false)

  let mitglieder = _zeilen(gruppenmitglieder)
  let daten = _zeilen(uebungsdaten)
  // Leere Zeile (= leerer Absatz in Word).
  let leer = block(height: zeile)
  let liste(xs) = for x in xs { block(strong(x)) }
  let strut(h) = table.cell(inset: 0pt, block(height: h))
  let zelle(oben, unten, ..args) = table.cell(
    inset: (x: zelle-x, top: oben, bottom: unten),
    ..args,
  )
  let mitte = align.with(left + horizon)

  // Kopfblock: Höhen der vier Word-Zeilen 0–3 zusammen.
  let kopf-hoehe = 113.5pt
  let kopf-innen = kopf-hoehe - dick
  // Bereich der verbundenen Zeilen 0–1 ("Protokoll Nr." wird darin zentriert).
  let nr-bereich = 87.37pt

  let anmerkungen-feld = {
    block[Anmerkungen zum Protokoll und zur Nachbesprechnung:]
    if anmerkungen != none { leer; anmerkungen }
  }

  // `rest` = Mindesthöhe der letzten Zeile (Anmerkungen).
  let tabelle(rest) = table(
    columns: spalten,
    rows: (kopf-hoehe, auto),
    stroke: none,
    inset: 0pt,

    // ---- A: Protokoll Nr. | Logo + Schule | IT-Logo
    zelle(dick / 2, dick / 2, block(height: nr-bereich, width: 100%, align(center + horizon, {
      block[Protokoll Nr.]
      if nr == none { leer } else {
        block(text(size: 18pt, weight: "bold", str(nr)))
      }
    }))),
    zelle(dick / 2, dick / 2, colspan: 3, block(height: kopf-innen, width: 100%, {
      // Logo: horizontal zentriert; dx gleicht die ungleich breiten Seitenspalten
      // (93.7pt links, 90.5pt rechts) aus, damit es mittig auf der Tabelle sitzt.
      place(top + left, dy: 12.12pt, dx: -1.6pt,
        block(width: 100%, align(center, image("assets/htl-wels-logo.png", width: 40pt))))
      place(center + top, dy: 64.37pt, align(center, strong[HTBLA Wels \ Abteilung für Informationstechnologie]))
    })),
    zelle(dick / 2, dick / 2, block(height: kopf-innen, width: 100%,
      place(center + horizon, image("assets/it-logo.png", width: 53.55pt, height: 54.75pt)),
    )),
    strut(kopf-hoehe),

    // ---- B: Protokoll <Fach>
    zelle(dick / 2, dick / 2, colspan: 5, align(center + horizon,
      text(size: 20pt, weight: "bold", tracking: 2pt)[Protokoll #fach],
    )),
    strut(48pt),

    // ---- C: Titel der Übung
    zelle(dick / 2, dick / 2, colspan: 5, mitte[Titel der Übung: #_wert(titel)]),
    strut(28.75pt),

    // ---- D: Katalog Nr. | Verfasser | Jahrgang
    zelle(dick / 2, duenn / 2, mitte[Katalog Nr.: #_wert(katalog-nr)]),
    zelle(dick / 2, duenn / 2, colspan: 2, mitte[Verfasser: #verfasser]),
    zelle(dick / 2, duenn / 2, colspan: 2, mitte(box(width: schmal)[Jahrgang: #jahrgang])),
    strut(27.25pt),

    // ---- E1: Gruppenmitglieder | Datum der Übungen
    zelle(0.5pt, 0.5pt, rowspan: 2, block(
      height: (1 + calc.max(mitglieder.len(), 1)) * zeile,
      align(horizon)[Gruppenmitglieder#text(size: 8pt)[:]],
    )),
    zelle(0.5pt, 0.5pt, colspan: 2, rowspan: 2, { leer; liste(mitglieder) }),
    zelle(0.5pt, 0.5pt, colspan: 2, {
      block[Datum der Übungen: ]
      liste(daten)
    }),
    // Word: eine Leerzeile über und zwei unter den Gruppenmitgliedern.
    strut(calc.max(4, mitglieder.len() + 3) * zeile + 1pt),

    // ---- E2: Abgabe Datum
    zelle(duenn / 2, dick / 2, colspan: 2, mitte(box(width: schmal)[Abgabe Datum: #_wert(abgabe-datum)])),
    strut(24.5pt),

    // ---- F: Übungsleiter
    zelle(dick / 2, dick / 2, colspan: 5, mitte[Übungsleiter: #_wert(uebungsleiter)]),
    strut(24.75pt),

    // ---- G: Noten
    zelle(dick / 2, dick / 2, colspan: 2, mitte[Note Protokoll: #_wert(note-protokoll)]),
    zelle(dick / 2, dick / 2, colspan: 3, mitte[Note Nachbesprechnung: #_wert(note-nachbesprechung)]),
    strut(56.25pt),

    // ---- H: Software
    zelle(dick / 2, duenn / 2, colspan: 5, {
      block[Verwendete Software / Betriebssysteme (Versionsnummer angeben):]
      if _zeilen(software) != () { leer; liste(_zeilen(software)); leer; leer }
    }),
    strut(60.75pt),

    // ---- I: Hardware
    zelle(duenn / 2, duenn / 2, colspan: 5, {
      block[Hardwaregeräte (Seriennummer angeben):]
      if _zeilen(hardware) != () { leer; liste(_zeilen(hardware)); leer; leer }
    }),
    strut(60.75pt),

    // ---- J: Anmerkungen (füllt den Rest der Seite)
    zelle(duenn / 2, duenn / 2, colspan: 5, anmerkungen-feld),
    strut(rest),

    // ---- Linien
    table.hline(y: 0, end: 5, stroke: dick),
    table.hline(y: 1, end: 5, stroke: dick),
    table.hline(y: 2, end: 5, stroke: dick),
    table.hline(y: 3, end: 5, stroke: dick),
    table.hline(y: 4, end: 5, stroke: duenn),
    table.hline(y: 5, start: 3, end: 5, stroke: duenn),
    table.hline(y: 6, end: 5, stroke: dick),
    table.hline(y: 7, end: 5, stroke: dick),
    table.hline(y: 8, end: 5, stroke: dick),
    table.hline(y: 9, end: 5, stroke: duenn),
    table.hline(y: 10, end: 5, stroke: duenn),
    table.hline(y: 11, end: 5, stroke: duenn),
    table.vline(x: 0, stroke: dick),
    table.vline(x: 5, stroke: dick),
    table.vline(x: 1, start: 0, end: 1, stroke: duenn),
    table.vline(x: 4, start: 0, end: 1, stroke: duenn),
    table.vline(x: 1, start: 3, end: 4, stroke: duenn),
    table.vline(x: 3, start: 3, end: 6, stroke: duenn),
    table.vline(x: 2, start: 7, end: 8, stroke: dick),
  )

  // Wie im Original reicht das Deckblatt bis zum unteren Seitenrand: die
  // Anmerkungen-Zeile bekommt den restlichen Platz. Ist das Deckblatt schon
  // voll, wächst die Tabelle einfach weiter (und bricht notfalls um).
  let (oben, unten) = (0.75pt, 0.5pt)
  layout(size => {
    let ohne-rest = measure(tabelle(0pt), width: size.width).height
    let feld = measure(block(width: spalten.sum() - 2 * zelle-x, inset: (y: duenn / 2), anmerkungen-feld)).height
    let rest = calc.max(0pt, size.height - oben - unten - ohne-rest + feld)
    pad(left: -0.75pt, top: oben, bottom: unten, tabelle(rest))
  })
}

// ------------------------------------------------------------- Hauptfunktion
#let protokoll(
  nr: none,
  fach: "Netzwerktechnik",
  titel: none,
  katalog-nr: none,
  verfasser: none,
  jahrgang: none,
  klasse: none,
  gruppenmitglieder: (),
  uebungsdaten: (),
  abgabe-datum: none,
  uebungsleiter: none,
  note-protokoll: none,
  note-nachbesprechung: none,
  software: (),
  hardware: (),
  anmerkungen: none,
  // Kopfzeile (links, mitte, rechts); auto = (klasse, "Übung: " + titel, verfasser)
  kopfzeile: auto,
  body,
) = {
  let kopf = if kopfzeile == auto {
    (klasse, if titel != none [Übung: #titel], verfasser)
  } else { kopfzeile }

  set document(title: if titel != none [Protokoll #fach – #titel] else [Protokoll #fach])
  set text(lang: "de", region: "AT", hyphenate: false, overhang: false)

  set page(
    paper: "a4",
    margin: rand,
    header-ascent: 0pt,
    footer-descent: 0pt,
    // Kopfzeile: Cambria 12pt, Tabstopps zentriert bei 80 mm und rechts bei 160 mm.
    header: {
      set text(font: schrift-cambria, size: 12pt, top-edge: "ascender", bottom-edge: "descender")
      let (links, mitte, rechts) = kopf
      // Wie Word: ein Tabstopp, der schon überschritten ist, schiebt den Text
      // nach rechts statt ihn überlappen zu lassen; umgebrochen wird nie.
      place(top + left, dy: kopf-abstand, context {
        let (l, m, r) = (links, mitte, rechts).map(x => measure(x).width)
        let xm = calc.max(l, 226.8pt - m / 2)
        let xr = calc.max(xm + m, 453.6pt - r)
        place(top + left, box(width: l, links))
        place(top + left, dx: xm, box(width: m, mitte))
        place(top + left, dx: xr, box(width: r, rechts))
      })
    },
    footer: {
      set text(font: schrift-aptos, size: 12pt, top-edge: "ascender", bottom-edge: "descender")
      place(bottom + right, dy: -fuss-abstand, context [
        Seite #counter(page).display() von #counter(page).final().first()
      ])
    },
  )

  deckblatt(
    nr: nr,
    fach: fach,
    titel: titel,
    katalog-nr: katalog-nr,
    verfasser: verfasser,
    jahrgang: jahrgang,
    gruppenmitglieder: gruppenmitglieder,
    uebungsdaten: uebungsdaten,
    abgabe-datum: abgabe-datum,
    uebungsleiter: uebungsleiter,
    note-protokoll: note-protokoll,
    note-nachbesprechung: note-nachbesprechung,
    software: software,
    hardware: hardware,
    anmerkungen: anmerkungen,
  )
  pagebreak()

  // Fließtext "Normal": Aptos 12pt, Zeilenabstand mehrfach 1,158, 8pt nach.
  // Word legt den zusätzlichen Zeilenabstand unter jede Zeile.
  let extra = 0.158 * 1.2207em
  set text(font: schrift-aptos, size: 12pt, top-edge: "ascender", bottom-edge: "descender")
  set par(leading: extra, spacing: 8pt + extra, justify: false)

  // Überschriften wie Word "Heading 1–4"; Ebene 1 zentriert wie im Original.
  show heading: it => {
    let (groesse, schrift, vor, nach) = (
      (20pt, schrift-aptos-display, 18pt, 4pt),
      (16pt, schrift-aptos-display, 8pt, 4pt),
      (14pt, schrift-aptos, 8pt, 4pt),
      (12pt, schrift-aptos, 4pt, 2pt),
    ).at(calc.min(it.level, 4) - 1)
    set text(font: schrift, size: groesse, weight: "regular", fill: blau, style: if it.level >= 4 { "italic" } else { "normal" })
    set align(if it.level == 1 { center } else { left })
    block(
      above: vor + 0.158 * 1.2207 * 12pt,
      below: nach + 0.158 * 1.2207 * groesse,
      sticky: true,
      it.body,
    )
  }

  body
}

// Leerer Absatz (entspricht einem leeren "Normal"-Absatz in Word).
#let leerzeile() = block(height: 1.2207 * 12pt, above: 8pt + 0.158 * 1.2207 * 12pt, below: 8pt + 0.158 * 1.2207 * 12pt)
