include $(TOPDIR)/rules.mk

PKG_NAME:=gravitonhmac
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(GRAVITONDIR)/include/package.mk

define Package/gravitonhmac
  SECTION:=graviton
  CATEGORY:=Graviton
  TITLE:=Hybrid TDMA userspace program
  DEPENDS:=+lzmq +libzmq-nc +libevent2 +libnl-tiny
endef

define Package/gravitonhmac/description
	Hybrid TDMA userspace program based on hMAC
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Build/Configure
endef

define Build/Compile
	$(call GravitonSrcDiet,./luasrc,$(PKG_BUILD_DIR)/luadest/)
	$(MAKE) -C $(PKG_BUILD_DIR) \
		LIBS="-nodefaultlibs -lgcc -lc -luClibc++" \
		LDFLAGS="$(EXTRA_LDFLAGS)" \
		CXXFLAGS="$(TARGET_CFLAGS) $(EXTRA_CPPFLAGS) -nostdinc++" \
		$(TARGET_CONFIGURE_OPTS) \
		CROSS="$(TARGET_CROSS)" \
		ARCH="$(ARCH)" \
		$(1);
endef

define Package/gravitonhmac/install
	$(INSTALL_DIR) $(1)/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/gravitonhmac $(1)/bin/
	$(CP) $(PKG_BUILD_DIR)/luadest/* $(1)/
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,gravitonhmac))
