#!/usr/bin/env bash
# Wrapper around the docker compose stack (see docker-compose.yml + README's
# "Docker" section). Add more subcommands here as the workflow grows.
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

ENV_FILE=".env.docker"
COMPOSE=(docker compose --env-file "$ENV_FILE")

usage() {
  cat <<EOF
Usage: ./manage.sh <command>

Commands:
  up      Build (if needed) and start all containers
  down    Stop and remove all containers (keeps data volumes)
EOF
}

require_env_file() {
  if [ ! -f "$ENV_FILE" ]; then
    echo "Missing $ENV_FILE — copy .env.docker.template to $ENV_FILE and fill in your keys first." >&2
    exit 1
  fi
}

case "${1:-}" in
  up)
    require_env_file
    "${COMPOSE[@]}" up --build -d
    ;;
  down)
    "${COMPOSE[@]}" down
    ;;
  *)
    usage
    exit 1
    ;;
esac
