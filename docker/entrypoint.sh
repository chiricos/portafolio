#!/bin/bash

echo "🚀 Iniciando Drupal..."

# Instalar extensiones PHP necesarias
docker-php-ext-install pdo_mysql gd curl mbstring

# Crear directorio de archivos si no existe
mkdir -p /app/web/sites/default/files

# Cambiar permisos
chmod 755 /app/web/sites/default/files

echo "✅ Configuración inicial completada"

# Iniciar PHP-FPM
php-fpm
