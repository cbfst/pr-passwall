# PassWall v1 Xray Tunnel 🛡️

[English](README.md) | [Русский](README.ru_RU.md) | [**<u>Español</u>**](README.es_ES.md) | [Deutsch](README.de_DE.md)

### PassWall v1 Xray Auto-Installer v2.0.0 [05-OCT-2026]

Instalador automático de PassWall v1 para GL.iNet / OpenWrt — el stack fue diseñado desde el principio para funcionar en **routers de bajo consumo con recursos limitados**. El proceso de instalación controla de forma estricta el consumo de memoria y el espacio libre, eliminando toda la basura del sistema para garantizar un funcionamiento estable de PassWall v1 en hardware modesto.

Este proyecto elimina el problema de la divergencia de versiones. Todos los paquetes binarios se toman de los repositorios upstream oficiales de sus autores, pero entran en este proyecto únicamente después de verificar la compatibilidad de todo el conjunto con routers reales. El script despliega en un clic un conjunto de paquetes verificado, elimina los duplicados en conflicto, aplica una configuración unstoppable y añade un cómodo gestor CLI para controlar PassWall.

## 🛠️ Funcionalidades

🚀 Instalación rápida — despliegue en un clic de un stack de paquetes de PassWall v1 previamente verificado.

📦 Versiones actualizadas — selección dinámica de las compilaciones más recientes del repositorio, sin riesgo de retroceso.

🧹 Sistema limpio — eliminación preventiva de paquetes del kernel en conflicto u obsoletos durante la instalación.

⚙️ Autoconfiguración — aplicación automática de las reglas de enrutamiento (Global Proxy, iptables, puertos).

📊 CLI cómodo — gestor de consola integrado para controlar el servicio, los registros y las actualizaciones.

🌐 IronUpdate — actualizaciones unstoppable de opkg en routers GL.iNet con mala conectividad y dominios inaccesibles.

---

## 🚀 Inicio rápido

Elija uno de los dos métodos de instalación. Se recomienda el **Método 1** — es totalmente automático, seguro y no requiere conexión manual a la consola del router.

### Método 1: Lanzador automático (Recomendado)

El script se ejecuta directamente en su PC o smartphone. Detectará por sí solo el router en la red local, limpiará las claves SSH obsoletas o en conflicto, pedirá la contraseña y desplegará todo el stack necesario llave en mano.

#### 💻 Para usuarios de Windows (7 / 8 / 10 / 11)
Para sistemas operativos Windows se ha desarrollado un paquete de automatización listo para usar:

1. Descargue el script bat oficial: `passwall-oneclick-installer.bat`
2. Ejecútelo con un doble clic (en Windows, confirme la ejecución en la ventana de SmartScreen si se solicita).
3. Siga las indicaciones interactivas en pantalla para completar el despliegue automático.

