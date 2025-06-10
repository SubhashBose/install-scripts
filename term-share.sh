#!/bin/bash

#run as 
# curl -sL https://install-scripts.bose.dev/term-share.sh | sudo bash -s -- <TOKEN>
# curl -sL https://install-scripts.bose.dev/term-share.sh >/tmp/ts.sh && chmod +x /tmp/ts.sh && /tmp/ts.sh <TOKEN>
# source <(curl -sL https://install-scripts.bose.dev/term-share.sh) && term-share <TOKEN>

# Detect OS
OS="$(uname -s)"
ARCH="$(uname -m)"

# Normalize OS
case "$OS" in
    Darwin) OS="darwin"; fn_append=".tgz" ;;
    Linux) OS="linux" ;;
    #FreeBSD) OS="freebsd" ;;
    *) echo "Unsupported OS: $OS" && exit 1 ;;
esac

# Normalize architecture
case "$ARCH" in
    x86_64) ARCH="amd64" ;;
    arm64|aarch64) ARCH="arm64" ;;
    i386|i686) ARCH="386" ;;
    *) echo "Unsupported architecture: $ARCH" && exit 1 ;;
esac

# Check for curl or wget
if command -v curl >/dev/null 2>&1; then
    DOWNLOADER="curl -L --progress-bar"
elif command -v wget >/dev/null 2>&1; then
    DOWNLOADER="wget -q --show-progress -O-"
else
    echo "Error: Neither curl nor wget is installed." >&2
    exit 1
fi

URL="https://github.com/SubhashBose/tty-share/releases/latest/download/tty-share_${OS}-${ARCH}"
$DOWNLOADER "$URL" > /tmp/tty-share
chmod +x /tmp/tty-share

RUNNER="/tmp/tty-share -listen localhost:63742 -silent"

if [ -n "$1" ]; then
    URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-${OS}-${ARCH}${fn_append}"
    if [ -n "$fn_append" ]; then
        $DOWNLOADER "$URL" | tar zxvfO - cloudflared > /tmp/cfd
    else
        $DOWNLOADER "$URL" > /tmp/cfd
    fi
    chmod +x /tmp/cfd
    cfd_pid=$(/tmp/cfd tunnel run --token "$1" > /dev/null  2>&1 & echo $!)
    $RUNNER 2> /dev/null
    kill "$cfd_pid" 2> /dev/null
else
    $RUNNER -public -webhook "https://webhook2tg.bose.dev/LQ7bZv2bp?msgparam=url" 2> /dev/null
fi
