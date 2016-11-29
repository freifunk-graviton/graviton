include $(TOPDIR)/rules.mk

PKG_NAME:=graviton-admin-wireless
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(GRAVITONDIR)/include/package.mk

PKG_CONFIG_DEPENDS += $(GRAVITON_I18N_CONFIG)


define Package/graviton-admin-wireless
  SECTION:=graviton
  CATEGORY:=Graviton
  DEPENDS:=+graviton-admin-luci +libiwinfo-lua
  TITLE:=UI for Wifi Settings
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
	$(call GravitonBuildI18N,graviton-admin-wireless,i18n)
	$(call GravitonSrcDiet,./luasrc,$(PKG_BUILD_DIR)/luadest/)
endef

define Package/graviton-admin-wireless/install
	$(CP) $(PKG_BUILD_DIR)/luadest/* $(1)/
	$(call GravitonInstallI18N,graviton-admin-wireless,$(1))
endef

$(eval $(call BuildPackage,graviton-admin-wireless))
