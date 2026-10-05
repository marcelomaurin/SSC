# Instalación de SSC 3.0.0

[Português](README.md) · [English](README.en.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Русский](README.ru.md) · [中文](README.zh-CN.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

Los binarios 2.x existentes son históricos. Los instaladores 3.0.0 compilan el fuente actual antes de instalar.

## Windows

```powershell
powershell -ExecutionPolicy Bypass -File .\bin\install_ssc_3.0.0.ps1
```

Compila `src/ssc.lpi`, instala el ejecutable en `%LOCALAPPDATA%\Programs\SSC3` y crea accesos directos.

Inno Setup: `win_bin/install/ssc3.iss`. Salida: `bin/win_X64/setup_3.0.0.exe`.

## Linux

```bash
chmod +x bin/install_ssc_3.0.0.sh
./bin/install_ssc_3.0.0.sh
```

Instala para el usuario en `~/.local/`.

## Debian

```bash
chmod +x buildlinux.sh
./buildlinux.sh
```

Salida: `bin/lin_bin/ssc3_3.0.0_<arquitectura>.deb`.

Requiere Lazarus/FPC y los paquetes CHATGPT `openai_core` y `openai_input`.

Permiso serie Linux:

```bash
sudo usermod -aG dialout "$USER"
```
