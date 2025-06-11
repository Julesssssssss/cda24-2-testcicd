# Étape 1 : Builder
FROM node:24.2-alpine3.21 AS builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .

# Build Next.js (génère .next)
RUN npm run build

# Étape 2 : Image finale "next"
FROM node:24.2-alpine3.21 AS next

WORKDIR /app

# Copie les fichiers nécessaires
COPY --from=builder /app/package.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# Copie ton script d’entrée
COPY docker/next/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["entrypoint.sh"]
CMD ["npm", "run", "start"]
