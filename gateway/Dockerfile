# Stage 1: Dependency Cacher
FROM node:20-alpine AS deps
WORKDIR /usr/src/app
COPY package*.json ./
# We use 'npm ci' if lockfile exists, otherwise 'npm install'
RUN if [ -f package-lock.json ]; then npm ci --omit=dev; else npm install --omit=dev; fi

# Stage 2: Production Runner
FROM node:20-alpine
# Install Tini
RUN apk add --no-cache tini

WORKDIR /usr/src/app

# Copy node_modules from Stage 1
COPY --from=deps /usr/src/app/node_modules ./node_modules
# Copy source code
COPY . .

# Security: Non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
RUN chown -R appuser:appgroup /usr/src/app
USER appuser

EXPOSE 5921

ENTRYPOINT ["/sbin/tini", "--"]

# Fail-safe command: uses whatever is in your package.json
CMD ["npm", "start"]
