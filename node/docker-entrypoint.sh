#!/bin/sh
#ddev-generated
set -e

if [ ! -f package.json ]; then
		npx -y nuxi@latest init . --gitInit false --packageManager npm --force

		if [ "$HAS_REVERB" = "true" ]; then
        npm install --save laravel-echo pusher-js
    fi
fi

if [ ! -d "node_modules" ]; then
  npm install
fi

exec npm run dev
