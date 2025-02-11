#!/bin/sh
#ddev-generated
set -e

if [ "$(uname)" = "Darwin" ]; then
    sed_inplace() {
        sed -i '' "$@"
    }
else
    sed_inplace() {
        sed -i "$@"
    }
fi

if [ ! -f package.json ]; then
		npx -y nuxi@latest init . --gitInit false --packageManager npm --force

		if [ "$HAS_REVERB" = "true" ]; then
        npm install --save laravel-echo pusher-js
    fi

    CONFIG_FILE="nuxt.config.ts"
    if [ -f "$CONFIG_FILE" ]; then
        sed_inplace "s/export default defineNuxtConfig({/export default defineNuxtConfig({\\
      vite: {\\
        server: {\\
          allowedHosts: true\\
        }\\
      },\\
      runtimeConfig: {\\
        public: {\\
          clientApiURL: process.env.API_URL_CLIENT,\\
          serverApiURL: process.env.API_URL_SERVER\\
        }\\
      },/" "$CONFIG_FILE"
    fi
fi

if [ ! -d "node_modules" ]; then
  npm install
fi

exec npm run dev
