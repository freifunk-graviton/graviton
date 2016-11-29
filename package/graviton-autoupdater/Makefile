include $(TOPDIR)/rules.mk

PKG_NAME:=graviton-autoupdater
PKG_VERSION:=1
PKG_RELEASE:=$(GRAVITON_BRANCH)

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)
PKG_BUILD_DEPENDS := respondd

include $(GRAVITONDIR)/include/package.mk


define Package/graviton-autoupdater
  SECTION:=graviton
  CATEGORY:=Graviton
  DEPENDS:=+graviton-core +libgravitonutil +micrond +autoupdater
  TITLE:=Automatically update firmware
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Build/Compile
	$(call Build/Compile/Default)
	$(call GravitonSrcDiet,./luasrc,$(PKG_BUILD_DIR)/luadest/)
endef

define Package/graviton-autoupdater/install
	$(CP) ./files/* $(1)/
	$(CP) $(PKG_BUILD_DIR)/luadest/* $(1)/

	$(INSTALL_DIR) $(1)/lib/graviton/respondd
	$(CP) $(PKG_BUILD_DIR)/respondd.so $(1)/lib/graviton/respondd/autoupdater.so

	if [ '$(GRAVITON_BRANCH)' ]; then \
		$(INSTALL_DIR) $(1)/lib/graviton/autoupdater; \
		echo '$(GRAVITON_BRANCH)' > $(1)/lib/graviton/autoupdater/default_branch; \
	fi
endef

define Package/graviton-autoupdater/postinst
#!/bin/sh
$(call GravitonCheckSite,check_site.lua)
endef

$(eval $(call BuildPackage,graviton-autoupdater))
