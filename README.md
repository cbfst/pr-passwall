# PassWall v1 Xray Tunnel 🛡️

[**<u>English</u>**](README.md) | [Русский](README.ru_RU.md) | [Español](README.es_ES.md) | [Deutsch](README.de_DE.md)

### PassWall v1 Xray Auto-Installer v2.0.0 [05-OCT-2026]

An automatic PassWall v1 installer for GL.iNet / OpenWrt — the stack was originally designed to run on **low-power routers with limited resources**. The installation process strictly controls memory usage and free space, removing all system clutter to ensure stable operation of PassWall v1 on modest hardware.

This project eliminates the version drift problem. All binary packages are taken from the official upstream repositories of their authors, but they only make it into this project after the entire bundle has been verified for compatibility with real routers. The script deploys a vetted package set in one click, removes conflicting duplicates, applies an unstoppable configuration, and adds a convenient CLI manager for controlling PassWall.

## 🛠️ Features

🚀 Fast installation — one-click deployment of a pre-verified PassWall v1 package stack.

📦 Up-to-date versions — dynamic selection of the latest builds from the repository, with no risk of a rollback.

🧹 Clean system — preventive removal of conflicting and outdated kernel packages during installation.

⚙️ Auto-configuration — automatic application of routing rules (Global Proxy, iptables, ports).

📊 Convenient CLI — a built-in console manager for controlling the service, logs, and updates.

🌐 IronUpdate — unstoppable opkg updates on GL.iNet routers with poor connectivity and unreachable domains.

---

## 🚀 Quick Start

Choose one of the two installation methods. **Method 1** is recommended — it is fully automatic, safe, and requires no manual connection to the router console.

### Method 1: Automatic Launcher (Recommended)

The script runs directly on your PC or smartphone. It will detect the router on the local network by itself, clean up stale or conflicting SSH keys, ask for the password, and deploy the entire required stack turnkey.

#### 💻 For Windows Users (7 / 8 / 10 / 11)
A ready-made automation package is available for Windows:

1. Download the official bat script: `passwall-oneclick-installer.bat`
2. Run it with a double-click (in Windows, confirm the run in the SmartScreen prompt if requested).
3. Follow the on-screen interactive prompts to complete the automatic deployment.

