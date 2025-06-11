# Étape de build
FROM node:24-alpine3.21 AS builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .

# Étape de développement
FROM node:24-alpine3.21

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
