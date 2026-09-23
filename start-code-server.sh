#!/usr/bin/env bash
set -euo pipefail

export PATH="/root/.local/bin:/usr/local/bin:${PATH}"

: "${PASSWORD:?PASSWORD environment variable is required}"

mkdir -p /data/workspace /data/config /data/antigravity

# Keep Antigravity state on the attached volume when credentials are available.
if [ -d /root/.local/share/antigravity ] && [ ! -e /data/antigravity/.initialized ]; then
  cp -a /root/.local/share/antigravity/. /data/antigravity/ 2>/dev/null || true
  touch /data/antigravity/.initialized
fi

if [ -d /data/antigravity ] && [ -f /data/antigravity/.initialized ]; then
  mkdir -p /root/.local/share/antigravity
  cp -a /data/antigravity/. /root/.local/share/antigravity/ 2>/dev/null || true
fi

exec env \
  PORT="${PORT:-8080}" \
  PASSWORD="${PASSWORD}" \
  code-server \
  --auth password \
  --cert false \
  --disable-telemetry \
  /data/workspace
