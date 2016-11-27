# Copyright (C) 2012 Nils Schneider <nils at nilsschneider.net>
# Copyright (C) 2016 Vincent Wiemann <vincent.wiemann@ironai.com>
# This is free software, licensed under the Apache 2.0 license.

include $(TOPDIR)/rules.mk

PKG_NAME:=graviton-admin-core
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(GRAVITONDIR)/include/package.mk


define Package/graviton-admin-core
  SECTION:=graviton
  CATEGORY:=Graviton
  TITLE:=Setup mode
  DEPENDS:=+graviton-core +uhttpd +dnsmasq
  PROVIDES:=graviton-admin-core-virtual
endef

define Package/graviton-admin-core/description
	Failsafe mode, core Graviton Luci files and config
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
	$(call GravitonSrcDiet,./luasrc,$(PKG_BUILD_DIR)/luadest/)
endef

define Package/graviton-admin-core/install
	$(CP) ./files/* $(1)/
	$(CP) $(PKG_BUILD_DIR)/luadest/* $(1)/
endef

define Package/graviton-admin-core/postinst
#!/bin/sh
$(call GravitonCheckSite,check_site.lua)
endef

$(eval $(call BuildPackage,graviton-admin-core))
