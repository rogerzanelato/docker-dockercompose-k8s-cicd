FROM node:alpine as builder
WORKDIR '/app'
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx
# Esse Expose não é necessário para nós no local, pois utilizamos o binding "-p" para mapear as portas
# contudo, ele é necessário para que a AWS efetue o mapeamento da porta no container
EXPOSE 80
COPY --from=builder /app/build /usr/share/nginx/html