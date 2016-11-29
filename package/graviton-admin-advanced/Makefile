# Copyright (C) 2013 Nils Schneider <nils at nilsschneider.net>
# This is free software, licensed under the Apache 2.0 license.

include $(TOPDIR)/rules.mk

PKG_NAME:=graviton-admin-advanced
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(GRAVITONDIR)/include/package.mk

PKG_CONFIG_DEPENDS += $(GRAVITON_I18N_CONFIG)


define Package/graviton-admin-advanced
  SECTION:=graviton
  CATEGORY:=Graviton
  TITLE:=Luci module for advanced settings
  DEPENDS:=+graviton-admin-luci
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
	$(call GravitonBuildI18N,graviton-admin-advanced,i18n)
	$(call GravitonSrcDiet,./luasrc,$(PKG_BUILD_DIR)/luadest/)
endef

define Package/graviton-admin-advanced/install
	$(CP) $(PKG_BUILD_DIR)/luadest/* $(1)/
	$(call GravitonInstallI18N,graviton-admin-advanced,$(1))
endef

$(eval $(call BuildPackage,graviton-admin-advanced))
