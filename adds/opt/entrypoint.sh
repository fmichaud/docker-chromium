#!/bin/sh
set -e

CHROME_BIN="/usr/bin/chromium"
PROFILE_DIR="${CHROMIUM_USER_DATA_DIR:-/home/appuser/.config/chromium}"

mkdir -p "$PROFILE_DIR"

unset DBUS_SESSION_BUS_ADDRESS

URLS=""
[ -n "$URL_TAB1" ] && URLS="$URLS $URL_TAB1"
[ -n "$URL_TAB2" ] && URLS="$URLS $URL_TAB2"
[ -z "$URLS" ] && URLS="https://teams.microsoft.com/"

exec "$CHROME_BIN" \
  --user-data-dir="$PROFILE_DIR" \
  --no-first-run \
  --no-default-browser-check \
  --disable-dev-shm-usage \
  --disable-crash-reporter \
  --disable-gpu \
  --disable-gpu-compositing \
  --use-gl=swiftshader \
  --no-sandbox \
  $URLS

