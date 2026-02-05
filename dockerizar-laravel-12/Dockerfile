# ==========================================
# Etapa 1: Dependencias de PHP (Composer)
# ==========================================
FROM composer:2 AS vendor
WORKDIR /app
COPY web/composer.json web/composer.lock* ./
# Copiamos artisan por si algún script de composer lo requiere (package:discover)
COPY web/artisan ./
RUN composer install \
    --no-dev \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --prefer-dist

# ==========================================
# Etapa 2: Assets de Frontend (Vite)
# ==========================================
FROM node:20 AS node-assets
WORKDIR /app
COPY web/package.json web/package-lock.json* ./
RUN npm install
COPY web/vite.config.js ./
COPY web/resources ./resources
COPY web/public ./public
RUN npm run build

# ==========================================
# Etapa 3: Imagen Final (PHP 8.4 + Apache)
# ==========================================
FROM php:8.4-apache

LABEL maintainer="soporte@pruebaweb.com"

# Configuración del Sistema y Zona Horaria
RUN ln -sf /usr/share/zoneinfo/America/Asuncion /etc/localtime

# Dependencias del Sistema
RUN apt-get update && apt-get install -y --no-install-recommends \
    libicu-dev \
    libonig-dev \
    libxml2-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libwebp-dev \
    libfreetype6-dev \
    libzip-dev \
    libexif-dev \
    zip \
    unzip \
    git \
    wget \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Extensiones de PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) \
    intl \
    mbstring \
    xml \
    pdo \
    pdo_mysql \
    gd \
    zip \
    exif \
    pcntl \
    sockets \
    opcache

# Configuración de PHP (Producción)
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY <<EOF /usr/local/etc/php/conf.d/laravel-optimizations.ini
expose_php = Off
max_execution_time = 120
max_input_time = 120
memory_limit = 512M
post_max_size = 64M
upload_max_filesize = 32M
short_open_tag = On

[opcache]
opcache.enable=1
opcache.memory_consumption=256
opcache.interned_strings_buffer=16
opcache.max_accelerated_files=20000
opcache.revalidate_freq=0
opcache.validate_timestamps=1
EOF

# Configuración de Apache
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Habilitar Módulos de Apache
RUN a2enmod rewrite headers

# Configuración de Seguridad Apache (opcional si ya se usa middleware)
COPY ./server/security-headers.conf /etc/apache2/conf-available/security-headers.conf
RUN a2enconf security-headers && a2disconf security

WORKDIR /var/www/html

# Copiar la aplicación
COPY --chown=www-data:www-data ./web .
# Copiar dependencias de la etapa 1
COPY --from=vendor --chown=www-data:www-data /app/vendor ./vendor
# Copiar assets de frontend construidos de la etapa 2
COPY --from=node-assets --chown=www-data:www-data /app/public/build ./public/build

# Entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Permisos para storage y cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

ENTRYPOINT ["entrypoint.sh"]
CMD ["apache2-foreground"]
