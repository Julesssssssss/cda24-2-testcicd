# Étape de build
FROM node:20-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .

# Étape de développementt
FROM node:20-alpine

WORKDIR /app

COPY --from=builder /app /app

# Installe les dépendances si elles ne sont pas déjà présentes (via entrypoint)
COPY docker/next/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN npm install
RUN npm run build
EXPOSE 3000

ENTRYPOINT ["entrypoint.sh"]
CMD ["npm", "run", "start"]
