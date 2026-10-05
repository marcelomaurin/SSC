# SSC — Software Serial Communication

[Português](README.md) · [English](README.en.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Русский](README.ru.md) · [中文](README.zh-CN.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

**Versão 3.0.0**

O **SSC (Software Serial Communication)** é um conjunto de ferramentas para **testar, monitorar e transportar comunicação serial por rede**. Ele foi pensado para situações em que um equipamento usa uma porta Serial/USB, mas você precisa analisar os dados ou levar essa comunicação até outro computador/rede.

O projeto completo possui **dois programas e um firmware**:

| Componente | Função |
|---|---|
| **SSC Serial Analyzer** | Programa de usuário para abrir uma porta serial, visualizar RX/TX, enviar comandos e diagnosticar protocolos. |
| **SSC Bridge Client** | Programa que lê/escreve uma serial local e transporta os bytes pela rede TCP/IP. |
| **FelineSrv Firmware** | Firmware do hardware remoto que recebe/envia os dados TCP e os apresenta novamente como comunicação Serial/USB. |

---

## 1. Para que serve o SSC?

Com o **Serial Analyzer** você pode:

- descobrir quais portas seriais estão realmente conectadas;
- abrir uma COM no Windows ou uma `/dev/tty*` no Linux;
- visualizar tudo o que chega pela serial;
- enviar texto ou bytes em hexadecimal;
- acompanhar quantidade de bytes recebidos e transmitidos;
- registrar horário das mensagens;
- salvar o monitor em arquivo de log;
- testar Arduino, ESP, conversores USB/Serial, equipamentos médicos, industriais e outros dispositivos seriais;
- usar o Analyzer para diagnosticar qualquer uma das pontas da solução de ponte remota.

Com o conjunto **Bridge Client + FelineSrv**, uma comunicação serial pode atravessar uma rede TCP/IP:

```text
Equipamento / Software A
        │
        │ Serial / USB
        ▼
SSC Bridge Client
        │
        │ TCP/IP / rede
        ▼
Hardware com FelineSrv
        │
        │ Serial / USB
        ▼
Equipamento / Software B
```

O **SSC Serial Analyzer não é a ponte de rede**. Ele é a ferramenta de teste e diagnóstico. A comunicação remota pertence ao **SSC Bridge Client** e ao firmware **FelineSrv**.

---

# 2. Instalação

## Windows

A nova linha 3.0 utiliza o código atual do diretório `src/`.

Na pasta `bin/` existe o instalador por PowerShell:

```text
bin/install_ssc_3.0.0.ps1
```

Execute pelo PowerShell a partir da raiz do projeto.

Também existe o projeto do instalador Inno Setup:

```text
win_bin/install/ssc3.iss
```

Quando compilado em uma máquina Windows com Lazarus/FPC e Inno Setup, ele gera:

```text
bin/win_X64/setup_3.0.0.exe
```

> Os instaladores 2.x existentes em `bin/win_X64/` são versões históricas. Eles não correspondem ao novo Analyzer 3.0.

## Linux

Instalador:

```bash
chmod +x bin/install_ssc_3.0.0.sh
./bin/install_ssc_3.0.0.sh
```

O script compila o projeto atual e instala o SSC para o usuário.

Para gerar um pacote Debian:

```bash
chmod +x buildlinux.sh
./buildlinux.sh
```

O pacote gerado é gravado em:

```text
bin/lin_bin/
```

Documentação específica de instalação: [bin/README.md](bin/README.md).

---

# 3. Primeiro uso — Serial Analyzer

## Passo 1 — conecte o equipamento

Conecte o dispositivo Serial/USB ao computador antes ou depois de abrir o SSC.

Exemplos:

- Arduino;
- ESP com conversor USB/Serial;
- CH340;
- CP210x;
- FTDI;
- equipamento com RS-232 usando conversor USB;
- equipamentos industriais ou biomédicos com interface serial.

## Passo 2 — abra o SSC

Ao iniciar, o programa procura as portas disponíveis no sistema.

A lista **não deve mostrar uma relação fixa de COM1, COM2, COM3...**. Ela é preenchida com as portas realmente detectadas.

## Passo 3 — escolha a porta

No campo **Porta**, selecione o dispositivo desejado.

Exemplos:

```text
Windows: COM3, COM5, COM12
Linux:   /dev/ttyUSB0, /dev/ttyACM0
```

Quando disponíveis, o SSC também pode identificar informações como fabricante, nome do dispositivo, VID e PID.

## Passo 4 — se a porta não apareceu

Clique em:

**Atualizar portas**

O programa fará uma nova varredura.

Isso é útil quando você conecta ou desconecta um dispositivo com o SSC já aberto.

Se a porta atualmente conectada desaparecer fisicamente, o programa encerra a conexão com segurança.

---

# 4. Configurando a comunicação serial

Antes de clicar em **Conectar**, configure os mesmos parâmetros usados pelo equipamento.

| Campo | Significado |
|---|---|
| **Baud rate** | Velocidade da comunicação, por exemplo 2400, 9600, 19200, 115200. |
| **Data bits** | Quantidade de bits de dados, normalmente 8. |
| **Parity** | Paridade: None, Even, Odd etc. |
| **Stop bits** | Bits de parada, normalmente 1. |
| **Porta** | Dispositivo serial selecionado. |

Um exemplo muito comum é:

```text
9600 baud
8 data bits
No parity
1 stop bit
```

Isto também é conhecido como **9600 8N1**.

> Os parâmetros precisam ser iguais nas duas pontas. Se estiverem diferentes, os dados podem chegar ilegíveis ou não chegar.

---

# 5. Conectando

Depois de selecionar a porta e configurar a comunicação:

1. clique em **Conectar**;
2. confira o status da conexão;
3. mantenha o equipamento transmitindo;
4. observe a área **Monitor**.

Para liberar a porta, clique em **Desconectar**.

Uma porta serial normalmente só pode ser aberta por um programa de cada vez. Se Arduino IDE, PuTTY, outro terminal ou outro SSC estiver usando a mesma porta, a conexão pode falhar.

---

# 6. Monitorando dados recebidos

A aba **Monitor** mostra os dados que chegam pela porta serial.

Há três formas de visualização:

### Texto

Exibe os caracteres recebidos.

Exemplo:

```text
TEMP=25.4
OK
```

### HEX

Exibe cada byte em hexadecimal.

Exemplo:

```text
54 45 4D 50 3D 32 35 2E 34
```

Este modo é importante para protocolos binários, caracteres de controle e equipamentos que não transmitem texto legível.

### Texto + HEX

Mostra as duas representações, permitindo comparar o conteúdo recebido com os bytes reais.

---

# 7. Timestamp e Auto-scroll

## Timestamp

Quando habilitado, cada registro recebe informação de horário. Isso facilita comparar mensagens, atrasos e sequência do protocolo.

## Auto-scroll

Quando habilitado, o monitor acompanha automaticamente os dados mais recentes.

Desative-o quando quiser analisar uma parte antiga do log sem a tela voltar automaticamente para o final.

---

# 8. Enviando dados

Abra a área **Transmitir**.

O SSC aceita envio em:

- **Texto**;
- **HEX**.

## Exemplo de envio em texto

Digite:

```text
STATUS
```

Escolha o final de linha exigido pelo equipamento e clique em **Enviar**.

Também é possível enviar usando **Enter**.

## Exemplo de envio HEX

Se o protocolo exigir os bytes:

```text
02 31 03
```

selecione **HEX** e informe os bytes.

Isso permite transmitir bytes que não possuem representação de teclado simples.

---

# 9. Final de linha: CR, LF e CR+LF

Muitos equipamentos só processam um comando quando recebem um terminador.

O SSC permite:

| Opção | Byte(s) |
|---|---|
| **Nenhum** | não acrescenta terminador |
| **CR** | `0D` |
| **LF** | `0A` |
| **CR+LF** | `0D 0A` |

Exemplo: se o manual do equipamento informar que o comando precisa terminar com CR:

```text
STATUS<CR>
```

selecione **CR** antes de enviar.

---

# 10. Contadores RX e TX

A barra de status apresenta contadores de comunicação:

- **RX** — quantidade de bytes recebidos;
- **TX** — quantidade de bytes transmitidos.

Eles ajudam a responder rapidamente:

- o dispositivo está transmitindo?
- o SSC realmente enviou algo?
- a quantidade de dados está aumentando?
- existe comunicação em apenas uma direção?

---

# 11. Limpando e salvando o monitor

## Limpar

O botão **Limpar** apaga o conteúdo exibido no Monitor.

Ele não altera o dispositivo e não limpa buffers do hardware remoto.

## Salvar log

Use **Salvar log** para gravar o conteúdo do monitor em arquivo.

O log é útil para:

- analisar protocolos;
- comparar testes;
- documentar falhas;
- compartilhar uma captura da comunicação;
- manter evidências de RX/TX.

---

# 12. Configurações salvas

O Analyzer grava preferências em:

```text
ssc3.ini
```

São preservados, entre outros:

- última porta selecionada;
- baud rate;
- data bits;
- paridade;
- stop bits;
- posição da janela;
- tamanho da janela.

Se a porta salva não estiver mais conectada, ela não deve ser inventada na lista: o SSC mostra apenas dispositivos detectados.

---

# 13. Como funciona a recepção no SSC 3

A recepção atual utiliza o componente `TAISerialModem` da biblioteca CHATGPT:

```text
Timer
  ↓
TAISerialModem.Poll
  ↓
OnRXReceive
  ↓
Monitor
```

A versão antiga fazia uma leitura e depois executava `Flush`, o que poderia apagar bytes ainda aguardando processamento.

O SSC 3 **não executa Flush após cada leitura**.

---

# 14. Solução de problemas

## A porta não aparece

1. clique em **Atualizar portas**;
2. desconecte e reconecte o cabo USB;
3. verifique o Gerenciador de Dispositivos no Windows ou `/dev/tty*` no Linux;
4. confirme se o driver do CH340/CP210x/FTDI está instalado;
5. teste outro cabo USB — muitos cabos fornecem energia, mas não possuem linhas de dados.

## A porta aparece, mas não conecta

Verifique se outro programa já está usando a porta.

Feche, por exemplo:

- Serial Monitor da Arduino IDE;
- PuTTY;
- RealTerm;
- outro terminal;
- outra instância do SSC.

## Recebo caracteres estranhos

Normalmente indica configuração serial incorreta.

Confira principalmente:

- baud rate;
- data bits;
- paridade;
- stop bits.

## Envio comando, mas o equipamento não responde

Verifique:

- se o equipamento exige CR, LF ou CR+LF;
- se o comando deve ser enviado em HEX;
- se existe protocolo de checksum;
- se RX/TX estão ligados corretamente;
- se o equipamento exige controle de fluxo.

## Linux informa permissão negada

O usuário precisa ter permissão para acessar a porta serial. Em distribuições Debian/Ubuntu, normalmente a porta pertence ao grupo `dialout`.

Exemplo:

```bash
sudo usermod -aG dialout "$USER"
```

Depois, encerre a sessão e entre novamente.

---

# 15. A ponte Serial ↔ TCP

O segundo programa do projeto, **SSC Bridge Client**, existe para transportar os bytes da porta serial através da rede.

Ele não deve interpretar o protocolo do equipamento. A função principal da ponte é preservar o fluxo de bytes:

```text
RX Serial -> TCP
TCP -> TX Serial
```

Na ponta remota, o **FelineSrv** realiza a operação inversa.

Dessa forma, dois equipamentos ou softwares que esperam comunicação serial podem operar mesmo estando separados por uma rede.

---

# 16. Firmware FelineSrv

O firmware principal está em:

```text
Felinesrv/FelineSrv.ino
```

No código atual ele:

- inicializa a rede Ethernet;
- tenta DHCP;
- usa IP estático como contingência;
- abre servidor TCP na porta **8088**;
- abre página de diagnóstico HTTP na porta **80**;
- inicializa a serial em **2400 baud**;
- recebe byte do cliente TCP e escreve na Serial;
- recebe byte da Serial e envia ao cliente TCP;
- possui opção de echo;
- usa LED/pino para indicar conexão;
- registra informações em cartão SD quando disponível.

Há também:

```text
escuta/escuta.ino
```

que é um firmware auxiliar de teste/loopback entre interfaces seriais.

Manual específico: [Felinesrv/README.md](Felinesrv/README.md).

---

# 17. Para desenvolvedores

O fonte oficial do Analyzer é:

```text
src/
```

Abra no Lazarus:

```text
src/ssc.lpi
```

O projeto utiliza a biblioteca:

https://github.com/marcelomaurin/CHATGPT

Pacotes necessários:

- `openai_core`;
- `openai_input`.

Componentes reutilizados:

- `TAISerialModem`;
- `TAIListSerialDevices`;
- `StrToHex`;
- `HexToStr`.

A branch abaixo preserva o estado anterior à refatoração:

```text
backup-pre-ssc3-20261005
```

---

# 18. Estrutura do repositório

```text
SSC/
├── src/                   # SSC Serial Analyzer
├── Felinesrv/             # Firmware da ponte TCP <-> Serial
├── escuta/                # Firmware auxiliar de teste
├── bin/                   # Instaladores e binários
├── win_bin/install/       # Projeto do instalador Windows
├── buildlinux.sh          # Geração do pacote Debian
└── README*.md             # Documentação em vários idiomas
```

---

# 19. Licença

SSC é distribuído sob a licença **GPL v3**.

Projeto: https://github.com/marcelomaurin/SSC
