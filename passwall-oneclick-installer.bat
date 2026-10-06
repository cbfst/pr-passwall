@echo off
chcp 866 > nul
color 0A
title PassWall v1 Auto-Installer

set "ROUTER_IP=192.168.8.1"
set "INSTALLER_URL=https://raw.githubusercontent.com/cbfst/pr-passwall/main/autopasswall.sh"
set "LANG_CODE=en"
set "L_CHOICE="

echo ==============================================================================
echo  CyberFantomo Security Technologies :: PassWall v1 Auto-Installer
echo  Version: 2.0.0 [10.2026] ^| Official Web: www.cbf.st
echo  Target: GL-E750 / GL-E750V2 / GL-AR300M16 (MIPS 24Kc)
echo ==============================================================================
echo.
echo Select language / Выберите язык / Seleccionar idioma / Sprache:
echo   1) English
echo   2) Русский
echo   3) Espanol
echo   4) Deutsch
echo ==============================================================================
set /p L_CHOICE=Choice / Выбор / Eleccion / Auswahl [1]: 
echo.

if "%L_CHOICE%"=="2" goto SET_RU
if "%L_CHOICE%"=="3" goto SET_ES
if "%L_CHOICE%"=="4" goto SET_DE

:SET_EN
set "LANG_CODE=en"
set "T_CHECK=Checking connectivity to router (%ROUTER_IP%)..."
set "T_OK=[OK] Router is reachable (%ROUTER_IP%)"
set "T_PASS=ENTER ROUTER ADMIN PASSWORD AND PRESS ENTER."
set "T_PASS_HINT=(Password is hidden - this is standard security practice.)"
set "T_ERR=[ERROR] Router %ROUTER_IP% is unreachable!"
set "T_ERR_TITLE=Possible causes:"
set "T_ERR_1=1. You are not connected to the router Wi-Fi or LAN network."
set "T_ERR_2=2. Active VPN or Proxy on your PC blocks router connection."
set "T_ERR_3=3. Check network cable or Wi-Fi connection to the router."
set "T_SSH_ERR=[ERROR] OpenSSH client not found!"
set "T_SSH_HINT=Install: Settings - Apps - Optional Features - OpenSSH Client"
set "T_WAN_ERR=[ERROR] Router has no Internet access!"
set "T_WAN_HINT=The router itself must be connected to the Internet (check WAN cable, SIM card or Wi-Fi in 192.168.8.1)."
goto PROCEED

:SET_RU
set "LANG_CODE=ru"
set "T_CHECK=Проверка связи с роутером (%ROUTER_IP%)..."
set "T_OK=[OK] Роутер доступен (%ROUTER_IP%)"
set "T_PASS=ВВЕДИТЕ ПАРОЛЬ ОТ АДМИН-ПАНЕЛИ РОУТЕРА И НАЖМИТЕ ENTER."
set "T_PASS_HINT=(Пароль при вводе скрыт - это стандартная практика безопасности.)"
set "T_ERR=[ERROR] Роутер %ROUTER_IP% недоступен!"
set "T_ERR_TITLE=Возможные причины:"
set "T_ERR_1=1. Вы не подключены к Wi-Fi или LAN сети роутера."
set "T_ERR_2=2. На ПК включен VPN или Прокси (блокирует подключение к роутеру)."
set "T_ERR_3=3. Проверьте кабель или подключение к Wi-Fi сети роутера."
set "T_SSH_ERR=[ERROR] Клиент OpenSSH не найден!"
set "T_SSH_HINT=Установка: Параметры - Приложения - Дополнительные компоненты - Клиент OpenSSH"
set "T_WAN_ERR=[ОШИБКА] На роутере отсутствует доступ в интернет!"
set "T_WAN_HINT=Сам роутер должен быть подключен к интернету (проверьте WAN-кабель, SIM-карту или Wi-Fi в панели 192.168.8.1)."
goto PROCEED

