

# Etapa 1: Composer
FROM composer:2 AS vendor
WORKDIR /app_composer
COPY web/composer.json web/composer.lock* ./
RUN composer install --no-dev --optimize-autoloader

# Etapa 2: PHP + Apache
FROM php:8.4-apache

# Configuración de Apache
ENV SERVER_NAME=visualgroup.local
ENV SERVER_ADMIN=soporte@nosotroshq.com

# Definir el directorio de trabajo
WORKDIR /var/www/html

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y wget zip unzip git && rm -rf /var/lib/apt/lists/*

# Instalar extensiones mínimas necesarias
RUN docker-php-ext-install pdo pdo_mysql

# Copiar composer vendor desde la Etapa 1
COPY --from=vendor app_composer/vendor ./vendor

# Habilitar mod_rewrite y mod_headers
RUN a2enmod rewrite headers

# Setear configuración de Apache: copiar y habilitar security-headers
COPY ./server/security-headers.conf /etc/apache2/conf-available/security-headers.conf
RUN a2enconf security-headers

# Copiar la app al contenedor
# En caso de necesitar permiso usar --chmod=755
COPY --chown=wwww-data:www-data ./web /var/www/html
