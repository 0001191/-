#!/usr/bin/env bash
# Start the native Zulip 12.3 stack on a host that is not booted with systemd.
set -euo pipefail

if [[ "$(id -u)" -ne 0 ]]; then
  echo "Run as root: sudo $0" >&2
  exit 1
fi

services=(
  postgresql
  redis-server
  rabbitmq-server
  memcached
  nginx
  supervisor
)

for service in "${services[@]}"; do
  if /etc/init.d/"${service}" status >/dev/null 2>&1; then
    echo "${service}: already running"
    continue
  fi
  echo "${service}: starting"
  /etc/init.d/"${service}" start
done

pg_isready -h /var/run/postgresql
supervisorctl status
echo "Zulip services are up. nginx listens on 80 and 443."
