# Installation de SSC 3.0.0

[Português](README.md) · [English](README.en.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Русский](README.ru.md) · [中文](README.zh-CN.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

Les binaires 2.x présents sont historiques. Les installateurs 3.0.0 compilent la source actuelle avant installation.

## Windows

```powershell
powershell -ExecutionPolicy Bypass -File .\bin\install_ssc_3.0.0.ps1
```

Compilation de `src/ssc.lpi`, installation sous `%LOCALAPPDATA%\Programs\SSC3` et création de raccourcis.

Inno Setup : `win_bin/install/ssc3.iss`. Sortie : `bin/win_X64/setup_3.0.0.exe`.

## Linux

```bash
chmod +x bin/install_ssc_3.0.0.sh
./bin/install_ssc_3.0.0.sh
```

Installation utilisateur dans `~/.local/`.

## Debian

```bash
chmod +x buildlinux.sh
./buildlinux.sh
```

Sortie : `bin/lin_bin/ssc3_3.0.0_<architecture>.deb`.

Nécessite Lazarus/FPC et les paquets CHATGPT `openai_core`, `openai_input`.

Permission série Linux :

```bash
sudo usermod -aG dialout "$USER"
```
