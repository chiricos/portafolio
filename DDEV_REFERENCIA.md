# Referencia Rápida - Comandos DDEV

## Inicio y parada

```bash
ddev start              # Iniciar proyecto
ddev stop               # Detener proyecto (sin eliminar datos)
ddev restart            # Reiniciar proyecto
ddev delete             # Eliminar proyecto (no elimina código fuente)
ddev describe           # Ver información del proyecto
```

## Make (Recomendado)

```bash
make help               # Ver todos los comandos
make install            # Instalar dependencias
make start              # Levantar DDEV
make stop               # Detener DDEV
make restart            # Reiniciar DDEV
make status             # Ver estado
make url                # Ver URL del sitio
make drush [cmd]        # Ejecutar drush
make logs               # Ver logs
make db-dump            # Backup BD
make db-restore         # Restaurar BD
make clean              # Limpiar todo
```

## Drush (Drupal)

```bash
ddev drush status                    # Ver estado
ddev drush cache:rebuild             # Limpiar caché
ddev drush config:export             # Exportar configuración
ddev drush config:import             # Importar configuración
ddev drush updatedb                  # Ejecutar actualizaciones
ddev drush user:password admin pass  # Cambiar contraseña admin
ddev drush pm:list                   # Listar módulos
ddev drush en [module]               # Habilitar módulo
ddev drush dis [module]              # Deshabilitar módulo
```

## Base de datos

```bash
ddev db-connect                 # Conectar a BD (MySQL)
ddev db-create                  # Crear BD
ddev db-import backup.sql       # Importar BD
ddev db-dump > backup.sql       # Exportar BD
ddev snapshot                   # Crear snapshot de BD
ddev snapshot list              # Listar snapshots
ddev snapshot restore           # Restaurar snapshot
```

## Compositor

```bash
ddev composer install           # Instalar dependencias
ddev composer update            # Actualizar dependencias
ddev composer require vendor/package  # Instalar paquete
```

## Terminal

```bash
ddev ssh                        # Acceder a terminal del container web
ddev ssh -s db                  # Acceder a terminal del container BD
ddev exec [comando]             # Ejecutar comando en web container
ddev exec -s db [comando]       # Ejecutar comando en db container
```

## Logs

```bash
ddev logs -f                    # Ver logs en tiempo real (web)
ddev logs -f -s db              # Ver logs de BD
ddev logs -f -s mailhog         # Ver logs de MailHog
ddev logs                       # Ver logs histórico
```

## Desarrollo

```bash
ddev xdebug on                  # Habilitar Xdebug
ddev xdebug off                 # Desactivar Xdebug
ddev debug                      # Ver información de diagnóstico
ddev list                       # Listar todos los proyectos DDEV
ddev config                     # Ver/editar configuración
```

## Servicios

```bash
ddev describe                   # Ver URLs de todos los servicios
ddev list                       # Ver estado de todos los servicios
```

## URL del sitio

```bash
# Sitio principal
http://portafolio.ddev.site

# MailHog (pruebas de correo)
http://portafolio.ddev.site:8025
```

## Comandos útiles

```bash
# Cambiar versiones (editar .ddev/config.yaml y reiniciar)
php_version: "8.3"
database:
  type: mysql
  version: "8.0"
webserver_type: nginx-fpm

# Luego
ddev restart
```

## Troubleshooting

```bash
ddev debug              # Información de diagnóstico
ddev logs -f            # Ver logs en tiempo real
ddev describe           # Ver estado del proyecto
ddev restart            # Reiniciar proyecto
```

## Atajos útiles

### Alias en bash/zsh

Agrega al `~/.bashrc` o `~/.zshrc`:

```bash
alias dd="ddev"
alias dds="ddev ssh"
alias dde="ddev exec"
alias ddc="ddev drush cache:rebuild"
alias ddc:ex="ddev drush config:export"
alias ddc:im="ddev drush config:import"
```

Luego:
```bash
dd start                # En lugar de: ddev start
dds                     # En lugar de: ddev ssh
ddc                     # En lugar de: ddev drush cache:rebuild
```

---

**Más información:** `ddev help` o visita https://ddev.readthedocs.io/
