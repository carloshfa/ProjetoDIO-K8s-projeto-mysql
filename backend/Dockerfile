# Imagem base PHP 7.4 com Apache para o backend.
# Instalamos extensões necessárias para GD, PDO MySQL e MySQLi.
# Dockerfile do backend PHP. Cria uma imagem Apache com suporte a MySQL.
FROM php:7.4-apache

WORKDIR /var/www/html

# Copia os arquivos PHP do backend para o diretório do servidor.
COPY index.php /var/www/html/
COPY conexao.php /var/www/html/

# Instala extensões PHP necessárias para GD, PDO MySQL e MySQLi.
RUN apt-get update && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
 && docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install -j$(nproc) gd \
 && docker-php-ext-install pdo_mysql \
 && docker-php-ext-install mysqli

# Expõe a porta 80 para o servidor Apache.
EXPOSE 80
