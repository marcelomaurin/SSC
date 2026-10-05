# FelineSrv — Firmware da ponte TCP ↔ Serial

[Português](README.md) · [English](README.en.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Русский](README.ru.md) · [中文](README.zh-CN.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

**Versão da documentação: 3.0.0**

O **FelineSrv** é o firmware do hardware remoto do projeto SSC. Sua função é transformar o hardware em uma **ponte bidirecional entre uma conexão TCP/IP e uma interface Serial/USB**.

Ele não interpreta o protocolo do equipamento. O objetivo é transportar os bytes recebidos em uma ponta para a outra ponta.

## Papel no SSC

```text
SSC Bridge Client
      │
      │ TCP/IP
      ▼
┌──────────────────┐
│ Hardware         │
│ FelineSrv        │
│                  │
│ TCP <-> Serial   │
└──────────────────┘
      │
      │ Serial / USB
      ▼
Equipamento remoto
```

O **SSC Serial Analyzer** pode ser usado para testar a serial antes ou depois da ponte, mas não faz parte obrigatória do caminho.

## Arquivo principal

```text
Felinesrv/FelineSrv.ino
```

## Funções atuais

O firmware atual:

- inicializa a interface Ethernet;
- tenta receber configuração de rede por DHCP;
- usa configuração IP estática como contingência;
- abre um servidor TCP;
- recebe bytes do cliente TCP e escreve na Serial;
- recebe bytes da Serial e envia ao cliente TCP;
- possui modo de echo;
- indica conexão através de um pino/LED;
- registra informações em cartão SD quando disponível;
- disponibiliza uma página HTTP simples para diagnóstico.

## Parâmetros atuais do fonte

| Parâmetro | Valor atual |
|---|---|
| Porta TCP da ponte | **8088** |
| Porta HTTP de diagnóstico | **80** |
| Serial | **2400 baud** |
| IP estático de contingência | **192.168.2.70** |
| DNS | **192.168.0.1** |
| Gateway | **192.168.0.1** |
| Máscara | **255.255.255.0** |
| Pino SD | **4** |
| Pino Ethernet CS | **10** |
| Pino de conexão | **13** |
| Pino de teste | **12** |
| Pino de echo | **11** |

Esses valores são os encontrados no sketch atual e podem precisar ser alterados de acordo com a placa, shield e rede utilizados.

## Fluxo de dados

### TCP para Serial

```text
Cliente TCP
   │
   ▼
porta 8088
   │
   ▼
FelineSrv
   │
   ▼
Serial.write()
   │
   ▼
Equipamento
```

### Serial para TCP

```text
Equipamento
   │
   ▼
Serial.read()
   │
   ▼
FelineSrv
   │
   ▼
cliente TCP
```

O transporte é feito byte a byte. O firmware deve evitar modificar o conteúdo do protocolo original.

## Bibliotecas

O sketch utiliza:

```cpp
#include <Ethernet.h>
#include <SPI.h>
#include <SD.h>
#include <EEPROM.h>
```

Em placas Arduino compatíveis, essas bibliotecas normalmente são fornecidas pela própria plataforma ou pelo suporte da placa/shield.

## Gravando o firmware

1. Abra `FelineSrv.ino` na Arduino IDE.
2. Selecione a placa correta.
3. Selecione a porta USB/Serial da placa.
4. Confira a configuração dos pinos para o hardware utilizado.
5. Confira a configuração de rede.
6. Confira a velocidade serial esperada pelo equipamento.
7. Compile o sketch.
8. Grave o firmware.
9. Reinicie o hardware.
10. Observe a Serial de debug e/ou a página HTTP de diagnóstico.

## Configuração da rede

O firmware primeiro tenta:

```text
DHCP
```

Se não conseguir, o fonte atual usa configuração estática.

Antes de implantar em outra rede, ajuste principalmente:

```cpp
IPAddress ip(...);
IPAddress myDns(...);
IPAddress gateway(...);
IPAddress subnet(...);
```

O endereço IP do hardware precisa ser alcançável pelo computador que executa o **SSC Bridge Client**.

## Conexão TCP

O Bridge Client deve conectar ao IP do hardware na porta:

```text
8088
```

Depois da conexão, os dados recebidos por TCP são enviados para a Serial e os dados recebidos na Serial retornam pelo socket.

## Diagnóstico HTTP

O firmware também abre a porta:

```text
80
```

A página atual apresenta informações de diagnóstico como estado de echo, cliente conectado, cartão SD, debug e buffers de comunicação.

Use essa página apenas como apoio de diagnóstico; ela não substitui o canal TCP 8088 usado para transportar os dados seriais.

## Echo

Quando o echo está ativo, o firmware pode devolver dados para a própria origem. Isso é útil em testes, mas pode ser indesejado em um protocolo real.

Ao testar um equipamento, confirme se o echo deve ficar ligado ou desligado.

## Log em cartão SD

Quando o cartão SD está disponível, o firmware usa:

```text
log.txt
```

para registrar informações de debug.

Se o SD não estiver disponível, o código mantém parte das informações em buffer de memória.

## LED/indicação de conexão

O sketch atual utiliza o pino 13 para indicar conexão. Quando um cliente está conectado ao servidor TCP, o pino é ativado; na desconexão ele é desativado.

## Baud rate

O sketch atual inicializa:

```cpp
Serial.begin(2400);
```

Esse valor **precisa ser igual à velocidade do dispositivo remoto**. Se o equipamento usa 9600, 19200, 115200 ou outro valor, altere o firmware antes de gravá-lo.

## Teste básico

Um teste recomendado:

1. grave o FelineSrv;
2. confirme que ele recebeu IP;
3. do computador, teste conectividade com o IP;
4. conecte o Bridge Client à porta 8088;
5. envie bytes pela Serial local;
6. confirme a chegada na Serial remota;
7. envie bytes no sentido inverso;
8. confira RX e TX nas duas pontas;
9. somente depois conecte o equipamento real.

## Firmware auxiliar `escuta`

O repositório também possui:

```text
escuta/escuta.ino
```

Esse sketch é auxiliar e implementa um loopback/ponte entre interfaces seriais para testes de bancada. Ele não substitui o FelineSrv.

## Segurança e rede

O firmware atual foi criado como uma ponte simples e não implementa criptografia ou autenticação TCP no sketch existente. Portanto, utilize-o preferencialmente em uma rede controlada ou protegida por VPN/firewall quando houver necessidade de atravessar redes não confiáveis.

## Relação com os programas

- **SSC Serial Analyzer:** diagnóstico serial;
- **SSC Bridge Client:** lado de software da ponte;
- **FelineSrv:** lado de hardware da ponte.

## Licença

Parte do projeto SSC, distribuído sob GPL v3.