:SET_ES
set "LANG_CODE=es"
set "T_CHECK=Comprobando conexion con el router (%ROUTER_IP%)..."
set "T_OK=[OK] Router disponible (%ROUTER_IP%)"
set "T_PASS=INTRODUZCA LA CONTRASENA DEL PANEL Y PULSE ENTER."
set "T_PASS_HINT=(La contrasena no se muestra - es una practica estandar.)"
set "T_ERR=[ERROR] El router %ROUTER_IP% no responde!"
set "T_ERR_TITLE=Causas posibles:"
set "T_ERR_1=1. No esta conectado a la red Wi-Fi o LAN del router."
set "T_ERR_2=2. VPN o Proxy en su PC bloquea la conexion con el router."
set "T_ERR_3=3. Compruebe el cable o la conexion Wi-Fi con el router."
set "T_SSH_ERR=[ERROR] Cliente OpenSSH no encontrado!"
set "T_SSH_HINT=Instalar: Configuracion - Aplicaciones - Caracteristicas opcionales - OpenSSH"
set "T_WAN_ERR=[ERROR] El router no tiene conexion a Internet!"
set "T_WAN_HINT=El propio router debe estar conectado a Internet (compruebe cable WAN, tarjeta SIM o Wi-Fi en 192.168.8.1)."
goto PROCEED

:SET_DE
set "LANG_CODE=de"
set "T_CHECK=Pruefe Verbindung zum Router (%ROUTER_IP%)..."
set "T_OK=[OK] Router erreichbar (%ROUTER_IP%)"
set "T_PASS=ADMIN-PASSWORT EINGEBEN UND ENTER DRUECKEN."
set "T_PASS_HINT=(Passwort wird не angezeigt - Standard.)"
set "T_ERR=[ERROR] Router %ROUTER_IP% ist nicht erreichbar!"
set "T_ERR_TITLE=Moegliche Ursachen:"
set "T_ERR_1=1. Sie sind nicht mit dem WLAN oder LAN des Routers verbunden."
set "T_ERR_2=2. VPN oder Proxy auf dem PC blockiert die Verbindung zum Router."
set "T_ERR_3=3. Kabel- oder WLAN-Verbindung zum Router pruefen."
set "T_SSH_ERR=[ERROR] OpenSSH-Client nicht gefunden!"
set "T_SSH_HINT=Installation: Einstellungen - Apps - Optionale Features - OpenSSH"
set "T_WAN_ERR=[FEHLER] Router hat keine Internetverbindung!"
set "T_WAN_HINT=Der Router selbst muss mit dem Internet verbunden sein (WAN-Kabel, SIM-Karte oder WLAN im Adminpanel 192.168.8.1 pruefen)."
goto PROCEED

:PROCEED
where ssh > nul 2>nul
if errorlevel 1 goto NO_SSH

echo [...] %T_CHECK%
ping -n 1 -w 2000 %ROUTER_IP% > nul 2>nul
if errorlevel 1 goto NO_ROUTER
echo %T_OK%
echo.
echo %T_PASS%
echo %T_PASS_HINT%
echo ==============================================================================

if exist "%USERPROFILE%\.ssh\known_hosts" ssh-keygen -R %ROUTER_IP% > nul 2>nul

ssh -tt -o StrictHostKeyChecking=accept-new root@%ROUTER_IP% "wget --no-check-certificate -qO /tmp/autopasswall.sh %INSTALLER_URL% || uclient-fetch -qO /tmp/autopasswall.sh %INSTALLER_URL%; if [ ! -s /tmp/autopasswall.sh ]; then exit 111; fi; tr -d '\r' < /tmp/autopasswall.sh > /tmp/.ap && mv -f /tmp/.ap /tmp/autopasswall.sh; chmod +x /tmp/autopasswall.sh; exec /bin/sh /tmp/autopasswall.sh --lang=%LANG_CODE%"
if %ERRORLEVEL% EQU 111 goto NO_WAN
goto END

:NO_WAN
color 0C
echo.
echo ==============================================================================
echo %T_WAN_ERR%
echo ==============================================================================
echo %T_WAN_HINT%
echo ==============================================================================
pause
exit /b 1

:NO_ROUTER
color 0C
echo.
echo ==============================================================================
echo %T_ERR%
echo ==============================================================================
echo %T_ERR_TITLE%
echo  %T_ERR_1%
echo  %T_ERR_2%
echo  %T_ERR_3%
echo ==============================================================================
pause
exit /b 1

:NO_SSH
color 0C
echo.
echo ==============================================================================
echo %T_SSH_ERR%
echo %T_SSH_HINT%
echo ==============================================================================
pause
exit /b 1

:END
echo.
pause