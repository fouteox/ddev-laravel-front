#!/bin/sh
set -e

if [ ! -f package.json ]; then
		npx -y nuxi@latest init . --gitInit false --packageManager npm --force
fi

if [ ! -d "node_modules" ]; then
  npm install
fi

exec npm run dev
