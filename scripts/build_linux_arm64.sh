#!/usr/bin/env bash
# Compila o Sistema de Pesagem para Linux ARM64 (Orange Pi 4 Pro com
# Armbian / Debian 13 "Trixie") e gera um pacote .tar.gz em dist/.
#
# O Flutter não faz compilação cruzada para Linux: este script roda numa
# máquina Linux ARM64 — o próprio Orange Pi ou o runner ARM64 do GitHub
# Actions (ver .github/workflows/build-linux-arm64.yml).
#
# Uso:
#   ./scripts/build_linux_arm64.sh            # instala dependências e compila
#   ./scripts/build_linux_arm64.sh --sem-apt  # pula o apt-get (deps já instaladas)
set -euo pipefail

FLUTTER_VERSION="${FLUTTER_VERSION:-3.41.4}"
FLUTTER_DIR="${FLUTTER_DIR:-$HOME/flutter}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALL_APT=1

for arg in "$@"; do
  case "$arg" in
    --sem-apt) INSTALL_APT=0 ;;
    *) echo "Opção desconhecida: $arg" >&2; exit 1 ;;
  esac
done

arch="$(uname -m)"
if [[ "$arch" != "aarch64" && "$arch" != "arm64" ]]; then
  echo "Este script precisa rodar em Linux ARM64 (atual: $arch)." >&2
  echo "Compile no próprio Orange Pi ou use o workflow do GitHub Actions." >&2
  exit 1
fi

if [[ "$INSTALL_APT" == 1 ]]; then
  echo "==> Instalando dependências de compilação (apt)"
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends \
    git curl unzip xz-utils zip ca-certificates \
    clang cmake ninja-build pkg-config \
    libgtk-3-dev liblzma-dev g++
fi

if [[ ! -x "$FLUTTER_DIR/bin/flutter" ]]; then
  echo "==> Baixando Flutter $FLUTTER_VERSION em $FLUTTER_DIR"
  git clone --depth 1 --branch "$FLUTTER_VERSION" \
    https://github.com/flutter/flutter.git "$FLUTTER_DIR"
fi
export PATH="$FLUTTER_DIR/bin:$PATH"

flutter --disable-analytics >/dev/null 2>&1 || true
flutter config --enable-linux-desktop --no-enable-android --no-enable-web >/dev/null
flutter --version

cd "$ROOT_DIR"
echo "==> Baixando pacotes Dart"
flutter pub get

echo "==> Compilando (release, linux-arm64)"
flutter build linux --release

BUNDLE_DIR="build/linux/arm64/release/bundle"
if [[ ! -d "$BUNDLE_DIR" ]]; then
  echo "Bundle não encontrado em $BUNDLE_DIR" >&2
  exit 1
fi

VERSION="$(grep -E '^version:' pubspec.yaml | awk '{print $2}' | cut -d+ -f1)"
PKG_NAME="pesagem-totem-${VERSION}-linux-arm64"
mkdir -p dist
rm -rf "dist/$PKG_NAME"
cp -r "$BUNDLE_DIR" "dist/$PKG_NAME"
cp scripts/install_orangepi.sh "dist/$PKG_NAME/"
cp linux/packaging/pesagem-totem.desktop "dist/$PKG_NAME/"
tar -C dist -czf "dist/$PKG_NAME.tar.gz" "$PKG_NAME"

echo
echo "Pacote gerado: dist/$PKG_NAME.tar.gz"
echo "Para instalar no Orange Pi:"
echo "  tar -xzf $PKG_NAME.tar.gz && cd $PKG_NAME && sudo ./install_orangepi.sh"
