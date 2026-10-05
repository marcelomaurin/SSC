# Instalação do SSC 3.0.0

[Português](README.md) · [English](README.en.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Русский](README.ru.md) · [中文](README.zh-CN.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

Esta pasta contém os instaladores e binários do SSC.

## Importante sobre as versões

Os arquivos 2.x já existentes são **históricos**. Eles foram preservados para referência, mas não representam o fonte atual do SSC Serial Analyzer 3.0.

A versão 3.0.0 possui instaladores que **compilam o fonte atual antes de instalar**, evitando distribuir um executável antigo com número de versão novo.

## Windows

Instalador PowerShell:

```text
bin/install_ssc_3.0.0.ps1
```

Execute a partir da raiz do repositório:

```powershell
powershell -ExecutionPolicy Bypass -File .\bin\install_ssc_3.0.0.ps1
```

O script:

1. localiza `lazbuild`;
2. compila `src/ssc.lpi`;
3. verifica `src/ssc.exe`;
4. instala em `%LOCALAPPDATA%\Programs\SSC3`;
5. cria atalhos no Menu Iniciar e Área de Trabalho.

### Instalador Windows tradicional

Projeto Inno Setup:

```text
win_bin/install/ssc3.iss
```

Pré-requisitos para gerar o EXE:

- Lazarus/FPC;
- pacotes CHATGPT `openai_core` e `openai_input`;
- Inno Setup.

Primeiro compile `src/ssc.lpi`. Depois compile `ssc3.iss`.

Saída:

```text
bin/win_X64/setup_3.0.0.exe
```

## Linux

Instalador para o usuário:

```bash
chmod +x bin/install_ssc_3.0.0.sh
./bin/install_ssc_3.0.0.sh
```

O script compila `src/ssc.lpi` e instala:

```text
~/.local/bin/ssc3
~/.local/share/applications/ssc3.desktop
~/.local/share/icons/ssc3.png
```

Nenhum `sudo` é necessário para esse modo.

## Pacote Debian

Execute na raiz:

```bash
chmod +x buildlinux.sh
./buildlinux.sh
```

O script:

1. detecta a arquitetura;
2. verifica `lazbuild` e `dpkg-deb`;
3. compila o Analyzer;
4. monta uma árvore Debian limpa;
5. gera o pacote em `bin/lin_bin/`.

Nome esperado:

```text
ssc3_3.0.0_<arquitetura>.deb
```

Instalação:

```bash
sudo apt install ./bin/lin_bin/ssc3_3.0.0_amd64.deb
```

A arquitetura do nome muda conforme a máquina de build.

## Dependências de compilação

O projeto Lazarus depende da biblioteca:

https://github.com/marcelomaurin/CHATGPT

Pacotes necessários:

- `openai_core`;
- `openai_input`.

## Linux: acesso à serial

Se o programa abrir mas não conseguir acessar `/dev/ttyUSB0` ou `/dev/ttyACM0`:

```bash
sudo usermod -aG dialout "$USER"
```

Saia da sessão e entre novamente.

## Verificação da versão

A documentação e os scripts desta pasta correspondem à linha:

```text
SSC 3.0.0
```

Não renomeie os instaladores 2.x para 3.0.0; eles foram compilados a partir de código antigo.
