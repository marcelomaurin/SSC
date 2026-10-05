# FelineSrv — TCP ↔ Serial ब्रिज फर्मवेयर

[Português](README.md) · [English](README.en.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Русский](README.ru.md) · [中文](README.zh-CN.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

FelineSrv SSC के दूरस्थ हार्डवेयर का फर्मवेयर है। यह डिवाइस प्रोटोकॉल को बदले बिना TCP/IP ↔ Serial/USB के बीच दोतरफा ब्रिज बनाता है।

स्रोत: `Felinesrv/FelineSrv.ino`।

## वर्तमान मान

TCP **8088**, HTTP diagnostic **80**, Serial **2400 baud**, fallback IP **192.168.2.70**, DNS/Gateway **192.168.0.1**, mask **255.255.255.0**। Pins: SD 4, Ethernet CS 10, connection 13, test 12, echo 11।

## डेटा प्रवाह

```text
SSC Bridge Client <-> TCP/IP <-> FelineSrv <-> Serial/USB <-> Remote device
```

TCP bytes Serial पर लिखे जाते हैं और Serial bytes TCP client को भेजे जाते हैं।

## नेटवर्क

पहले DHCP की कोशिश होती है; असफल होने पर static fallback उपयोग होता है। Bridge Client TCP port **8088** से जुड़ता है।

## HTTP diagnostic

Port **80** echo, client, SD, debug और buffers की जानकारी दिखाता है। वास्तविक serial transport TCP 8088 पर होता है।

## फर्मवेयर अपलोड

Arduino IDE में `FelineSrv.ino` खोलें, board और port चुनें, pins/network/baud rate जाँचें, compile और upload करें।

Libraries: `Ethernet.h`, `SPI.h`, `SD.h`, `EEPROM.h`।

## Baud rate

वर्तमान कोड: `Serial.begin(2400)`। डिवाइस की गति अलग हो तो इसे बदलें।

## परीक्षण

IP, network, TCP 8088 और दोनों दिशा का डेटा पहले जाँचें; उसके बाद वास्तविक उपकरण जोड़ें।

`escuta/escuta.ino` loopback/test के लिए सहायक फर्मवेयर है।

## सुरक्षा

वर्तमान sketch TCP encryption या authentication नहीं देता। सुरक्षित नेटवर्क, firewall या VPN का उपयोग करें।

## लाइसेंस

GPL v3.
