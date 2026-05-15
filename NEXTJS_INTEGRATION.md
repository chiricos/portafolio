# Integración Next.js ↔ Drupal

## Endpoints JSON:API principales

### Homepage completa (una sola petición)

```
GET /jsonapi/node/homepage?
  filter[status]=1
  &include=field_secciones,
    field_secciones.field_slides,
    field_secciones.field_slides.field_imagen,
    field_secciones.field_imagen,
    field_secciones.field_cuerpo
  &fields[node--homepage]=sections,title,metatag
```

### Menús (header y footer)

```
GET /api/menu_items/main       → Menú principal (header)
GET /api/menu_items/footer     → Menú footer
```

Requiere `drupal/next` habilitado y configurado en `/admin/config/services/next`.

### Artículos (listado)

```
GET /jsonapi/node/articulo?
  filter[status]=1
  &sort=-createdAt
  &page[limit]=6
  &include=featuredImage
  &fields[node--articulo]=title,excerpt,featuredImage,createdAt,path
```

### Artículo individual

```
GET /jsonapi/node/articulo?
  filter[path.alias]=/blog/mi-articulo
  &include=featuredImage
```

O por UUID:
```
GET /jsonapi/node/articulo/{uuid}?include=featuredImage
```

### Proyectos destacados

```
GET /jsonapi/node/proyecto?
  filter[status]=1
  &filter[featured]=1
  &include=images
  &fields[node--proyecto]=title,body,images,technologies,projectUrl,path
```

### Configuración del sitio (header/footer)

```
GET /jsonapi/block_content/site_config?
  filter[status]=1
  &include=field_logo
  &page[limit]=1
```

---

## Estructura de datos en Next.js

### `lib/drupal.ts` — helpers recomendados

```typescript
import { DrupalClient } from 'next-drupal'

export const drupal = new DrupalClient(
  process.env.NEXT_PUBLIC_DRUPAL_BASE_URL!,
  {
    auth: {
      clientId: process.env.DRUPAL_CLIENT_ID!,
      clientSecret: process.env.DRUPAL_CLIENT_SECRET!,
    },
  }
)

// Includes para la homepage completa
export const HOMEPAGE_INCLUDES = [
  'sections',
  'sections.field_slides',
  'sections.field_slides.field_imagen',
].join(',')
```

### Tipos TypeScript

```typescript
// types/drupal.ts

export type DrupalParagraphType =
  | 'paragraph--hero_slider'
  | 'paragraph--seccion_noticias'
  | 'paragraph--seccion_proyectos'
  | 'paragraph--seccion_habilidades'
  | 'paragraph--seccion_experiencia'
  | 'paragraph--seccion_texto'

export interface SlideItem {
  field_titulo_seccion: string
  field_subtitulo?: string
  field_imagen?: DrupalFile
  field_cta_texto?: string
  field_cta_url?: { uri: string; title: string }
}

export interface HeroSlider {
  type: 'paragraph--hero_slider'
  field_slides: SlideItem[]
}

export interface SeccionNoticias {
  type: 'paragraph--seccion_noticias'
  field_titulo_seccion: string
  field_cantidad: number
}
```

### Componente dispatcher de secciones

```tsx
// components/SectionRenderer.tsx
import { DrupalParagraphType } from '@/types/drupal'

const SECTION_MAP: Record<string, React.ComponentType<any>> = {
  'paragraph--hero_slider':      HeroSlider,
  'paragraph--seccion_noticias': SeccionNoticias,
  'paragraph--seccion_proyectos':SeccionProyectos,
  'paragraph--seccion_habilidades': SeccionHabilidades,
  'paragraph--seccion_experiencia': SeccionExperiencia,
  'paragraph--seccion_texto':    SeccionTexto,
}

export function SectionRenderer({ section }: { section: { type: DrupalParagraphType } }) {
  const Component = SECTION_MAP[section.type]
  if (!Component) return null
  return <Component {...section} />
}
```

### `pages/index.tsx` — Homepage

```tsx
import { GetStaticProps } from 'next'
import { drupal, HOMEPAGE_INCLUDES } from '@/lib/drupal'
import { SectionRenderer } from '@/components/SectionRenderer'

export default function HomePage({ homepage, siteConfig }) {
  return (
    <>
      {homepage.sections.map((section) => (
        <SectionRenderer key={section.id} section={section} />
      ))}
    </>
  )
}

export const getStaticProps: GetStaticProps = async (context) => {
  const [homepageNodes, siteConfigBlocks] = await Promise.all([
    drupal.getResourceCollection('node--homepage', {
      params: {
        'filter[status]': 1,
        include: HOMEPAGE_INCLUDES,
        'page[limit]': 1,
      },
    }),
    drupal.getResourceCollection('block_content--site_config', {
      params: { 'filter[status]': 1, include: 'field_logo', 'page[limit]': 1 },
    }),
  ])

  return {
    props: {
      homepage: homepageNodes[0] ?? null,
      siteConfig: siteConfigBlocks[0] ?? null,
    },
    revalidate: 60,
  }
}
```

---

## Variables de entorno necesarias (`.env.local`)

```env
NEXT_PUBLIC_DRUPAL_BASE_URL=https://portafolio.ddev.site
DRUPAL_SITE_ID=nextjs
DRUPAL_FRONT_PAGE=/node
DRUPAL_PREVIEW_SECRET=un-secreto-aleatorio
DRUPAL_CLIENT_ID=<uuid-del-consumer-oauth>
DRUPAL_CLIENT_SECRET=<secreto-del-consumer>
```

---

## Pasos de configuración en Drupal admin

1. **OAuth keys**: `/admin/config/people/simple_oauth/oauth2_token/settings`
   - Generar par de claves pública/privada

2. **Consumer**: `/admin/config/services/consumer/add`
   - Label: `Next.js Frontend`
   - New Secret: copiar a `DRUPAL_CLIENT_SECRET`
   - Roles: `authenticated` (mínimo)

3. **Sitio Next.js**: `/admin/config/services/next/sites/add`
   - Site ID: `nextjs`
   - Base URL: URL del frontend Next.js
   - Preview URL: `[base_url]/api/preview`
   - Preview Secret: el mismo que `DRUPAL_PREVIEW_SECRET`

4. **Crear nodo Homepage**: `/node/add/homepage`
   - Agregar párrafos en el orden deseado

5. **Crear site_config**: `/block/add/site_config`
   - Completar logo, redes, contacto, copyright
