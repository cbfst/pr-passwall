# PassWall v1 Xray Tunnel 🛡️

[English](README.md) | [**<u>Русский</u>**](README.ru_RU.md) | [Español](README.es_ES.md) | [Deutsch](README.de_DE.md)

### PassWall v1 Xray Auto-Installer v2.0.0 [05-OCT-2026]

Автоматический установщик PassWall v1 для GL.iNet / OpenWrt - cтек изначально спроектирован для работы на **маломощных роутерах с ограниченными ресурсами**. Процесс установки жестко контролирует потребление памяти и свободное место, удаляя весь системный мусор для стабильной работы PassWall v1 на слабом железе.

Данный проект устраняет проблему рассинхронизации версий. Все бинарные пакеты берутся из официальных апстрим-репозиториев авторов, но попадают в этот проект строго после проверки всей связки на совместимость с реальными роутерами. Скрипт в один клик разворачивает проверенный срез пакетов, исключает конфликтующие дубликаты, прописывает отказоустойчивую конфигурацию и добавляет удобный CLI-менеджер для управления PassWall.

## 🛠️ Возможности

🚀 Быстрая установка — автоматическое развёртывание проверенного стека пакетов PassWall v1 в один клик.

📦 Свежие версии — динамический подбор наиболее актуальных сборок из репозитория без риска отката.

🧹 Чистая система — превентивное удаление конфликтующих и устаревших пакетов ядра при установке.

⚙️ Автонастройка — автоматическое применение правил маршрутизации (Global Proxy, Iptables, порты).

📊 Удобный CLI — встроенный консольный менеджер для управления службой, логами и обновлениями.

🌐 IronUpdate — отказоустойчивое обновление opkg на роутерах GL.iNet при плохой сети и недоступных доменах.

---

## 🚀 Быстрый старт

Выберите один из двух способов установки. Рекомендуется **Способ 1** — он полностью автоматический, безопасный и не требует ручного подключения к консоли роутера.

### Способ 1: Автоматический лаунчер (Рекомендуется)

Скрипт запускается прямо на вашем персональном компьютере или смартфоне. Он самостоятельно обнаружит роутер в локальной сети, очистит устаревшие или конфликтующие SSH-ключи, запросит пароль и развернёт весь необходимый стек «под ключ».

#### 💻 Для пользователей Windows (7 / 8 / 10 / 11)
Для операционных систем Windows разработан готовый исполняемый пакет автоматизации:

1. Скачайте официальный bat-скрипт: `passwall-oneclick-installer.bat`
2. Запустите его двойным щелчком мыши (в Windows при необходимости подтвердите запуск в окне SmartScreen).
3. Следуйте интерактивным подсказкам на экране для автоматического развёртывания.

