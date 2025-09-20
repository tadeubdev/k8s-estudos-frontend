# Etapa 1 - Build
FROM node:20-alpine AS builder

WORKDIR /app

# Copia package.json e package-lock.json antes para cache
COPY package*.json ./

COPY nginx.conf /etc/nginx/conf.d/default.conf

# Instala dependências
RUN npm install

# Copia o restante do código
COPY . .

# Build da aplicação
RUN npm run build

# Etapa 2 - Servir com Nginx
FROM nginx:alpine

# Remove configs default do nginx
RUN rm -rf /usr/share/nginx/html/*

# Copia arquivos do build do Vue para o nginx
COPY --from=builder /app/dist /usr/share/nginx/html

# Copia configuração personalizada do nginx (opcional)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
