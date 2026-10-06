# PassWall v1 Xray Tunnel 🛡️

[English](README.md) | [Русский](README.ru_RU.md) | [Español](README.es_ES.md) | [**<u>Deutsch</u>**](README.de_DE.md)

### PassWall v1 Xray Auto-Installer v2.0.0 [05-OCT-2026]

Automatischer PassWall-v1-Installer für GL.iNet / OpenWrt — das Stack wurde von Grund auf für den Betrieb auf **schwachen Routern mit begrenzten Ressourcen** entwickelt. Der Installationsprozess kontrolliert streng den Speicherverbrauch und den freien Platz und entfernt gesamten Systemballast, um einen stabilen Betrieb von PassWall v1 auf bescheidener Hardware zu gewährleisten.

Dieses Projekt beseitigt das Problem der Versions-Divergenz. Alle Binärpakete stammen aus den offiziellen Upstream-Repositories ihrer Autoren, gelangen jedoch erst in dieses Projekt, nachdem das gesamte Ensemble auf Kompatibilität mit echten Routern überprüft wurde. Das Skript stellt mit einem Klick ein verifiziertes Paketset bereit, entfernt konfliktreiche Duplikate, wendet eine unstoppable-Konfiguration an und ergänzt einen komfortablen CLI-Manager zur Steuerung von PassWall.

## 🛠️ Funktionen

🚀 Schnelle Installation — One-Click-Deployment eines vorab verifizierten PassWall-v1-Paketstacks.

📦 Aktuelle Versionen — dynamische Auswahl der neuesten Builds aus dem Repository, ohne Risiko eines Rollbacks.

🧹 Sauberes System — präventive Entfernung konfliktreicher und veralteter Kernel-Pakete während der Installation.

⚙️ Autokonfiguration — automatische Anwendung der Routing-Regeln (Global Proxy, iptables, Ports).

📊 Komfortabler CLI — ein integrierter Konsolen-Manager zur Steuerung des Dienstes, der Logs und der Updates.

🌐 IronUpdate — unstoppable opkg-Updates auf GL.iNet-Routern bei schlechter Konnektivität und nicht erreichbaren Domänen.

---

## 🚀 Schnellstart

Wählen Sie eine der beiden Installationsmethoden. **Methode 1** wird empfohlen — sie ist vollständig automatisch, sicher und erfordert keine manuelle Verbindung mit der Router-Konsole.

### Methode 1: Automatischer Launcher (Empfohlen)

Das Skript läuft direkt auf Ihrem PC oder Smartphone. Es erkennt den Router im lokalen Netzwerk selbstständig, bereinigt veraltete oder konfliktreiche SSH-Schlüssel, fragt nach dem Passwort und stellt das gesamte benötigte Stack schlüsselfertig bereit.

#### 💻 Für Windows-Benutzer (7 / 8 / 10 / 11)
Für Windows-Betriebssysteme steht ein fertiges Automatisierungspaket bereit:

1. Laden Sie das offizielle Bat-Skript herunter: `passwall-oneclick-installer.bat`
2. Starten Sie es per Doppelklick (bestätigen Sie in Windows die Ausführung gegebenenfalls im SmartScreen-Dialog).
3. Folgen Sie den interaktiven Anweisungen auf dem Bildschirm, um die automatische Bereitstellung abzuschließen.

