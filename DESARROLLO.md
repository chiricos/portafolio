# Desarrollo y Contribución

## Configuración de desarrollo

Este proyecto está configurado para desarrollo con Docker Compose. Para empezar:

```bash
make install
make up
```

## Estructura de carpetas para desarrollo

```
portafolio/
├── web/
│   ├── modules/custom/              # Tus módulos personalizados
│   │   └── portfolio_[nombre]/      # Estructura de módulo
│   │       ├── portfolio_[nombre].info.yml
│   │       ├── portfolio_[nombre].module
│   │       ├── src/
│   │       ├── templates/
│   │       └── config/
│   └── themes/                      # Temas personalizados
│       └── portfolio_theme/
│           ├── portfolio_theme.info.yml
│           ├── css/
│           ├── js/
│           ├── templates/
│           └── config/
└── config/sync/                     # Configuración sincronizada
```

## Crear un módulo personalizado

```bash
# Estructura mínima de un módulo
mkdir -p web/modules/custom/portfolio_projects

# Crear archivo info.yml
cat > web/modules/custom/portfolio_projects/portfolio_projects.info.yml << 'EOF'
name: Portfolio Projects
description: Módulo para gestionar proyectos del portafolio
package: Custom
version: 1.0.0
type: module
core_version_requirement: ^10
EOF

# Crear archivo module (opcional)
touch web/modules/custom/portfolio_projects/portfolio_projects.module

# Habilitar el módulo
docker-compose exec web drush en portfolio_projects
```

## Crear un tema personalizado

```bash
# Crear estructura del tema
mkdir -p web/themes/portfolio_theme/{css,js,templates,config/install}

# Crear archivo info.yml
cat > web/themes/portfolio_theme/portfolio_theme.info.yml << 'EOF'
name: Portfolio Theme
description: Tema personalizado para el portafolio
version: 1.0.0
type: theme
base theme: olivero
core_version_requirement: ^10
EOF
```

## Sincronización de configuración

Drupal permite exportar/importar configuración:

```bash
# Exportar configuración a config/sync/
docker-compose exec web drush config:export

# Importar configuración desde config/sync/
docker-compose exec web drush config:import

# Ver diferencias antes de importar
docker-compose exec web drush config:status
```

## Comprobar código con Drupal Standards

```bash
# Instalar PHP CodeSniffer con estándares Drupal
composer require squizlabs/php_codesniffer drupal/coder

# Ejecutar verificación
./vendor/bin/phpcs web/modules/custom --standard=Drupal
```

## Testing

```bash
# Ejecutar tests PHPUnit
docker-compose exec web ./vendor/bin/phpunit

# Con coverage
docker-compose exec web ./vendor/bin/phpunit --coverage-html=coverage
```

## Debugging

### XDebug
El proyecto puede configurarse para usar XDebug:

1. Descomentar XDebug en docker/php.ini
2. Configurar IDE (VS Code, PhpStorm, etc.)
3. Usar breakpoints durante desarrollo

### Drush debugging
```bash
# Ver más información en comandos
docker-compose exec web drush --verbose

# Modo debug
docker-compose exec web drush --debug
```

## Git Workflow

```bash
# Crear rama de feature
git checkout -b feature/mi-feature

# Hacer cambios y commits
git add .
git commit -m "feat: Descripción del cambio"

# Exportar configuración
docker-compose exec web drush config:export

# Agregar cambios de configuración
git add config/sync/
git commit -m "config: Cambios de configuración"

# Subir a remoto
git push origin feature/mi-feature
```

## Performance

### Limpiar caché
```bash
docker-compose exec web drush cache:rebuild
```

### Deshabilitar módulos innecesarios
```bash
docker-compose exec web drush pml  # Listar módulos
docker-compose exec web drush pm:disable MODULE_NAME
```

## Checklist antes de producción

- [ ] Todas las configuraciones exportadas (config:export)
- [ ] Caché limpio (cache:rebuild)
- [ ] Bases de datos actualizadas (updatedb)
- [ ] Seguridad verificada (drush status-report)
- [ ] Tests ejecutados
- [ ] Documentación actualizada

## Contacto y soporte

Para reportar issues o sugerencias:
1. Crear issue en el repositorio
2. Describir problema/sugerencia detalladamente
3. Incluir pasos para reproducir (si aplica)

## Recursos

- [Drupal Docs](https://www.drupal.org/docs)
- [Drupal API](https://api.drupal.org/)
- [Drush Documentation](https://www.drush.org/)
- [Symfony Documentation](https://symfony.com/doc/current/index.html)
