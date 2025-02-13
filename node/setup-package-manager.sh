#!/bin/bash
#ddev-generated
set -e

ENV_FILE="${DDEV_APPROOT}/.ddev/.env.node"
DOCKERFILE="${DDEV_APPROOT}/.ddev/node/Dockerfile"
ENTRYPOINT="${DDEV_APPROOT}/.ddev/node/docker-entrypoint.sh"

if [ ! -f "$ENV_FILE" ]; then
    echo "Le fichier .env.node n'existe pas"
    exit 0
fi

mkdir "${DDEV_APPROOT}/front"

PACKAGE_MANAGER=$(grep "^PACKAGE_MANAGER=" "$ENV_FILE" | cut -d '=' -f2 | tr -d '"' | tr -d "'")

if [ "$PACKAGE_MANAGER" = "bun" ]; then
    echo "Configuration pour Bun..."

    sed -i.bak 's/node:22-slim/oven\/bun:1-slim/' "$DOCKERFILE"
    sed -i.bak 's/node/bun/g' "$DOCKERFILE"

    sed -i.bak 's|npx -y nuxi@latest init \. --gitInit false --packageManager npm --force|bun x --yes nuxi@latest init . --gitInit false --packageManager bun --force|' "$ENTRYPOINT"
    sed -i.bak 's|npm install --save laravel-echo pusher-js|bun add -d laravel-echo pusher-js|' "$ENTRYPOINT"
    sed -i.bak 's|npm install|bun install|' "$ENTRYPOINT"
    sed -i.bak 's|npm run dev|bun --bun run dev|' "$ENTRYPOINT"

    rm -f "${DOCKERFILE}.bak" "${ENTRYPOINT}.bak"

    echo "Configuration pour Bun terminée"
fi
