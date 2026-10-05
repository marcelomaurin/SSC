# FelineSrv — TCP ↔ Serial Bridge-Firmware

[Português](README.md) · [English](README.en.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Русский](README.ru.md) · [中文](README.zh-CN.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

FelineSrv ist die Firmware der entfernten SSC-Hardware. Sie bildet eine bidirektionale TCP/IP ↔ Serial/USB-Brücke, ohne das Geräteprotokoll zu interpretieren.

Quelle: `Felinesrv/FelineSrv.ino`.

## Aktuelle Werte

TCP **8088**, HTTP-Diagnose **80**, Serial **2400 Baud**, statische Fallback-IP **192.168.2.70**, DNS/Gateway **192.168.0.1**, Maske **255.255.255.0**. Pins: SD 4, Ethernet CS 10, Verbindung 13, Test 12, Echo 11.

## Datenfluss

```text
SSC Bridge Client <-> TCP/IP <-> FelineSrv <-> Serial/USB <-> entferntes Gerät
```

TCP-Bytes werden auf Serial geschrieben; Serial-Bytes gehen zurück zum TCP-Client.

## Netzwerk

Zuerst DHCP, bei Fehler statischer Fallback. Der Bridge Client verbindet sich mit TCP-Port **8088**.

## Diagnose

Port **80** bietet eine einfache Statusseite. Der eigentliche serielle Transport läuft über TCP 8088.

## Firmware aufspielen

`FelineSrv.ino` in Arduino IDE öffnen, Board/Port wählen, Pins, Netzwerk und Baudrate prüfen, kompilieren und hochladen.

Bibliotheken: `Ethernet.h`, `SPI.h`, `SD.h`, `EEPROM.h`.

## Baudrate

Aktuell `Serial.begin(2400)`. An das entfernte Gerät anpassen.

## Test

IP und Erreichbarkeit prüfen, TCP 8088 verbinden und beide Datenrichtungen testen, bevor das echte Gerät angeschlossen wird.

`escuta/escuta.ino` ist Hilfsfirmware für Loopback/Tests.

## Sicherheit

Die aktuelle Firmware bietet keine TCP-Verschlüsselung oder Authentifizierung. Kontrolliertes Netz, Firewall oder VPN verwenden.

## Lizenz

GPL v3.
