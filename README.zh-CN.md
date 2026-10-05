# SSC — Software Serial Communication

[Português](README.md) · [English](README.en.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Русский](README.ru.md) · [中文](README.zh-CN.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

**版本 3.0.0**

SSC 是一套用于**测试、监控并通过网络传输串口通信**的工具。完整项目由**两个程序和一个固件**组成。

| 组件 | 功能 |
|---|---|
| **SSC Serial Analyzer** | 打开串口、显示 RX/TX、发送命令并帮助分析协议。 |
| **SSC Bridge Client** | 读写本地串口，并通过 TCP/IP 传输原始字节流。 |
| **FelineSrv Firmware** | 运行在远端硬件上，把 TCP 数据重新转换为 Serial/USB。 |

## 安装

Windows：`bin/install_ssc_3.0.0.ps1`。

Inno Setup 工程：`win_bin/install/ssc3.iss`，构建后生成 `bin/win_X64/setup_3.0.0.exe`。

Linux：

```bash
chmod +x bin/install_ssc_3.0.0.sh
./bin/install_ssc_3.0.0.sh
```

生成 Debian 包：

```bash
chmod +x buildlinux.sh
./buildlinux.sh
```

参见 [bin/README.zh-CN.md](bin/README.zh-CN.md)。

## 第一次使用

1. 连接 Serial/USB 设备。
2. 启动 SSC。
3. 选择检测到的串口。
4. 如果没有出现，点击刷新端口。
5. 设置 baud rate、data bits、parity、stop bits。
6. 点击连接。
7. 在 Monitor 中查看数据。

SSC 使用 `TAIListSerialDevices`，只显示操作系统真实检测到的设备。

## 串口参数

参数必须与设备一致。常见配置：**9600 8N1**。

## Monitor

显示模式：**Text**、**HEX**、**Text + HEX**。Timestamp 用于分析时间顺序；Auto-scroll 自动跟随新数据；RX/TX 显示收发字节数。

## 发送数据

文本示例：`STATUS`。

HEX 示例：`02 31 03`。

行结束符：无、CR (`0D`)、LF (`0A`)、CR+LF (`0D 0A`)。

## 日志

清除按钮只清除显示内容；保存日志会把当前监控内容写入文件。用户设置保存在 `ssc3.ini`。

## 故障排除

找不到端口：刷新、重新连接 USB、检查驱动和数据线。

无法连接：关闭其他正在占用串口的软件。

乱码：检查 baud、data bits、parity、stop bits。

设备无响应：检查 CR/LF、HEX、checksum 和接线。

Linux 权限：

```bash
sudo usermod -aG dialout "$USER"
```

## 远程串口桥

```text
本地 Serial <-> SSC Bridge Client <-> TCP/IP <-> FelineSrv <-> 远端 Serial/USB
```

## 固件

`Felinesrv/FelineSrv.ino` 当前使用 Ethernet/SPI/SD/EEPROM，支持 DHCP 和静态地址回退，TCP 端口 **8088**，HTTP 诊断端口 **80**，Serial **2400 baud**，双向字节转发、echo、连接指示和 SD 日志。

`escuta/escuta.ino` 是辅助 loopback/test 固件。

参见 [Felinesrv/README.zh-CN.md](Felinesrv/README.zh-CN.md)。

## 开发

在 Lazarus 中打开 `src/ssc.lpi`。需要 CHATGPT 项目的 `openai_core` 和 `openai_input`。

## 许可证

GPL v3。
