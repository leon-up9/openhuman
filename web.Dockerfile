# Browser build of the OpenHuman UI, served as static files by Caddy.
# The UI talks to a separate openhuman-core over JSON-RPC; endpoint + bearer are
# entered in the browser (stored in localStorage), nothing secret is baked in.
FROM node:24-bookworm-slim AS build
RUN corepack enable
WORKDIR /repo
COPY . .
RUN pnpm install --frozen-lockfile
RUN pnpm --filter openhuman-app build:web

FROM caddy:2-alpine
COPY --from=build /repo/app/dist-web /srv
RUN printf ':{$PORT}\nroot * /srv\nencode gzip\ntry_files {path} /index.html\nfile_server\n' > /etc/caddy/Caddyfile
