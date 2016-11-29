include $(TOPDIR)/rules.mk

PKG_NAME:=graviton-lock-password
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk


define Package/graviton-lock-password
  SECTION:=graviton
  CATEGORY:=Graviton
  TITLE:=Locks the root account by default
  DEPENDS:=+graviton-core
endef

define Package/graviton-lock-password/description
	This packages locks the root account by default.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/graviton-lock-password/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,graviton-lock-password))
