include $(TOPDIR)/rules.mk

PKG_NAME:=graviton-site
PKG_VERSION:=$(if $(GRAVITON_SITE_CODE),$(GRAVITON_SITE_CODE),1)
PKG_RELEASE:=$(GRAVITON_RELEASE)

PKG_FILE_DEPENDS := $(GRAVITON_SITEDIR)/site.conf $(GRAVITON_SITEDIR)/i18n/
PKG_BUILD_DEPENDS := luci-base/host lua-cjson/host

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(GRAVITONDIR)/include/package.mk

PKG_CONFIG_DEPENDS += $(GRAVITON_I18N_CONFIG)


define Package/graviton-site
  SECTION:=graviton
  CATEGORY:=Graviton
  TITLE:=Site-specific files of Graviton
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
	$(call GravitonBuildI18N,graviton-site,$(GRAVITON_SITEDIR)/i18n)
endef

define Package/graviton-site/install
	$(INSTALL_DIR) $(1)/lib/graviton
	lua -e 'print(require("cjson").encode(assert(dofile("$(GRAVITONDIR)/scripts/site_config.lua"))))' > $(1)/lib/graviton/site.json
	echo "$(GRAVITON_RELEASE)" > $(1)/lib/graviton/release

	$(call GravitonInstallI18N,graviton-site,$(1))
endef

$(eval $(call BuildPackage,graviton-site))
