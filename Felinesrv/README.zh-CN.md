# FelineSrv — TCP ↔ Serial 桥接固件

[Português](README.md) · [English](README.en.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Русский](README.ru.md) · [中文](README.zh-CN.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

FelineSrv 是 SSC 远端硬件的固件，用于建立双向 TCP/IP ↔ Serial/USB 桥，不解释设备协议。

源码：`Felinesrv/FelineSrv.ino`。

## 当前默认值

TCP **8088**，HTTP 诊断 **80**，Serial **2400 baud**，备用静态 IP **192.168.2.70**，DNS/Gateway **192.168.0.1**，掩码 **255.255.255.0**。引脚：SD 4、Ethernet CS 10、连接指示 13、测试 12、echo 11。

## 数据流

```text
SSC Bridge Client <-> TCP/IP <-> FelineSrv <-> Serial/USB <-> 远端设备
```

TCP 字节写入 Serial；Serial 字节发送回 TCP 客户端。

## 网络

固件先尝试 DHCP，失败后使用静态配置。Bridge Client 应连接硬件 IP 的 TCP **8088**。

## HTTP 诊断

端口 **80** 提供 echo、连接、SD、debug 和缓冲区状态。真正的串口传输使用 TCP 8088。

## 烧录

在 Arduino IDE 中打开 `FelineSrv.ino`，选择正确的板卡和端口，检查引脚、网络和 baud rate，然后编译并上传。

使用库：`Ethernet.h`、`SPI.h`、`SD.h`、`EEPROM.h`。

## 串口速度

当前为 `Serial.begin(2400)`。如果设备速度不同必须修改。

## 测试

先检查 IP、网络、TCP 8088 和双向数据，再连接真实设备。

`escuta/escuta.ino` 是辅助 loopback/test 固件。

## 安全

当前固件没有 TCP 加密或认证。跨不可信网络时请使用受控网络、防火墙或 VPN。

## 许可证

GPL v3。
