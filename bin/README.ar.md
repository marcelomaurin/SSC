# تثبيت SSC 3.0.0

[Português](README.md) · [English](README.en.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Русский](README.ru.md) · [中文](README.zh-CN.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

ملفات 2.x الحالية تاريخية. سكربتات 3.0.0 تبني المصدر الحالي قبل التثبيت.

## Windows

```powershell
powershell -ExecutionPolicy Bypass -File .\bin\install_ssc_3.0.0.ps1
```

يبني `src/ssc.lpi` ويثبت في `%LOCALAPPDATA%\Programs\SSC3` وينشئ اختصارات.

Inno Setup: `win_bin/install/ssc3.iss`. الناتج: `bin/win_X64/setup_3.0.0.exe`.

## Linux

```bash
chmod +x bin/install_ssc_3.0.0.sh
./bin/install_ssc_3.0.0.sh
```

تثبيت للمستخدم في `~/.local/`.

## Debian

```bash
chmod +x buildlinux.sh
./buildlinux.sh
```

الناتج: `bin/lin_bin/ssc3_3.0.0_<architecture>.deb`.

يتطلب Lazarus/FPC وحزم CHATGPT `openai_core` و`openai_input`.

صلاحية Serial:

```bash
sudo usermod -aG dialout "$USER"
```
