# AGENTS.md

## Runtime
- Use `make`/`ddev` commands, not `docker-compose`. `docker-compose.yml` exists, but the live local workflow is DDEV (`.ddev/config.yaml`, `Makefile`).
- Start from the repo root. DDEV is configured as `type: drupal10` with `docroot: web` and a `post-start` hook that runs `drush cache:rebuild`.
- Preferred commands:
  - `make install` -> `ddev composer install`
  - `make start` -> `ddev start`
  - `make drush <command>` for Drupal CLI work
  - `make status`, `make logs`, `make url` for environment checks

## Code Ownership
- Treat these as Composer-managed/generated and do not hand-edit them unless the task is explicitly about upstream/vendor code: `vendor/`, `web/core/`, `web/modules/contrib/`, `web/profiles/contrib/`, `web/themes/contrib/`, `web/libraries/`.
- Custom application code is not scaffolded yet. `web/modules/custom/` exists but is empty, and there is no checked-in custom theme under `web/themes/`.
- `template/` is a standalone static HTML/CSS/JS prototype, not wired into Drupal by the current repo.

## Config Gotcha
- Do not assume tracked `config/sync/` is the active Drupal config export directory. It exists in the repo, but current executable settings do not point to it.
- `web/sites/default/settings.ddev.php` sets `$settings['config_sync_directory'] = 'sites/default/files/sync'` when nothing else overrides it, and `web/sites/default/settings.php` does not override that.
- Because `web/sites/*/files/` is gitignored, a normal `ddev drush config:export` currently writes to an ignored location unless settings are changed first.
- Before doing config import/export work, verify the active sync dir and avoid claiming that `config/sync/` is authoritative without updating settings.

## Verification
- If you changed PHP/Drupal code, run the narrowest relevant command inside DDEV first:
  - `make drush status`
  - `make drush cache:rebuild`
  - `ddev exec ./vendor/bin/phpcs <path>`
  - `ddev exec ./vendor/bin/phpunit <args>`
- There is no root PHPCS/PHPUnit/PHPStan config in this repo. The available configs under `web/core/` are Drupal core's own, so avoid assuming project-wide lint/test commands beyond targeted tool runs.

## Docs
- Treat several prose docs as historical scaffolding, not source of truth. `DESARROLLO.md`, `GIT_WORKFLOW.md`, and `PRODUCCION.md` still contain `docker-compose` examples and describe modules/themes that are not present.
- Prefer `.ddev/config.yaml`, `Makefile`, `composer.json`, `settings.php`, and the actual tree over the markdown guides when they disagree.
