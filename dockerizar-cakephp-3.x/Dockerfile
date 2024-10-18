FROM php:8.1-apache

ENV SERVER_NAME misitio.com
ENV SERVER_ADMIN admin@misitio.com

#Habilitamos la configuración de php que ya esta dentro de la imagen
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

#Instalamos dependencias para las extensiones que necesitamos
RUN apt-get update && apt-get install -y \
    ruby-sass \ 
    #necesario para intl
    libicu-dev \ 
    #necesario para mbstring
    libonig-dev \ 
    #necesario para simplexml
    libxml2-dev \ 
    #necesario para gd
    libfreetype-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libwebp-dev \
    #requerido por php-zip
    libzip-dev

#instalamos las extensiones adicionales de php
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp
RUN docker-php-ext-install intl mbstring simplexml pdo pdo_mysql gd zip

#Configuración del apache
RUN sed -ri -e 's!#ServerName www.example.com!ServerName ${SERVER_NAME}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!ServerAdmin webmaster@localhost!ServerAdmin ${SERVER_ADMIN}!g' /etc/apache2/sites-available/*.conf
RUN sed -i '/<\/VirtualHost>/i\\t<Directory \/var\/www\/html\/>\n\t\tAllowOverride All\n\t<\/Directory>' /etc/apache2/sites-available/*.conf
RUN a2enmod rewrite

#Configuración del php
#RUN sed -i 's/short_open_tag = Off/short_open_tag = On/g' "$PHP_INI_DIR/php.ini"
#RUN sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 20M/g' "$PHP_INI_DIR/php.ini"
#RUN sed -i 's/max_execution_time = 30/max_execution_time = 60/g' "$PHP_INI_DIR/php.ini"
#RUN sed -i 's/post_max_size = 8M/post_max_size = 64M/g' "$PHP_INI_DIR/php.ini"
#RUN sed -i 's/memory_limit = 128M/memory_limit = 256M/g' "$PHP_INI_DIR/php.ini"

#copiamos los archivos del composer y lo instalamos
COPY ./composer.* /var/www/html

WORKDIR /var/www/html
RUN apt update
# RUN php composer.phar update --with-all-dependencies
RUN php composer.phar install
# composer update --with-all-dependencies

#copiamos la aplicación
COPY ./ /var/www/html

#Ajustamos los permisos al final de todo.
RUN chown www-data:www-data /var/www/html -R
