# # Étape de build
# FROM node:24.2-alpine3.21 AS builder

# WORKDIR /app

# COPY package.json package-lock.json ./
# RUN npm ci

# COPY . .

# Étape de développement
FROM node:24.2-alpine3.21 as next


ADD . /app/
WORKDIR /app

RUN npm install --omit:dev
RUN npm run build

COPY --from=builder /app/package.json /app/package.json
COPY --from=builder /app/.next /app/.next
COPY --from=builder /app/node_modules /app/node_modules



# Installe les dépendances si elles ne sont pas déjà présentes (via entrypoint)
COPY docker/next/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
EXPOSE 3000

ENTRYPOINT ["entrypoint.sh"]
CMD ["npm", "run", "start"]
