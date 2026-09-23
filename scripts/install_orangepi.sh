#!/usr/bin/env bash
# Instala o Sistema de Pesagem no Orange Pi 4 Pro (Armbian, Debian 13
# "Trixie", ARM64) a partir do pacote gerado por build_linux_arm64.sh.
#
# Rode de dentro da pasta extraída do pacote:
#   sudo ./install_orangepi.sh [--usuario NOME] [--modo desktop|kiosk|nenhum]
#
# Modos de inicialização automática:
#   desktop  imagem Armbian com área de trabalho: abre o app em tela cheia
#            ao fazer login (autostart do XDG).
#   kiosk    imagem Armbian mínima (sem área de trabalho): o compositor
#            Wayland "cage" roda só o app no tty1, direto no boot.
#   nenhum   só instala; o app é aberto manualmente.
# Sem --modo, usa "desktop" se houver um gerenciador de login gráfico e
# "kiosk" caso contrário.
set -euo pipefail

APP_DIR=/opt/pesagem-totem
BINARY=pesagem_totem
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_USER="${SUDO_USER:-}"
MODE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --usuario) TARGET_USER="$2"; shift 2 ;;
    --modo) MODE="$2"; shift 2 ;;
    *) echo "Opção desconhecida: $1" >&2; exit 1 ;;
  esac
done

if [[ "$(id -u)" != 0 ]]; then
  echo "Rode com sudo: sudo $0 $*" >&2
  exit 1
fi
if [[ -z "$TARGET_USER" || "$TARGET_USER" == root ]]; then
  echo "Informe o usuário que vai rodar o totem: sudo $0 --usuario NOME" >&2
  exit 1
fi
if [[ ! -x "$SRC_DIR/$BINARY" ]]; then
  echo "Executável $BINARY não encontrado em $SRC_DIR." >&2
  echo "Rode este script de dentro da pasta extraída do pacote .tar.gz." >&2
  exit 1
fi
if [[ "$SRC_DIR" == "$APP_DIR" ]]; then
  echo "Rode a partir da pasta extraída do pacote, não de $APP_DIR." >&2
  exit 1
fi
if [[ -z "$MODE" ]]; then
  if systemctl is-enabled display-manager.service >/dev/null 2>&1; then
    MODE=desktop
  else
    MODE=kiosk
  fi
fi

echo "==> Instalando dependências de execução"
apt-get update
PACKAGES=(
  libgtk-3-0t64        # interface (Flutter Linux usa GTK3)
  libegl1 libgles2     # renderização OpenGL/EGL (Mesa)
  zenity               # janela de seleção de arquivo (importação manual)
  bluez                # gateway BLE da balança (opcional)
  coreutils            # stty/cat/dd usados pela balança e pela impressora
  fonts-dejavu-core
)
if [[ "$MODE" == kiosk ]]; then
  PACKAGES+=(cage)
fi
apt-get install -y --no-install-recommends "${PACKAGES[@]}"

echo "==> Copiando o app para $APP_DIR"
rm -rf "$APP_DIR"
mkdir -p "$APP_DIR"
cp -r "$SRC_DIR/." "$APP_DIR/"
rm -f "$APP_DIR/install_orangepi.sh"
chmod +x "$APP_DIR/$BINARY"

echo "==> Permissões de hardware para o usuário $TARGET_USER"
# dialout: portas seriais da balança (/dev/ttyUSB*, /dev/ttyS*)
# lp: impressora USB (/dev/usb/lp*)
usermod -aG dialout,lp "$TARGET_USER"
# Garante o /dev/usb/lp0 da impressora de etiquetas a cada boot.
echo usblp > /etc/modules-load.d/pesagem-totem.conf
modprobe usblp 2>/dev/null || echo "Aviso: módulo usblp não carregou (impressora USB)."

echo "==> Atalho no menu de aplicativos"
install -m 644 "$SRC_DIR/pesagem-totem.desktop" /usr/share/applications/pesagem-totem.desktop

USER_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
AUTOSTART_FILE="$USER_HOME/.config/autostart/pesagem-totem.desktop"
SERVICE_FILE=/etc/systemd/system/pesagem-totem-kiosk.service

rm -f "$AUTOSTART_FILE"
if [[ -f "$SERVICE_FILE" ]]; then
  systemctl disable pesagem-totem-kiosk.service >/dev/null 2>&1 || true
  rm -f "$SERVICE_FILE"
fi

case "$MODE" in
  desktop)
    echo "==> Autostart na área de trabalho (tela cheia)"
    install -d -o "$TARGET_USER" -g "$TARGET_USER" "$USER_HOME/.config/autostart"
    # xset: impede a tela de apagar/descansar no totem (sessões X11).
    sed "s|^Exec=.*|Exec=sh -c \"xset s off -dpms 2>/dev/null; exec $APP_DIR/$BINARY --kiosk\"|" \
      "$SRC_DIR/pesagem-totem.desktop" > "$AUTOSTART_FILE"
    chown "$TARGET_USER:$TARGET_USER" "$AUTOSTART_FILE"
    ;;
  kiosk)
    echo "==> Serviço kiosk (cage no tty1)"
    cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=Sistema de Pesagem (totem)
After=systemd-user-sessions.service plymouth-quit-wait.service network-online.target
Wants=network-online.target
Conflicts=getty@tty1.service

[Service]
User=$TARGET_USER
PAMName=login
TTYPath=/dev/tty1
StandardInput=tty
StandardOutput=journal
StandardError=journal
UtmpIdentifier=tty1
UtmpMode=user
Environment=XDG_SESSION_TYPE=wayland
Environment=PESAGEM_KIOSK=1
ExecStart=/usr/bin/cage -s -- $APP_DIR/$BINARY --kiosk
Restart=always
RestartSec=3

[Install]
WantedBy=graphical.target
EOF
    systemctl daemon-reload
    systemctl disable getty@tty1.service >/dev/null 2>&1 || true
    systemctl set-default graphical.target >/dev/null
    systemctl enable pesagem-totem-kiosk.service
    ;;
  nenhum) ;;
  *) echo "Modo inválido: $MODE (use desktop, kiosk ou nenhum)" >&2; exit 1 ;;
esac

echo
echo "Instalação concluída em $APP_DIR (modo: $MODE)."
echo "Reinicie o Orange Pi para aplicar grupos e inicialização automática: sudo reboot"
