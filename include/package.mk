# Dependencies for LuaSrcDiet
PKG_BUILD_DEPENDS += luci-base/host lua/host

include $(INCLUDE_DIR)/package.mk

# Annoyingly, make's shell function replaces all newlines with spaces, so we have to do some escaping work. Yuck.
define GravitonCheckSite
[ -z "$$GRAVITONDIR" ] || sed -e 's/-@/\n/g' -e 's/+@/@/g' <<'END__GRAVITON__CHECK__SITE' | "$$GRAVITONDIR"/scripts/check_site.sh
$(shell cat $(1) | sed -ne '1h; 1!H; $$ {g; s/@/+@/g; s/\n/-@/g; p}')
END__GRAVITON__CHECK__SITE
endef

# Languages supported by LuCi
GRAVITON_SUPPORTED_LANGS := ca zh_cn en fr de el he hu it ja ms no pl pt_br pt ro ru es sv uk vi

GRAVITON_I18N_PACKAGES := $(foreach lang,$(GRAVITON_SUPPORTED_LANGS),+LUCI_LANG_$(lang):luci-i18n-base-$(lang))
GRAVITON_I18N_CONFIG := $(foreach lang,$(GRAVITON_SUPPORTED_LANGS),CONFIG_LUCI_LANG_$(lang))
GRAVITON_ENABLED_LANGS := $(foreach lang,$(GRAVITON_SUPPORTED_LANGS),$(if $(CONFIG_LUCI_LANG_$(lang)),$(lang)))


define GravitonBuildI18N
	mkdir -p $$(PKG_BUILD_DIR)/i18n
	for lang in $$(GRAVITON_ENABLED_LANGS); do \
		if [ -e $(2)/$$$$lang.po ]; then \
			rm -f $$(PKG_BUILD_DIR)/i18n/$(1).$$$$lang.lmo; \
			po2lmo $(2)/$$$$lang.po $$(PKG_BUILD_DIR)/i18n/$(1).$$$$lang.lmo; \
		fi; \
	done
endef

define GravitonInstallI18N
	$$(INSTALL_DIR) $(2)/usr/lib/lua/luci/i18n
	for lang in $$(GRAVITON_ENABLED_LANGS); do \
		if [ -e $$(PKG_BUILD_DIR)/i18n/$(1).$$$$lang.lmo ]; then \
			$$(INSTALL_DATA) $$(PKG_BUILD_DIR)/i18n/$(1).$$$$lang.lmo $(2)/usr/lib/lua/luci/i18n/$(1).$$$$lang.lmo; \
		fi; \
	done
endef

define GravitonSrcDiet
	rm -rf $(2)
	$(CP) $(1) $(2)
	$(FIND) $(2) -type f | while read src; do \
	if $(STAGING_DIR_HOST)/bin/lua $(STAGING_DIR_HOST)/bin/LuaSrcDiet \
		--noopt-binequiv -o "$$$$src.o" "$$$$src"; \
	then \
		chmod $$$$(stat -c%a "$$$$src") "$$$$src.o"; \
		mv "$$$$src.o" "$$$$src"; \
	fi; \
	done
endef
