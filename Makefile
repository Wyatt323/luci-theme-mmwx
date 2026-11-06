# SPDX-License-Identifier: Apache-2.0

include $(TOPDIR)/rules.mk

LUCI_TITLE:=MMWX-inspired theme for LuCI
LUCI_DEPENDS:=+luci-base
LUCI_URL:=https://github.com/Wyatt323/luci-theme-mmwx
PKG_LICENSE:=Apache-2.0
PKG_VERSION:=0.1.0
PKG_RELEASE:=3
LUCI_MINIFY_CSS:=0
LUCI_MINIFY_JS:=0

# ZIP extraction on Windows may not retain the executable bit.
define Build/Prepare/luci-theme-mmwx
	chmod 0755 $(PKG_BUILD_DIR)/root/etc/uci-defaults/30_luci-theme-mmwx
endef

define Package/luci-theme-mmwx/postrm
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] || {
	uci -q delete luci.themes.MMWX
	uci commit luci
}
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
