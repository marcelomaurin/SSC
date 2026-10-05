# SSC — Software Serial Communication

[Português](README.md) · [English](README.en.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Русский](README.ru.md) · [中文](README.zh-CN.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

**الإصدار 3.0.0**

SSC هو مجموعة أدوات **لاختبار ومراقبة ونقل الاتصال التسلسلي عبر الشبكة**. يتكون المشروع من **برنامجين وبرنامج ثابت واحد (Firmware)**.

| المكوّن | الوظيفة |
|---|---|
| **SSC Serial Analyzer** | يفتح المنفذ التسلسلي ويعرض RX/TX ويرسل الأوامر ويساعد في تحليل البروتوكول. |
| **SSC Bridge Client** | يقرأ/يكتب المنفذ المحلي وينقل البايتات عبر TCP/IP. |
| **FelineSrv Firmware** | يعمل على العتاد البعيد ويحوّل TCP إلى Serial/USB من جديد. |

## التثبيت

Windows: `bin/install_ssc_3.0.0.ps1`.

مشروع Inno Setup: `win_bin/install/ssc3.iss`، وبعد البناء ينتج `bin/win_X64/setup_3.0.0.exe`.

Linux:

```bash
chmod +x bin/install_ssc_3.0.0.sh
./bin/install_ssc_3.0.0.sh
```

حزمة Debian:

```bash
chmod +x buildlinux.sh
./buildlinux.sh
```

راجع [bin/README.ar.md](bin/README.ar.md).

## أول استخدام

1. صِل جهاز Serial/USB.
2. شغّل SSC.
3. اختر المنفذ المكتشف.
4. إذا لم يظهر، استخدم تحديث المنافذ.
5. اضبط baud rate وdata bits وparity وstop bits.
6. اضغط اتصال.
7. راقب البيانات في Monitor.

يستخدم SSC المكوّن `TAIListSerialDevices` ويعرض الأجهزة التي اكتشفها النظام فعلياً فقط.

## إعدادات Serial

يجب أن تطابق إعدادات الجهاز. مثال شائع: **9600 8N1**.

## Monitor

الأوضاع: **Text** و**HEX** و**Text + HEX**. يضيف Timestamp معلومات الوقت، ويتابع Auto-scroll البيانات الجديدة، وتعرض عدادات RX/TX عدد البايتات.

## الإرسال

نص: `STATUS`.

HEX: `02 31 03`.

نهاية السطر: بدون، CR (`0D`)، LF (`0A`)، CR+LF (`0D 0A`).

## السجلات

المسح يزيل العرض فقط. حفظ السجل يكتب البيانات في ملف. تُحفظ التفضيلات في `ssc3.ini`.

## حل المشاكل

المنفذ غير موجود: حدّث القائمة، أعد توصيل USB، تحقق من التعريف والكابل.

فشل الاتصال: أغلق أي برنامج آخر يستخدم المنفذ.

أحرف غير مفهومة: تحقق من baud وdata bits وparity وstop bits.

الجهاز لا يجيب: تحقق من CR/LF وHEX وchecksum والتوصيلات.

في Linux:

```bash
sudo usermod -aG dialout "$USER"
```

## الجسر البعيد

```text
Serial محلي <-> SSC Bridge Client <-> TCP/IP <-> FelineSrv <-> Serial/USB بعيد
```

## البرنامج الثابت

`Felinesrv/FelineSrv.ino` يستخدم حالياً Ethernet/SPI/SD/EEPROM، وDHCP مع إعداد ثابت احتياطي، وTCP على **8088**، وتشخيص HTTP على **80**، وSerial بسرعة **2400 baud**، ونقل ثنائي الاتجاه وecho ومؤشر اتصال وسجل SD.

`escuta/escuta.ino` برنامج مساعد لاختبار loopback.

راجع [Felinesrv/README.ar.md](Felinesrv/README.ar.md).

## التطوير

افتح `src/ssc.lpi` في Lazarus. الحزمتان المطلوبتان من مشروع CHATGPT هما `openai_core` و`openai_input`.

## الترخيص

GPL v3.
