# SSC — Software Serial Communication

[Português](README.md) · [English](README.en.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Русский](README.ru.md) · [中文](README.zh-CN.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

**Version 3.0.0**

SSC est un ensemble d'outils pour **tester, surveiller et transporter une communication série sur un réseau**. Le projet comprend **deux programmes et un firmware**.

| Composant | Fonction |
|---|---|
| **SSC Serial Analyzer** | Ouvre un port série, affiche RX/TX, envoie des commandes et aide au diagnostic. |
| **SSC Bridge Client** | Lit/écrit un port série local et transporte les octets via TCP/IP. |
| **FelineSrv Firmware** | Fonctionne sur le matériel distant et reconvertit TCP en Serial/USB. |

## Utilisation

Le Serial Analyzer détecte les ports réellement connectés, ouvre COM ou /dev/tty, affiche Texte/HEX, transmet du texte ou des octets HEX, gère CR/LF, compte RX/TX et sauvegarde les journaux.

## Installation

Windows : `bin/install_ssc_3.0.0.ps1`.

Projet Inno Setup : `win_bin/install/ssc3.iss`, qui produit `bin/win_X64/setup_3.0.0.exe` après compilation.

Linux :

```bash
chmod +x bin/install_ssc_3.0.0.sh
./bin/install_ssc_3.0.0.sh
```

Paquet Debian :

```bash
chmod +x buildlinux.sh
./buildlinux.sh
```

Voir [bin/README.fr.md](bin/README.fr.md).

## Premier démarrage

1. Branchez le périphérique Serial/USB.
2. Démarrez SSC.
3. Sélectionnez le port détecté.
4. Utilisez **Actualiser les ports** s'il n'apparaît pas.
5. Configurez baud, bits de données, parité et stop bits.
6. Cliquez **Connecter**.
7. Consultez **Monitor**.

SSC utilise `TAIListSerialDevices` et n'affiche pas une liste COM fictive.

## Paramètres série

Ils doivent correspondre à l'équipement. Exemple courant : **9600 8N1**.

## Monitor

Modes : **Texte**, **HEX**, **Texte + HEX**. Timestamp facilite l'analyse temporelle, Auto-scroll suit les nouvelles données, et les compteurs RX/TX indiquent le trafic.

## Transmission

Exemple texte : `STATUS`.

Exemple HEX : `02 31 03`.

Terminaisons disponibles : aucune, CR (`0D`), LF (`0A`) et CR+LF (`0D 0A`).

## Logs

**Effacer** nettoie l'affichage. **Sauvegarder le log** écrit la capture dans un fichier. Les préférences sont stockées dans `ssc3.ini`.

## Dépannage

Port absent : actualisez, reconnectez l'USB, vérifiez le pilote et le câble.

Connexion impossible : fermez tout autre terminal série.

Caractères illisibles : vérifiez baud, bits, parité et stop bits.

Pas de réponse : vérifiez CR/LF, HEX, checksum et câblage.

Sous Linux, si nécessaire :

```bash
sudo usermod -aG dialout "$USER"
```

## Pont distant

```text
Série locale <-> SSC Bridge Client <-> TCP/IP <-> FelineSrv <-> Série/USB distante
```

## Firmware

`Felinesrv/FelineSrv.ino` utilise actuellement Ethernet/SPI/SD/EEPROM, DHCP avec repli statique, TCP **8088**, HTTP **80**, Serial **2400 bauds**, transfert bidirectionnel, echo, indication de connexion et journal SD.

`escuta/escuta.ino` est un firmware auxiliaire de test.

Voir [Felinesrv/README.fr.md](Felinesrv/README.fr.md).

## Développement

Ouvrez `src/ssc.lpi` dans Lazarus. Paquets requis : `openai_core`, `openai_input` du projet CHATGPT.

## Licence

GPL v3.
