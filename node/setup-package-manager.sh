#!/bin/bash
set -e

ENV_FILE="${DDEV_APPROOT}/.ddev/.env.node"
DOCKERFILE="${DDEV_APPROOT}/.ddev/node/Dockerfile"
ENTRYPOINT="${DDEV_APPROOT}/.ddev/node/docker-entrypoint.sh"

if [ ! -f "$ENV_FILE" ]; then
    echo "Le fichier .env.node n'existe pas"
    exit 0
fi

PACKAGE_MANAGER=$(grep "^PACKAGE_MANAGER=" "$ENV_FILE" | cut -d '=' -f2 | tr -d '"' | tr -d "'")

if [ "$PACKAGE_MANAGER" = "bun" ]; then
    echo "Configuration pour Bun..."

    sed -i'' -e 's/node:22-slim/oven\/bun:1-slim/' "$DOCKERFILE"
    sed -i'' -e 's/node/bun/g' "$DOCKERFILE"

    sed -i'' -e 's|npx -y nuxi@latest init \. --gitInit false --packageManager npm --force|bun x --yes nuxi@latest init . --gitInit false --packageManager bun --force|' "$ENTRYPOINT"
    sed -i'' -e 's|npm install --save laravel-echo pusher-js|bun add -d laravel-echo pusher-js|' "$ENTRYPOINT"
    sed -i'' -e 's|npm install|bun install|' "$ENTRYPOINT"
    sed -i'' -e 's|npm run dev|bun --bun run dev|' "$ENTRYPOINT"

    echo "Configuration pour Bun terminée"
fi