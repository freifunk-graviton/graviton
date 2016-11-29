include $(TOPDIR)/rules.mk

PKG_NAME:=graviton-wifi-bridge
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(GRAVITONDIR)/include/package.mk


define Package/graviton-wifi-bridge
  SECTION:=graviton
  CATEGORY:=Graviton
  TITLE:=Provides a bridge with the wireless interface
  DEPENDS:=+graviton-core
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
	$(call GravitonSrcDiet,./luasrc,$(PKG_BUILD_DIR)/luadest/)
endef

define Package/graviton-wifi-bridge/install
	$(CP) $(PKG_BUILD_DIR)/luadest/* $(1)/
endef

define Package/graviton-wifi-bridge/postinst
#!/bin/sh
$(call GravitonCheckSite,check_site.lua)
endef

$(eval $(call BuildPackage,graviton-wifi-bridge))
