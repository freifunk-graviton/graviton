# Copyright (C) 2013 Nils Schneider <nils at nilsschneider.net>
# Copyright (C) 2016 Vincent Wiemann <vincent.wiemann@ironai.com>
# This is free software, licensed under the Apache 2.0 license.

include $(TOPDIR)/rules.mk

PKG_NAME:=graviton-admin-theme
PKG_VERSION:=0.1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(GRAVITONDIR)/include/package.mk


define Package/graviton-admin-theme
  SECTION:=graviton
  CATEGORY:=Graviton
  TITLE:=Luci theme for Graviton
  DEPENDS:=+pretty-hostname
endef

define Package/graviton-admin-theme/description
	Luci based config mode
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
	$(call GravitonSrcDiet,./luasrc,$(PKG_BUILD_DIR)/luadest/)
endef

define Package/graviton-admin-theme/install
	$(CP) ./files/* $(1)/
	$(CP) $(PKG_BUILD_DIR)/luadest/* $(1)/
endef

$(eval $(call BuildPackage,graviton-admin-theme))
