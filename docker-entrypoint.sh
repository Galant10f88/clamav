#!/bin/sh
set -eu

PORT_ENV="${PORT:-3310}"

# Rewrite TCPSocket to $PORT (Railway) or keep default 3310
TMP_CONF="/tmp/clamd.conf"
# Remove any existing TCPSocket lines and append the desired one at the end
if grep -q '^TCPSocket ' /etc/clamav/clamd.conf; then
  grep -v '^TCPSocket ' /etc/clamav/clamd.conf > "$TMP_CONF"
else
  cp /etc/clamav/clamd.conf "$TMP_CONF"
fi
echo "TCPSocket $PORT_ENV" >> "$TMP_CONF"
mv "$TMP_CONF" /etc/clamav/clamd.conf

# Update signatures (best-effort)
freshclam || true

exec clamd -c /etc/clamav/clamd.conf --foreground=true