# Copyright (C) 2024 manper
# This is free software, licensed under the GNU General Public License v2.

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI Support for switching to official system
LUCI_DEPENDS:=

include $(TOPDIR)/feeds/luci/luci.mk

# call Build Package - OpenWrt buildroot signature
$(eval $(call BuildPackage,luci-app-Secondsystem))
