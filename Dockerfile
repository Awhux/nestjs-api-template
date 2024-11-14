ARG NODE_VERSION=20
FROM node:${NODE_VERSION}-alpine AS builder
RUN corepack enable
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile
COPY . .
RUN pnpm build

FROM node:${NODE_VERSION}-alpine AS production
RUN corepack enable
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY package.json pnpm-lock.yaml ./
ENV NODE_ENV=production
EXPOSE 3000
CMD ["pnpm", "serve"]
