# FelineSrv — Firmware puente TCP ↔ Serie

[Português](README.md) · [English](README.en.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Русский](README.ru.md) · [中文](README.zh-CN.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

FelineSrv es el firmware del hardware remoto de SSC. Realiza un puente bidireccional entre TCP/IP y Serial/USB sin interpretar el protocolo.

Fuente: `Felinesrv/FelineSrv.ino`.

## Valores actuales

- TCP: **8088**;
- diagnóstico HTTP: **80**;
- Serial: **2400 baud**;
- IP estática de respaldo: **192.168.2.70**;
- DNS/Gateway: **192.168.0.1**;
- máscara: **255.255.255.0**;
- SD: pin 4;
- Ethernet CS: pin 10;
- conexión: pin 13;
- prueba: pin 12;
- echo: pin 11.

## Funcionamiento

```text
SSC Bridge Client <-> TCP/IP <-> FelineSrv <-> Serial/USB <-> Equipo remoto
```

Los bytes TCP se escriben en Serial y los bytes Serial se envían al cliente TCP.

## Red

Primero intenta DHCP. Si falla usa la configuración estática. El Bridge Client debe conectarse al IP del hardware en la puerta **8088**.

## Diagnóstico

La puerta **80** muestra una página simple con estado de echo, cliente, SD, debug y buffers. No sustituye el canal TCP 8088.

## Grabar el firmware

Abra el sketch en Arduino IDE, seleccione placa y puerto, revise pines, red y baud rate, compile y grabe.

El fuente actual usa `Ethernet.h`, `SPI.h`, `SD.h` y `EEPROM.h`.

## Baud rate

Actualmente: `Serial.begin(2400)`. Cámbielo si el equipo usa otra velocidad.

## Log y echo

Con SD disponible se usa `log.txt`. Echo ayuda en pruebas, pero puede interferir con protocolos reales.

## Prueba recomendada

Verifique IP, conectividad, TCP 8088 y transferencia en ambos sentidos antes de conectar el equipo final.

`escuta/escuta.ino` es firmware auxiliar para loopback/pruebas.

## Seguridad

El sketch actual no cifra ni autentica TCP. Use red controlada, firewall o VPN.

## Licencia

GPL v3.
