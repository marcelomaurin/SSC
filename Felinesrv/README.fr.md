# FelineSrv — Firmware du pont TCP ↔ Série

[Português](README.md) · [English](README.en.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Русский](README.ru.md) · [中文](README.zh-CN.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

FelineSrv est le firmware du matériel distant SSC. Il crée un pont bidirectionnel TCP/IP ↔ Serial/USB sans interpréter le protocole.

Source : `Felinesrv/FelineSrv.ino`.

## Valeurs actuelles

TCP **8088**, diagnostic HTTP **80**, Serial **2400 bauds**, IP de secours **192.168.2.70**, DNS/Gateway **192.168.0.1**, masque **255.255.255.0**. Pins : SD 4, Ethernet CS 10, connexion 13, test 12, echo 11.

## Fonctionnement

```text
SSC Bridge Client <-> TCP/IP <-> FelineSrv <-> Serial/USB <-> Équipement distant
```

Les octets TCP sont écrits sur Serial et les octets Serial sont renvoyés au client TCP.

## Réseau

Le firmware tente DHCP puis utilise la configuration statique en secours. Le Bridge Client se connecte au port **8088**.

## Diagnostic HTTP

Le port **80** présente l'état echo/client/SD/debug et des buffers. Le transport série réel utilise TCP 8088.

## Programmation

Ouvrez `FelineSrv.ino` dans Arduino IDE, choisissez la carte et le port, vérifiez pins/réseau/baud, compilez et téléversez.

Bibliothèques : `Ethernet.h`, `SPI.h`, `SD.h`, `EEPROM.h`.

## Vitesse série

Actuellement `Serial.begin(2400)`. Modifiez-la selon l'équipement.

## Test

Vérifiez IP, réseau, connexion TCP 8088 puis les deux directions de données avant de connecter l'équipement final.

`escuta/escuta.ino` est un firmware auxiliaire de loopback/test.

## Sécurité

Pas de chiffrement/authentification TCP dans le sketch actuel. Utilisez un réseau contrôlé, firewall ou VPN.

## Licence

GPL v3.
