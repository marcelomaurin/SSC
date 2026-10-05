# SSC — Software Serial Communication

[Português](README.md) · [English](README.en.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Русский](README.ru.md) · [中文](README.zh-CN.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

**Version 3.0.0**

SSC ist ein Werkzeugsatz zum **Testen, Überwachen und Übertragen serieller Kommunikation über ein Netzwerk**. Das Projekt besteht aus **zwei Programmen und einer Firmware**.

| Komponente | Aufgabe |
|---|---|
| **SSC Serial Analyzer** | Öffnet eine serielle Schnittstelle, zeigt RX/TX, sendet Befehle und unterstützt die Protokolldiagnose. |
| **SSC Bridge Client** | Liest/schreibt eine lokale serielle Schnittstelle und überträgt die Bytes per TCP/IP. |
| **FelineSrv Firmware** | Läuft auf der entfernten Hardware und setzt TCP wieder in Serial/USB um. |

## Installation

Windows: `bin/install_ssc_3.0.0.ps1`.

Inno Setup: `win_bin/install/ssc3.iss` erzeugt nach dem Build `bin/win_X64/setup_3.0.0.exe`.

Linux:

```bash
chmod +x bin/install_ssc_3.0.0.sh
./bin/install_ssc_3.0.0.sh
```

Debian-Paket:

```bash
chmod +x buildlinux.sh
./buildlinux.sh
```

Siehe [bin/README.de.md](bin/README.de.md).

## Erster Start

1. Serial/USB-Gerät anschließen.
2. SSC starten.
3. Erkannte Schnittstelle auswählen.
4. Falls nötig **Ports aktualisieren**.
5. Baudrate, Datenbits, Parität und Stopbits einstellen.
6. **Verbinden**.
7. Daten im **Monitor** beobachten.

SSC verwendet `TAIListSerialDevices` und zeigt nur tatsächlich erkannte Geräte.

## Serielle Einstellungen

Die Werte müssen mit dem Gerät übereinstimmen. Häufig: **9600 8N1**.

## Monitor

Anzeigen: **Text**, **HEX**, **Text + HEX**. Timestamp unterstützt zeitliche Analyse. Auto-scroll folgt neuen Daten. RX/TX zählt empfangene/gesendete Bytes.

## Senden

Textbeispiel: `STATUS`.

HEX-Beispiel: `02 31 03`.

Zeilenende: keines, CR (`0D`), LF (`0A`) oder CR+LF (`0D 0A`).

## Logs

**Löschen** leert nur die Anzeige. **Log speichern** schreibt die Aufzeichnung in eine Datei. Einstellungen stehen in `ssc3.ini`.

## Fehlerbehebung

Port fehlt: neu scannen, USB neu verbinden, Treiber und Kabel prüfen.

Verbindung fehlschlägt: andere serielle Programme schließen.

Unlesbare Zeichen: Baudrate, Datenbits, Parität und Stopbits prüfen.

Keine Antwort: CR/LF, HEX-Format, Checksum und Verdrahtung prüfen.

Linux-Berechtigung:

```bash
sudo usermod -aG dialout "$USER"
```

## Remote-Bridge

```text
Lokale Serial <-> SSC Bridge Client <-> TCP/IP <-> FelineSrv <-> entfernte Serial/USB
```

## Firmware

`Felinesrv/FelineSrv.ino` nutzt derzeit Ethernet/SPI/SD/EEPROM, DHCP mit statischem Fallback, TCP **8088**, HTTP **80**, Serial **2400 Baud**, bidirektionale Weiterleitung, Echo, Verbindungsanzeige und SD-Log.

`escuta/escuta.ino` ist Hilfsfirmware für Loopback/Tests.

Siehe [Felinesrv/README.de.md](Felinesrv/README.de.md).

## Entwicklung

`src/ssc.lpi` in Lazarus öffnen. Erforderlich: `openai_core` und `openai_input` aus dem CHATGPT-Projekt.

## Lizenz

GPL v3.
