# SSC — Software Serial Communication

[Português](README.md) · [English](README.en.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Русский](README.ru.md) · [中文](README.zh-CN.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

**Version 3.0.0**

SSC is a toolkit for **testing, monitoring and transporting serial communication over a network**. The project is made of **two applications and one firmware**:

| Component | Purpose |
|---|---|
| **SSC Serial Analyzer** | Opens a serial port, displays RX/TX, sends commands and helps diagnose protocols. |
| **SSC Bridge Client** | Reads/writes a local serial port and transports the byte stream over TCP/IP. |
| **FelineSrv Firmware** | Runs on the remote hardware and bridges TCP data back to Serial/USB. |

## What can a user do?

With the Serial Analyzer you can discover actually connected ports, open COM or /dev/tty devices, view incoming data as text or HEX, send text or hexadecimal bytes, select CR/LF terminators, monitor RX/TX counters and save logs.

The Analyzer is a diagnostic tool. Remote transport belongs to the Bridge Client + FelineSrv pair.

## Installation

### Windows

Use:

```text
bin/install_ssc_3.0.0.ps1
```

The Inno Setup project is:

```text
win_bin/install/ssc3.iss
```

When built on Windows with Lazarus/FPC and Inno Setup it generates:

```text
bin/win_X64/setup_3.0.0.exe
```

Old 2.x installers are historical and do not represent the 3.0 source.

### Linux

```bash
chmod +x bin/install_ssc_3.0.0.sh
./bin/install_ssc_3.0.0.sh
```

To create a Debian package:

```bash
chmod +x buildlinux.sh
./buildlinux.sh
```

See [bin/README.en.md](bin/README.en.md).

## First use

1. Connect the Serial/USB device.
2. Start SSC.
3. Choose the detected port.
4. If the device is not listed, click **Refresh ports**.
5. Configure baud rate, data bits, parity and stop bits.
6. Click **Connect**.
7. Watch received data in **Monitor**.

Typical ports:

```text
Windows: COM3, COM5, COM12
Linux:   /dev/ttyUSB0, /dev/ttyACM0
```

The list is not a fixed COM1..COMn list. SSC uses `TAIListSerialDevices` to show devices actually detected by the operating system.

## Serial settings

The settings must match the equipment. A common configuration is **9600 8N1**:

- 9600 baud;
- 8 data bits;
- no parity;
- 1 stop bit.

Wrong settings may produce unreadable data or no communication.

## Monitor

Display modes:

- **Text** — readable characters;
- **HEX** — raw byte values;
- **Text + HEX** — both representations.

Optional timestamp helps analyze sequence and delays. Auto-scroll follows the newest data.

RX and TX counters show how many bytes were received and transmitted.

## Sending commands

The Transmit area supports **Text** and **HEX**.

Example text:

```text
STATUS
```

Example HEX:

```text
02 31 03
```

End-of-line options:

| Option | Bytes |
|---|---|
| None | no extra byte |
| CR | 0D |
| LF | 0A |
| CR+LF | 0D 0A |

If a device manual says a command must end with CR, select CR before sending.

## Logs

Use **Clear** to clear only the displayed monitor. Use **Save log** to write the current monitor to a file for protocol analysis, comparison and troubleshooting.

Preferences are stored in `ssc3.ini`.

## Troubleshooting

**Port not shown:** refresh ports, reconnect USB, check the driver and try another data-capable USB cable.

**Port shown but cannot connect:** another application may already have the port open. Close Arduino Serial Monitor, PuTTY, RealTerm or another SSC instance.

**Garbled characters:** check baud rate, data bits, parity and stop bits.

**Device does not answer:** verify CR/LF, whether the protocol is binary/HEX, checksum requirements and wiring.

**Linux permission denied:** the user may need membership in the `dialout` group:

```bash
sudo usermod -aG dialout "$USER"
```

Log out and back in afterwards.

## Remote serial bridge

```text
Local Serial <-> SSC Bridge Client <-> TCP/IP <-> FelineSrv <-> Remote Serial/USB
```

The bridge should preserve the byte stream instead of interpreting the device protocol.

## FelineSrv firmware

Main source:

```text
Felinesrv/FelineSrv.ino
```

The current firmware uses Ethernet/SPI/SD/EEPROM, tries DHCP with a static fallback, listens on TCP port **8088**, exposes HTTP diagnostics on port **80**, currently initializes Serial at **2400 baud**, forwards bytes both ways and provides echo, connection indication and SD logging.

`escuta/escuta.ino` is an auxiliary serial loopback/test firmware.

See [Felinesrv/README.en.md](Felinesrv/README.en.md).

## Developers

Official Analyzer source: `src/`. Open `src/ssc.lpi` in Lazarus.

Required packages from https://github.com/marcelomaurin/CHATGPT:

- `openai_core`;
- `openai_input`.

Reused components/functions: `TAISerialModem`, `TAIListSerialDevices`, `StrToHex`, `HexToStr`.

## License

GPL v3.
