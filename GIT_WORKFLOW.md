# Git Workflow para Drupal Portafolio

## Configuración inicial

```bash
# Clonar el repositorio
git clone [url-repo] portafolio
cd portafolio

# Configurar usuario Git (si no está configurado)
git config user.name "Tu Nombre"
git config user.email "tu@email.com"
```

## Workflow de desarrollo

### 1. Crear rama para nueva feature

```bash
# Actualizar rama main
git checkout main
git pull origin main

# Crear rama de feature
git checkout -b feature/nombre-feature
# O para bugfix
git checkout -b bugfix/nombre-bug
```

### 2. Realizar cambios

```bash
# Hacer cambios en código, temas, módulos, etc.

# Exportar configuración de Drupal
docker-compose exec web drush config:export

# Ver cambios
git status
git diff

# Preparar commits
git add .

# Commit con mensaje descriptivo
git commit -m "feat: Descripción clara del cambio"
```

### Convenciones de commits

```
feat: nueva feature (ej: feat: Agregar campo de testimonios)
fix: corrección de bug (ej: fix: Corregir validación de email)
docs: cambios en documentación
style: cambios de formato (sin cambiar código)
refactor: refactorización de código
perf: mejora de performance
test: agregar tests
chore: tareas de mantenimiento (ej: chore: Actualizar composer.lock)
config: cambios de configuración de Drupal
```

### 3. Subir cambios

```bash
# Push a rama remota
git push origin feature/nombre-feature

# Crear Pull Request en GitHub/GitLab

# Después de aprobación, mergear
git checkout main
git pull origin main
git merge feature/nombre-feature
git push origin main

# Eliminar rama local
git branch -d feature/nombre-feature

# Eliminar rama remota
git push origin --delete feature/nombre-feature
```

## Manejo de conflictos

```bash
# Ver estado de merge
git status

# Resolver conflictos manualmente en tu editor
# Luego:
git add archivo-resuelto.php
git commit -m "resolve: Resolver conflicto en [archivo]"
```

## Revert de cambios

```bash
# Deshacer cambios locales no preparados
git checkout -- archivo.php

# Deshacer cambios preparados
git reset HEAD archivo.php

# Deshacer últimos commits locales
git reset --soft HEAD~1  # Mantiene cambios
git reset --hard HEAD~1  # Elimina cambios

# Crear commit que revierte otro commit
git revert [commit-hash]
```

## Stash de cambios

```bash
# Guardar cambios sin commitear
git stash

# Listar stash guardados
git stash list

# Recuperar último stash
git stash pop

# Recuperar stash específico
git stash apply stash@{0}

# Eliminar stash
git stash drop stash@{0}
```

## Historial y búsqueda

```bash
# Ver historial de commits
git log --oneline

# Ver commits de un archivo específico
git log -- archivo.php

# Ver cambios en un commit
git show [commit-hash]

# Buscar commit por mensaje
git log --grep="palabra"

# Ver rama que contiene un commit
git branch -r --contains [commit-hash]
```

## Tags para versiones

```bash
# Crear tag
git tag -a v1.0.0 -m "Versión 1.0.0 - Lanzamiento inicial"

# Listar tags
git tag

# Ver detalles de tag
git show v1.0.0

# Eliminar tag local
git tag -d v1.0.0

# Eliminar tag remoto
git push origin --delete v1.0.0

# Push de tags
git push origin --tags
```

## Mejores prácticas

### ✅ Hacer

- Commits pequeños y enfocados
- Mensajes de commit descriptivos
- Exportar configuración antes de commit (`drush config:export`)
- Incluir config/sync/ en commits
- Revisar cambios antes de push (`git diff`)
- Usar ramas para cada feature
- Hacer pull regularmente de main

### ❌ Evitar

- Commits enormes con múltiples cambios
- Mensajes genéricos ("fixed stuff")
- Hacer push directo a main
- Olvidar exportar configuración
- Commitear archivos sensibles (.env, credenciales)
- Mergear sin revisar cambios

## Sincronización de configuración en equipo

```bash
# Cuando recibes cambios de otro desarrollador:

# 1. Actualizar rama main
git pull origin main

# 2. Importar configuración sincronizada
docker-compose exec web drush config:import

# 3. Ejecutar actualizaciones de BD
docker-compose exec web drush updatedb

# 4. Limpiar caché
docker-compose exec web drush cache:rebuild
```

## Evitar problemas comunes

### Problema: Cambios de configuración en conflicto

```bash
# Solución 1: Re-exportar configuración
docker-compose exec web drush config:export

# Solución 2: Ver estado actual
docker-compose exec web drush config:status

# Solución 3: Importar cambios del otro desarrollador
git pull
docker-compose exec web drush config:import
```

### Problema: Cambios en config/sync no se aplican

```bash
# Verificar estado
docker-compose exec web drush config:status

# Forzar reimportación
docker-compose exec web drush config:import --force
```

### Problema: Cambios locales sobre-escritos

```bash
# Guardar cambios
git stash

# Actualizar desde remoto
git pull origin main

# Recuperar cambios guardados
git stash pop

# Resolver conflictos si los hay
```

## Integración continua (CI/CD)

### Ejemplo: GitHub Actions

`.github/workflows/drupal-ci.yml`:
```yaml
name: Drupal CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    services:
      mysql:
        image: mysql:8.0
        env:
          MYSQL_DATABASE: drupal
          MYSQL_ROOT_PASSWORD: root
        options: >-
          --health-cmd="mysqladmin ping"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=3
    
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.2'
          extensions: pdo_mysql, gd, curl
      
      - name: Install dependencies
        run: composer install
      
      - name: Lint PHP
        run: ./vendor/bin/phpcs web/modules/custom
```

## Más información

- [Git Documentation](https://git-scm.com/doc)
- [GitHub Flow Guide](https://guides.github.com/introduction/flow/)
- [Drupal Git Guide](https://www.drupal.org/docs/develop/git)
