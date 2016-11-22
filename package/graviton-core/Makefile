include $(TOPDIR)/rules.mk

PKG_NAME:=graviton-core
PKG_VERSION:=1
PKG_RELEASE:=$(GRAVITON_VERSION)

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(GRAVITONDIR)/include/package.mk


define Package/graviton-core
  SECTION:=graviton
  CATEGORY:=Graviton
  TITLE:=Base files of Graviton
  DEPENDS:=+graviton-site +libgravitonutil +lua-platform-info +lua-hash +luci-base +luci-lib-jsonc +odhcp6c +firewall +pretty-hostname
endef

define Package/graviton-core/description
	Graviton community wifi mesh firmware framework: core
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
	$(call GravitonSrcDiet,./luasrc,$(PKG_BUILD_DIR)/luadest/)
endef

define Package/graviton-core/install
	$(CP) ./files/* $(1)/
	$(CP) $(PKG_BUILD_DIR)/luadest/* $(1)/
	$(SED) 's/__GRAVITON_OPENWRT_FEEDS__/{$(GRAVITON_OPENWRT_FEEDS:%="%",)}/' $(1)/lib/graviton/upgrade/500-opkg

	$(INSTALL_DIR) $(1)/lib/graviton
	echo "$(GRAVITON_VERSION)" > $(1)/lib/graviton/graviton-version
endef

define Package/graviton-core/postinst
#!/bin/sh
$(call GravitonCheckSite,check_site.lua)
endef

$(eval $(call BuildPackage,graviton-core))
