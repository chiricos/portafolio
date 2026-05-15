# Copilot Instructions — Portafolio

## Architecture

This is a **headless Drupal 11 + Next.js** project:

- **Drupal** (`/web`) — API backend. Exposes content via JSON:API. No frontend rendering.
- **Next.js** — separate frontend repo (not in this directory). Consumes Drupal's JSON:API using the `next-drupal` npm package.
- **DDEV** — local development environment (`type: drupal11`, `php_version: 8.3`, MySQL 8.0).
- `template/` — standalone static HTML/CSS/JS prototype. Not wired into Drupal.

Decoupled stack modules in `composer.json`:
- `drupal/next` — preview and on-demand revalidation bridge
- `drupal/simple_oauth` — OAuth2 authentication for Next.js
- `drupal/decoupled_router` — resolves Drupal paths/aliases for Next.js
- `drupal/subrequests` — batches JSON:API calls
- `drupal/jsonapi_extras` — fine-grained JSON:API endpoint control
- `drupal/metatag` — exposes SEO meta tags via API

## Runtime Commands

**Always use `make`/`ddev`, never `docker-compose`** (the `docker-compose.yml` is legacy).

```bash
make install          # ddev composer install
make start            # ddev start
make stop             # ddev stop
make restart          # ddev restart
make status           # ddev describe
make logs             # ddev logs -f
make url              # print site URL
make drush <cmd>      # ddev drush <cmd>
make db-dump          # ddev snapshot
make db-restore       # ddev snapshot restore
```

Common Drush commands:
```bash
make drush cache:rebuild
make drush updatedb
make drush config:export
make drush config:import
make drush en <module> -y
```

Lint / static analysis (no project-level config — use Drupal core's):
```bash
ddev exec ./vendor/bin/phpcs --standard=web/core/phpcs.xml.dist <path>
ddev exec ./vendor/bin/phpunit --configuration web/core/phpunit.xml.dist <path>
```

## Code Ownership

Do **not** hand-edit:
- `vendor/`, `web/core/`, `web/modules/contrib/`, `web/themes/contrib/`, `web/libraries/`

Custom code lives in:
- `web/modules/custom/` — currently empty; new modules go here
- `web/themes/` — no custom theme yet

When adding a custom module, name it with the `portfolio_` prefix (e.g. `portfolio_projects`). Set `core_version_requirement: ^11` in `.info.yml`.

## Config Sync Gotcha

`web/sites/default/settings.php` does **not** set `$settings['config_sync_directory']`. DDEV's `settings.ddev.php` sets it to `sites/default/files/sync` (which is gitignored).

`config/sync/` contains 190 committed YAML files — to use them as the active directory, explicitly add this to `settings.php`:

```php
$settings['config_sync_directory'] = '../config/sync';
```

Before any `config:export` or `config:import` work, verify the active sync dir:
```bash
make drush status | grep "Config"
```

## Next.js Integration Setup (post-install)

After enabling modules, configure in Drupal admin:
1. Generate OAuth keys → `/admin/config/people/simple_oauth/oauth2_token/settings`
2. Create a Consumer for Next.js → `/admin/config/services/consumer`
3. Configure the Next.js site → `/admin/config/services/next`

Environment variables expected by the Next.js frontend:
```
NEXT_PUBLIC_DRUPAL_BASE_URL=https://portafolio.ddev.site
DRUPAL_CLIENT_ID=<consumer-uuid>
DRUPAL_CLIENT_SECRET=<secret>
DRUPAL_PREVIEW_SECRET=<random>
```

## Commit Conventions

```
feat:     new feature
fix:      bug fix
config:   Drupal configuration changes
refactor: code restructure
docs:     documentation only
chore:    maintenance (e.g. composer.lock updates)
perf:     performance improvement
```

## Docs Reliability

These files are **historical scaffolding** and may reference `docker-compose` or modules not yet installed — do not treat as source of truth:
`DESARROLLO.md`, `GIT_WORKFLOW.md`, `PRODUCCION.md`, `ESTRUCTURA.md`, `MODULOS_Y_TEMAS.md`

Prefer `.ddev/config.yaml`, `Makefile`, `composer.json`, and `web/sites/default/settings.php` over prose docs when they disagree.
