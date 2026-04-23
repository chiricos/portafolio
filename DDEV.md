# DDEV - Guía de Uso

DDEV (Local) es una herramienta poderosa para desarrollo local con Drupal. Reemplaza la necesidad de Docker Compose manual, Vagrant o MAMPs.

## Requisitos previos

1. **Docker Desktop** instalado (para Linux, Docker engine + Docker CLI)
2. **DDEV** instalado
3. **Git** instalado

### Instalar DDEV

#### En macOS
```bash
brew install ddev/ddev/ddev
```

#### En Windows
```bash
choco install ddev
# O descargar desde https://github.com/ddev/ddev/releases
```

#### En Linux
```bash
curl -fsSL https://apt.fury.io/ddev/pubkey.gpg | sudo gpg --dearmor -o /usr/share/keyrings/ddev-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/ddev-archive-keyring.gpg] https://apt.fury.io/ddev/ * *" | sudo tee /etc/apt/sources.list.d/ddev.list
sudo apt-get update
sudo apt-get install ddev
```

## Primeros pasos

### 1. Instalar dependencias
```bash
make install
# O manualmente:
ddev composer install
```

### 2. Levantar el proyecto
```bash
make start
# O manualmente:
ddev start
```

### 3. Acceder al sitio
```bash
make url
# O abre en navegador:
# http://portafolio.ddev.site
```

## Comandos principales

```bash
# Ver estado del proyecto
ddev describe

# Ver logs
ddev logs -f

# Ejecutar comandos de Drush
ddev drush status
ddev drush cache:rebuild
ddev drush config:export

# Ejecutar comandos en web container
ddev ssh  # Acceder a shell del container

# Base de datos
ddev db-create          # Crear nueva BD
ddev db-import <file>   # Importar BD
ddev db-dump > backup.sql  # Exportar BD

# Snapshots (Backups de BD)
ddev snapshot              # Crear snapshot
ddev snapshot list         # Listar snapshots
ddev snapshot restore      # Restaurar último snapshot

# Detener/reiniciar
ddev stop                  # Detener sin eliminar datos
ddev restart              # Reiniciar
ddev delete               # Eliminar proyecto (no elimina código)
```

## Uso con Make (Recomendado)

```bash
# Instalar y levantar
make install
make start

# Ejecutar comandos
make drush status
make drush cache:rebuild
make drush config:export

# Backup
make db-dump

# Restaurar
make db-restore

# Detener
make stop

# Reiniciar
make restart

# Ver estado
make status

# Ver URL
make url

# Limpiar todo
make clean
```

## Configuración avanzada

### Ver archivo de configuración
```bash
cat .ddev/config.yaml
```

### Cambiar PHP, DB, o web server
Editar `.ddev/config.yaml` y ejecutar `ddev restart`

```yaml
php_version: "8.3"          # Cambiar PHP
database:
  type: postgres            # O mariadb, postgres
  version: "16"
webserver_type: apache-fpm  # O apache-fpm, apache-cgi
```

### Agregar variables de entorno
```yaml
web_environment:
  - DRUPAL_ENV=development
  - CUSTOM_VAR=value
```

### Habilitar Xdebug

```bash
# Habilitar Xdebug
ddev xdebug on

# Configurar IDE (Ver instrucciones en VS Code, PHPStorm, etc.)

# Desactivar (recomendado para mejor performance)
ddev xdebug off
```

### Usar servicios adicionales

El archivo `.ddev/config.yaml` puede incluir servicios adicionales:

```yaml
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.14.0
    environment:
      - discovery.type=single-node
      - "ES_JAVA_OPTS=-Xms750m -Xmx750m"
```

## Tips de rendimiento

### 1. No usar Xdebug siempre
```bash
ddev xdebug off  # Desactivado por defecto
ddev xdebug on   # Activar solo cuando depures
```

### 2. Usar memoria caché
```bash
# Redis (agregar a .ddev/config.yaml)
services:
  redis:
    image: redis:latest
```

### 3. Limpiar periódicamente
```bash
# Limpiar caché
ddev drush cache:rebuild

# Deshabilitar módulos no usados
ddev drush pm:disable devel kint
```

## Troubleshooting

### DDEV no inicia
```bash
# Verificar estado de Docker
docker ps

# Reiniciar DDEV
ddev restart

# Ver logs
ddev logs -f

# Diagnóstico
ddev debug
```

### Error: "Port 80 already in use"
```bash
# Ver configuración de puertos
cat .ddev/config.yaml | grep router

# Cambiar puerto
# Editar .ddev/config.yaml y cambiar router_http_port
```

### No puedo conectar a la BD
```bash
# Verificar conexión
ddev db-connect

# Crear BD si no existe
ddev db-create
```

### Drupal no está instalado
```bash
# Instalar Drupal
ddev drush site:install standard --account-name=admin --account-pass=admin

# O restaurar desde backup
ddev db-import backup.sql
```

### Errores de permisos
```bash
# Resetear permisos
ddev ssh
chmod -R 755 /var/www/html/web/sites/default
chmod 644 /var/www/html/web/sites/default/settings.php
```

## Flujo de trabajo típico

### Desarrollo diario
```bash
# 1. Iniciar día
ddev start

# 2. Hacer cambios en código
# (editar archivos en tu IDE)

# 3. Exportar configuración
ddev drush config:export

# 4. Hacer commit
git add .
git commit -m "feat: Mi cambio"

# 5. Finalizar día
ddev stop
```

### Sincronizar con equipo
```bash
# Obtener cambios de equipo
git pull

# Importar configuración
ddev drush config:import

# Actualizar BD
ddev drush updatedb

# Limpiar caché
ddev drush cache:rebuild
```

### Desplegar a producción
Seguir guía en [PRODUCCION.md](PRODUCCION.md)

## Comparativa: DDEV vs Docker Compose

| Característica | DDEV | Docker Compose |
|---|---|---|
| Facilidad de uso | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| Configuración | Mínima | Configuración manual |
| Comandos | Simples (ddev ssh) | Complejos (docker-compose exec) |
| MailHog integrado | ✅ Incluido | ❌ Requiere config |
| Database tools | ✅ Integrados | ❌ Requiere setup |
| Snapshots de BD | ✅ Sí | ❌ No |
| Community | Grande | Muy grande |
| Documentación | Excelente | Buena |
| Para desarrollo | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |

## Integración con CI/CD

DDEV es principalmente para desarrollo local. Para CI/CD usar:
- GitHub Actions con DDEV
- Gitlab CI
- CircleCI

Ejemplo CI/CD con GitHub Actions + DDEV:
```yaml
name: DDEV CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: ddev/github-action-setup-ddev@v1
      - name: Install dependencies
        run: ddev composer install
      - name: Start DDEV
        run: ddev start -y
      - name: Run tests
        run: ddev phpunit
```

## Recursos útiles

- **[DDEV Documentación oficial](https://ddev.readthedocs.io/)**
- **[DDEV GitHub Issues](https://github.com/ddev/ddev/issues)**
- **[Drupal Documentación](https://www.drupal.org/docs)**
- **[Drush Commands](https://www.drush.org/)**

## Próximos pasos

1. ✅ DDEV está configurado
2. Ejecutar `make install` para instalar dependencias
3. Ejecutar `make start` para levantar el proyecto
4. Acceder a http://portafolio.ddev.site
5. Comenzar a desarrollar tu portafolio

---

**¿Problema? Ejecuta:**
```bash
ddev debug
```

Esta información de diagnóstico es útil para troubleshooting.
