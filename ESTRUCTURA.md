# Estructura Drupal para Portafolio

## Directorios principales

```
portafolio/
├── web/
│   ├── core/                          # Drupal core (generado por Composer)
│   ├── libraries/                     # Librerías JS/CSS de terceros
│   ├── modules/
│   │   ├── contrib/                   # Módulos descargados (generado)
│   │   └── custom/
│   │       ├── portfolio_projects/    # Módulo para proyectos
│   │       ├── portfolio_testimonials/# Módulo para testimonios
│   │       └── portfolio_skills/      # Módulo para habilidades
│   ├── themes/
│   │   ├── contrib/                   # Temas descargados (generado)
│   │   └── portfolio_theme/           # Tema personalizado
│   ├── profiles/                      # Perfiles de instalación
│   ├── sites/
│   │   ├── default/
│   │   │   ├── files/                 # Archivos subidos por usuarios
│   │   │   ├── settings.php           # Configuración del sitio
│   │   │   └── services.yml           # Servicios
│   ├── index.php
│   ├── web.config
│   └── .htaccess
├── config/
│   └── sync/                          # Sincronización de configuración
├── docker/
│   ├── nginx.conf                     # Configuración Nginx
│   ├── php.ini                        # Configuración PHP
│   └── entrypoint.sh                  # Script de inicio
├── composer.json
├── composer.lock
├── docker-compose.yml
├── Makefile
├── .env.example
├── .gitignore
└── README.md
```

## Módulos Personalizados para Portafolio

### portfolio_projects
Módulo para gestionar proyectos/trabajos realizados:
- Campo de imágenes
- Campo de descripción
- Campo de tecnologías usadas
- Campo de enlace al proyecto

### portfolio_testimonials
Módulo para testimonios de clientes:
- Nombre del cliente
- Empresa
- Testimonio
- Foto del cliente
- Calificación

### portfolio_skills
Módulo para habilidades:
- Nombre de habilidad
- Categoría
- Nivel de experiencia
- Años de experiencia

## Configuración recomendada

### Temas
- **Bartik**: Tema por defecto (requiere personalización)
- **Olivero**: Tema moderno basado en componentes
- **Crear tema personalizado**: Recomendado para portafolios profesionales

### Módulos esenciales
- Views: Para listas de proyectos
- Display Suite: Para control de layouts
- Pathauto: URLs amigables
- Metatag: SEO
- Image Styles: Estilos de imagen

### Campos personalizados por contenido

#### Tipo "Proyecto"
- title: Título del proyecto
- body: Descripción larga
- field_images: Imágenes (múltiple)
- field_technologies: Tecnologías (referencia)
- field_client: Cliente (opcional)
- field_project_link: Enlace del proyecto
- field_date_completed: Fecha de finalización

#### Tipo "Habilidad"
- title: Nombre de habilidad
- field_level: Nivel (expert, proficient, beginner)
- field_category: Categoría (backend, frontend, devops, etc.)

## Mejores prácticas

1. **Usar configuración sincronizada**: Guardar configuración en `config/sync/`
2. **Versionado con Git**: Incluir cambios de configuración
3. **Separar development de production**: Usar diferentes .env
4. **Realizar backups regularmente**: Especialmente de base de datos
5. **Documentar cambios**: Mantener changelog de cambios
6. **Testing**: Usar Drupal TestSuite para tests

## Desarrollo local

Ver README.md para instrucciones de instalación y desarrollo.
