.PHONY: help install start stop restart logs clean drush status

help:
	@echo "Portafolio Drupal + DDEV - Comandos disponibles"
	@echo "==============================================="
	@echo "make install      - Instalar dependencias (composer)"
	@echo "make start        - Iniciar el proyecto DDEV"
	@echo "make stop         - Detener el proyecto DDEV"
	@echo "make restart      - Reiniciar el proyecto DDEV"
	@echo "make status       - Ver estado del proyecto"
	@echo "make logs         - Ver logs en tiempo real"
	@echo "make drush        - Ejecutar comandos de Drush"
	@echo "make db-dump      - Hacer backup de la base de datos"
	@echo "make db-restore   - Restaurar base de datos desde backup"
	@echo "make clean        - Limpiar y resetear el proyecto"
	@echo "make url          - Ver URL del sitio"
	@echo ""

install: 
	@echo "🔧 Instalando dependencias..."
	ddev composer install
	@echo "✅ Dependencias instaladas"

start:
	@echo "🚀 Levantando proyecto DDEV..."
	ddev start
	@echo "✅ DDEV iniciado"
	@echo ""
	@echo "🌐 Acceso al sitio:"
	@ddev describe | grep -E "URL|Mail|MailHog"

stop:
	@echo "⏹️  Deteniendo DDEV..."
	ddev stop
	@echo "✅ DDEV detenido"

restart:
	@echo "🔄 Reiniciando DDEV..."
	ddev restart
	@echo "✅ DDEV reiniciado"

status:
	@echo "📊 Estado del proyecto:"
	ddev describe

logs:
	ddev logs -f

clean:
	@echo "🧹 Limpiando el proyecto..."
	ddev delete -O
	rm -rf web/core web/libraries web/modules/contrib web/profiles/contrib web/themes/contrib
	@echo "✅ Limpieza completada. Ejecuta 'make start' para reiniciar"

drush:
	ddev drush $(filter-out $@,$(MAKECMDGOALS))

db-dump:
	@echo "💾 Haciendo backup de BD..."
	@mkdir -p db_snapshots
	ddev snapshot
	@echo "✅ Backup realizado"

db-restore:
	@echo "📂 Restaurando BD..."
	ddev snapshot restore
	@echo "✅ BD restaurada"

url:
	@ddev describe | grep "URL"

# Make targets que aceptan argumentos
%:
	@:
