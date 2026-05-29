#!/bin/bash
set -e

COMPOSE_CMD="docker compose"
COMPOSE_FILES="-f docker-compose.yml"

if grep -qi microsoft /proc/version 2>/dev/null; then
    echo "[run.sh] WSL detected — loading docker-compose.wsl.yml"
    COMPOSE_FILES="$COMPOSE_FILES -f docker-compose.wsl.yml"
else
    echo "[run.sh] Native Linux detected"
fi

export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
export USERNAME=$(whoami)

$COMPOSE_CMD $COMPOSE_FILES "$@"
