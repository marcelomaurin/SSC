# FelineSrv — برنامج جسر TCP ↔ Serial الثابت

[Português](README.md) · [English](README.en.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Русский](README.ru.md) · [中文](README.zh-CN.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

FelineSrv هو البرنامج الثابت للعتاد البعيد في SSC. ينشئ جسراً ثنائي الاتجاه بين TCP/IP وSerial/USB بدون تفسير بروتوكول الجهاز.

المصدر: `Felinesrv/FelineSrv.ino`.

## القيم الحالية

TCP **8088**، تشخيص HTTP **80**، Serial **2400 baud**، IP احتياطي **192.168.2.70**، DNS/Gateway **192.168.0.1**، القناع **255.255.255.0**. الأرجل: SD 4، Ethernet CS 10، اتصال 13، اختبار 12، echo 11.

## تدفق البيانات

```text
SSC Bridge Client <-> TCP/IP <-> FelineSrv <-> Serial/USB <-> الجهاز البعيد
```

بايتات TCP تكتب إلى Serial، وبايتات Serial ترسل إلى عميل TCP.

## الشبكة

يحاول DHCP أولاً ثم يستخدم الإعداد الثابت الاحتياطي. يتصل Bridge Client بالمنفذ TCP **8088**.

## تشخيص HTTP

المنفذ **80** يعرض حالة echo والعميل وSD وdebug والـ buffers. نقل البيانات الأساسي يستخدم 8088.

## تحميل البرنامج الثابت

افتح `FelineSrv.ino` في Arduino IDE، اختر اللوحة والمنفذ، راجع الأرجل والشبكة والسرعة، ثم قم بالبناء والرفع.

المكتبات: `Ethernet.h` و`SPI.h` و`SD.h` و`EEPROM.h`.

## السرعة

حالياً `Serial.begin(2400)`. غيّرها إذا كان الجهاز يستخدم سرعة أخرى.

## الاختبار

تحقق من IP والشبكة وTCP 8088 والاتجاهين قبل توصيل الجهاز الحقيقي.

`escuta/escuta.ino` برنامج مساعد للاختبار والـ loopback.

## الأمان

لا يوجد تشفير أو مصادقة TCP في الكود الحالي. استخدم شبكة محمية أو firewall أو VPN.

## الترخيص

GPL v3.
