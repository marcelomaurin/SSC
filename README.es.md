# SSC — Software Serial Communication

[Português](README.md) · [English](README.en.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Русский](README.ru.md) · [中文](README.zh-CN.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

**Versión 3.0.0**

SSC es un conjunto de herramientas para **probar, monitorizar y transportar comunicación serie por red**. El proyecto contiene **dos programas y un firmware**:

| Componente | Función |
|---|---|
| **SSC Serial Analyzer** | Abre una puerta serie, muestra RX/TX, envía comandos y ayuda a diagnosticar protocolos. |
| **SSC Bridge Client** | Lee/escribe una serie local y transporta los bytes por TCP/IP. |
| **FelineSrv Firmware** | Se ejecuta en el hardware remoto y convierte TCP nuevamente en Serial/USB. |

## ¿Qué puede hacer el usuario?

El Analyzer descubre puertos realmente conectados, abre COM o /dev/tty, muestra datos como texto o HEX, envía texto o bytes hexadecimales, configura CR/LF, cuenta RX/TX y guarda logs.

## Instalación

### Windows

```text
bin/install_ssc_3.0.0.ps1
```

Proyecto Inno Setup:

```text
win_bin/install/ssc3.iss
```

Al compilarlo genera `bin/win_X64/setup_3.0.0.exe`.

### Linux

```bash
chmod +x bin/install_ssc_3.0.0.sh
./bin/install_ssc_3.0.0.sh
```

Para paquete Debian:

```bash
chmod +x buildlinux.sh
./buildlinux.sh
```

Más información: [bin/README.es.md](bin/README.es.md).

## Primer uso

1. Conecte el dispositivo Serial/USB.
2. Abra SSC.
3. Seleccione el puerto detectado.
4. Si no aparece, pulse **Actualizar puertos**.
5. Configure baud rate, bits de datos, paridad y stop bits.
6. Pulse **Conectar**.
7. Observe la pestaña **Monitor**.

Ejemplos: `COM5`, `/dev/ttyUSB0`, `/dev/ttyACM0`.

SSC no muestra una lista fija de COM. Usa `TAIListSerialDevices` para mostrar dispositivos detectados por el sistema.

## Parámetros serie

Deben coincidir con el equipo. Un ejemplo típico es **9600 8N1**: 9600 baud, 8 bits, sin paridad, 1 stop bit.

## Monitor

Modos:

- **Texto**;
- **HEX**;
- **Texto + HEX**.

Timestamp permite analizar secuencias y retardos. Auto-scroll sigue los datos nuevos. RX y TX muestran los bytes recibidos y enviados.

## Envío

Puede enviar **Texto** o **HEX**.

Texto:

```text
STATUS
```

HEX:

```text
02 31 03
```

Terminadores: Ninguno, CR (`0D`), LF (`0A`) o CR+LF (`0D 0A`).

## Logs y configuración

**Limpiar** borra solamente el contenido visible. **Guardar log** crea un archivo para análisis. Las preferencias se guardan en `ssc3.ini`.

## Solución de problemas

**El puerto no aparece:** actualice, reconecte el USB, revise drivers y pruebe otro cable.

**No conecta:** otra aplicación puede estar usando el puerto.

**Caracteres extraños:** revise baud, bits, paridad y stop bits.

**No hay respuesta:** revise CR/LF, formato HEX, checksum y cableado.

En Linux, si hay error de permisos:

```bash
sudo usermod -aG dialout "$USER"
```

## Puente remoto

```text
Serie local <-> SSC Bridge Client <-> TCP/IP <-> FelineSrv <-> Serie/USB remota
```

## Firmware

Fuente principal: `Felinesrv/FelineSrv.ino`. Actualmente usa Ethernet/SPI/SD/EEPROM, DHCP con respaldo estático, TCP **8088**, HTTP **80**, Serial **2400 baud**, reenvío bidireccional, echo, indicador de conexión y log SD.

`escuta/escuta.ino` es un firmware auxiliar de loopback/prueba.

Manual: [Felinesrv/README.es.md](Felinesrv/README.es.md).

## Desarrollo

Abra `src/ssc.lpi` en Lazarus. Requiere `openai_core` y `openai_input` de https://github.com/marcelomaurin/CHATGPT.

## Licencia

GPL v3.