[![Download One-Click Installer](https://img.shields.io/badge/Download-Passwall%20OneClick%20Installer-green?style=for-the-badge&logo=windows)](https://github.com/cbfst/pr-passwall/raw/refs/heads/main/passwall-oneclick-installer.bat)

#### 📱 For Unix Systems and Smartphones

**Android [(Termux)](https://play.google.com/store/apps/details?id=com.termux) / Linux (Terminal) / macOS (Terminal):**
```sh
curl -fsSL https://raw.githubusercontent.com/cbfst/pr-passwall/main/autosetup.sh | tr -d '\r' > autosetup.sh && [ -s autosetup.sh ] && sh autosetup.sh
```

**iOS [(iSH App)](https://apps.apple.com/us/app/ish-shell/id1436902243):**
```sh
wget -qO- https://raw.githubusercontent.com/cbfst/pr-passwall/main/autosetup.sh | tr -d '\r' > autosetup.sh && [ -s autosetup.sh ] && sh autosetup.sh
```

---

### Method 2: Direct Installation via SSH on the Router

Use this option only if you have already connected to the router console over SSH by yourself.

```sh
wget -O autopasswall.sh https://raw.githubusercontent.com/cbfst/pr-passwall/main/autopasswall.sh && tr -d '\r' < autopasswall.sh > /tmp/.ap && mv -f /tmp/.ap autopasswall.sh && chmod +x autopasswall.sh && ash autopasswall.sh
```

#### Choosing a Language for Direct Installation
For a silent installation without interactive prompts, use the `--lang` flag:

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

## 🛠️ CLI Management (`passwall`)

After installation, a system management tool is available:

| Command | Description |
|---|---|
| `passwall start` | Start the proxy service |
| `passwall stop` | Stop the proxy service |
| `passwall restart` | Restart the service and routing rules |
| `passwall reload` | Reload the configuration without restarting the process |
| `passwall enable` | Enable autostart when the router powers on |
| `passwall disable` | Disable autostart when the router powers on |
| `passwall log` | Show the main PassWall v1 log |
| `passwall log-core` | Show the working log of the proxy core (Xray) |
| `passwall logread` | Filter the system log for PassWall 1 events |
| `passwall config` | Show the current UCI configuration |
| `passwall status` | Show the status of the main switch |
| `passwall raw-config` | Show the contents of `/etc/config/passwall` directly |
| `passwall update` | Check for and selectively update components and the manager from the repository |
| `passwall lang [lang]` | Change the manager interface language (`ru`, `en`, `es`, `de`) |
| `passwall remove` | Remove only the LuCI PassWall v1 interface |
| `passwall purge` | Completely remove PassWall v1, cores, and configurations |
| `passwall manager` | Show the management menu |

## 📊 Compatibility

| Hardware | Platform | Status |
|---|---|---|
| GL.iNet GL-E750 (Mudi v1 / v2) | MIPS 24Kc (QCA9531) | Compatible out of the box (128 MB Flash / 128 MB RAM) |
| GL.iNet GL-AR300M16 (Shadow) | MIPS 24Kc (QCA9531) | Requires memory expansion via [autoextroot](https://codeberg.org/cbfst/pr-tools/raw/#autoextroot) |
| Other OpenWrt v22+ routers | MIPS 24Kc | Compatible if ≥ 35 MB is available on `/overlay` |

> **GL-AR300M16 note:** the built-in 16 MB of NOR Flash is critically insufficient for hosting Xray and PassWall v1. Installation is only possible after expanding `/overlay` onto external storage using the `autoextroot` utility.

## 🗑️ Uninstallation

To completely remove PassWall v1, the Xray cores, accompanying utilities, and configurations, run:

```sh
passwall purge
```

## 📜 License

The installer and manager scripts are distributed under the MIT license. The PassWall v1 and Xray binary packages hosted in the `package/` directory are distributed under the terms of their own licenses (AGPL-3.0 / BSD-3-Clause / GPL-3.0 / GPL-2.0 / MIT / MPL-2.0), with all copyright notices of the original projects preserved.

The full MIT license text is available in the [LICENSE](LICENSE) file. Third-party package license texts are available in the [LICENSES](https://github.com/cbfst/pr-passwall/tree/main/LICENSES) directory. The exact versions and sources of each binary are listed in [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).

## ⚠️ Disclaimer

The software is provided "as is". The authors are not liable for equipment failures caused by flash-memory wear, insufficient power supply, or incorrect third-party modifications of the network stack.

## 🤝 Credits

The project is developed and maintained by [CyberFantomo Security Technologies](https://cbf.st).

## 📬 Contact the Team

* **E-mail:** shop@cyberfantomo.org
* **Telegram:** [@shop_cyberfantomo](https://t.me/shop_cyberfantomo)
* **Jabber:** shop_cyberfantomo@jabb.im (OMEMO)
* **Matrix:** shop_cyberfantomo@matrix.org
* **Simplex:** https://smp18.simplex.im/a#wXfNXcP319FOFs0iz1ulw52oQ3uVxXPEiO2PrUY-YM0
* **Session:** 051d4ee58c4131ca66f81e51b7e3d763e1cbca916506d53fd9470599b92d561777
* **TOX:** 76AFEEA3D27E7313E9E8F1B20EB07331B7988A5A6FFFDAC55573E5B938A2C91635C99EE33E16

---

## ☕ Support the Project

If CyberFantomo's work and technical solutions have been useful to you, saved you time, or helped you successfully complete your tasks, you can support the team and contribute to the development of our projects:

* **XMR:** `891DdwDRK1s3SDb7wEtUAYfY2nZUVnyPScDKWR9d4YarhKXg3jxxXskLf43tLBitxJhXJ1uCW25dTZH87zNirVsPEiP4JDN`
* **BTC:** `bc1pd735wqdvrr8gjqvhm2kumzdj2mrcgjz0etlhehaxw00un2kkshkspdv8tv`
* **LTC:** `MK6V1bBpqS6ndFLkaqN2PAASSZnFPeHnNz`
* **ETH:** `0xbadea4f945579e90eeb51079b3175f2aa678b8b9`
* **USDT TRC-20 / TRX:** `TDPvWdHhWCzrVZUb8PvJdC9WqVNBsuuD1s`
* **Other cryptocurrencies:** [ZEC, DASH, TON, SOL, etc.](https://plisio.net/donate/xGE8oIPW)<br>
> <sup>The Email field is technically required, but the address is not verified. If you wish to stay anonymous, simply enter any random email (for example, `anon@mail.com`).</sup>

---

## 🔄 Related Repositories

- [IronUpdate](https://codeberg.org/cbfst/pr-ironupdate) — an unstoppable one-click solution for recovering opkg and repositories on GL.iNet (OpenWrt) routers. It automatically repairs broken or blocked package feeds, discovers working mirrors, and enables seamless package installation even when the stock manager fails.
- [AutoExtroot](https://codeberg.org/cbfst/pr-tools/#autoextroot) — an unstoppable one-click extroot installer for OpenWrt routers. It expands the router's available system storage using a USB drive or microSD.
- [OpenWrt PassWall](https://github.com/Openwrt-Passwall/openwrt-passwall/releases) — official releases of the original PassWall package. The project provides the interface and routing logic for flexible management of proxying rules.
- [OpenWrt Xray](https://github.com/yichya/openwrt-xray/releases) — official releases of precompiled Xray-core packages for OpenWrt. They provide the router with basic support for modern tunneling protocols.
