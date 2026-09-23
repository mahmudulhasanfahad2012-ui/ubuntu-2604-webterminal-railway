#!/usr/bin/env bash
set -euo pipefail

export PATH="/root/.local/bin:/usr/local/bin:${PATH}"

: "${PASSWORD:?PASSWORD environment variable is required}"

mkdir -p /data/workspace /data/config/code-server /data/antigravity
mkdir -p /root/.local/share

# Keep Antigravity OAuth state on the attached volume from the first run onward.
# A symlink avoids copying stale credentials and preserves credentials obtained later.
if [ -e /root/.local/share/antigravity ] && [ ! -L /root/.local/share/antigravity ]; then
  cp -a /root/.local/share/antigravity/. /data/antigravity/ 2>/dev/null || true
  rm -rf /root/.local/share/antigravity
fi
ln -sfn /data/antigravity /root/.local/share/antigravity

exec env \
  PORT="${PORT:-8080}" \
  PASSWORD="${PASSWORD}" \
  code-server \
  --auth password \
  --cert false \
  --disable-telemetry \
  --user-data-dir /data/config/code-server \
  /data/workspace
