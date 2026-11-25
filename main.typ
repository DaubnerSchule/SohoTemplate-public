// Neues Protokoll: diese Datei kopieren, Werte anpassen, kompilieren mit
//   typst compile --font-path fonts main.typ
// Nicht benötigte Felder einfach weglassen (bleiben dann leer).

#import "protokoll.typ": protokoll, leerzeile

#show: protokoll.with(
  nr: 1,
  fach: "Netzwerktechnik",
  titel: "Titel der Übung",
  katalog-nr: 1,
  verfasser: "Vorname Nachname",
  jahrgang: "2026/27",
  klasse: "Klasse", // links in der Kopfzeile
  gruppenmitglieder: ("Name 1,", "Name 2"),
  uebungsdaten: ("TT.MM.JJJJ,", "TT.MM.JJJJ"),
  abgabe-datum: "TT.MM.JJJJ",
  uebungsleiter: "Kürzel",
  software: (
    "Betriebssystem (Version)",
    "Programm (Version)",
  ),
  hardware: ("Gerät, Modell (Seriennummer)",),
)

// Screenshot zentriert, nie breiter als die Textspalte:
//   #bild("bilder/screenshot.png", 80%)
#let bild(pfad, breite) = align(center, image(pfad, width: breite))

= Aufgabenstellung

Kurze Beschreibung der Aufgabe: Was soll in der Übung erreicht werden?

#leerzeile()

= Stoffzusammenfassung

Theoretischer Hintergrund zur Übung – die wichtigsten Begriffe, Protokolle und
Zusammenhänge in eigenen Worten.

#leerzeile()

= Ausarbeitung des Protokolls

== Erster Schritt

Beschreibung des ersten Arbeitsschritts. Befehle lassen sich als `Code` setzen,
wichtige Begriffe *fett*.

== Zweiter Schritt

Beschreibung des zweiten Arbeitsschritts, gegebenenfalls mit Screenshots.

#leerzeile()

= Fazit

Zusammenfassung der Ergebnisse: Was hat funktioniert, was nicht, und was wurde
dabei gelernt?
