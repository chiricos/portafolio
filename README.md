# Portafolio - Drupal Project

Un sitio de portafolio profesional construido con Drupal 10, desarrollado con DDEV.

## Requisitos

- **Docker Desktop** (o Docker Engine en Linux)
- **DDEV** (Local)
- **Git**
- **Composer** (instalado automáticamente por DDEV)

### Instalar DDEV

- **macOS**: `brew install ddev/ddev/ddev`
- **Windows**: `choco install ddev` o descargar desde https://github.com/ddev/ddev/releases
- **Linux**: Ver instrucciones en https://ddev.readthedocs.io/en/stable/users/install/

## Instalación Rápida

### 1. Instalar dependencias

```bash
make install
```

### 2. Levantar el proyecto

```bash
make start
```

### 3. Acceder a Drupal

```bash
make url
```

O abre en tu navegador: **http://portafolio.ddev.site**

## Estructura del Proyecto

```
portafolio/
├── .ddev/                    # Configuración de DDEV
├── config/
│   └── sync/                 # Configuración sincronizada de Drupal
├── web/
│   ├── core/                 # Drupal core
│   ├── modules/custom/       # Módulos personalizados
│   ├── themes/               # Temas personalizados
│   └── sites/                # Configuración del sitio
├── GUIA_RAPIDA.md           # Primeros pasos (comienza aquí)
├── DDEV.md                  # Guía completa de DDEV
├── DESARROLLO.md            # Guía de desarrollo
├── PRODUCCION.md            # Guía de despliegue
├── MODULOS_Y_TEMAS.md       # Módulos y temas recomendados
└── GIT_WORKFLOW.md          # Flujo de Git
```

## Comandos principales

```bash
# Ver todos los comandos disponibles
make help

# Instalar dependencias
make install

# Iniciar proyecto
make start

# Detener proyecto
make stop

# Reiniciar
make restart

# Ver estado
make status

# Ejecutar Drush
make drush [comando]

# Ejemplo: limpiar caché
make drush cache:rebuild

# Backup de BD
make db-dump

# Restaurar BD
make db-restore

# Acceder a terminal del container
ddev ssh
```

## Documentación

| Tema | Archivo |
|---|---|
| **Primeros pasos** | [GUIA_RAPIDA.md](GUIA_RAPIDA.md) |
| **DDEV completo** | [DDEV.md](DDEV.md) |
| **Desarrollo** | [DESARROLLO.md](DESARROLLO.md) |
| **Producción** | [PRODUCCION.md](PRODUCCION.md) |
| **Módulos/Temas** | [MODULOS_Y_TEMAS.md](MODULOS_Y_TEMAS.md) |
| **Git Workflow** | [GIT_WORKFLOW.md](GIT_WORKFLOW.md) |

## Servicios incluidos

- **PHP 8.2** con FPM/Nginx
- **MySQL 8.0**
- **MailHog** (http://portafolio.ddev.site:8025)
- **Drush** (CLI de Drupal)
- **Composer** (Gestor de dependencias)

## Workflow típico

```bash
# 1. Iniciar el día
make start

# 2. Hacer cambios
# (editar archivos en tu IDE)

# 3. Exportar configuración
ddev drush config:export

# 4. Hacer commit
git add .
git commit -m "feat: Descripción del cambio"

# 5. Finalizar el día
make stop
```

## Troubleshooting

### DDEV no inicia
```bash
ddev restart
ddev logs -f  # Ver logs
```

### No puedo acceder al sitio
```bash
ddev describe  # Ver información
ddev debug     # Diagnóstico
```

### Cambiar contraseña admin
```bash
ddev drush user:password admin nuevacontraseña
```

## Más información

- 📖 [GUIA_RAPIDA.md](GUIA_RAPIDA.md) - Comienza aquí
- 🛠️ [DDEV.md](DDEV.md) - Guía completa de DDEV
- 📚 [Documentación oficial de Drupal](https://www.drupal.org/docs)
- 🎯 [Drush Commands](https://www.drush.org/)
- 🐳 [DDEV Documentation](https://ddev.readthedocs.io/)

## Licencia

Este proyecto está bajo licencia GPL v2 o posterior (estándar de Drupal).

