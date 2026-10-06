#!/bin/sh

# ============================================================
#  autosetup.sh — клиентский лаунчер One-Click PassWall v1
#  Запуск: смартфон (Termux / iSH), Linux, macOS
# ============================================================

ROUTER_IP="192.168.8.1"
ROUTER_PORT="22"
ROUTER_USER="root"
INSTALLER_URL="https://raw.githubusercontent.com/cbfst/pr-passwall/main/autopasswall.sh"

# --- Самоудаление скрипта с устройства после работы ---------
cleanup() {
    rm -f "$0" 2>/dev/null || true
    rm -f autosetup.sh 2>/dev/null || true
}
trap cleanup EXIT HUP INT TERM

# --- OpenSSH: установка при отсутствии -----------------------
if ! command -v ssh >/dev/null 2>&1; then
    if command -v pkg >/dev/null 2>&1; then
        pkg install openssh -y >/dev/null 2>&1
    elif command -v apk >/dev/null 2>&1; then
        apk add openssh >/dev/null 2>&1
    fi
fi

if ! command -v ssh >/dev/null 2>&1; then
    printf '\033[41;37;1m[ERROR]\033[0m OpenSSH client not found. Install openssh package.\n'
    exit 1
fi

# --- 1. Интерактивный выбор языка -----------------------------
printf '\033[1;34m==============================================================================\033[0m\n'
printf '\033[1;32m Select language / Выберите язык / Selecciona idioma / Sprache wählen:\033[0m\n'
printf '  1) English\n'
printf '  2) Русский\n'
printf '  3) Español\n'
printf '  4) Deutsch\n'
printf '\033[1;34m==============================================================================\033[0m\n'
printf 'Choice [1]: '
read -r L_CHOICE

case "$L_CHOICE" in
    2) LANG_CODE="ru" ;;
    3) LANG_CODE="es" ;;
    4) LANG_CODE="de" ;;
    *) LANG_CODE="en" ;;
esac

