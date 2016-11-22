# Copyright (C) 2013 Nils Schneider <nils at nilsschneider.net>
# Copyright (C) 2016 Vincent Wiemann <vincent.wiemann@ironai.com>
# This is free software, licensed under the Apache 2.0 license.

include $(TOPDIR)/rules.mk

PKG_NAME:=graviton-luci-admin
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(GLUONDIR)/include/package.mk

PKG_CONFIG_DEPENDS += $(GLUON_I18N_CONFIG)


define Package/graviton-luci-admin
  SECTION:=graviton
  CATEGORY:=Graviton
  TITLE:=Luci based simple administration interface
  DEPENDS:=graviton-config-mode-core-virtual +pretty-hostname
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
	$(call GravitonBuildI18N,graviton-luci-admin,i18n)
	$(call GravitonSrcDiet,./luasrc,$(PKG_BUILD_DIR)/luadest/)
endef

define Package/graviton-luci-admin/install
	$(CP) ./files/* $(1)/
	$(CP) $(PKG_BUILD_DIR)/luadest/* $(1)/
	$(call GravitonInstallI18N,graviton-luci-admin,$(1))
endef

$(eval $(call BuildPackage,graviton-luci-admin))
