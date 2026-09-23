# Sistema de Pesagem (pesagem_totem)

Totem de autoatendimento para pesagem e impressão de etiquetas com código de
barras. Feito em Flutter. Roda em:

- **Orange Pi 4 Pro**, Armbian com Debian 13 (Trixie), ARM64 (plataforma principal do totem)
- Windows (PC com balança em porta COM e impressora USB)
- Android (tablet com gateway BLE ou cabo USB-OTG)

## Hardware no Orange Pi

| Dispositivo | Conexão | Como o app usa |
|---|---|---|
| Balança | Adaptador USB-serial (`/dev/ttyUSB*`, `/dev/ttyACM*`) ou UART da placa (`/dev/ttyS*`) | `stty` configura a porta e um processo `cat` lê os dados ([linux_serial_scale_service.dart](lib/services/scale/linux_serial_scale_service.dart)) |
| Balança BLE | Gateway Bluetooth LE | BlueZ, via `flutter_blue_plus` |
| Impressora de etiquetas | USB (`/dev/usb/lp0`) ou fila CUPS | Envia os bytes TSPL crus ([linux_usb_printer_service.dart](lib/services/printer/linux_usb_printer_service.dart)) |
| Tela | HDMI/touch | Modo totem = janela em tela cheia |

Em **Configurações → Balança**, escolha "Porta Serial" e toque em *Buscar portas
seriais*. Dê preferência aos caminhos `/dev/serial/by-id/...`: eles continuam
válidos quando o adaptador é reconectado.

## Gerar o pacote ARM64

O Flutter não faz compilação cruzada para Linux. O pacote precisa ser gerado
numa máquina Linux ARM64. Há duas opções.

### Opção 1: GitHub Actions (recomendado)

A cada push na `main`, o workflow [build-linux-arm64.yml](.github/workflows/build-linux-arm64.yml)
compila num runner ARM64 e publica o artefato
`pesagem-totem-<versão>-linux-arm64.tar.gz` na aba **Actions**. Ao criar uma
tag `v*` (ex.: `git tag v1.0.0 && git push --tags`), o pacote também é anexado
a uma Release.

### Opção 2: compilar no próprio Orange Pi

```bash
git clone https://github.com/<usuario>/<repositorio>.git
cd <repositorio>
./scripts/build_linux_arm64.sh
```

O script instala as dependências de compilação, baixa o Flutter 3.41.4 em
`~/flutter` e gera o pacote em `dist/`. A primeira compilação leva vários
minutos.

## Instalar no Orange Pi

```bash
tar -xzf pesagem-totem-1.0.0-linux-arm64.tar.gz
cd pesagem-totem-1.0.0-linux-arm64
sudo ./install_orangepi.sh --usuario <usuario-do-totem>
sudo reboot
```

O instalador:

- instala as dependências de execução (GTK3, Mesa/EGL, zenity, bluez);
- copia o app para `/opt/pesagem-totem`;
- adiciona o usuário aos grupos `dialout` (balança serial) e `lp` (impressora USB);
- carrega o módulo `usblp` a cada boot (`/dev/usb/lp0`);
- configura o app para abrir sozinho, em tela cheia:
  - `--modo desktop`: imagem Armbian **com** área de trabalho. O app abre ao fazer login.
  - `--modo kiosk`: imagem Armbian **mínima**. O compositor `cage` roda só o
    app no tty1, direto no boot (serviço `pesagem-totem-kiosk`).
  - `--modo nenhum`: só instala.

  Sem `--modo`, o instalador detecta o modo sozinho: `desktop` se houver
  gerenciador de login gráfico, senão `kiosk`.

Para abrir o app em tela cheia manualmente: `/opt/pesagem-totem/pesagem_totem --kiosk`.

### Solução de problemas

| Sintoma | Verificação |
|---|---|
| "Sem permissão para abrir /dev/ttyUSB0" | `groups` precisa listar `dialout`. Reinicie a sessão após instalar. |
| Nenhuma porta serial listada | `ls /dev/serial/by-id/` e `dmesg \| tail` ao plugar o adaptador. |
| Impressora não aparece | `ls /dev/usb/`. Se estiver vazio, rode `sudo modprobe usblp`. |
| Logs do modo kiosk | `journalctl -u pesagem-totem-kiosk -f` |
| Banco de dados | `~/.local/share/com.exattapdv.pesagem_totem/` |

## Desenvolvimento

```bash
flutter pub get
dart run build_runner build   # regenera o Drift (app_database.g.dart)
flutter analyze
flutter test
```