[![Descargar One-Click Installer](https://img.shields.io/badge/Descargar-Passwall%20OneClick%20Installer-green?style=for-the-badge&logo=windows)](https://github.com/cbfst/pr-passwall/raw/refs/heads/main/passwall-oneclick-installer.bat)

#### 📱 Para sistemas Unix y smartphones

**Android [(Termux)](https://play.google.com/store/apps/details?id=com.termux) / Linux (Terminal) / macOS (Terminal):**
```sh
curl -fsSL https://raw.githubusercontent.com/cbfst/pr-passwall/main/autosetup.sh | tr -d '\r' > autosetup.sh && [ -s autosetup.sh ] && sh autosetup.sh
```

**iOS [(App iSH)](https://apps.apple.com/us/app/ish-shell/id1436902243):**
```sh
wget -qO- https://raw.githubusercontent.com/cbfst/pr-passwall/main/autosetup.sh | tr -d '\r' > autosetup.sh && [ -s autosetup.sh ] && sh autosetup.sh
```

---

### Método 2: Instalación directa por SSH en el router

Utilice esta opción solo si ya se ha conectado por su cuenta a la consola del router por SSH.

```sh
wget -O autopasswall.sh https://raw.githubusercontent.com/cbfst/pr-passwall/main/autopasswall.sh && tr -d '\r' < autopasswall.sh > /tmp/.ap && mv -f /tmp/.ap autopasswall.sh && chmod +x autopasswall.sh && ash autopasswall.sh
```

#### Selección de idioma en la instalación directa
Para una instalación silenciosa sin solicitudes interactivas, utilice el flag `--lang`:

```sh
/tmp/autopasswall.sh --lang=ru # Русский
```
```sh
/tmp/autopasswall.sh --lang=en # English
```
```sh
/tmp/autopasswall.sh --lang=es # Español
```
```sh
/tmp/autopasswall.sh --lang=de # Deutsch
```

## 🛠️ Gestión mediante CLI (`passwall`)

Tras la instalación estará disponible un gestor del sistema:

| Comando | Descripción |
|---|---|
| `passwall start` | Iniciar el servicio de proxy |
| `passwall stop` | Detener el servicio de proxy |
| `passwall restart` | Reiniciar el servicio y las reglas de enrutamiento |
| `passwall reload` | Recargar la configuración sin reiniciar el proceso |
| `passwall enable` | Activar el inicio automático al encender el router |
| `passwall disable` | Desactivar el inicio automático al encender el router |
| `passwall log` | Mostrar el registro principal de PassWall v1 |
| `passwall log-core` | Mostrar el registro de trabajo del núcleo de proxy (Xray) |
| `passwall logread` | Filtrar el registro del sistema por eventos de PassWall 1 |
| `passwall config` | Mostrar la configuración UCI actual |
| `passwall status` | Mostrar el estado del interruptor principal |
| `passwall raw-config` | Mostrar directamente el contenido de `/etc/config/passwall` |
| `passwall update` | Comprobar y actualizar de forma puntual los componentes y el gestor desde el repositorio |
| `passwall lang [lang]` | Cambiar el idioma de la interfaz del gestor (`ru`, `en`, `es`, `de`) |
| `passwall remove` | Eliminar únicamente la interfaz LuCI de PassWall v1 |
| `passwall purge` | Eliminar por completo PassWall v1, los núcleos y las configuraciones |
| `passwall manager` | Mostrar el menú de gestión |

## 📊 Compatibilidad

| Hardware | Plataforma | Estado |
|---|---|---|
| GL.iNet GL-E750 (Mudi v1 / v2) | MIPS 24Kc (QCA9531) | Compatible directamente (128 MB Flash / 128 MB RAM) |
| GL.iNet GL-AR300M16 (Shadow) | MIPS 24Kc (QCA9531) | Requiere ampliación de memoria mediante [autoextroot](https://codeberg.org/cbfst/pr-tools/#autoextroot) |
| Otros routers OpenWrt v22+ | MIPS 24Kc | Compatibles si hay ≥ 35 MB disponibles en `/overlay` |

> **Nota sobre GL-AR300M16:** los 16 MB de memoria NOR Flash integrados resultan radicalmente insuficientes para alojar Xray y PassWall v1. La instalación solo es posible tras ampliar `/overlay` a un almacenamiento externo mediante la utilidad `autoextroot`.

## 🗑️ Desinstalación

Para eliminar por completo PassWall v1, los núcleos de Xray, las utilidades asociadas y las configuraciones, ejecute:

```sh
passwall purge
```

## 📜 Licencia

Los scripts del instalador y del gestor se distribuyen bajo la licencia MIT. Los paquetes binarios de PassWall v1 y Xray alojados en el directorio `package/` se distribuyen bajo los términos de sus propias licencias (AGPL-3.0 / BSD-3-Clause / GPL-3.0 / GPL-2.0 / MIT / MPL-2.0), conservando todos los avisos de copyright de los proyectos originales.

El texto completo de la licencia MIT está disponible en el archivo [LICENSE](LICENSE). Los textos de las licencias de los paquetes de terceros están disponibles en el directorio [LICENSES](LICENSES). Las versiones exactas y las fuentes de cada binario se enumeran en [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).

## ⚠️ Aviso de responsabilidad

El software se proporciona «tal cual». Los autores no se hacen responsables de fallos del equipo causados por el desgaste de la memoria flash, un suministro de energía insuficiente o modificaciones incorrectas del stack de red por parte de terceros.

## 🤝 Autoría

El proyecto está desarrollado y mantenido por [CyberFantomo Security Technologies](https://www.cbf.st).

## 📬 Contacto con el equipo

* **E-mail:** shop@cyberfantomo.org
* **Telegram:** [@shop_cyberfantomo](https://t.me/shop_cyberfantomo)
* **Jabber:** shop_cyberfantomo@jabb.im (OMEMO)
* **Matrix:** shop_cyberfantomo@matrix.org
* **Simplex:** https://smp18.simplex.im/a#wXfNXcP319FOFs0iz1ulw52oQ3uVxXPEiO2PrUY-YM0
* **Session:** 051d4ee58c4131ca66f81e51b7e3d763e1cbca916506d53fd9470599b92d561777
* **TOX:** 76AFEEA3D27E7313E9E8F1B20EB07331B7988A5A6FFFDAC55573E5B938A2C91635C99EE33E16

---

## ☕ Apoyar el proyecto

Si el trabajo y las soluciones técnicas de CyberFantomo le han resultado útiles, le han ahorrado tiempo o le han ayudado a completar con éxito sus tareas, puede apoyar al equipo y contribuir al desarrollo de nuestros proyectos:

* **XMR:** `891DdwDRK1s3SDb7wEtUAYfY2nZUVnyPScDKWR9d4YarhKXg3jxxXskLf43tLBitxJhXJ1uCW25dTZH87zNirVsPEiP4JDN`
* **BTC:** `bc1pd735wqdvrr8gjqvhm2kumzdj2mrcgjz0etlhehaxw00un2kkshkspdv8tv`
* **LTC:** `MK6V1bBpqS6ndFLkaqN2PAASSZnFPeHnNz`
* **ETH:** `0xbadea4f945579e90eeb51079b3175f2aa678b8b9`
* **USDT TRC-20 / TRX:** `TDPvWdHhWCzrVZUb8PvJdC9WqVNBsuuD1s`
* **Otras criptomonedas:** [ZEC, DASH, TON, SOL, etc.](https://plisio.net/donate/xGE8oIPW)<br>
> <sup>El campo de Email es técnicamente obligatorio, pero la dirección no se verifica. Si desea mantener el anonimato, introduzca simplemente cualquier correo aleatorio (por ejemplo, `anon@mail.com`).</sup>

---

## 🔄 Repositorios relacionados

- [IronUpdate](https://codeberg.org/cbfst/pr-ironupdate) — solución one-click unstoppable para recuperar opkg y los repositorios en routers GL.iNet (OpenWrt). Repara automáticamente los feeds de paquetes rotos o bloqueados, descubre espejos funcionales y permite instalar paquetes sin problemas incluso cuando el gestor de fábrica falla.
- [AutoExtroot](https://codeberg.org/cbfst/pr-tools/#autoextroot) — instalador one-click unstoppable de extroot para routers OpenWrt. Amplía el almacenamiento del sistema disponible en el router mediante una memoria USB o microSD.
- [OpenWrt PassWall](https://github.com/Openwrt-Passwall/openwrt-passwall/releases) — versiones oficiales del paquete PassWall original. El proyecto proporciona la interfaz y la lógica de enrutamiento para una gestión flexible de las reglas de proxy.
- [OpenWrt Xray](https://github.com/yichya/openwrt-xray/releases) — versiones oficiales de los paquetes precompilados de Xray-core para OpenWrt. Proporcionan al router soporte básico de protocolos de tunelización modernos.