# Guía de Producción

## Antes de desplegar

### 1. Checklist de seguridad

- [ ] Cambiar contraseña de admin
- [ ] Cambiar HASH_SALT a un valor único: `php -r "echo base64_encode(random_bytes(55));"`
- [ ] Desactivar debug mode (`DEBUG=false`)
- [ ] Revisar permisos de carpetas
- [ ] Configurar HTTPS/SSL
- [ ] Configurar backup automático
- [ ] Revisar y actualizar módulos
- [ ] Ejecutar drush status-report y resolver warnings
- [ ] Probar en staging antes de producción

### 2. Optimización de performance

```bash
# Limpiar caché
drush cache:rebuild

# Agrupar y minificar CSS/JS
# (Configurar en Admin > Appearance > Performance)

# Deshabilitar módulos no usados
drush pm:disable devel kint

# Optimizar imágenes
# Usar Image Styles para tamaños consistentes
```

### 3. Configuración de base de datos

```bash
# Hacer backup antes de cambios
drush sql:dump > backup.sql

# Ejecutar updatedb
drush updatedb

# Exportar configuración final
drush config:export
```

## Despliegue con Docker en servidor

### Opción 1: Docker Compose en VPS

```bash
# En el servidor
git clone [tu-repo] portafolio
cd portafolio

# Editar .env con valores de producción
cp .env.example .env
# Editar .env

# Cambiar docker-compose.yml para producción
# - Remover puertos innecesarios (mailhog, phpmyadmin)
# - Cambiar contraseñas de BD
# - Configurar volumes para persistencia

# Iniciar
docker-compose -f docker-compose.prod.yml up -d
```

### Opción 2: Nginx + PHP-FPM + MySQL (sin Docker)

```bash
# Instalar dependencias
apt-get update && apt-get install -y nginx php8.2-fpm php8.2-mysql mysql-server

# Descargar Drupal con Composer
composer create-project drupal/recommended-project:^10.0 portafolio

# Configurar Nginx (ver ejemplo en docker/nginx.conf)
# Configurar PHP-FPM

# Iniciar servicios
systemctl start nginx
systemctl start php8.2-fpm
systemctl start mysql
```

## Configuración de HTTPS

### Con Let's Encrypt y Nginx

```bash
# Instalar Certbot
apt-get install certbot python3-certbot-nginx

# Generar certificado
certbot certonly --nginx -d ejemplo.com -d www.ejemplo.com

# Configurar Nginx para HTTPS (actualizar docker/nginx.conf)
# Agregar bloque para SSL:

listen 443 ssl;
ssl_certificate /etc/letsencrypt/live/ejemplo.com/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/ejemplo.com/privkey.pem;

# Renovación automática
certbot renew --quiet --no-self-upgrade
```

## Backup y Recuperación

### Backup automático

```bash
#!/bin/bash
# backup.sh

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backups/drupal"

# Backup de BD
docker-compose exec -T database mysqldump -u drupal_user -p[password] portafolio_drupal > $BACKUP_DIR/db_$DATE.sql

# Backup de archivos
tar -czf $BACKUP_DIR/files_$DATE.tar.gz web/sites/default/files

# Backup de configuración
tar -czf $BACKUP_DIR/config_$DATE.tar.gz config/

# Limpiar backups antiguos (> 30 días)
find $BACKUP_DIR -mtime +30 -delete
```

### Recuperar desde backup

```bash
# Restaurar BD
docker-compose exec -T database mysql -u drupal_user -p[password] portafolio_drupal < backup.sql

# Restaurar archivos
tar -xzf files_backup.tar.gz -C web/sites/default/

# Restaurar configuración
tar -xzf config_backup.tar.gz
drush config:import
```

## Monitoreo

### Health Check

```bash
# Verificar estado del sitio
drush status

# Ver reportes de seguridad/problemas
drush status-report

# Ver logs de errores
tail -f /var/log/nginx/error.log
tail -f /var/log/php-fpm.log
```

### Metrics a monitorear

- Disponibilidad del sitio (uptime)
- Tiempo de respuesta
- Uso de CPU y memoria
- Espacio en disco
- Errores en logs
- Actualizaciones disponibles

### Herramientas recomendadas

- **Uptime Robot**: Monitoreo de disponibilidad
- **New Relic**: Performance monitoring
- **Sentry**: Error tracking
- **DataDog**: Infrastructure monitoring

## Updates y Mantenimiento

### Actualizar Drupal

```bash
# 1. Backup
drush sql:dump > backup.sql
tar -czf files_backup.tar.gz web/sites/default/files

# 2. Actualizar
composer update drupal/core --with-dependencies

# 3. Update de BD
drush updatedb

# 4. Exportar configuración
drush config:export

# 5. Limpiar caché
drush cache:rebuild
```

### Actualizar módulos contribuidos

```bash
# Ver actualizaciones disponibles
drush pm:updates

# Actualizar módulo específico
composer update drupal/views

# Actualizar todos
composer update
```

## Seguridad

### Headers HTTP importantes

```nginx
# Agregar a nginx.conf
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
add_header Permissions-Policy "accelerometer=(), camera=(), geolocation=(), gyroscope=(), magnetometer=(), microphone=(), payment=(), usb=()" always;
```

### WAF (Web Application Firewall)

Considerar usar:
- Cloudflare
- ModSecurity
- AWS WAF

## Escalabilidad

Para sitios con mucho tráfico:

1. **Cache**: Redis, Varnish
2. **CDN**: Cloudflare, AWS CloudFront
3. **Load Balancing**: Nginx, HAProxy
4. **Database Replication**: MySQL replication, MariaDB Galera
5. **Static Files**: S3, Cloud Storage
6. **Search**: Elasticsearch para búsquedas avanzadas

## Contacto y soporte

Para issues en producción:
1. Revisar logs (nginx, php-fpm, mysql)
2. Ejecutar `drush status-report`
3. Contactar proveedor de hosting si es necesario
4. Consultar documentación de Drupal