# --- 2. Локализованные словари интерфейса ---------------------
case "$LANG_CODE" in
    ru)
        T_TITLE="PassWall v1 Auto-Installer"
        T_SUBTITLE="Версия: 2.0.0 [10.2026] | Сайт: www.cbf.st"
        T_TARGET="Роутеры: GL-E750 / GL-E750V2 / GL-AR300M16 (MIPS 24Kc)"
        T_CHECK_NET="Проверка связи с роутером (192.168.8.1)..."
        T_OK_ONLINE="Роутер доступен (192.168.8.1)"
        T_ERR_NET="Ошибка: Роутер 192.168.8.1 недоступен!"
        T_TROUBLE_TITLE="Возможные причины и решение:"
        T_TR_1="1. Вы не подключены к Wi-Fi или LAN сети роутера."
        T_TR_2="2. На смартфоне/ПК включен сторонний VPN или Прокси (блокирует подключение к роутеру)."
        T_TR_3="3. На смартфоне активен Мобильный Интернет (4G/5G) — выключите Передачу Данных."
        T_PROMPT_PASS="Введите пароль от админ-панели роутера и нажмите Enter:"
        T_HINT_PASS="(Вводимый пароль скрыт — это нормальная практика безопасности)"
        T_ROUTER_NO_NET="Ошибка: На роутере отсутствует доступ в интернет!"
        T_ROUTER_NO_NET_HINT="Сам роутер должен быть подключен к интернету (проверьте WAN-кабель, SIM-карту или Wi-Fi в панели управления 192.168.8.1)."
        ;;
    es)
        T_TITLE="PassWall v1 Auto-Installer"
        T_SUBTITLE="Versión: 2.0.0 [10.2026] | Web: www.cbf.st"
        T_TARGET="Routers: GL-E750 / GL-E750V2 / GL-AR300M16 (MIPS 24Kc)"
        T_CHECK_NET="Comprobando conexión con el router (192.168.8.1)..."
        T_OK_ONLINE="Router disponible (192.168.8.1)"
        T_ERR_NET="¡Error: El router 192.168.8.1 no responde!"
        T_TROUBLE_TITLE="Posibles causas y soluciones:"
        T_TR_1="1. No está conectado a la red Wi-Fi o LAN del router."
        T_TR_2="2. Hay un VPN o Proxy activo en su dispositivo (bloquea la conexión al router)."
        T_TR_3="3. Los Datos Móviles (4G/5G) están activos en el teléfono (desactívelos)."
        T_PROMPT_PASS="Ingrese la contraseña del panel de administración y pulse Enter:"
        T_HINT_PASS="(La contraseña está oculta al escribir — es normal)"
        T_ROUTER_NO_NET="¡Error: El router no tiene conexión a Internet!"
        T_ROUTER_NO_NET_HINT="El router debe tener acceso a Internet (verifique el cable WAN, la tarjeta SIM o Wi-Fi en el panel de administración 192.168.8.1)."
        ;;
    de)
        T_TITLE="PassWall v1 Auto-Installer"
        T_SUBTITLE="Version: 2.0.0 [10.2026] | Web: www.cbf.st"
        T_TARGET="Router: GL-E750 / GL-E750V2 / GL-AR300M16 (MIPS 24Kc)"
        T_CHECK_NET="Prüfe Verbindung zum Router (192.168.8.1)..."
        T_OK_ONLINE="Router erreichbar (192.168.8.1)"
        T_ERR_NET="Fehler: Router 192.168.8.1 ist nicht erreichbar!"
        T_TROUBLE_TITLE="Mögliche Ursachen und Lösungen:"
        T_TR_1="1. Nicht mit dem Wi-Fi oder LAN des Routers verbunden."
        T_TR_2="2. Aktives VPN oder Proxy auf Smartphone/PC blockiert Verbindung zum Router."
        T_TR_3="3. Mobile Daten (4G/5G) auf dem Smartphone aktiv (bitte deaktivieren)."
        T_PROMPT_PASS="Router-Admin-Passwort eingeben und Enter drücken:"
        T_HINT_PASS="(Die Passworteingabe ist unsichtbar — das ist normal)"
        T_ROUTER_NO_NET="Fehler: Router hat keine Internetverbindung!"
        T_ROUTER_NO_NET_HINT="Der Router selbst muss mit dem Internet verbunden sein (WAN-Kabel, SIM-Karte oder WLAN im Adminpanel 192.168.8.1 prüfen)."
        ;;
    *)
        T_TITLE="PassWall v1 Auto-Installer"
        T_SUBTITLE="Version: 2.0.0 [10.2026] | Web: www.cbf.st"
        T_TARGET="Target: GL-E750 / GL-E750V2 / GL-AR300M16 (MIPS 24Kc)"
        T_CHECK_NET="Checking connectivity to router (192.168.8.1)..."
        T_OK_ONLINE="Router is reachable at 192.168.8.1"
        T_ERR_NET="Error: Router 192.168.8.1 is unreachable!"
        T_TROUBLE_TITLE="Troubleshooting steps:"
        T_TR_1="1. You are not connected to the router Wi-Fi or LAN network."
        T_TR_2="2. Active VPN or Proxy on your phone/PC is blocking router connection."
        T_TR_3="3. Mobile Data (4G/5G) is active on smartphone (please turn off Mobile Data)."
        T_PROMPT_PASS="Enter router admin password and press Enter:"
        T_HINT_PASS="(Password is hidden while typing — this is normal)"
        T_ROUTER_NO_NET="Error: Router has no Internet connection!"
        T_ROUTER_NO_NET_HINT="The router itself must be connected to the Internet (check WAN cable, SIM card, or Wi-Fi in the router admin panel 192.168.8.1)."
        ;;
esac

# --- 3. Баннер на выбранном языке -----------------------------
printf '\033[1;34m==============================================================================\033[0m\n'
printf '\033[1;32m CyberFantomo Security Technologies :: %s\033[0m\n' "$T_TITLE"
printf '\033[1;38;5;208m %s\033[0m\n' "$T_SUBTITLE"
printf '\033[1;34m %s\033[0m\n' "$T_TARGET"
printf '\033[1;34m==============================================================================\033[0m\n'
printf '\n'

