include $(TOPDIR)/rules.mk

PKG_NAME:=graviton-ebtables
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk


define Package/graviton-ebtables
  SECTION:=graviton
  CATEGORY:=Graviton
  TITLE:=Ebtables support
  DEPENDS:=+graviton-core +ebtables +kmod-ebtables-ipv4 +kmod-ebtables-ipv6 +kmod-ipt-core
endef

define Package/graviton-ebtables/description
	Graviton community wifi mesh firmware framework: ebtables support
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/graviton-ebtables/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,graviton-ebtables))
