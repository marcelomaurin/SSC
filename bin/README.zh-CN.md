# SSC 3.0.0 安装

[Português](README.md) · [English](README.en.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Русский](README.ru.md) · [中文](README.zh-CN.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

现有 2.x 二进制文件是历史版本。3.0.0 安装脚本会先构建当前源码，再进行安装。

## Windows

```powershell
powershell -ExecutionPolicy Bypass -File .\bin\install_ssc_3.0.0.ps1
```

脚本构建 `src/ssc.lpi`，安装到 `%LOCALAPPDATA%\Programs\SSC3` 并创建快捷方式。

Inno Setup：`win_bin/install/ssc3.iss`。输出：`bin/win_X64/setup_3.0.0.exe`。

## Linux

```bash
chmod +x bin/install_ssc_3.0.0.sh
./bin/install_ssc_3.0.0.sh
```

安装到当前用户的 `~/.local/`。

## Debian

```bash
chmod +x buildlinux.sh
./buildlinux.sh
```

输出：`bin/lin_bin/ssc3_3.0.0_<architecture>.deb`。

需要 Lazarus/FPC 以及 CHATGPT 的 `openai_core`、`openai_input`。

串口权限：

```bash
sudo usermod -aG dialout "$USER"
```