[![Скачать One-Click Installer](https://img.shields.io/badge/Скачать-Passwall%20OneClick%20Installer-green?style=for-the-badge&logo=windows)](https://github.com/cbfst/pr-passwall/raw/refs/heads/main/passwall-oneclick-installer.bat)

#### 📱 Для Unix-систем и смартфонов

**Android [(Termux)](https://play.google.com/store/apps/details?id=com.termux) / Linux (Terminal) / macOS (Terminal):**
```sh
curl -fsSL https://raw.githubusercontent.com/cbfst/pr-passwall/main/autosetup.sh | tr -d '\r' > autosetup.sh && [ -s autosetup.sh ] && sh autosetup.sh
```

**iOS [(iSH App)](https://apps.apple.com/us/app/ish-shell/id1436902243):**
```sh
wget -qO- https://raw.githubusercontent.com/cbfst/pr-passwall/main/autosetup.sh | tr -d '\r' > autosetup.sh && [ -s autosetup.sh ] && sh autosetup.sh
```

---

### Способ 2: Прямая установка через SSH на роутере

Используйте этот вариант, только если вы уже самостоятельно подключились к консоли роутера по SSH.

```sh
wget -O https://raw.githubusercontent.com/cbfst/pr-passwall/main/autopasswall.sh && tr -d '\r' < autopasswall.sh > /tmp/.ap && mv -f /tmp/.ap autopasswall.sh && chmod +x autopasswall.sh && ash autopasswall.sh
```

#### Выбор языка при прямой установке
Для тихой установки без интерактивных запросов используйте флаг `--lang` (`en, ru, es, de`):

```sh
wget -O autopasswall.sh https://codeberg.org/cbfst/pr-passwall/raw/branch/main/autopasswall.sh && tr -d '\r' < autopasswall.sh > /tmp/.ap && mv -f /tmp/.ap autopasswall.sh && chmod +x autopasswall.sh && ash autopasswall.sh --lang=ru
```

## 🛠️ Управление через CLI (`passwall`)

После установки доступен системный менеджер управления:

| Команда | Описание |
|---|---|
| `passwall start` | Запустить службу проксирования |
| `passwall stop` | Остановить службу проксирования |
| `passwall restart` | Перезапустить службу и правила маршрутизации |
| `passwall reload` | Перезагрузить конфигурацию без перезапуска процесса |
| `passwall enable` | Включить автозапуск при включении роутера |
| `passwall disable` | Выключить автозапуск при включении роутера |
| `passwall log` | Вывести основной лог PassWall v1 |
| `passwall log-core` | Вывести рабочий лог прокси-ядра (Xray) |
| `passwall logread` | Отфильтровать системный журнал по событиям PassWall 1 |
| `passwall config` | Вывести текущую конфигурацию UCI |
| `passwall status` | Показать статус главного переключателя |
| `passwall raw-config` | Показать содержимое `/etc/config/passwall` напрямую |
| `passwall update` | Проверить и точечно обновить компоненты и менеджер из репозитория |
| `passwall lang [lang]` | Сменить язык интерфейса менеджера (`ru`, `en`, `es`, `de`) |
| `passwall remove` | Удалить только интерфейс LuCI PassWall v1 |
| `passwall purge` | Полностью удалить PassWall v1, ядра и конфигурации |
| `passwall manager` | Показать меню управления |

## 📊 Совместимость

| Оборудование | Платформа | Статус |
|---|---|---|
| GL.iNet GL-E750 (Mudi v1 / v2) | MIPS 24Kc (QCA9531) | Совместим из коробки (128 МБ Flash / 128 МБ RAM) |
| GL.iNet GL-AR300M16 (Shadow) | MIPS 24Kc (QCA9531) | Требуется расширение памяти через [autoextroot](https://codeberg.org/cbfst/pr-tools/#autoextroot) |
| Другие роутеры OpenWrt v22+ | MIPS 24Kc | Совместимы при наличии ≥ 35 МБ на `/overlay` |

> **Примечание по GL-AR300M16:** встроенной памяти 16 МБ NOR Flash категорически недостаточно для размещения Xray и PassWall v1. Установка возможна только после расширения `/overlay` на внешний накопитель с помощью утилиты `autoextroot`.

## 🗑️ Удаление

Для полного удаления PassWall v1, ядер Xray, сопутствующих утилит и конфигураций выполните:

```sh
passwall purge
```

## 📜 Лицензия

Скрипты установщика и менеджера распространяются под лицензией MIT. Бинарные пакеты PassWall v1 и Xray, размещённые в каталоге `package/`, распространяются на условиях их собственных лицензий (AGPL-3.0 / BSD-3-Clause / GPL-3.0 / GPL-2.0 / MIT / MPL-2.0) с сохранением всех авторских прав исходных проектов.

Полный текст лицензии MIT — в файле [LICENSE](LICENSE). Тексты лицензий сторонних пакетов — в каталоге [LICENSES](LICENSES). Точные версии и источники каждого бинарника — в [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).

## ⚠️ Отказ от ответственности

Программное обеспечение предоставляется «как есть». Авторы не несут ответственности за сбои в работе оборудования, вызванные аппаратным износом flash-памяти, нехваткой питания или некорректными сторонними модификациями сетевого стека.

## 🤝 Авторство

Проект разработан и поддерживается [CyberFantomo Security Technologies](https://www.cbf.st).

## 📬 Связь с командой

* **E-mail:** shop@cyberfantomo.org
* **Telegram:** [@shop_cyberfantomo](https://t.me/shop_cyberfantomo)
* **Jabber:** shop_cyberfantomo@jabb.im (OMEMO)
* **Matrix:** shop_cyberfantomo@matrix.org
* **Simplex:** https://smp18.simplex.im/a#wXfNXcP319FOFs0iz1ulw52oQ3uVxXPEiO2PrUY-YM0
* **Session:** 051d4ee58c4131ca66f81e51b7e3d763e1cbca916506d53fd9470599b92d561777
* **TOX:** 76AFEEA3D27E7313E9E8F1B20EB07331B7988A5A6FFFDAC55573E5B938A2C91635C99EE33E16

## ☕ Поддержать проект

Если наработки и технические решения CyberFantomo оказались полезны, сэкономили ваше время или помогли успешно реализовать ваши задачи, вы можете поддержать команду и внести вклад в развитие наших проектов:

* **XMR:** `891DdwDRK1s3SDb7wEtUAYfY2nZUVnyPScDKWR9d4YarhKXg3jxxXskLf43tLBitxJhXJ1uCW25dTZH87zNirVsPEiP4JDN`
* **BTC:** `bc1pd735wqdvrr8gjqvhm2kumzdj2mrcgjz0etlhehaxw00un2kkshkspdv8tv`
* **LTC:** `MK6V1bBpqS6ndFLkaqN2PAASSZnFPeHnNz`
* **ETH:** `0xbadea4f945579e90eeb51079b3175f2aa678b8b9`
* **USDT TRC-20 / TRX:** `TDPvWdHhWCzrVZUb8PvJdC9WqVNBsuuD1s`
* **Другие криптовалюты:** [ZEC, DASH, TON, SOL, etc.](https://plisio.net/donate/xGE8oIPW)<br>
> <sup>Поле Email требуется технически, но адрес не проверяется. Если вы хотите сохранить анонимность, просто введите любой случайный маил (например, `anon@mail.com`).</sup>

---

## 🔄 Связанные репозитории

- [IronUpdate](https://codeberg.org/cbfst/pr-ironupdate) — отказоустойчивое one-click решение для восстановления работы opkg и репозиториев на роутерах GL.iNet (OpenWrt). Автоматически исправляет недоступные фиды, находит рабочие зеркала и возвращает возможность ставить пакеты.
- [AutoExtroot](https://codeberg.org/cbfst/pr-tools/#autoextroot) — отказоустойчивый one-click установщик extroot для роутеров OpenWrt. Увеличивает доступную системную память роутера за счёт USB-накопителя или microSD.
- [OpenWrt PassWall](https://github.com/Openwrt-Passwall/openwrt-passwall/releases) — официальные релизы оригинального пакета PassWall. Проект предоставляет интерфейс и логику маршрутизации для гибкого управления правилами проксирования.
- [OpenWrt Xray](https://github.com/yichya/openwrt-xray/releases) — официальные релизы скомпилированных пакетов Xray-core под OpenWrt. Обеспечивают роутер базовой поддержкой современных протоколов туннелирования.

