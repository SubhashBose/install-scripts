#!/bin/sh
# Runs as $ curl -sL https://install-scripts.bose.dev/detect-platform.sh | sh

# detect-platform.sh — outputs a platform string like "linux-amd64" or "windows-amd64.exe"

# ── OS detection ─────────────────────────────────────────────────────────────
raw_os="$(uname -s 2>/dev/null | tr '[:upper:]' '[:lower:]')"

case "$raw_os" in
  linux*)   os="linux"   ;;
  darwin*)  os="darwin"  ;;
  freebsd*) os="freebsd" ;;
  mingw*|msys*|cygwin*|windows*) os="windows" ;;
  *)
    # Last-resort: try $OSTYPE (set by bash/zsh)
    case "${OSTYPE:-}" in
      linux*)   os="linux"   ;;
      darwin*)  os="darwin"  ;;
      freebsd*) os="freebsd" ;;
      msys*|cygwin*|win32) os="windows" ;;
      *)
        echo "Unsupported OS: $raw_os" >&2
        exit 1
        ;;
    esac
    ;;
esac

# ── Architecture detection ────────────────────────────────────────────────────
raw_arch="$(uname -m 2>/dev/null)"

case "$raw_arch" in
  x86_64|amd64)          arch="amd64"   ;;
  i?86|x86)              arch="386"     ;;
  aarch64|arm64)         arch="arm64"   ;;
  armv*|arm)             arch="arm"     ;;
  riscv64)               arch="riscv64" ;;
  *)
    echo "Unsupported architecture: $raw_arch" >&2
    exit 1
    ;;
esac

# ── Compose output ────────────────────────────────────────────────────────────
if [ "$os" = "windows" ]; then
  os_arch = "${os}-${arch}.exe"
else
  os_arch = "${os}-${arch}"
fi

if [ "$2" == "" ]; then
  echo "$os_arch"
  exit 0
fi

bin_url = "https://github.com/${1}/releases/latest/download/${2}-${os_arch}"

echo "$bin_url"
