#!/bin/sh

set -e

# === Версия утилиты ===
VERSION="2.0.0"
VERSION_DATE="05-OCT-2026"
BASE_URL="https://github.com/cbfst/pr-passwall/raw/main/package"
API_URL="https://api.github.com/repos/cbfst/pr-passwall/contents/package"
SCRIPT_URL="https://github.com/cbfst/pr-passwall/raw/main/autopasswall.sh"
IRON_URL="https://codeberg.org/cbfst/pr-ironupdate/raw/branch/main/ironupdate.sh"
CONF_LANG="/etc/passwall_mgr.lang"

RED_BG='\033[41;37;1m'
GREEN='\033[32m'
BLUE='\033[34m'
YELLOW='\033[33m'
RESET='\033[0m'

APP_LANG=""
[ -f "$CONF_LANG" ] && APP_LANG=$(tr -d '\r\n ' < "$CONF_LANG" 2>/dev/null)
APP_LANG=${APP_LANG:-en}

load_lang_strings() {
    case "$APP_LANG" in
        ru)
            T_TITLE="PassWall Tunnel v1 | Авто-Установщик"
            T_SUBTITLE="Для роутеров OpenWrt v22+ / GL.iNet"
            T_CHECK_ROOT="ОШИБКА: Запустите скрипт от пользователя root!"
            T_CHECK_SPACE="Проверка свободного места на /overlay..."
            T_SPACE_OK="Свободно на /overlay: %s КБ"
            T_SPACE_LOW="Критически мало места на /overlay (%s КБ). Требуется минимум 15 МБ."
            T_NET_CHECK="Проверка подключения к сети..."
            T_NET_OK="Сеть доступна"
            T_NET_FAIL="Ошибка: Нет доступа к интернету. Проверьте WAN и DNS."
            T_GL_DETECT="Обнаружен роутер GL.iNet — проверка IronUpdate..."
            T_GL_INSTALLED="IronUpdate установлен (%s)"
            T_GL_ACTIVE="IronUpdate активен (язык: %s)"
            T_GL_SKIP="Стандартный OpenWrt — IronUpdate не требуется."
            T_REPO_CHECK="Проверка доступности репозитория и пакетов перед установкой..."
            T_REPO_FAIL="Критическая ошибка: файл компонента '%s' недоступен для загрузки!"
            T_REPO_HINT="Проверьте подключение роутера к интернету (кабель WAN, SIM-карту, Wi-Fi), DNS или доступность серверов Codeberg."
            T_REPO_OK="Все необходимые компоненты проверены и доступны для загрузки"
            T_AUDIT_COMP="Установка проверенных компонентов..."
            T_UPDATING="Обновление списков пакетов репозиториев..."
            T_DEPS_INSTALL="Проверка базовых зависимостей..."
            T_DEPS_OK="Зависимости проверены"
            T_DOWNLOADING="Загрузка %s..."
            T_DOWNLOAD_FAIL="Не удалось скачать %s после 3 попыток"
            T_INSTALLING="Установка %s..."
            T_INSTALL_OK="%s успешно установлен"
            T_INSTALL_SKIP="%s уже установлен и актуален (v%s), пропуск"
            T_INSTALL_FORCE="Конфликт зависимостей для %s, установка с force-флагами..."
            T_INSTALL_FAIL="Критическая ошибка: не удалось установить %s"
            T_CONFIGURING="Применение конфигурации PassWall (Global Proxy, Iptables)..."
            T_CONF_OK="Конфигурация применена"
            T_CLEANUP="Очистка временных файлов инсталлятора..."
            T_MANAGER_INST="Установка команды управления 'passwall'..."
            T_MANAGER_OK="Команда 'passwall' зарегистрирована"
            T_SUCCESS="Установка и настройка PassWall Tunnel успешно завершена!"
            T_REBOOTING="Перезагрузка роутера через 10 секунд (Ctrl+C для отмены)..."
            T_ALL_OK="Все компоненты PassWall актуальны и работают."
            T_CONFLICT_FIX="Удаление старого пакета xray-core для исключения конфликтов..."
            TXT_SVC_STARTED="Служба PassWall запущена."
            TXT_SVC_STOPPED="Служба PassWall остановлена."
            TXT_SVC_RESTARTED="Служба PassWall перезапущена."
            TXT_SVC_RELOADED="Конфигурация перезагружена."
            TXT_SVC_ENABLED="Автозапуск при старте системы включен."
            TXT_SVC_DISABLED="Автозапуск при старте системы выключен."
            TXT_LOG_EMPTY="Лог-файл пуст или отсутствует."
            TXT_CHECK_START="Проверка обновлений в репозитории..."
            TXT_MGR_UPDATING="Обновление менеджера PassWall (%s -> %s)..."
            TXT_CHECK_PKG="Проверка %s: установлена v%s, в репозитории v%s"
            TXT_PKG_UPTODATE="%s актуален (v%s), пропуск"
            TXT_PKG_UPDATED="Обновлено: %s (v%s -> v%s)"
            TXT_PKG_FAILED="Ошибка установки: %s"
            TXT_UP_TO_DATE="Все компоненты имеют актуальные версии."
            TXT_STOPPING="Остановка PassWall..."
            TXT_REMOVING_UI="Удаление интерфейса PassWall..."
            TXT_PURGING_ALL="Полная очистка PassWall, ядер и конфигураций..."
            TXT_PURGE_DONE="PassWall и зависимые пакеты полностью удалены."
            TXT_REMOVE_DONE="Интерфейс PassWall удален."
            TXT_LANG_SET="Язык переключен на: %s"
            TXT_HELP_TITLE="Управление службой:"
            TXT_HELP_DIAG="Диагностика и логи:"
            TXT_HELP_CONF="Конфигурация (UCI):"
            TXT_HELP_MAINT="Обновление и обслуживание:"
            TXT_H_START="Запустить службу проксирования"
            TXT_H_STOP="Остановить службу проксирования"
            TXT_H_RESTART="Перезапустить службу и правила маршрутизации"
            TXT_H_RELOAD="Перезагрузить настройки без перезапуска демона"
            TXT_H_ENABLE="Включить автозапуск при загрузке роутера"
            TXT_H_DISABLE="Выключить автозапуск при загрузке роутера"
            TXT_H_LOG="Показать основной лог службы PassWall"
            TXT_H_CORE="Показать лог бэкенд-ядра (Xray / Sing-box)"
            TXT_H_LOGREAD="Фильтр системного журнала по событиям PassWall"
            TXT_H_CONFIG="Вывести полную конфигурацию UCI passwall"
            TXT_H_STATUS="Статус главного переключателя (enabled / disabled)"
            TXT_H_RAW="Вывести содержимое /etc/config/passwall напрямую"
            TXT_H_UPDATE="Обновить PassWall, ядра и сам менеджер"
            TXT_H_LANG="Сменить язык менеджера (ru, en, es, de)"
            TXT_H_REMOVE="Удалить только интерфейс PassWall"
            TXT_H_PURGE="Полностью удалить PassWall, ядра и конфигурации"
            TXT_H_MGR="Показать это меню управления"
            TXT_MGR_UPDATED="Менеджер PassWall обновлен до актуальной версии (%s)."
            ;;
        es)
            T_TITLE="PassWall Tunnel v1 | Auto-Instalador"
            T_SUBTITLE="Para routers OpenWrt v22+ / GL.iNet"
            T_CHECK_ROOT="¡ERROR: Ejecute este script como root!"
            T_CHECK_SPACE="Comprobando espacio libre en /overlay..."
            T_SPACE_OK="Espacio libre en /overlay: %s KB"
            T_SPACE_LOW="Espacio insuficiente en /overlay (%s KB). Se requieren al menos 15MB."
            T_NET_CHECK="Comprobando conexión a Internet..."
            T_NET_OK="Red disponible"
            T_NET_FAIL="Error: Sin conexión a Internet."
            T_GL_DETECT="Router GL.iNet detectado — comprobando IronUpdate..."
            T_GL_INSTALLED="IronUpdate instalado (%s)"
            T_GL_ACTIVE="IronUpdate activo (idioma: %s)"
            T_GL_SKIP="OpenWrt estándar — omitiendo IronUpdate."
            T_REPO_CHECK="Comprobando disponibilidad del repositorio y paquetes..."
            T_REPO_FAIL="Error crítico: ¡El archivo del componente '%s' no está disponible para descargar!"
            T_REPO_HINT="Compruebe la conexión a Internet del router (cable WAN, tarjeta SIM, Wi-Fi), DNS o el repositorio de Codeberg."
            T_REPO_OK="Todos los componentes necesarios están disponibles para descargar"
            T_AUDIT_COMP="Instalando componentes verificados..."
            T_UPDATING="Actualizando listas de paquetes..."
            T_DEPS_INSTALL="Comprobando dependencias del sistema..."
            T_DEPS_OK="Dependencias verificadas"
            T_DOWNLOADING="Descargando %s..."
            T_DOWNLOAD_FAIL="Fallo al descargar %s"
            T_INSTALLING="Instalando %s..."
            T_INSTALL_OK="%s instalado correctamente"
            T_INSTALL_SKIP="%s ya está instalado (v%s), omitiendo"
            T_INSTALL_FORCE="Conflicto de dependencias en %s, forzando instalación..."
            T_INSTALL_FAIL="Error crítico: No se pudo instalar %s"
            T_CONFIGURING="Aplicando configuración de PassWall (Global, Iptables)..."
            T_CONF_OK="Configuración aplicada"
            T_CLEANUP="Limpiando archivos temporales..."
            T_MANAGER_INST="Instalando gestor de comandos 'passwall'..."
            T_MANAGER_OK="Comando 'passwall' registrado"
            T_SUCCESS="¡Instalación y configuración de PassWall completada!"
            T_REBOOTING="Reiniciando el router en 10 segundos..."
            T_ALL_OK="Todos los componentes están actualizados."
            T_CONFLICT_FIX="Eliminando paquete obsoleto xray-core para evitar conflictos..."
            TXT_SVC_STARTED="Servicio PassWall iniciado."
            TXT_SVC_STOPPED="Servicio PassWall detenido."
            TXT_SVC_RESTARTED="Servicio PassWall reiniciado."
            TXT_SVC_RELOADED="Configuración recargada."
            TXT_SVC_ENABLED="Inicio automático activado."
            TXT_SVC_DISABLED="Inicio automático desactivado."
            TXT_LOG_EMPTY="El archivo de registro está vacío o no existe."
            TXT_CHECK_START="Comprobando actualizaciones en el repositorio..."
            TXT_MGR_UPDATING="Actualizando gestor PassWall (%s -> %s)..."
            TXT_CHECK_PKG="Comprobando %s: instalado v%s, disponible v%s"
            TXT_PKG_UPTODATE="%s está actualizado (v%s), omitiendo"
            TXT_PKG_UPDATED="Actualizado: %s (v%s -> v%s)"
            TXT_PKG_FAILED="Error al instalar: %s"
            TXT_UP_TO_DATE="Todos los componentes están actualizados."
            TXT_STOPPING="Deteniendo PassWall..."
            TXT_REMOVING_UI="Eliminando interfaz de PassWall..."
            TXT_PURGING_ALL="Eliminación completa de PassWall, núcleos y configuraciones..."
            TXT_PURGE_DONE="PassWall y paquetes dependientes eliminados por completo."
            TXT_REMOVE_DONE="Interfaz de PassWall eliminada."
            TXT_LANG_SET="Idioma cambiado a: %s"
            TXT_HELP_TITLE="Control del servicio:"
            TXT_HELP_DIAG="Diagnóstico y registros:"
            TXT_HELP_CONF="Configuración (UCI):"
            TXT_HELP_MAINT="Mantenimiento y actualización:"
            TXT_H_START="Iniciar servicio proxy de PassWall"
            TXT_H_STOP="Detener servicio proxy de PassWall"
            TXT_H_RESTART="Reiniciar servicio y reglas de enrutamiento"
            TXT_H_RELOAD="Recargar configuración sin reiniciar el demonio"
            TXT_H_ENABLE="Activar inicio automático al encender el router"
            TXT_H_DISABLE="Desactivar inicio automático"
            TXT_H_LOG="Mostrar registro principal del servicio PassWall"
            TXT_H_CORE="Mostrar registro del núcleo backend (Xray / Sing-box)"
            TXT_H_LOGREAD="Filtrar registro del sistema por eventos de PassWall"
            TXT_H_CONFIG="Mostrar configuración completa UCI de passwall"
            TXT_H_STATUS="Estado del interruptor principal (habilitado / deshabilitado)"
            TXT_H_RAW="Mostrar contenido directo de /etc/config/passwall"
            TXT_H_UPDATE="Actualizar PassWall, núcleos y gestor"
            TXT_H_LANG="Cambiar idioma del gestor (ru, en, es, de)"
            TXT_H_REMOVE="Eliminar solo la interfaz PassWall"
            TXT_H_PURGE="Purgar completamente PassWall, núcleos y configuraciones"
            TXT_H_MGR="Mostrar este menú de gestión"
            TXT_MGR_UPDATED="Gestor PassWall actualizado a la versión %s."
            ;;
        de)
            T_TITLE="PassWall Tunnel v1 | Auto-Installer"
            T_SUBTITLE="Für OpenWrt v22+ / GL.iNet Router"
            T_CHECK_ROOT="FEHLER: Führen Sie das Skript als root aus!"
            T_CHECK_SPACE="Prüfe freien Speicherplatz auf /overlay..."
            T_SPACE_OK="Freier Speicher auf /overlay: %s KB"
            T_SPACE_LOW="Kritisch: Zu wenig Speicherplatz auf /overlay (%s KB)."
            T_NET_CHECK="Prüfe Internetverbindung..."
            T_NET_OK="Netzwerk verfügbar"
            T_NET_FAIL="Fehler: Keine Internetverbindung vorhanden."
            T_GL_DETECT="GL.iNet-Router erkannt — prüfe IronUpdate..."
            T_GL_INSTALLED="IronUpdate installiert (%s)"
            T_GL_ACTIVE="IronUpdate aktiv (Sprache: %s)"
            T_GL_SKIP="Standard OpenWrt — IronUpdate wird übersprungen."
            T_REPO_CHECK="Prüfe Erreichbarkeit von Repository und Paketen..."
            T_REPO_FAIL="Kritischer Fehler: Komponentendatei '%s' ist nicht zum Download verfügbar!"
            T_REPO_HINT="Prüfen Sie die Internetverbindung des Routers (WAN-Kabel, SIM-Karte, WLAN), DNS oder Codeberg-Erreichbarkeit."
            T_REPO_OK="Alle benötigten Komponenten sind zum Download verfügbar"
            T_AUDIT_COMP="Installiere geprüfte Komponenten..."
            T_UPDATING="Aktualisiere Paketlisten..."
            T_DEPS_INSTALL="Prüfe Systemabhängigkeiten..."
            T_DEPS_OK="Abhängigkeiten geprüft"
            T_DOWNLOADING="Lade %s herunter..."
            T_DOWNLOAD_FAIL="Download von %s fehlgeschlagen"
            T_INSTALLING="Installiere %s..."
            T_INSTALL_OK="%s erfolgreich installiert"
            T_INSTALL_SKIP="%s ist bereits installiert (v%s), übersprungen"
            T_INSTALL_FORCE="Abhängigkeitskonflikt bei %s, erzwinge Installation..."
            T_INSTALL_FAIL="Kritischer Fehler: Installation von %s fehlgeschlagen"
            T_CONFIGURING="Wende PassWall-Konfiguration an (Global, Iptables)..."
            T_CONF_OK="Konfiguration angewendet"
            T_CLEANUP="Bereinige temporäre Installationsdateien..."
            T_MANAGER_INST="Installiere 'passwall' Befehls-Manager..."
            T_MANAGER_OK="Befehl 'passwall' registriert"
            T_SUCCESS="PassWall Tunnel Setup erfolgreich abgeschlossen!"
            T_REBOOTING="Router-Neustart in 10 Sekunden..."
            T_ALL_OK="Alle Komponenten sind aktuell."
            T_CONFLICT_FIX="Entferne altes xray-core Paket zur Konfliktvermeidung..."
            TXT_SVC_STARTED="PassWall-Dienst gestartet."
            TXT_SVC_STOPPED="PassWall-Dienst gestoppt."
            TXT_SVC_RESTARTED="PassWall-Dienst neu gestartet."
            TXT_SVC_RELOADED="Konfiguration neu geladen."
            TXT_SVC_ENABLED="Autostart beim Booten aktiviert."
            TXT_SVC_DISABLED="Autostart beim Booten deaktiviert."
            TXT_LOG_EMPTY="Protokolldatei ist leer oder nicht vorhanden."
            TXT_CHECK_START="Prüfe Updates im Repository..."
            TXT_MGR_UPDATING="Aktualisiere PassWall-Manager (%s -> %s)..."
            TXT_CHECK_PKG="Prüfe %s: installiert v%s, im Repository v%s"
            TXT_PKG_UPTODATE="%s ist aktuell (v%s), übersprungen"
            TXT_PKG_UPDATED="Aktualisiert: %s (v%s -> v%s)"
            TXT_PKG_FAILED="Fehler beim Installieren von %s"
            TXT_UP_TO_DATE="Alle Komponenten sind auf dem neuesten Stand."
            TXT_STOPPING="PassWall wird gestoppt..."
            TXT_REMOVING_UI="PassWall-Oberfläche wird entfernt..."
            TXT_PURGING_ALL="Vollständige Entfernung von PassWall, Cores und Konfigurationen..."
            TXT_PURGE_DONE="PassWall und zugehörige Pakete vollständig entfernt."
            TXT_REMOVE_DONE="PassWall-Oberfläche entfernt."
            TXT_LANG_SET="Sprache geändert auf: %s"
            TXT_HELP_TITLE="Dienststeuerung:"
            TXT_HELP_DIAG="Diagnose & Protokolle:"
            TXT_HELP_CONF="Konfiguration (UCI):"
            TXT_HELP_MAINT="Wartung & Aktualisierung:"
            TXT_H_START="PassWall-Proxy-Dienst starten"
            TXT_H_STOP="PassWall-Proxy-Dienst stoppen"
            TXT_H_RESTART="Dienst und Routing-Regeln neu starten"
            TXT_H_RELOAD="Konfiguration neu laden ohne Daemon-Neustart"
            TXT_H_ENABLE="Autostart beim Systemstart aktivieren"
            TXT_H_DISABLE="Autostart beim Systemstart deaktivieren"
            TXT_H_LOG="Hauptprotokoll von PassWall anzeigen"
            TXT_H_CORE="Protokoll des Backend-Cores (Xray / Sing-box) anzeigen"
            TXT_H_LOGREAD="Systemprotokoll nach PassWall-Ereignissen filtern"
            TXT_H_CONFIG="Vollständige UCI-PassWall-Konfiguration ausgeben"
            TXT_H_STATUS="Status des Hauptschalters anzeigen (aktiv / inaktiv)"
            TXT_H_RAW="Inhalt von /etc/config/passwall direkt anzeigen"
            TXT_H_UPDATE="PassWall, Cores und den Manager aktualisieren"
            TXT_H_LANG="Sprache des Managers ändern (ru, en, es, de)"
            TXT_H_REMOVE="Nur PassWall-Oberfläche entfernen"
            TXT_H_PURGE="PassWall, Cores und Konfigurationen vollständig löschen"
            TXT_H_MGR="Dieses Menü anzeigen"
            TXT_MGR_UPDATED="PassWall-Manager wurde auf Version %s aktualisiert."
            ;;
        *)
            T_TITLE="PassWall Tunnel v1 | Auto-Installer"
            T_SUBTITLE="For OpenWrt v22+ / GL.iNet Routers"
            T_CHECK_ROOT="ERROR: Run this script as root!"
            T_CHECK_SPACE="Checking free space on /overlay..."
            T_SPACE_OK="Free overlay space: %s KB"
            T_SPACE_LOW="Critical: low space on /overlay (%s KB). At least 15MB required."
            T_NET_CHECK="Checking Internet connectivity..."
            T_NET_OK="Network is online"
            T_NET_FAIL="Error: No internet connection. Check WAN/DNS."
            T_GL_DETECT="GL.iNet router detected — verifying IronUpdate..."
            T_GL_INSTALLED="IronUpdate installed (%s)"
            T_GL_ACTIVE="IronUpdate is active (language: %s)"
            T_GL_SKIP="Standard OpenWrt environment — skipping IronUpdate."
            T_REPO_CHECK="Checking repository and package availability before setup..."
            T_REPO_FAIL="Critical error: component file '%s' is not available for download!"
            T_REPO_HINT="Check router Internet connection (WAN cable, SIM card, Wi-Fi), DNS, or Codeberg repository availability."
            T_REPO_OK="All required components are verified and available for download"
            T_AUDIT_COMP="Installing verified components..."
            T_UPDATING="Updating package lists..."
            T_DEPS_INSTALL="Verifying core dependencies..."
            T_DEPS_OK="Dependencies verified"
            T_DOWNLOADING="Downloading %s..."
            T_DOWNLOAD_FAIL="Failed to download %s after 3 attempts"
            T_INSTALLING="Installing %s..."
            T_INSTALL_OK="%s installed successfully"
            T_INSTALL_SKIP="%s is already installed (v%s), skipping"
            T_INSTALL_FORCE="Dependency conflict on %s, applying force flags..."
            T_INSTALL_FAIL="Critical error: Failed to install %s"
            T_CONFIGURING="Applying PassWall baseline configuration (Global mode, Iptables)..."
            T_CONF_OK="Configuration applied"
            T_CLEANUP="Cleaning temporary installation files..."
            T_MANAGER_INST="Installing 'passwall' command manager..."
            T_MANAGER_OK="Registered 'passwall' command"
            T_SUCCESS="PassWall Tunnel setup completed successfully!"
            T_REBOOTING="Rebooting router in 10 seconds (Ctrl+C to abort)..."
            T_ALL_OK="All PassWall components are up to date."
            T_CONFLICT_FIX="Removing old legacy xray-core package to prevent conflicts..."
            TXT_SVC_STARTED="PassWall service started."
            TXT_SVC_STOPPED="PassWall service stopped."
            TXT_SVC_RESTARTED="PassWall service restarted."
            TXT_SVC_RELOADED="Configuration reloaded."
            TXT_SVC_ENABLED="Boot autostart enabled."
            TXT_SVC_DISABLED="Boot autostart disabled."
            TXT_LOG_EMPTY="Log file is empty or missing."
            TXT_CHECK_START="Checking remote repository for updates..."
            TXT_MGR_UPDATING="Updating PassWall Manager (%s -> %s)..."
            TXT_CHECK_PKG="Checking %s: installed v%s, available v%s"
            TXT_PKG_UPTODATE="%s is up to date (v%s), skipping"
            TXT_PKG_UPDATED="Updated: %s (v%s -> v%s)"
            TXT_PKG_FAILED="Failed to install: %s"
            TXT_UP_TO_DATE="All components are up to date."
            TXT_STOPPING="Stopping PassWall..."
            TXT_REMOVING_UI="Removing PassWall interface..."
            TXT_PURGING_ALL="Purging PassWall, cores and configurations..."
            TXT_PURGE_DONE="PassWall and all associated packages completely purged."
            TXT_REMOVE_DONE="PassWall interface removed."
            TXT_LANG_SET="Language set to: %s"
            TXT_HELP_TITLE="Service Controls:"
            TXT_HELP_DIAG="Diagnostics & Logs:"
            TXT_HELP_CONF="Configuration (UCI):"
            TXT_HELP_MAINT="Updates & Maintenance:"
            TXT_H_START="Start PassWall proxy service"
            TXT_H_STOP="Stop PassWall proxy service"
            TXT_H_RESTART="Restart PassWall service and routing rules"
            TXT_H_RELOAD="Reload configuration without restarting daemon"
            TXT_H_ENABLE="Enable autostart on system boot"
            TXT_H_DISABLE="Disable autostart on system boot"
            TXT_H_LOG="Display main PassWall service log"
            TXT_H_CORE="Display backend core (Xray / Sing-box) log"
            TXT_H_LOGREAD="Filter system log for PassWall events"
            TXT_H_CONFIG="Dump full UCI passwall configuration"
            TXT_H_STATUS="Show main switch state (enabled / disabled)"
            TXT_H_RAW="Show /etc/config/passwall file content"
            TXT_H_UPDATE="Check and update PassWall, cores and manager"
            TXT_H_LANG="Change CLI manager language (ru, en, es, de)"
            TXT_H_REMOVE="Remove PassWall interface only"
            TXT_H_PURGE="Completely purge PassWall, Cores and configurations"
            TXT_H_MGR="Show this management menu"
            TXT_MGR_UPDATED="PassWall manager updated to version %s."
            ;;
    esac
}

