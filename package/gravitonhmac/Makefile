include $(TOPDIR)/rules.mk

PKG_NAME:=gravitonhmac
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

PKG_FIXUP:=libtool-ucxx

include $(INCLUDE_DIR)/uclibc++.mk
include $(GRAVITONDIR)/include/package.mk

define Package/gravitonhmac
  SECTION:=graviton
  CATEGORY:=Graviton
  TITLE:=Hybrid TDMA userspace program
  DEPENDS:=+lzmq +libzmq-nc +libevent2 +libnl-tiny +libpthread $(CXX_DEPENDS)
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
	CFLAGS="$(TARGET_CFLAGS)" \
	CPPFLAGS="$(TARGET_CPPFLAGS)" \
	$(MAKE) -C $(PKG_BUILD_DIR) $(TARGET_CONFIGURE_OPTS)
endef

define Package/gravitonhmac/install
	$(INSTALL_DIR) $(1)/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/gravitonhmac $(1)/bin/
	$(CP) $(PKG_BUILD_DIR)/luadest/* $(1)/
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,gravitonhmac))
