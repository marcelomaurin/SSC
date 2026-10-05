# FelineSrv — TCP ↔ Serial bridge firmware

[Português](README.md) · [English](README.en.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Русский](README.ru.md) · [中文](README.zh-CN.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

**Documentation version: 3.0.0**

FelineSrv is the remote hardware firmware of SSC. It provides a **bidirectional bridge between TCP/IP and Serial/USB** and is intended to forward bytes without interpreting the equipment protocol.

## Position in SSC

```text
SSC Bridge Client <-> TCP/IP <-> FelineSrv hardware <-> Serial/USB <-> Remote device
```

Main source: `Felinesrv/FelineSrv.ino`.

## Current functions

- Ethernet initialization;
- DHCP attempt with static fallback;
- TCP server for serial transport;
- TCP-to-Serial forwarding;
- Serial-to-TCP forwarding;
- echo mode;
- connection indicator;
- SD-card logging;
- HTTP diagnostic page.

## Current source defaults

| Parameter | Value |
|---|---|
| Bridge TCP port | **8088** |
| Diagnostic HTTP port | **80** |
| Serial speed | **2400 baud** |
| Static fallback IP | **192.168.2.70** |
| DNS | **192.168.0.1** |
| Gateway | **192.168.0.1** |
| Netmask | **255.255.255.0** |
| SD pin | **4** |
| Ethernet CS pin | **10** |
| Connected pin | **13** |
| Test pin | **12** |
| Echo pin | **11** |

These values come from the current sketch and may need adjustment for your board, shield and network.

## Data path

```text
TCP client -> port 8088 -> FelineSrv -> Serial.write() -> device
device -> Serial.read() -> FelineSrv -> TCP client
```

Transport is byte-oriented. The bridge should preserve the original protocol content.

## Libraries

`Ethernet.h`, `SPI.h`, `SD.h` and `EEPROM.h`.

## Flashing

1. Open `FelineSrv.ino` in Arduino IDE.
2. Select the correct board.
3. Select its USB/Serial port.
4. Verify pin definitions.
5. Verify network configuration.
6. Set the Serial baud rate required by the remote equipment.
7. Compile and upload.
8. Reboot the hardware.
9. Check debug output and/or the HTTP diagnostic page.

## Network

The sketch first tries DHCP. If that fails, it uses the configured static fallback. Adjust `ip`, `myDns`, `gateway` and `subnet` before deployment when needed.

The SSC Bridge Client connects to the hardware IP on TCP port **8088**.

## HTTP diagnostics

Port **80** provides a simple status page with echo, client connection, SD/debug information and communication buffers. It is for diagnostics only; serial transport uses TCP 8088.

## Echo and SD log

Echo is useful during testing but may be undesirable with real equipment. SD logging uses `log.txt` when the card is available.

## Serial speed

The current sketch contains:

```cpp
Serial.begin(2400);
```

Change it if the remote device uses another speed.

## Recommended test

Flash firmware, verify its IP, test network reachability, connect the Bridge Client to 8088, test data in both directions, inspect RX/TX and only then attach the real equipment.

## Auxiliary firmware

`escuta/escuta.ino` is a bench-test loopback/serial bridge and does not replace FelineSrv.

## Security

The current sketch does not provide TCP encryption or authentication. Use a controlled network, firewall or VPN when crossing untrusted networks.

## License

GPL v3, as part of SSC.