# --- 4. Проверка доступности роутера -------------------------
printf '\033[1;33m[...] %s\033[0m\n' "$T_CHECK_NET"

ROUTER_ONLINE=0

# Проверка 1: отклик HTTP-сервера роутера (порт 80) через curl/wget
if command -v curl >/dev/null 2>&1; then
    if curl -s -m 2 "http://${ROUTER_IP}/" >/dev/null 2>&1; then
        ROUTER_ONLINE=1
    fi
elif command -v wget >/dev/null 2>&1; then
    if wget -q -T 2 -O /dev/null "http://${ROUTER_IP}/" >/dev/null 2>&1; then
        ROUTER_ONLINE=1
    fi
fi

# Проверка 2: отклик SSH (порт 22), если веб-сервер не ответил
if [ "$ROUTER_ONLINE" -eq 0 ]; then
    SSH_CHECK=$(ssh -o BatchMode=yes -o ConnectTimeout=2 -o StrictHostKeyChecking=accept-new "${ROUTER_USER}@${ROUTER_IP}" exit 2>&1)
    if [ $? -eq 0 ] || echo "$SSH_CHECK" | grep -qi "Permission denied\|Identification\|Verification"; then
        ROUTER_ONLINE=1
    fi
fi

if [ "$ROUTER_ONLINE" -eq 0 ]; then
    printf '\n'
    printf '\033[41;37;1m[ERROR]\033[0m \033[1;31m%s\033[0m\n' "$T_ERR_NET"
    printf '\033[1;33m%s\033[0m\n' "$T_TROUBLE_TITLE"
    printf '  \033[1;37m%s\033[0m\n' "$T_TR_1"
    printf '  \033[1;37m%s\033[0m\n' "$T_TR_2"
    printf '  \033[1;37m%s\033[0m\n' "$T_TR_3"
    printf '\033[1;34m==============================================================================\033[0m\n'
    exit 1
fi

printf '\033[1;32m[OK] %s\033[0m\n\n' "$T_OK_ONLINE"

# --- 5. Запрос пароля SSH ------------------------------------
printf '\033[1;32m[OK]\033[0m \033[1;37m%s\033[0m\n' "$T_PROMPT_PASS"
printf '\033[1;33m     %s\033[0m\n' "$T_HINT_PASS"
printf '\033[1;34m==============================================================================\033[0m\n'

# --- 6. Сброс известного ключа роутера -----------------------
mkdir -p "$HOME/.ssh" 2>/dev/null
touch "$HOME/.ssh/known_hosts" 2>/dev/null
ssh-keygen -R "$ROUTER_IP" >/dev/null 2>&1

# --- 7. Команда для выполнения внутри роутера ---------------
REMOTE_CMD="wget --no-check-certificate -qO /tmp/autopasswall.sh ${INSTALLER_URL} || uclient-fetch -qO /tmp/autopasswall.sh ${INSTALLER_URL}; if [ ! -s /tmp/autopasswall.sh ]; then printf '\n\033[41;37;1m[ERROR]\033[0m \033[1;31m%s\033[0m\n\033[1;33m%s\033[0m\n\n' '${T_ROUTER_NO_NET}' '${T_ROUTER_NO_NET_HINT}'; exit 1; fi; tr -d '\r' < /tmp/autopasswall.sh > /tmp/.ap && mv -f /tmp/.ap /tmp/autopasswall.sh; chmod +x /tmp/autopasswall.sh; /bin/sh /tmp/autopasswall.sh --lang=${LANG_CODE}"

# --- 8. Вызов SSH с принудительным TTY -----------------------
ssh -tt -o StrictHostKeyChecking=accept-new "${ROUTER_USER}@${ROUTER_IP}" "$REMOTE_CMD"

# Финальная очистка
cleanup