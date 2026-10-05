# FelineSrv — прошивка моста TCP ↔ Serial

[Português](README.md) · [English](README.en.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Русский](README.ru.md) · [中文](README.zh-CN.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

FelineSrv — прошивка удалённого оборудования SSC. Она создаёт двунаправленный мост TCP/IP ↔ Serial/USB без интерпретации протокола устройства.

Исходник: `Felinesrv/FelineSrv.ino`.

## Текущие параметры

TCP **8088**, HTTP-диагностика **80**, Serial **2400 baud**, резервный IP **192.168.2.70**, DNS/Gateway **192.168.0.1**, маска **255.255.255.0**. Пины: SD 4, Ethernet CS 10, connection 13, test 12, echo 11.

## Поток данных

```text
SSC Bridge Client <-> TCP/IP <-> FelineSrv <-> Serial/USB <-> удалённое устройство
```

Байты TCP записываются в Serial, а байты Serial отправляются TCP-клиенту.

## Сеть

Сначала используется DHCP, затем статический резерв. Bridge Client подключается к TCP-порту **8088**.

## HTTP-диагностика

Порт **80** показывает состояние echo, клиента, SD, debug и буферов. Основной транспорт работает через 8088.

## Прошивка платы

Откройте `FelineSrv.ino` в Arduino IDE, выберите плату и порт, проверьте пины/сеть/baud, скомпилируйте и загрузите.

Используются `Ethernet.h`, `SPI.h`, `SD.h`, `EEPROM.h`.

## Скорость

Сейчас: `Serial.begin(2400)`. Измените под удалённое устройство.

## Тест

Проверьте IP, сеть, TCP 8088 и передачу в обе стороны до подключения реального оборудования.

`escuta/escuta.ino` — вспомогательная loopback/test прошивка.

## Безопасность

В текущем скетче нет шифрования или аутентификации TCP. Используйте защищённую сеть, firewall или VPN.

## Лицензия

GPL v3.
