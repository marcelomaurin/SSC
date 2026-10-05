# SSC — Software Serial Communication

[Português](README.md) · [English](README.en.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Русский](README.ru.md) · [中文](README.zh-CN.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

**संस्करण 3.0.0**

SSC एक टूलकिट है जो **सीरियल संचार की जाँच, निगरानी और नेटवर्क पर ट्रांसपोर्ट** करने के लिए बनाया गया है। परियोजना में **दो प्रोग्राम और एक फर्मवेयर** हैं।

| घटक | कार्य |
|---|---|
| **SSC Serial Analyzer** | सीरियल पोर्ट खोलता है, RX/TX दिखाता है, कमांड भेजता है और प्रोटोकॉल जाँच में मदद करता है। |
| **SSC Bridge Client** | स्थानीय सीरियल पोर्ट पढ़ता/लिखता है और बाइट्स TCP/IP से भेजता है। |
| **FelineSrv Firmware** | दूरस्थ हार्डवेयर पर चलता है और TCP डेटा को फिर Serial/USB में बदलता है। |

## इंस्टॉलेशन

Windows: `bin/install_ssc_3.0.0.ps1`।

Inno Setup प्रोजेक्ट: `win_bin/install/ssc3.iss`; build होने पर `bin/win_X64/setup_3.0.0.exe` बनता है।

Linux:

```bash
chmod +x bin/install_ssc_3.0.0.sh
./bin/install_ssc_3.0.0.sh
```

Debian पैकेज:

```bash
chmod +x buildlinux.sh
./buildlinux.sh
```

देखें [bin/README.hi.md](bin/README.hi.md)।

## पहली बार उपयोग

1. Serial/USB डिवाइस कनेक्ट करें।
2. SSC खोलें।
3. खोजा गया पोर्ट चुनें।
4. पोर्ट न दिखे तो पोर्ट सूची रीफ्रेश करें।
5. baud rate, data bits, parity और stop bits सेट करें।
6. Connect दबाएँ।
7. Monitor में डेटा देखें।

SSC `TAIListSerialDevices` का उपयोग करता है और केवल सिस्टम द्वारा वास्तव में पाए गए पोर्ट दिखाता है।

## सीरियल सेटिंग

सेटिंग उपकरण से मेल खानी चाहिए। सामान्य उदाहरण: **9600 8N1**।

## Monitor

मोड: **Text**, **HEX**, **Text + HEX**। Timestamp समय विश्लेषण में मदद करता है; Auto-scroll नया डेटा दिखाता है; RX/TX काउंटर प्राप्त/भेजे गए बाइट बताते हैं।

## डेटा भेजना

Text उदाहरण: `STATUS`।

HEX उदाहरण: `02 31 03`।

लाइन अंत: None, CR (`0D`), LF (`0A`), CR+LF (`0D 0A`)।

## लॉग

Clear केवल स्क्रीन साफ करता है। Save log डेटा को फ़ाइल में लिखता है। सेटिंग `ssc3.ini` में सेव होती हैं।

## समस्या समाधान

पोर्ट नहीं दिखता: रीफ्रेश करें, USB फिर लगाएँ, ड्राइवर और डेटा केबल जाँचें।

कनेक्ट नहीं होता: पोर्ट उपयोग कर रहे दूसरे प्रोग्राम बंद करें।

गलत अक्षर: baud, data bits, parity और stop bits जाँचें।

डिवाइस जवाब नहीं देता: CR/LF, HEX, checksum और wiring जाँचें।

Linux अनुमति:

```bash
sudo usermod -aG dialout "$USER"
```

## रिमोट सीरियल ब्रिज

```text
Local Serial <-> SSC Bridge Client <-> TCP/IP <-> FelineSrv <-> Remote Serial/USB
```

## फर्मवेयर

`Felinesrv/FelineSrv.ino` वर्तमान में Ethernet/SPI/SD/EEPROM, DHCP के साथ static fallback, TCP **8088**, HTTP **80**, Serial **2400 baud**, दोतरफा byte forwarding, echo, connection indication और SD logging का उपयोग करता है।

`escuta/escuta.ino` loopback/test के लिए सहायक फर्मवेयर है।

देखें [Felinesrv/README.hi.md](Felinesrv/README.hi.md)।

## विकास

Lazarus में `src/ssc.lpi` खोलें। CHATGPT प्रोजेक्ट के `openai_core` और `openai_input` पैकेज आवश्यक हैं।

## लाइसेंस

GPL v3.
