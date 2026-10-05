# SSC 3.0.0 installation

[Português](README.md) · [English](README.en.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Русский](README.ru.md) · [中文](README.zh-CN.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

This folder contains SSC installers and binaries.

Existing 2.x binaries are **historical** and do not represent the current 3.0 Serial Analyzer source. The 3.0.0 installer scripts build the current source before installing it.

## Windows

```powershell
powershell -ExecutionPolicy Bypass -File .\bin\install_ssc_3.0.0.ps1
```

The script finds `lazbuild`, builds `src/ssc.lpi`, installs `src/ssc.exe` under `%LOCALAPPDATA%\Programs\SSC3` and creates Start Menu/Desktop shortcuts.

Traditional Inno Setup project:

```text
win_bin/install/ssc3.iss
```

After building the Lazarus project, compile that script with Inno Setup. Output:

```text
bin/win_X64/setup_3.0.0.exe
```

## Linux

```bash
chmod +x bin/install_ssc_3.0.0.sh
./bin/install_ssc_3.0.0.sh
```

It installs for the current user under `~/.local/` and does not require sudo.

## Debian package

```bash
chmod +x buildlinux.sh
./buildlinux.sh
```

Output:

```text
bin/lin_bin/ssc3_3.0.0_<architecture>.deb
```

## Build dependencies

Install Lazarus/FPC and the CHATGPT project packages `openai_core` and `openai_input`.

## Linux serial permissions

```bash
sudo usermod -aG dialout "$USER"
```

Log out and back in afterwards.
