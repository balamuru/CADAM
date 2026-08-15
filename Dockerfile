# syntax=docker/dockerfile:1

# --- Build stage --------------------------------------------------------
# Compiles the TanStack Start / Nitro app. Vite inlines every VITE_* var at
# build time (see src/lib/supabase.ts etc.), so those must arrive as build
# ARGs, not runtime environment — changing one means rebuilding this image.
FROM node:22-slim AS build
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . .

ARG VITE_SUPABASE_URL
ARG VITE_SUPABASE_ANON_KEY
ARG VITE_SSO_PROVIDER=
ARG VITE_ACCOUNT_URL=
ARG VITE_POSTHOG_PROJECT_KEY=
ARG VITE_POSTHOG_HOST=
ARG VITE_SENTRY_ENVIRONMENT=
ARG VITE_SENTRY_DSN=
ARG VITE_SENTRY_TRACES_SAMPLE_RATE=

RUN npm run build

# --- Runtime stage -------------------------------------------------------
# Nitro's node-server preset produces a self-contained .output/ directory
# (its own trimmed node_modules for traced deps, e.g. tslib) — no npm
# install needed here, just run the bundled entry.
FROM node:22-slim AS runtime
WORKDIR /app
ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=3000

COPY --from=build /app/.output ./

EXPOSE 3000
CMD ["node", "server/index.mjs"]
