# SSC — Software Serial Communication

[Português](README.md) · [English](README.en.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Русский](README.ru.md) · [中文](README.zh-CN.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

**Версия 3.0.0**

SSC — набор инструментов для **тестирования, мониторинга и передачи последовательной связи через сеть**. Проект состоит из **двух программ и одной прошивки**.

| Компонент | Назначение |
|---|---|
| **SSC Serial Analyzer** | Открывает последовательный порт, показывает RX/TX, отправляет команды и помогает анализировать протокол. |
| **SSC Bridge Client** | Читает/пишет локальный Serial и передаёт байты по TCP/IP. |
| **FelineSrv Firmware** | Работает на удалённом устройстве и преобразует TCP обратно в Serial/USB. |

## Установка

Windows: `bin/install_ssc_3.0.0.ps1`.

Inno Setup: `win_bin/install/ssc3.iss`; после сборки создаёт `bin/win_X64/setup_3.0.0.exe`.

Linux:

```bash
chmod +x bin/install_ssc_3.0.0.sh
./bin/install_ssc_3.0.0.sh
```

Debian:

```bash
chmod +x buildlinux.sh
./buildlinux.sh
```

См. [bin/README.ru.md](bin/README.ru.md).

## Первый запуск

1. Подключите Serial/USB устройство.
2. Запустите SSC.
3. Выберите обнаруженный порт.
4. Если его нет — нажмите обновление портов.
5. Настройте baud, data bits, parity, stop bits.
6. Нажмите подключение.
7. Смотрите данные в Monitor.

SSC использует `TAIListSerialDevices` и показывает реально найденные порты.

## Настройки Serial

Параметры должны совпадать с устройством. Типичный пример: **9600 8N1**.

## Monitor

Режимы: **Text**, **HEX**, **Text + HEX**. Timestamp помогает анализировать время. Auto-scroll показывает новые данные. RX/TX — счётчики байтов.

## Передача

Текст: `STATUS`.

HEX: `02 31 03`.

Окончание строки: нет, CR (`0D`), LF (`0A`), CR+LF (`0D 0A`).

## Журналы

Очистка удаляет только содержимое экрана. Сохранение лога записывает захват в файл. Настройки хранятся в `ssc3.ini`.

## Устранение проблем

Нет порта: обновите список, переподключите USB, проверьте драйвер и кабель.

Не подключается: закройте другие программы, использующие порт.

Нечитаемые символы: проверьте скорость, биты данных, parity и stop bits.

Нет ответа: проверьте CR/LF, HEX, checksum и подключение.

Linux:

```bash
sudo usermod -aG dialout "$USER"
```

## Удалённый мост

```text
Local Serial <-> SSC Bridge Client <-> TCP/IP <-> FelineSrv <-> Remote Serial/USB
```

## Прошивка

`Felinesrv/FelineSrv.ino` сейчас использует Ethernet/SPI/SD/EEPROM, DHCP со статическим резервом, TCP **8088**, HTTP **80**, Serial **2400 baud**, двустороннюю передачу, echo, индикацию соединения и SD-лог.

`escuta/escuta.ino` — вспомогательная loopback/test прошивка.

См. [Felinesrv/README.ru.md](Felinesrv/README.ru.md).

## Разработка

Откройте `src/ssc.lpi` в Lazarus. Требуются `openai_core` и `openai_input` проекта CHATGPT.

## Лицензия

GPL v3.
