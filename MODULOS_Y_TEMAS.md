# Módulos y Temas Recomendados para Portafolio

## Módulos imprescindibles

### Estructura de contenido
- **Views** - Crear vistas personalizadas de contenido
  ```bash
  composer require drupal/views
  drush en views
  ```
  
- **Pathauto** - URLs amigables automáticas
  ```bash
  composer require drupal/pathauto drupal/token
  drush en pathauto token
  ```

### SEO y Meta
- **Metatag** - Gestión de meta tags para SEO
  ```bash
  composer require drupal/metatag
  drush en metatag
  ```

- **Sitemap** - Generar sitemap.xml
  ```bash
  composer require drupal/xmlsitemap
  drush en xmlsitemap
  ```

### Admin y UX
- **Admin Toolbar** - Barra de admin mejorada
  ```bash
  composer require drupal/admin_toolbar
  drush en admin_toolbar admin_toolbar_tools
  ```

- **Chaos Tool Suite** - Herramientas para desarrolladores
  ```bash
  composer require drupal/ctools
  drush en ctools
  ```

### Multimedia
- **Media** - Gestión mejorada de media
  ```bash
  composer require drupal/media
  drush en media
  ```

- **Image** - Estilos de imagen (core)
  ```bash
  drush en image responsive_image
  ```

## Módulos opcionales recomendados

### Contacto
- **Contact Storage** - Guardar envíos de formulario
  ```bash
  composer require drupal/contact_storage
  drush en contact_storage
  ```

### Performance
- **Purge** - Gestionar caché
  ```bash
  composer require drupal/purge
  drush en purge
  ```

- **Big Pipe** - Mejora de rendimiento (core)
  ```bash
  drush en big_pipe
  ```

### Seguridad
- **CAPTCHA/reCAPTCHA** - Protección anti-spam
  ```bash
  composer require drupal/captcha drupal/recaptcha
  drush en captcha recaptcha
  ```

### Email
- **Maillog** - Log de emails enviados
  ```bash
  composer require drupal/maillog
  drush en maillog
  ```

## Temas recomendados

### Para comenzar rápido
- **Olivero** (Drupal core) - Moderno, responsivo, basado en componentes
- **Bootstrap 5** - Basado en Bootstrap 5
  ```bash
  composer require drupal/bootstrap5
  ```

### Temas profesionales
- **Bootstrap Theme** - Versátil y bien documentado
- **Radix** - UI Kit moderno para Drupal
  ```bash
  composer require drupal/radix
  ```

## Crear tema personalizado

### Estructura mínima
```
web/themes/portfolio_theme/
├── portfolio_theme.info.yml
├── portfolio_theme.libraries.yml
├── portfolio_theme.theme
├── css/
│   └── style.css
├── js/
│   └── script.js
└── templates/
    ├── layout/
    │   ├── html.html.twig
    │   └── page.html.twig
    ├── components/
    │   ├── header.html.twig
    │   ├── footer.html.twig
    │   └── projects.html.twig
    └── node/
        └── node--project.html.twig
```

### portfolio_theme.info.yml
```yaml
name: Portfolio Theme
description: Tema personalizado para portafolio profesional
type: theme
base: olivero
core_version_requirement: ^10
version: 1.0.0

libraries:
  - portfolio_theme/global-styling
  - portfolio_theme/global-scripts
```

### portfolio_theme.libraries.yml
```yaml
global-styling:
  version: 1.0
  css:
    theme:
      css/style.css: {}
      css/responsive.css: {}

global-scripts:
  version: 1.0
  js:
    js/script.js: {}
  dependencies:
    - core/drupal
    - core/jquery
```

## Módulos personalizados recomendados

### Portfolio Projects
Crear en `web/modules/custom/portfolio_projects/`

**Estructura**:
- Tipo de contenido: "Proyecto"
- Campos: imágenes, tecnologías, link, cliente, etc.
- Vista para listar proyectos
- Bloque resumen de proyectos

### Portfolio Settings
Crear en `web/modules/custom/portfolio_settings/`

- Configuración global del portafolio
- Redes sociales
- Información de contacto
- Datos personales

## Instalación rápida de módulos recomendados

```bash
# Instalar todos los módulos recomendados
composer require \
  drupal/views \
  drupal/pathauto \
  drupal/token \
  drupal/metatag \
  drupal/xmlsitemap \
  drupal/admin_toolbar \
  drupal/ctools \
  drupal/contact_storage

# Habilitar todos
drush en views pathauto token metatag xmlsitemap admin_toolbar admin_toolbar_tools ctools contact_storage
```

## Actualizaciones y mantenimiento

```bash
# Ver módulos que tienen actualizaciones
drush pm:updates

# Actualizar módulo específico
composer update drupal/views

# Actualizar todos
composer update

# Ejecutar actualizaciones de BD
drush updatedb

# Limpiar caché
drush cache:rebuild
```

## Comparativa: Drupal vs Alternativas

| Característica | Drupal | WordPress | Joomla |
|---|---|---|---|
| Flexibilidad | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| Curva aprendizaje | Empinada | Suave | Media |
| SEO | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| Seguridad | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| Performance | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| Comunidad | Grande | Muy grande | Media |
| Para portafolios | Excelente | Bueno | Aceptable |

## Recursos útiles

- [drupal.org - Proyectos](https://www.drupal.org/project/modules)
- [Thunder CMS](https://www.drupal.org/project/thunder) - Distro de Drupal
- [Umami Demo](https://www.drupal.org/docs/10/umami-demo) - Site demo
