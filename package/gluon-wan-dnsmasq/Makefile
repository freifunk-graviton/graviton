include $(TOPDIR)/rules.mk

PKG_NAME:=graviton-wan-dnsmasq
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(GRAVITONDIR)/include/package.mk


define Package/graviton-wan-dnsmasq
  SECTION:=graviton
  CATEGORY:=Graviton
  TITLE:=Support for a secondary DNS server using the WAN interface
  DEPENDS:=+graviton-core +dnsmasq +libpacketmark
endef

define Package/graviton-wan-dnsmasq/description
	Graviton community wifi mesh firmware framework: Support for a secondary DNS server using the WAN interface
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
	$(call GravitonSrcDiet,./luasrc,$(PKG_BUILD_DIR)/luadest/)
endef

define Package/graviton-wan-dnsmasq/install
	$(CP) ./files/* $(1)/
	$(CP) $(PKG_BUILD_DIR)/luadest/* $(1)/
endef

$(eval $(call BuildPackage,graviton-wan-dnsmasq))
