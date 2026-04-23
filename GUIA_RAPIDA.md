# Guía Rápida de Inicio con DDEV

## 1. Configuración inicial (2 minutos)

```bash
# Navegar al proyecto
cd portafolio

# Instalar dependencias
make install
```

## 2. Levantar el proyecto (1 minuto)

```bash
# Iniciar DDEV
make start

# Ver información del proyecto
make status
```

## 3. Acceder a Drupal

```bash
# Ver URL
make url

# O accede a:
# http://portafolio.ddev.site
```

**Credenciales iniciales:**
- Usuario: admin
- Contraseña: admin (configurar tras la instalación)

**Servicios adicionales:**
- **MailHog**: http://portafolio.ddev.site:8025 (para pruebas de correo)

## 4. Primeros pasos en Drupal

### Crear un tipo de contenido "Proyecto"
1. Ve a **Structure > Content types > Add content type**
2. Nombre: "Proyecto"
3. ID: "proyecto"
4. Guardar

### Agregar campos al tipo "Proyecto"
1. En la página del tipo de contenido, ve a **Manage fields**
2. Agrega estos campos:
   - **field_images** (Imagen, múltiples valores)
   - **field_technologies** (Texto, múltiples valores)
   - **field_project_link** (Enlace)
   - **field_description** (Texto largo con formato)

### Crear una Vista de Proyectos
1. Ve a **Structure > Views > Add view**
2. Nombre: "Projects"
3. Content type: "Proyecto"
4. Mostrar: "Fields"
5. Guardar

## 5. Comandos útiles con Make

```bash
# Ver todos los comandos
make help

# Ejecutar comandos de Drush
make drush status
make drush cache:rebuild
make drush config:export

# Ver logs
make logs

# Acceder a shell del container
ddev ssh

# Backup de BD
make db-dump

# Restaurar BD
make db-restore

# Detener
make stop

# Reiniciar
make restart

# Limpiar todo y empezar de cero
make clean
```

## 6. Comandos Drush útiles

```bash
# Limpiar caché
ddev drush cache:rebuild

# Ver estado
ddev drush status

# Exportar configuración
ddev drush config:export

# Importar configuración
ddev drush config:import

# Ejecutar actualizaciones
ddev drush updatedb

# Cambiar contraseña de admin
ddev drush user:password admin nuevacontraseña
```

## Siguientes pasos

1. **Personalizar el tema**: Crear tema personalizado en `web/themes/portfolio_theme/`
2. **Instalar módulos adicionales**: `ddev composer require drupal/module-name`
3. **Crear módulos personalizados**: En `web/modules/custom/`
4. **Configurar SEO**: Metatags, Sitemap
5. **Optimizar imágenes**: Instalar Image Styles
6. **Configurar correo**: SMTP para producción

## Troubleshooting

### Problema: DDEV no inicia
```bash
# Verificar estado
ddev describe

# Reiniciar
ddev restart

# Ver logs
ddev logs -f
```

### Problema: No puedo acceder a http://portafolio.ddev.site
- Verifica que DDEV está corriendo: `ddev describe`
- Revisa logs: `ddev logs -f`
- Reinicia: `ddev restart`

### Problema: Error de permisos en `web/sites/default/`
```bash
ddev ssh
chmod -R 755 /var/www/html/web/sites/default
```

### Problema: Base de datos no conecta
```bash
# Verificar conexión
ddev db-connect

# Si necesitas reinstalar
ddev delete -O
ddev start
```

### Problema: Olvidé la contraseña de admin
```bash
ddev drush user:password admin nuevacontraseña
```

## Más información

- [DDEV.md](DDEV.md) - Guía completa de DDEV
- [Documentación de Drupal](https://www.drupal.org/docs)
- [Drush Commands](https://www.drush.org/)
- [DDEV Documentation](https://ddev.readthedocs.io/)

