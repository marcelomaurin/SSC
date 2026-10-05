# SSC 3.0.0 इंस्टॉलेशन

[Português](README.md) · [English](README.en.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Русский](README.ru.md) · [中文](README.zh-CN.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

मौजूदा 2.x binaries ऐतिहासिक हैं। 3.0.0 installer scripts इंस्टॉल करने से पहले वर्तमान source build करते हैं।

## Windows

```powershell
powershell -ExecutionPolicy Bypass -File .\bin\install_ssc_3.0.0.ps1
```

यह `src/ssc.lpi` build करता है, `%LOCALAPPDATA%\Programs\SSC3` में इंस्टॉल करता है और shortcuts बनाता है।

Inno Setup: `win_bin/install/ssc3.iss`। Output: `bin/win_X64/setup_3.0.0.exe`।

## Linux

```bash
chmod +x bin/install_ssc_3.0.0.sh
./bin/install_ssc_3.0.0.sh
```

यह वर्तमान user के `~/.local/` में इंस्टॉल करता है।

## Debian

```bash
chmod +x buildlinux.sh
./buildlinux.sh
```

Output: `bin/lin_bin/ssc3_3.0.0_<architecture>.deb`।

Lazarus/FPC और CHATGPT के `openai_core`, `openai_input` आवश्यक हैं।

Serial permission:

```bash
sudo usermod -aG dialout "$USER"
```
