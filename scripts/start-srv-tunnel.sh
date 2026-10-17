#!/usr/bin/env bash
# Keep the srv.us tunnel up. The public hostname is derived from the SSH key
# and stays the same across reconnects.
set -euo pipefail

key="${HOME}/.ssh/zulip-tunnel"
if [[ ! -f "${key}" ]]; then
  echo "Missing ${key}. The stable hostname is tied to this key." >&2
  exit 1
fi

if pgrep -f "ssh .*srv.us" >/dev/null 2>&1; then
  echo "srv.us tunnel already running"
  exit 0
fi

exec ssh -i "${key}" -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new \
  -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -o ExitOnForwardFailure=yes \
  -tt -R 1:localhost:8080 srv.us
