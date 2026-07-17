# Dockerfile do frontend. Cria uma imagem NGINX para servir arquivos estáticos.
FROM nginx:alpine

WORKDIR /usr/share/nginx/html

# Copia os arquivos HTML, CSS e JS para o diretório web do NGINX.
COPY . /usr/share/nginx/html/

# Expõe a porta 80 para acesso HTTP.
EXPOSE 80
