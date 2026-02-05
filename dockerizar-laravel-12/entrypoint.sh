#!/bin/bash
set -e

# Asegurar permisos correctos para Laravel
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Limpiar cache de bootstrap para evitar errores de proveedores no encontrados (ej. dev packages)
rm -f /var/www/html/bootstrap/cache/config.php \
      /var/www/html/bootstrap/cache/routes.php \
      /var/www/html/bootstrap/cache/services.php \
      /var/www/html/bootstrap/cache/packages.php \
      /var/www/html/bootstrap/cache/events.php

# Si estamos en modo producción o si artisan existe
if [ -f "/var/www/html/artisan" ]; then
    echo "Iniciando configuración de Laravel..."

    # 1. Correr migraciones automáticamente
    # Esto creará las tablas necesarias para sesiones y cache (si se usa driver database)
    echo "Ejecutando migraciones..."
    php artisan migrate --force --no-interaction

    # 2. Limpiar cualquier residuo previo
    # Usamos || true para que el contenedor no muera si hay algún error menor de limpieza
    echo "Limpiando caches..."
    php artisan config:clear || true
    php artisan cache:clear || true
    php artisan view:clear || true
    php artisan route:clear || true
    
    # 3. Cachear para producción (si APP_ENV es production)
    if [ "${APP_ENV}" = "production" ]; then
        echo "Optimizando para producción..."
        php artisan config:cache
        php artisan route:cache
        php artisan view:cache
    fi
fi

# 4. Iniciar Vite en segundo plano si se solicita (solo desarrollo)
if [ "${APP_ENV}" != "production" ]; then
    echo "Iniciando Vite en segundo plano..."
    (
        if [ ! -d "node_modules" ]; then
            echo "node_modules no encontrado, instalando dependencias..."
            npm install
        fi
        npm run dev -- --host
    ) > /proc/1/fd/1 2>/proc/1/fd/2 &
fi

exec "$@"
