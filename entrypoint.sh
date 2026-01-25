#!/bin/sh
set -e

if [ -z "$(ls -A /opt/hlds/cstrike 2>/dev/null)" ]; then
  echo "Initializing cstrike directory"
  cp -a /opt/hlds/cstrike_defaults/. /opt/hlds/cstrike/
fi

exec "$@"
