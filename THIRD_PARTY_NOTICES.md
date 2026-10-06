# Third-party binary packages

This repository redistributes the following prebuilt OpenWrt packages
(unmodified) in `package/`. Each entry lists the exact hosted version and
the upstream source for that version.

| Package | Version | License | Upstream |
|---|---|---|---|
| luci-app-passwall | 26.9.27 | GPL-3.0 | https://github.com/Openwrt-Passwall/openwrt-passwall/releases |
| openwrt-xray | 26.9.9-1 | MPL-2.0 | https://github.com/yichya/openwrt-xray/releases |
| chinadns-ng | 2025.08.09-r1 | AGPL-3.0 | https://github.com/zfl9/chinadns-ng/releases |
| dns2socks | 2.1-r2 | BSD-3-Clause | https://github.com/Openwrt-Passwall/openwrt-passwall-packages/releases |
| microsocks | 1.0.5-r1 | MIT | https://github.com/rofl0r/microsocks |
| tcping | 0.3-r1 | GPL-2.0 | https://github.com/Lienol/tcping |

License texts: [LICENSES/](https://github.com/cbfst/pr-passwall/tree/main/LICENSES). This project's own scripts are MIT: [LICENSE](LICENSE).

When a package in `package/` is refreshed, update this table in the same commit.