load_lang_strings

print_ok()   { printf "${GREEN}[OK]${RESET} %s\n" "$1"; }
print_err()  { printf "${RED_BG}[ERROR]${RESET} %s\n" "$1" >&2; }
print_info() { printf "${YELLOW}[...]${RESET} %s\n" "$1"; }
die()        { print_err "$1"; exit 1; }

banner() {
    printf "${BLUE}==============================================================================${RESET}\n"
    printf "${GREEN} CyberFantomo Security Technologies :: %s${RESET}\n" "$T_TITLE"
    printf "${YELLOW} Version: %s [%s] | %s${RESET}\n" "$VERSION" "$VERSION_DATE" "$T_SUBTITLE"
    printf "${BLUE}==============================================================================${RESET}\n"
    echo
}

safe_clean_tmp() {
    rm -f /tmp/*.ipk /tmp/*.tmp /tmp/cb_pkg.* /tmp/.probe.* 2>/dev/null || true
    sync
}

fetch_to() {
    URL="$1"; OUT="$2"
    ATTEMPTS=1
    while [ "$ATTEMPTS" -le 3 ]; do
        rm -f "$OUT"
        if command -v curl >/dev/null 2>&1; then
            curl -fsSLk --connect-timeout 10 --max-time 180 -o "$OUT" "$URL" 2>/dev/null
            [ -s "$OUT" ] && return 0
        fi
        if command -v uclient-fetch >/dev/null 2>&1; then
            uclient-fetch -4 -T 25 --no-check-certificate -q -O "$OUT" "$URL" 2>/dev/null
            [ -s "$OUT" ] && return 0
        fi
        if command -v wget >/dev/null 2>&1; then
            wget --no-check-certificate -q -O "$OUT" "$URL" 2>/dev/null
            [ -s "$OUT" ] && return 0
        fi
        ATTEMPTS=$((ATTEMPTS + 1))
        sleep 2
    done
    rm -f "$OUT"
    return 1
}

# Быстрая проверка доступности конкретного URL без повторного скачивания гигабайт
check_url_reachable() {
    URL="$1"
    if command -v curl >/dev/null 2>&1; then
        if curl -fsSLk -I --connect-timeout 6 --max-time 10 "$URL" 2>/dev/null | grep -qiE 'HTTP/.* (200|301|302)'; then
            return 0
        fi
        if curl -fsSLk -r 0-50 --connect-timeout 6 --max-time 10 -o /dev/null "$URL" 2>/dev/null; then
            return 0
        fi
    fi
    TMP_PROBE="/tmp/.probe.$$"
    rm -f "$TMP_PROBE"
    if fetch_to "$URL" "$TMP_PROBE"; then
        if [ -s "$TMP_PROBE" ]; then
            rm -f "$TMP_PROBE"
            return 0
        fi
    fi
    rm -f "$TMP_PROBE"
    return 1
}

is_glinet() {
    [ -f /etc/glversion ] && return 0
    [ -f /etc/config/glconfig ] && return 0
    grep -qi 'gl-inet\|gl\.inet' /etc/openwrt_release 2>/dev/null && return 0
    grep -qi 'GL-\|GL\.iNet' /tmp/sysinfo/model 2>/dev/null && return 0
    grep -qi 'gl-inet' /etc/opkg/distfeeds.conf 2>/dev/null && return 0
    return 1
}

pkg_installed() {
    opkg list-installed 2>/dev/null | awk -v p="$1" '$1 == p {found=1} END {exit !found}'
}

pkg_installed_ver() {
    opkg list-installed 2>/dev/null | awk -v p="$1" '$1 == p {print $3; exit}'
}

extract_version() {
    echo "$1" | grep -o '_[0-9][0-9a-zA-Z._-]*_' | head -n1 | tr -d '_'
}

# Поиск файла с кэшированием индекса API (чтобы не спамить Codeberg запросами)
get_latest_remote_pkg() {
    KEYWORD="$1"
    TMP_JSON="/tmp/cb_pkg.$$"
    if [ ! -s "$TMP_JSON" ]; then
        if ! fetch_to "$API_URL" "$TMP_JSON"; then
            rm -f "$TMP_JSON"
            return 1
        fi
    fi
    BEST_FILE=""
    MAX_V=""
    for F in $(grep -o '"name":"[^"]*"' "$TMP_JSON" | cut -d'"' -f4 | grep -i "$KEYWORD" | grep '\.ipk$'); do
        V=$(extract_version "$F")
        [ -z "$V" ] && continue
        if [ -z "$MAX_V" ]; then
            MAX_V="$V"; BEST_FILE="$F"
        else
            HIGHER=$(printf "%s\n%s\n" "$MAX_V" "$V" | sort -V | tail -n1)
            if [ "$V" = "$HIGHER" ] && [ "$V" != "$MAX_V" ]; then
                MAX_V="$V"; BEST_FILE="$F"
            fi
        fi
    done
    [ -n "$BEST_FILE" ] && echo "$BEST_FILE"
    return 0
}

pkg_name_from_file() {
    basename "$1" .ipk | sed 's/^22\.03-_//' | cut -d'_' -f1
}

opkg_install_ipk() {
    ARCH_FLAG=""
    opkg --help 2>&1 | grep -q 'force-architecture' && ARCH_FLAG="--force-architecture"
    OUT=$(IRON_WRAP=1 opkg install --force-overwrite "$1" 2>&1)
    RC=$?
    if [ $RC -ne 0 ]; then
        OUT=$(IRON_WRAP=1 opkg install --force-overwrite --force-depends $ARCH_FLAG "$1" 2>&1)
        RC=$?
    fi
    case "$OUT" in
        *"is up to date"*) return 2 ;;
    esac
    return $RC
}

remove_alternatives() {
    NEW_NAME="$1"
    KEYWORD="$2"
    for ALT in $(opkg list-installed 2>/dev/null | awk -v k="$KEYWORD" -v n="$NEW_NAME" '$1 ~ k && $1 != n && $1 !~ /i18n/ {print $1}'); do
        IRON_WRAP=1 opkg remove --force-depends "$ALT" >/dev/null 2>&1 || true
    done
}

CHANGES_MADE=0

install_smart_pkg() {
    KEYWORD="$1"
    FALLBACK_FILE="$2"
    DISPLAY_NAME="$3"

    FILE=""
    get_latest_remote_pkg "$KEYWORD" >/tmp/.lw.$$ 2>/dev/null && FILE=$(cat /tmp/.lw.$$)
    rm -f /tmp/.lw.$$
    [ -z "$FILE" ] && FILE="$FALLBACK_FILE"

    REMOTE_V=$(extract_version "$FILE" | tr -d '\r\n ')
    NEW_PKG_NAME=$(pkg_name_from_file "$FILE")
    LOCAL_V=$(pkg_installed_ver "$NEW_PKG_NAME" | tr -d '\r\n ')

    if [ -n "$LOCAL_V" ] && [ -n "$REMOTE_V" ]; then
        if [ "$LOCAL_V" = "$REMOTE_V" ]; then
            print_info "$(printf "$T_INSTALL_SKIP" "$DISPLAY_NAME" "$LOCAL_V")"
            return 0
        fi
        MAX_V=$(printf "%s\n%s\n" "$LOCAL_V" "$REMOTE_V" | sort -V | tail -n1)
        if [ "$LOCAL_V" = "$MAX_V" ]; then
            print_info "$(printf "$T_INSTALL_SKIP" "$DISPLAY_NAME" "$LOCAL_V")"
            return 0
        fi
    fi

    TARGET="/tmp/$FILE"
    if [ ! -s "$TARGET" ]; then
        print_info "$(printf "$T_DOWNLOADING" "$FILE")"
        if ! fetch_to "$BASE_URL/$FILE" "$TARGET"; then
            die "$(printf "$T_DOWNLOAD_FAIL" "$FILE")"
        fi
    fi

    print_info "$(printf "$T_INSTALLING" "$DISPLAY_NAME")"
    remove_alternatives "$NEW_PKG_NAME" "$KEYWORD"
    set +e
    opkg_install_ipk "$TARGET"
    IRC=$?
    set -e
    rm -f "$TARGET"

    if [ $IRC -eq 2 ]; then
        print_info "$(printf "$T_INSTALL_SKIP" "$DISPLAY_NAME" "$REMOTE_V")"
        return 0
    fi
    if [ $IRC -eq 0 ]; then
        print_ok "$(printf "$T_INSTALL_OK" "$DISPLAY_NAME")"
        CHANGES_MADE=1
        return 0
    fi
    die "$(printf "$T_INSTALL_FAIL" "$DISPLAY_NAME")"
}

# ==============================================================================
# РЕЖИМ МЕНЕДЖЕРА (/usr/bin/passwall)
# ==============================================================================
run_as_manager() {
    CMD="${1:-manager}"
    shift 2>/dev/null || true

    case "$CMD" in
        start)   /etc/init.d/passwall start && print_ok "$TXT_SVC_STARTED" ;;
        stop)    /etc/init.d/passwall stop && print_ok "$TXT_SVC_STOPPED" ;;
        restart) /etc/init.d/passwall restart && print_ok "$TXT_SVC_RESTARTED" ;;
        reload)  /etc/init.d/passwall reload && print_ok "$TXT_SVC_RELOADED" ;;
        enable)  /etc/init.d/passwall enable && print_ok "$TXT_SVC_ENABLED" ;;
        disable) /etc/init.d/passwall disable && print_ok "$TXT_SVC_DISABLED" ;;
        log)     [ -f /tmp/log/passwall.log ] && cat /tmp/log/passwall.log || print_err "$TXT_LOG_EMPTY" ;;
        log-core)[ -f /tmp/log/passwall_server.log ] && cat /tmp/log/passwall_server.log || print_err "$TXT_LOG_EMPTY" ;;
        logread) logread | grep -i passwall ;;
        config)  uci show passwall ;;
        status)
            VAL=$(uci -q get passwall.@global[0].enabled || uci -q get passwall.@global[0].enable || echo "0")
            [ "$VAL" = "1" ] && print_ok "PassWall: ENABLED" || print_info "PassWall: DISABLED"
            ;;
        raw-config) cat /etc/config/passwall ;;
        update|upgrade)
            TMP_MGR="/tmp/passwall_remote.$$"
            if fetch_to "$SCRIPT_URL" "$TMP_MGR"; then
                tr -d '\r' < "$TMP_MGR" > "${TMP_MGR}.c" && mv -f "${TMP_MGR}.c" "$TMP_MGR"
                REMOTE_VER=$(grep -m1 '^VERSION=' "$TMP_MGR" | cut -d '"' -f2 | tr -d '\r\n ')
                if [ -n "$REMOTE_VER" ]; then
                    MAX_VER=$(printf "%s\n%s\n" "$VERSION" "$REMOTE_VER" | sort -V | tail -n1)
                    if [ "$REMOTE_VER" = "$MAX_VER" ] && [ "$REMOTE_VER" != "$VERSION" ]; then
                        print_info "$(printf "$TXT_MGR_UPDATING" "$VERSION" "$REMOTE_VER")"
                        cp -f "$TMP_MGR" /usr/bin/passwall
                        chmod 755 /usr/bin/passwall
                        rm -f "$TMP_MGR"
                        print_ok "$(printf "$TXT_MGR_UPDATED" "$REMOTE_VER")"
                        exec /usr/bin/passwall update
                    fi
                fi
            fi
            rm -f "$TMP_MGR"

            print_info "$TXT_CHECK_START"

            if pkg_installed "xray-core" && pkg_installed "openwrt-xray"; then
                IRON_WRAP=1 opkg remove --force-depends xray-core >/dev/null 2>&1 || true
            fi

            COMPONENTS_KEYWORDS="
xray        Xray
passwall    luci-app-passwall
chinadns    chinadns-ng
dns2socks   dns2socks
microsocks  microsocks
tcping      tcping
"
            if pkg_installed "sing-box"; then
                COMPONENTS_KEYWORDS="$COMPONENTS_KEYWORDS
sing-box    sing-box"
            fi

            UPD_FLAG="/tmp/.pw_updated.$$"
            rm -f "$UPD_FLAG"

            echo "$COMPONENTS_KEYWORDS" | while read -r KEYWORD DISPLAY_NAME; do
                [ -z "$KEYWORD" ] && continue

                REMOTE_FILE=""
                get_latest_remote_pkg "$KEYWORD" >/tmp/.lw.$$ 2>/dev/null && REMOTE_FILE=$(cat /tmp/.lw.$$)
                rm -f /tmp/.lw.$$
                [ -z "$REMOTE_FILE" ] && continue
                REMOTE_V=$(extract_version "$REMOTE_FILE" | tr -d '\r\n ')
                [ -z "$REMOTE_V" ] && continue

                NEW_PKG_NAME=$(pkg_name_from_file "$REMOTE_FILE")
                LOCAL_V=$(pkg_installed_ver "$NEW_PKG_NAME" | tr -d '\r\n ')

                if [ -n "$LOCAL_V" ]; then
                    if [ "$LOCAL_V" = "$REMOTE_V" ]; then
                        print_info "$(printf "$TXT_PKG_UPTODATE" "$DISPLAY_NAME" "$LOCAL_V")"
                        continue
                    fi
                    MAX_V=$(printf "%s\n%s\n" "$LOCAL_V" "$REMOTE_V" | sort -V | tail -n1)
                    if [ "$LOCAL_V" = "$MAX_V" ]; then
                        print_info "$(printf "$TXT_PKG_UPTODATE" "$DISPLAY_NAME" "$LOCAL_V")"
                        continue
                    fi
                fi

                print_info "$(printf "$TXT_CHECK_PKG" "$DISPLAY_NAME" "${LOCAL_V:-none}" "$REMOTE_V")"

                TMP_IPK="/tmp/$REMOTE_FILE"
                if fetch_to "$BASE_URL/$REMOTE_FILE" "$TMP_IPK"; then
                    remove_alternatives "$NEW_PKG_NAME" "$KEYWORD"
                    set +e
                    opkg_install_ipk "$TMP_IPK"
                    URC=$?
                    set -e
                    rm -f "$TMP_IPK"
                    if [ $URC -eq 0 ]; then
                        print_ok "$(printf "$TXT_PKG_UPDATED" "$DISPLAY_NAME" "${LOCAL_V:-none}" "$REMOTE_V")"
                        echo 1 >> "$UPD_FLAG"
                    elif [ $URC -eq 2 ]; then
                        print_info "$(printf "$TXT_PKG_UPTODATE" "$DISPLAY_NAME" "$REMOTE_V")"
                    else
                        print_err "$(printf "$TXT_PKG_FAILED" "$DISPLAY_NAME")"
                    fi
                else
                    print_err "$(printf "$TXT_PKG_FAILED" "$DISPLAY_NAME")"
                fi
            done

            if [ -f "$UPD_FLAG" ]; then
                rm -f "$UPD_FLAG"
                /etc/init.d/passwall restart >/dev/null 2>&1 || true
                print_ok "$TXT_SVC_RESTARTED"
            else
                print_ok "$TXT_UP_TO_DATE"
            fi
            ;;
        lang)
            NEW_L="${1:-}"
            if [ -z "$NEW_L" ]; then
                echo "Select language / Выберите язык / Selecciona idioma / Sprache:"
                echo "  1) English   2) Русский   3) Español   4) Deutsch"
                printf "Choice [1]: "
                read -r L_CH
                case "$L_CH" in
                    2) NEW_L="ru" ;; 3) NEW_L="es" ;; 4) NEW_L="de" ;; *) NEW_L="en" ;;
                esac
            fi
            case "$NEW_L" in ru|en|es|de) ;; *) NEW_L="en" ;; esac
            echo "$NEW_L" > "$CONF_LANG"
            APP_LANG="$NEW_L"
            load_lang_strings
            command -v iron >/dev/null 2>&1 && iron lang "$NEW_L" >/dev/null 2>&1 || true
            print_ok "$(printf "$TXT_LANG_SET" "$NEW_L")"
            ;;
        remove)
            print_info "$TXT_STOPPING"
            /etc/init.d/passwall stop 2>/dev/null || true
            /etc/init.d/passwall disable 2>/dev/null || true
            print_info "$TXT_REMOVING_UI"
            IRON_WRAP=1 opkg remove --force-depends luci-app-passwall 2>/dev/null || true
            print_ok "$TXT_REMOVE_DONE"
            ;;
        purge)
            print_info "$TXT_STOPPING"
            /etc/init.d/passwall stop 2>/dev/null || true
            /etc/init.d/passwall disable 2>/dev/null || true
            print_info "$TXT_PURGING_ALL"
            IRON_WRAP=1 opkg remove --force-depends luci-app-passwall xray-core openwrt-xray sing-box chinadns-ng dns2socks microsocks tcping 2>/dev/null || true
            rm -rf /etc/config/passwall /etc/config/passwall_server /usr/share/passwall /tmp/etc/passwall /tmp/log/passwall* "$CONF_LANG" 2>/dev/null || true
            print_ok "$TXT_PURGE_DONE"
            rm -f /usr/bin/passwall
            ;;
        *)
            printf "${BLUE}==============================================================================${RESET}\n"
            printf "${GREEN} PassWall CLI Manager v%s [%s]${RESET}\n" "$VERSION" "$APP_LANG"
            printf "${BLUE}==============================================================================${RESET}\n"
            printf "${YELLOW}%s${RESET}\n" "$TXT_HELP_TITLE"
            printf "  %-26s %s\n" "passwall start" "$TXT_H_START"
            printf "  %-26s %s\n" "passwall stop" "$TXT_H_STOP"
            printf "  %-26s %s\n" "passwall restart" "$TXT_H_RESTART"
            printf "  %-26s %s\n" "passwall reload" "$TXT_H_RELOAD"
            printf "  %-26s %s\n" "passwall enable" "$TXT_H_ENABLE"
            printf "  %-26s %s\n" "passwall disable" "$TXT_H_DISABLE"
            echo
            printf "${YELLOW}%s${RESET}\n" "$TXT_HELP_DIAG"
            printf "  %-26s %s\n" "passwall log" "$TXT_H_LOG"
            printf "  %-26s %s\n" "passwall log-core" "$TXT_H_CORE"
            printf "  %-26s %s\n" "passwall logread" "$TXT_H_LOGREAD"
            echo
            printf "${YELLOW}%s${RESET}\n" "$TXT_HELP_CONF"
            printf "  %-26s %s\n" "passwall config" "$TXT_H_CONFIG"
            printf "  %-26s %s\n" "passwall status" "$TXT_H_STATUS"
            printf "  %-26s %s\n" "passwall raw-config" "$TXT_H_RAW"
            echo
            printf "${YELLOW}%s${RESET}\n" "$TXT_HELP_MAINT"
            printf "  %-26s %s\n" "passwall update" "$TXT_H_UPDATE"
            printf "  %-26s %s\n" "passwall lang [lang]" "$TXT_H_LANG"
            printf "  %-26s %s\n" "passwall remove" "$TXT_H_REMOVE"
            printf "  %-26s %s\n" "passwall purge" "$TXT_H_PURGE"
            printf "  %-26s %s\n" "passwall manager" "$TXT_H_MGR"
            echo
            ;;
    esac
}

if [ "$0" = "/usr/bin/passwall" ] || [ "$(basename "$0")" = "passwall" ]; then
    set +e
    run_as_manager "$@"
    exit 0
fi

# ==============================================================================
# РЕЖИМ ИНСТАЛЛЯТОРА
# ==============================================================================

CLI_LANG=""
for ARG in "$@"; do
    case "$ARG" in
        --lang=*|-l=*) CLI_LANG="${ARG#*=}" ;;
        --lang|-l)     CLI_LANG="NEXT" ;;
        *) [ "$CLI_LANG" = "NEXT" ] && CLI_LANG="$ARG" ;;
    esac
done

if [ -n "$CLI_LANG" ] && [ "$CLI_LANG" != "NEXT" ]; then
    APP_LANG="$CLI_LANG"
else
    echo "=============================================================================="
    echo "Select installer language / Выберите язык / Selecciona idioma / Sprache:"
    echo "  1) English   2) Русский   3) Español   4) Deutsch"
    echo "=============================================================================="
    printf "Choice [1]: "
    read -r LANG_CHOICE
    case "$LANG_CHOICE" in
        2) APP_LANG="ru" ;; 3) APP_LANG="es" ;; 4) APP_LANG="de" ;; *) APP_LANG="en" ;;
    esac
fi
case "$APP_LANG" in ru|en|es|de) ;; *) APP_LANG="en" ;; esac
load_lang_strings

banner

# 1. root
if [ "$(id -u)" -ne 0 ]; then
    die "$T_CHECK_ROOT"
fi

# 2. Место на /overlay
print_info "$T_CHECK_SPACE"
safe_clean_tmp
FREE_KB="$(df /overlay 2>/dev/null | tail -1 | awk '{print $4}')"
if [ -n "$FREE_KB" ]; then
    printf "$T_SPACE_OK\n" "$FREE_KB"
    if [ "$FREE_KB" -lt 15000 ]; then
        die "$(printf "$T_SPACE_LOW" "$FREE_KB")"
    fi
fi

# 3. Интернет
print_info "$T_NET_CHECK"
if ! ping -c 1 -W 3 1.1.1.1 >/dev/null 2>&1 && ! ping -c 1 -W 3 8.8.8.8 >/dev/null 2>&1; then
    die "$T_NET_FAIL"
fi
print_ok "$T_NET_OK"

# 4. Дубликаты ядра Xray
if pkg_installed "xray-core" && pkg_installed "openwrt-xray"; then
    print_info "$T_CONFLICT_FIX"
    IRON_WRAP=1 opkg remove --force-depends xray-core >/dev/null 2>&1 || true
fi

# 5. GL.iNet / IronUpdate
if is_glinet; then
    print_info "$T_GL_DETECT"
    if [ ! -x /usr/sbin/ironupdate ]; then
        if fetch_to "$IRON_URL" /tmp/ironupdate.sh; then
            tr -d '\r' < /tmp/ironupdate.sh > /tmp/ironupdate.c && mv -f /tmp/ironupdate.c /tmp/ironupdate.sh
            chmod +x /tmp/ironupdate.sh
            sh /tmp/ironupdate.sh --lang="$APP_LANG" || true
            rm -f /tmp/ironupdate.sh
            print_ok "$(printf "$T_GL_INSTALLED" "$APP_LANG")"
            CHANGES_MADE=1
        fi
    else
        iron lang "$APP_LANG" >/dev/null 2>&1 || true
        iron unlock >/dev/null 2>&1 || true
        print_ok "$(printf "$T_GL_ACTIVE" "$APP_LANG")"
    fi
else
    print_info "$T_GL_SKIP"
fi

# 6. ПРЕДВАРИТЕЛЬНАЯ ПРОВЕРКА ДОСТУПНОСТИ ВСЕХ ФАЙЛОВ (ДО ДЛИННЫХ ОПЕРАЦИЙ)
print_info "$T_REPO_CHECK"
API_CACHE="/tmp/cb_pkg.$$"
rm -f "$API_CACHE"

if ! fetch_to "$API_URL" "$API_CACHE" || [ ! -s "$API_CACHE" ]; then
    rm -f "$API_CACHE"
    print_err "$(printf "$T_REPO_FAIL" "API Index")"
    die "$T_REPO_HINT"
fi

# Проверка наличия и доступности каждого необходимого компонента
for COMP_ITEM in "chinadns:chinadns-ng_2025.08.09-r1_mips_24kc.ipk" \
                 "dns2socks:dns2socks_2.1-r2_mips_24kc.ipk" \
                 "microsocks:microsocks_1.0.5-r1_mips_24kc.ipk" \
                 "tcping:tcping_0.3-r1_mips_24kc.ipk" \
                 "xray:openwrt-xray_26.9.9-1_mips_24kc.ipk" \
                 "passwall:22.03-_luci-app-passwall_26.9.27_all.ipk"; do
    C_K="${COMP_ITEM%%:*}"
    C_F="${COMP_ITEM#*:}"
    FOUND_FILE=""
    get_latest_remote_pkg "$C_K" >/tmp/.lw.$$ 2>/dev/null && FOUND_FILE=$(cat /tmp/.lw.$$)
    rm -f /tmp/.lw.$$
    FOUND_FILE=${FOUND_FILE:-"$C_F"}

    # Проверка доступности скачивания без двойного расхода трафика
    if ! check_url_reachable "$BASE_URL/$FOUND_FILE"; then
        rm -f "$API_CACHE"
        print_err "$(printf "$T_REPO_FAIL" "$FOUND_FILE")"
        die "$T_REPO_HINT"
    fi
done
print_ok "$T_REPO_OK"

# 7. Обновление фидов — выполняется только если все файлы гарантированно доступны
print_info "$T_UPDATING"
set +e
opkg update
set -e

# 8. Базовые зависимости, включая зависимости luci-app-passwall
print_info "$T_DEPS_INSTALL"
set +e
for DEP in bash curl wget coreutils-timeout coreutils-base64 coreutils-nohup lyaml luci-compat kmod-ipt-iprange kmod-ipt-socket; do
    if ! pkg_installed "$DEP"; then
        opkg install "$DEP" >/dev/null 2>&1 && CHANGES_MADE=1
    fi
done
modprobe xt_socket 2>/dev/null
set -e
print_ok "$T_DEPS_OK"

# 9. Компоненты: версии сверяются по точным именам; ядро раньше интерфейса
print_info "$T_AUDIT_COMP"
install_smart_pkg "chinadns"   "chinadns-ng_2025.08.09-r1_mips_24kc.ipk"  "chinadns-ng"
install_smart_pkg "dns2socks"  "dns2socks_2.1-r2_mips_24kc.ipk"           "dns2socks"
install_smart_pkg "microsocks" "microsocks_1.0.5-r1_mips_24kc.ipk"        "microsocks"
install_smart_pkg "tcping"     "tcping_0.3-r1_mips_24kc.ipk"              "tcping"
install_smart_pkg "xray"       "openwrt-xray_26.9.9-1_mips_24kc.ipk"      "Xray"
install_smart_pkg "passwall"   "22.03-_luci-app-passwall_26.9.27_all.ipk" "luci-app-passwall"

# 10. Конфигурация PassWall
print_info "$T_CONFIGURING"
uci -q batch <<EOF
set passwall.@global[0].enabled='1'
set passwall.@global[0].udp_node='tcp'
set passwall.@global[0].tcp_proxy_mode='global'
set passwall.@global[0].udp_proxy_mode='global'
set passwall.@global[0].use_direct_list='0'
set passwall.@global[0].use_proxy_list='0'
set passwall.@global[0].use_gfw_list='0'
set passwall.@global[0].chn_list='0'
set passwall.@global[0].remote_dns='8.8.4.4'
set passwall.@global[0].dns_mode='udp'
set passwall.@global_forwarding[0].prefer_nft='0'
set passwall.@global_forwarding[0].tcp_no_redir_ports='disable'
set passwall.@global_forwarding[0].udp_no_redir_ports='1:65535'
set passwall.@global_forwarding[0].tcp_redir_ports='1:65535'
set passwall.@global_forwarding[0].udp_redir_ports='1:65535'
commit passwall
EOF
uci -q del passwall.@global[0].udp_no_redir_ports 2>/dev/null || true
uci -q del passwall.@global[0].filter_proxy_mode 2>/dev/null || true
uci -q del passwall.@global[0].china_list 2>/dev/null || true
uci -q commit passwall
print_ok "$T_CONF_OK"

# 11. Менеджер
print_info "$T_MANAGER_INST"
cp -f "$0" /usr/bin/passwall
chmod 755 /usr/bin/passwall
echo "$APP_LANG" > "$CONF_LANG"
print_ok "$T_MANAGER_OK"

# 12. Очистка
print_info "$T_CLEANUP"
safe_clean_tmp
rm -f "$0" 2>/dev/null || true

echo
printf "${GREEN}==============================================================================${RESET}\n"
printf "${GREEN} %s${RESET}\n" "$T_SUCCESS"
if [ "$CHANGES_MADE" -eq 1 ]; then
    printf "${YELLOW} %s${RESET}\n" "$T_REBOOTING"
    printf "${GREEN}==============================================================================${RESET}\n"
    echo
    sleep 10
    reboot
else
    printf "${GREEN} %s${RESET}\n" "$T_ALL_OK"
    printf "${GREEN}==============================================================================${RESET}\n"
    echo
fi
