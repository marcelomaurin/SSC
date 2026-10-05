# SSC 3.0.0 Installation

[Português](README.md) · [English](README.en.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Русский](README.ru.md) · [中文](README.zh-CN.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

Vorhandene 2.x-Binärdateien sind historisch. Die 3.0.0-Installationsskripte bauen vor der Installation den aktuellen Quellcode.

## Windows

```powershell
powershell -ExecutionPolicy Bypass -File .\bin\install_ssc_3.0.0.ps1
```

Baut `src/ssc.lpi`, installiert nach `%LOCALAPPDATA%\Programs\SSC3` und erstellt Verknüpfungen.

Inno Setup: `win_bin/install/ssc3.iss`. Ausgabe: `bin/win_X64/setup_3.0.0.exe`.

## Linux

```bash
chmod +x bin/install_ssc_3.0.0.sh
./bin/install_ssc_3.0.0.sh
```

Benutzerinstallation unter `~/.local/`.

## Debian

```bash
chmod +x buildlinux.sh
./buildlinux.sh
```

Ausgabe: `bin/lin_bin/ssc3_3.0.0_<architecture>.deb`.

Benötigt Lazarus/FPC sowie CHATGPT `openai_core` und `openai_input`.

Linux-Serial-Berechtigung:

```bash
sudo usermod -aG dialout "$USER"
```
