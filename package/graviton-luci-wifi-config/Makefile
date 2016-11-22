include $(TOPDIR)/rules.mk

PKG_NAME:=graviton-luci-wifi-config
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(GLUONDIR)/include/package.mk

PKG_CONFIG_DEPENDS += $(GLUON_I18N_CONFIG)


define Package/graviton-luci-wifi-config
  SECTION:=graviton
  CATEGORY:=Graviton
  DEPENDS:=+graviton-luci-admin +libiwinfo-lua
  TITLE:=UI for Wifi Settings
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
	$(call GravitonBuildI18N,graviton-luci-wifi-config,i18n)
	$(call GravitonSrcDiet,./luasrc,$(PKG_BUILD_DIR)/luadest/)
endef

define Package/graviton-luci-wifi-config/install
	$(CP) $(PKG_BUILD_DIR)/luadest/* $(1)/
	$(call GravitonInstallI18N,graviton-luci-wifi-config,$(1))
endef

$(eval $(call BuildPackage,graviton-luci-wifi-config))
