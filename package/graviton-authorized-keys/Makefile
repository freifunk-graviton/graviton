include $(TOPDIR)/rules.mk

PKG_NAME:=graviton-authorized-keys
PKG_VERSION:=2

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(GLUONDIR)/include/package.mk


define Package/graviton-authorized-keys
  SECTION:=graviton
  CATEGORY:=Graviton
  TITLE:=Fill /etc/dropbear/authorized_keys from site.conf
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

define Package/graviton-authorized-keys/install
	$(CP) $(PKG_BUILD_DIR)/luadest/* $(1)/
endef

define Package/graviton-authorized-keys/postinst
#!/bin/sh
$(call GravitonCheckSite,check_site.lua)
endef

$(eval $(call BuildPackage,graviton-authorized-keys))
