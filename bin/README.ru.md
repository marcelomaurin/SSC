# Установка SSC 3.0.0

[Português](README.md) · [English](README.en.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Русский](README.ru.md) · [中文](README.zh-CN.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

Существующие бинарные файлы 2.x являются историческими. Скрипты 3.0.0 сначала собирают текущий исходный код.

## Windows

```powershell
powershell -ExecutionPolicy Bypass -File .\bin\install_ssc_3.0.0.ps1
```

Собирает `src/ssc.lpi`, устанавливает в `%LOCALAPPDATA%\Programs\SSC3` и создаёт ярлыки.

Inno Setup: `win_bin/install/ssc3.iss`. Результат: `bin/win_X64/setup_3.0.0.exe`.

## Linux

```bash
chmod +x bin/install_ssc_3.0.0.sh
./bin/install_ssc_3.0.0.sh
```

Установка текущего пользователя в `~/.local/`.

## Debian

```bash
chmod +x buildlinux.sh
./buildlinux.sh
```

Результат: `bin/lin_bin/ssc3_3.0.0_<architecture>.deb`.

Требуются Lazarus/FPC и пакеты CHATGPT `openai_core`, `openai_input`.

Права на Serial:

```bash
sudo usermod -aG dialout "$USER"
```
