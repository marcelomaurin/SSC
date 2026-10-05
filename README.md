# SSC

**SSC - Software Serial Communication** é um analisador/terminal serial desenvolvido em Lazarus/Free Pascal.

A versão atual foi reorganizada para usar a biblioteca **CHATGPT** do mesmo autor como camada de comunicação, evitando duplicação de código serial.

## Fonte oficial

A única árvore de fonte da aplicação é:

```text
src/
```

Os antigos fontes duplicados da raiz foram removidos. A branch `backup-pre-ssc3-20261005` preserva o estado anterior à refatoração.

## Biblioteca CHATGPT utilizada

Repositório:

```text
https://github.com/marcelomaurin/CHATGPT
```

Pacotes Lazarus necessários:

- `openai_input`
- `openai_core`

Componentes/funções reutilizados:

- `TAISerialModem` — abertura, fechamento, transmissão, recepção e polling da porta serial;
- `TAIListSerialDevices` — descoberta das portas realmente detectadas pelo sistema;
- `StrToHex` e `HexToStr` — conversões HEX/texto da biblioteca CHATGPT.

O SSC não mantém mais uma implementação paralela baseada em `SdpoSerial`, nem uma rotina própria de enumeração de COM/tty.

## Detecção de portas

Ao iniciar, o SSC executa uma varredura através de `TAIListSerialDevices`.

O ComboBox mostra somente as portas retornadas pela biblioteca.

O botão **Atualizar portas**:

1. executa uma nova varredura;
2. mantém a porta selecionada se ela continuar presente;
3. detecta novas portas conectadas;
4. remove portas que deixaram de existir;
5. se a porta atualmente conectada desaparecer, encerra a conexão com segurança;
6. atualiza as informações da porta selecionada, incluindo nome amigável, fabricante e VID/PID quando disponíveis.

A opção `ProbeOpenable` permanece desabilitada para evitar abrir temporariamente a porta durante a descoberta e provocar reset por DTR em Arduino/ESP.

## Interface SSC 3

A interface foi refeita com foco no analisador serial.

### Conexão

- Porta serial;
- Atualizar portas;
- Baud rate;
- Bits de dados;
- Paridade;
- Stop bits;
- Conectar/Desconectar;
- identificação da porta detectada.

### Monitor serial

- recepção contínua por `TAISerialModem.Poll`;
- modos Texto, HEX e Texto + HEX;
- timestamp;
- auto-scroll;
- contadores RX/TX;
- limpar monitor;
- salvar log.

### Transmissão

- envio em Texto;
- envio em HEX;
- final de linha configurável: nenhum, CR, LF ou CR+LF;
- envio pelo botão ou tecla Enter.

## Recepção serial

A versão anterior fazia leitura seguida de `Flush`, o que podia eliminar bytes ainda pendentes.

A versão atual utiliza o fluxo previsto pela biblioteca CHATGPT:

```text
Timer -> TAISerialModem.Poll -> OnRXReceive -> Monitor
```

Não existe `Flush` após cada leitura.

## Configuração

As preferências são gravadas em `ssc3.ini` no diretório de configuração da aplicação.

São preservados:

- última porta selecionada;
- baud rate;
- data bits;
- paridade;
- stop bits;
- posição e tamanho da janela.

## Projeto Lazarus

Abra:

```text
src/ssc.lpi
```

Antes de compilar, instale os pacotes `openai_core` e `openai_input` do projeto CHATGPT no Lazarus.

## Licença

GPL v3.