[![One-Click-Installer herunterladen](https://img.shields.io/badge/Herunterladen-Passwall%20OneClick%20Installer-green?style=for-the-badge&logo=windows)](https://github.com/cbfst/pr-passwall/raw/refs/heads/main/passwall-oneclick-installer.bat)

#### 📱 Für Unix-Systeme und Smartphones

**Android [(Termux)](https://play.google.com/store/apps/details?id=com.termux) / Linux (Terminal) / macOS (Terminal):**
```sh
curl -fsSL https://raw.githubusercontent.com/cbfst/pr-passwall/main/autosetup.sh | tr -d '\r' > autosetup.sh && [ -s autosetup.sh ] && sh autosetup.sh
```

**iOS [(iSH App)](https://apps.apple.com/us/app/ish-shell/id1436902243):**
```sh
wget -qO- https://raw.githubusercontent.com/cbfst/pr-passwall/main/autosetup.sh | tr -d '\r' > autosetup.sh && [ -s autosetup.sh ] && sh autosetup.sh
```

---

### Methode 2: Direkte Installation über SSH auf dem Router

Verwenden Sie diese Option nur, wenn Sie sich bereits selbstständig über SSH mit der Router-Konsole verbunden haben.

```sh
wget -O autopasswall.sh https://raw.githubusercontent.com/cbfst/pr-passwall/main/autopasswall.sh && tr -d '\r' < autopasswall.sh > /tmp/.ap && mv -f /tmp/.ap autopasswall.sh && chmod +x autopasswall.sh && ash autopasswall.sh
```

#### Sprachwahl bei der direkten Installation
Für eine stille Installation ohne interaktive Abfragen verwenden Sie den Flag `--lang`:

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

## 🛠️ Verwaltung über den CLI (`passwall`)

Nach der Installation steht ein System-Manager zur Verfügung:

| Befehl | Beschreibung |
|---|---|
| `passwall start` | Den Proxy-Dienst starten |
| `passwall stop` | Den Proxy-Dienst stoppen |
| `passwall restart` | Den Dienst und die Routing-Regeln neu starten |
| `passwall reload` | Die Konfiguration ohne Neustart des Prozesses neu laden |
| `passwall enable` | Autostart beim Einschalten des Routers aktivieren |
| `passwall disable` | Autostart beim Einschalten des Routers deaktivieren |
| `passwall log` | Das Haupt-Log von PassWall v1 ausgeben |
| `passwall log-core` | Das Arbeits-Log des Proxy-Kerns (Xray) ausgeben |
| `passwall logread` | Das Systemprotokoll nach PassWall-1-Ereignissen filtern |
| `passwall config` | Die aktuelle UCI-Konfiguration ausgeben |
| `passwall status` | Den Status des Hauptschalters anzeigen |
| `passwall raw-config` | Den Inhalt von `/etc/config/passwall` direkt anzeigen |
| `passwall update` | Komponenten und Manager aus dem Repository prüfen und gezielt aktualisieren |
| `passwall lang [lang]` | Die Sprache der Manager-Oberfläche wechseln (`ru`, `en`, `es`, `de`) |
| `passwall remove` | Nur die LuCI-Oberfläche von PassWall v1 entfernen |
| `passwall purge` | PassWall v1, Kerne und Konfigurationen vollständig entfernen |
| `passwall manager` | Das Verwaltungsmenü anzeigen |

## 📊 Kompatibilität

| Hardware | Plattform | Status |
|---|---|---|
| GL.iNet GL-E750 (Mudi v1 / v2) | MIPS 24Kc (QCA9531) | Direkt kompatibel (128 MB Flash / 128 MB RAM) |
| GL.iNet GL-AR300M16 (Shadow) | MIPS 24Kc (QCA9531) | Erfordert eine Speichererweiterung über [autoextroot](https://codeberg.org/cbfst/pr-tools/#autoextroot) |
| Weitere OpenWrt-v22+-Router | MIPS 24Kc | Kompatibel, wenn ≥ 35 MB auf `/overlay` verfügbar sind |

> **Hinweis zum GL-AR300M16:** Die integrierten 16 MB NOR-Flash sind bei Weitem nicht ausreichend, um Xray und PassWall v1 unterzubringen. Eine Installation ist erst nach der Erweiterung von `/overlay` auf einen externen Speicher mit dem Dienstprogramm `autoextroot` möglich.

## 🗑️ Deinstallation

Um PassWall v1, die Xray-Kerne, die zugehörigen Dienstprogramme und Konfigurationen vollständig zu entfernen, führen Sie aus:

```sh
passwall purge
```

## 📜 Lizenz

Die Skripte des Installers und des Managers werden unter der MIT-Lizenz vertrieben. Die im Verzeichnis `package/` bereitgestellten Binärpakete von PassWall v1 und Xray werden zu den Bedingungen ihrer eigenen Lizenzen (AGPL-3.0 / BSD-3-Clause / GPL-3.0 / GPL-2.0 / MIT / MPL-2.0) vertrieben, wobei alle Copyright-Hinweise der Originalprojekte erhalten bleiben.

Der vollständige MIT-Lizenztext ist in der Datei [LICENSE](LICENSE) verfügbar. Die Lizenztexte der Drittanbieter-Pakete sind im Verzeichnis [LICENSES](LICENSES) verfügbar. Die genauen Versionen und Quellen jedes Binärpakets sind in [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) aufgeführt.

## ⚠️ Haftungsausschluss

Die Software wird „so wie sie ist“ bereitgestellt. Die Autoren haften nicht für Geräteausfälle, die durch Flash-Speicher-Verschleiß, unzureichende Stromversorgung oder fehlerhafte Modifikationen des Netzwerk-Stacks durch Dritte verursacht werden.

## 🤝 Urheberschaft

Das Projekt wird von [CyberFantomo Security Technologies](https://www.cbf.st) entwickelt und betreut.

## 📬 Kontakt zum Team

* **E-mail:** shop@cyberfantomo.org
* **Telegram:** [@shop_cyberfantomo](https://t.me/shop_cyberfantomo)
* **Jabber:** shop_cyberfantomo@jabb.im (OMEMO)
* **Matrix:** shop_cyberfantomo@matrix.org
* **Simplex:** https://smp18.simplex.im/a#wXfNXcP319FOFs0iz1ulw52oQ3uVxXPEiO2PrUY-YM0
* **Session:** 051d4ee58c4131ca66f81e51b7e3d763e1cbca916506d53fd9470599b92d561777
* **TOX:** 76AFEEA3D27E7313E9E8F1B20EB07331B7988A5A6FFFDAC55573E5B938A2C91635C99EE33E16

---

## ☕ Das Projekt unterstützen

Wenn Ihnen die Arbeiten und technischen Lösungen von CyberFantomo nützlich waren, Zeit gespart oder bei der erfolgreichen Umsetzung Ihrer Aufgaben geholfen haben, können Sie das Team unterstützen und einen Beitrag zur Entwicklung unserer Projekte leisten:

* **XMR:** `891DdwDRK1s3SDb7wEtUAYfY2nZUVnyPScDKWR9d4YarhKXg3jxxXskLf43tLBitxJhXJ1uCW25dTZH87zNirVsPEiP4JDN`
* **BTC:** `bc1pd735wqdvrr8gjqvhm2kumzdj2mrcgjz0etlhehaxw00un2kkshkspdv8tv`
* **LTC:** `MK6V1bBpqS6ndFLkaqN2PAASSZnFPeHnNz`
* **ETH:** `0xbadea4f945579e90eeb51079b3175f2aa678b8b9`
* **USDT TRC-20 / TRX:** `TDPvWdHhWCzrVZUb8PvJdC9WqVNBsuuD1s`
* **Weitere Kryptowährungen:** [ZEC, DASH, TON, SOL, etc.](https://plisio.net/donate/xGE8oIPW)<br>
> <sup>Das E-Mail-Feld ist technisch erforderlich, die Adresse wird jedoch nicht überprüft. Wenn Sie anonym bleiben möchten, geben Sie einfach eine zufällige E-Mail-Adresse ein (z. B. `anon@mail.com`).</sup>

---

## 🔄 Verwandte Repositories

- [IronUpdate](https://codeberg.org/cbfst/pr-ironupdate) — unstoppable One-Click-Lösung zur Wiederherstellung von opkg und Repositories auf GL.iNet-Routern (OpenWrt). Repariert automatisch defekte oder blockierte Paket-Feeds, findet funktionierende Mirrors und ermöglicht eine reibungslose Paketinstallation, selbst wenn der Werks-Manager versagt.
- [AutoExtroot](https://codeberg.org/cbfst/pr-tools/#autoextroot) — unstoppable One-Click-Extroot-Installer für OpenWrt-Router. Erweitert den verfügbaren Systemspeicher des Routers per USB-Stick oder microSD.
- [OpenWrt PassWall](https://github.com/Openwrt-Passwall/openwrt-passwall/releases) — offizielle Releases des originalen PassWall-Pakets. Das Projekt liefert die Oberfläche und die Routing-Logik für eine flexible Verwaltung der Proxy-Regeln.
- [OpenWrt Xray](https://github.com/yichya/openwrt-xray/releases) — offizielle Releases der vorkompilierten Xray-core-Pakete für OpenWrt. Sie bieten dem Router grundlegende Unterstützung moderner Tunneling-Protokolle.