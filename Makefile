all:

LC_ALL:=C
LANG:=C
export LC_ALL LANG

export SHELL:=/usr/bin/env bash

GRAVITONPATH ?= $(PATH)
export GRAVITONPATH := $(GRAVITONPATH)

empty:=
space:= $(empty) $(empty)

GRAVITONMAKE_EARLY = PATH=$(GRAVITONPATH) $(SUBMAKE) -C $(GRAVITON_ORIGOPENWRTDIR) -f $(GRAVITONDIR)/Makefile GRAVITON_TOOLS=0 QUILT=
GRAVITONMAKE = PATH=$(GRAVITONPATH) $(SUBMAKE) -C $(GRAVITON_OPENWRTDIR) -f $(GRAVITONDIR)/Makefile

ifneq ($(OPENWRT_BUILD),1)

GRAVITONDIR:=${CURDIR}

include $(GRAVITONDIR)/include/graviton.mk

TOPDIR:=$(GRAVITON_ORIGOPENWRTDIR)
export TOPDIR


update: FORCE
	$(GRAVITONDIR)/scripts/update.sh
	$(GRAVITONDIR)/scripts/patch.sh

update-patches: FORCE
	$(GRAVITONDIR)/scripts/update.sh
	$(GRAVITONDIR)/scripts/update-patches.sh
	$(GRAVITONDIR)/scripts/patch.sh

-include $(TOPDIR)/include/host.mk

_SINGLE=export MAKEFLAGS=$(space);

override OPENWRT_BUILD=1
override GRAVITON_TOOLS=1
GREP_OPTIONS=
export OPENWRT_BUILD GRAVITON_TOOLS GREP_OPTIONS

-include $(TOPDIR)/include/debug.mk
-include $(TOPDIR)/include/depends.mk
include $(GRAVITONDIR)/include/toplevel.mk


include $(GRAVITONDIR)/targets/targets.mk


CheckTarget := [ -n '$(GRAVITON_TARGET)' -a -n '$(GRAVITON_TARGET_$(GRAVITON_TARGET)_BOARD)' ] \
	|| (echo -e 'Please set GRAVITON_TARGET to a valid target. Graviton supports the following targets:$(subst $(space),\n * ,$(GRAVITON_TARGETS))'; false)


CheckExternal := test -d $(GRAVITON_ORIGOPENWRTDIR) || (echo 'You don'"'"'t seem to have obtained the external repositories needed by Graviton; please call `make update` first!'; false)


create-key: FORCE
	@$(CheckExternal)
	+@$(GRAVITONMAKE_EARLY) create-key

prepare-target: FORCE
	@$(CheckExternal)
	@$(CheckTarget)
	+@$(GRAVITONMAKE_EARLY) prepare-target

all: prepare-target
	+@$(GRAVITONMAKE) build-key
	+@$(GRAVITONMAKE) prepare
	+@$(GRAVITONMAKE) images
	+@$(GRAVITONMAKE) modules

prepare: prepare-target
	+@$(GRAVITONMAKE) build-key
	+@$(GRAVITONMAKE) $@

clean download images modules: FORCE
	@$(CheckExternal)
	@$(CheckTarget)
	+@$(GRAVITONMAKE_EARLY) maybe-prepare-target
	+@$(GRAVITONMAKE) build-key
	+@$(GRAVITONMAKE) $@

toolchain/% package/% target/% image/%: FORCE
	@$(CheckExternal)
	@$(CheckTarget)
	+@$(GRAVITONMAKE_EARLY) maybe-prepare-target
	+@$(GRAVITONMAKE) build-key
	+@$(GRAVITONMAKE) $@

manifest: FORCE
	@[ -n '$(GRAVITON_BRANCH)' ] || (echo 'Please set GRAVITON_BRANCH to create a manifest.'; false)
	@echo '$(GRAVITON_PRIORITY)' | grep -qE '^([0-9]*\.)?[0-9]+$$' || (echo 'Please specify a numeric value for GRAVITON_PRIORITY to create a manifest.'; false)
	@$(CheckExternal)

	( \
		echo 'BRANCH=$(GRAVITON_BRANCH)' && \
		echo 'DATE=$(shell $(GRAVITON_ORIGOPENWRTDIR)/staging_dir/host/bin/lua $(GRAVITONDIR)/scripts/rfc3339date.lua)' && \
		echo 'PRIORITY=$(GRAVITON_PRIORITY)' && \
		echo \
	) > $(GRAVITON_BUILDDIR)/$(GRAVITON_BRANCH).manifest.tmp

	+($(foreach GRAVITON_TARGET,$(GRAVITON_TARGETS), \
		( [ ! -e $(BOARD_BUILDDIR)/prepared ] || ( $(GRAVITONMAKE) manifest GRAVITON_TARGET='$(GRAVITON_TARGET)' V=s$(OPENWRT_VERBOSE) ) ) && \
	) :)

	mkdir -p $(GRAVITON_IMAGEDIR)/sysupgrade
	mv $(GRAVITON_BUILDDIR)/$(GRAVITON_BRANCH).manifest.tmp $(GRAVITON_IMAGEDIR)/sysupgrade/$(GRAVITON_BRANCH).manifest

dirclean : FORCE
	for dir in build_dir dl staging_dir tmp; do \
		rm -rf $(GRAVITON_ORIGOPENWRTDIR)/$$dir; \
	done
	rm -rf $(GRAVITON_BUILDDIR) $(GRAVITON_OUTPUTDIR)

else

TOPDIR=${CURDIR}
export TOPDIR

include rules.mk

include $(GRAVITONDIR)/include/graviton.mk

include $(INCLUDE_DIR)/host.mk
include $(INCLUDE_DIR)/depends.mk
include $(INCLUDE_DIR)/subdir.mk

include package/Makefile
include tools/Makefile
include toolchain/Makefile
include target/Makefile


PROFILES :=
PROFILE_PACKAGES :=

define Profile
  $(eval $(call Profile/Default))
  $(eval $(call Profile/$(1)))
endef

define GravitonProfile
PROFILES += $(1)
PROFILE_PACKAGES += $(filter-out -%,$(2) $(GRAVITON_$(1)_SITE_PACKAGES))
GRAVITON_$(1)_PROFILE := $(if $(3),$(3),$(1))
GRAVITON_$(1)_DEFAULT_PACKAGES := $(2)
GRAVITON_$(1)_FACTORY_SUFFIX := -squashfs-factory
GRAVITON_$(1)_SYSUPGRADE_SUFFIX := -squashfs-sysupgrade
GRAVITON_$(1)_FACTORY_EXT := .bin
GRAVITON_$(1)_SYSUPGRADE_EXT := .bin
GRAVITON_$(1)_FACTORY_EXTRA :=
GRAVITON_$(1)_SYSUPGRADE_EXTRA :=
GRAVITON_$(1)_MODELS :=
endef

define GravitonProfileFactorySuffix
GRAVITON_$(1)_FACTORY_SUFFIX := $(2)
GRAVITON_$(1)_FACTORY_EXT := $(3)
GRAVITON_$(1)_FACTORY_EXTRA := $(4)
endef

define GravitonProfileSysupgradeSuffix
GRAVITON_$(1)_SYSUPGRADE_SUFFIX := $(2)
GRAVITON_$(1)_SYSUPGRADE_EXT := $(3)
GRAVITON_$(1)_SYSUPGRADE_EXTRA := $(4)
endef

define GravitonModel
GRAVITON_$(1)_MODELS += $(3)
GRAVITON_$(1)_MODEL_$(3) := $(2)
GRAVITON_$(1)_MODEL_$(3)_ALIASES :=
endef

define GravitonModelAlias
GRAVITON_$(1)_MODEL_$(2)_ALIASES += $(3)
endef


export SHA512SUM := $(GRAVITONDIR)/scripts/sha512sum.sh


prereq: FORCE
	+$(NO_TRACE_MAKE) prereq

prepare-tmpinfo: FORCE
	@+$(MAKE) -r -s staging_dir/host/.prereq-build OPENWRT_BUILD= QUIET=0
	mkdir -p tmp/info
	$(_SINGLE)$(NO_TRACE_MAKE) -j1 -r -s -f include/scan.mk SCAN_TARGET="packageinfo" SCAN_DIR="package" SCAN_NAME="package" SCAN_DEPS="$(TOPDIR)/include/package*.mk $(TOPDIR)/overlay/*/*.mk" SCAN_EXTRA=""
	$(_SINGLE)$(NO_TRACE_MAKE) -j1 -r -s -f include/scan.mk SCAN_TARGET="targetinfo" SCAN_DIR="target/linux" SCAN_NAME="target" SCAN_DEPS="profiles/*.mk $(TOPDIR)/include/kernel*.mk $(TOPDIR)/include/target.mk" SCAN_DEPTH=2 SCAN_EXTRA="" SCAN_MAKEOPTS="TARGET_BUILD=1"
	for type in package target; do \
		f=tmp/.$${type}info; t=tmp/.config-$${type}.in; \
		[ "$$t" -nt "$$f" ] || ./scripts/metadata.pl $${type}_config "$$f" > "$$t" || { rm -f "$$t"; echo "Failed to build $$t"; false; break; }; \
	done
	[ tmp/.config-feeds.in -nt tmp/.packagefeeds ] || ./scripts/feeds feed_config > tmp/.config-feeds.in
	./scripts/metadata.pl package_mk tmp/.packageinfo > tmp/.packagedeps || { rm -f tmp/.packagedeps; false; }
	./scripts/metadata.pl package_feeds tmp/.packageinfo > tmp/.packagefeeds || { rm -f tmp/.packagefeeds; false; }
	touch $(TOPDIR)/tmp/.build

feeds: FORCE
	rm -rf $(TOPDIR)/package/feeds
	mkdir $(TOPDIR)/package/feeds
	[ ! -f $(GRAVITON_SITEDIR)/modules ] || . $(GRAVITON_SITEDIR)/modules && for feed in $$GRAVITON_SITE_FEEDS; do ln -s ../../../packages/$$feed $(TOPDIR)/package/feeds/$$feed; done
	ln -s ../../../package $(TOPDIR)/package/feeds/graviton
	. $(GRAVITONDIR)/modules && for feed in $$GRAVITON_FEEDS; do ln -s ../../../packages/$$feed $(TOPDIR)/package/feeds/module_$$feed; done
	+$(GRAVITONMAKE_EARLY) prepare-tmpinfo

graviton-tools: FORCE
	+$(GRAVITONMAKE_EARLY) tools/patch/install
	+$(GRAVITONMAKE_EARLY) tools/sed/install
	+$(GRAVITONMAKE_EARLY) tools/cmake/install
	+$(GRAVITONMAKE_EARLY) package/lua/host/install package/usign/host/install



early_prepared_stamp := $(GRAVITON_BUILDDIR)/prepared_$(shell \
	( \
		$(SHA512SUM) $(GRAVITONDIR)/modules; \
		[ ! -r $(GRAVITON_SITEDIR)/modules ] || $(SHA512SUM) $(GRAVITON_SITEDIR)/modules \
	) | $(SHA512SUM) )

prepare-early: FORCE
	for dir in build_dir dl staging_dir; do \
		mkdir -p $(GRAVITON_ORIGOPENWRTDIR)/$$dir; \
	done

	+$(GRAVITONMAKE_EARLY) feeds
	+$(GRAVITONMAKE_EARLY) graviton-tools

	mkdir -p $$(dirname $(early_prepared_stamp))
	touch $(early_prepared_stamp)

$(early_prepared_stamp):
	rm -f $(GRAVITON_BUILDDIR)/prepared_*
	+$(GRAVITONMAKE_EARLY) prepare-early

$(GRAVITON_OPKG_KEY): $(early_prepared_stamp) FORCE
	[ -s $(GRAVITON_OPKG_KEY) -a -s $(GRAVITON_OPKG_KEY).pub ] || \
		( mkdir -p $$(dirname $(GRAVITON_OPKG_KEY)) && $(STAGING_DIR_HOST)/bin/usign -G -s $(GRAVITON_OPKG_KEY) -p $(GRAVITON_OPKG_KEY).pub -c "Graviton opkg key" )

$(GRAVITON_OPKG_KEY).pub: $(GRAVITON_OPKG_KEY)

create-key: $(GRAVITON_OPKG_KEY).pub

include $(GRAVITONDIR)/targets/targets.mk

ifneq ($(GRAVITON_TARGET),)

include $(GRAVITONDIR)/targets/$(GRAVITON_TARGET)/profiles.mk

BOARD := $(GRAVITON_TARGET_$(GRAVITON_TARGET)_BOARD)
override SUBTARGET := $(GRAVITON_TARGET_$(GRAVITON_TARGET)_SUBTARGET)

target_prepared_stamp := $(BOARD_BUILDDIR)/target-prepared
graviton_prepared_stamp := $(BOARD_BUILDDIR)/prepared

PREPARED_RELEASE = $$(cat $(graviton_prepared_stamp))
IMAGE_PREFIX = graviton-$(GRAVITON_SITE_CODE)-$(PREPARED_RELEASE)
MODULE_PREFIX = graviton-$(GRAVITON_SITE_CODE)-$(PREPARED_RELEASE)


include $(INCLUDE_DIR)/target.mk

build-key: FORCE
	rm -f $(BUILD_KEY) $(BUILD_KEY).pub
	cp $(GRAVITON_OPKG_KEY) $(BUILD_KEY)
	cp $(GRAVITON_OPKG_KEY).pub $(BUILD_KEY).pub

config: FORCE
	+$(NO_TRACE_MAKE) scripts/config/conf OPENWRT_BUILD= QUIET=0
	+$(GRAVITONMAKE) prepare-tmpinfo
	( \
		cat $(GRAVITONDIR)/include/config; \
		echo 'CONFIG_TARGET_$(GRAVITON_TARGET_$(GRAVITON_TARGET)_BOARD)=y'; \
		$(if $(GRAVITON_TARGET_$(GRAVITON_TARGET)_SUBTARGET), \
			echo 'CONFIG_TARGET_$(GRAVITON_TARGET_$(GRAVITON_TARGET)_BOARD)_$(GRAVITON_TARGET_$(GRAVITON_TARGET)_SUBTARGET)=y'; \
		) \
		cat $(GRAVITONDIR)/targets/$(GRAVITON_TARGET)/config 2>/dev/null; \
		echo 'CONFIG_BUILD_SUFFIX="graviton-$(GRAVITON_TARGET)"'; \
		echo '$(patsubst %,CONFIG_PACKAGE_%=m,$(sort $(filter-out -%,$(GRAVITON_DEFAULT_PACKAGES) $(GRAVITON_SITE_PACKAGES) $(PROFILE_PACKAGES))))' \
			| sed -e 's/ /\n/g'; \
		echo '$(patsubst %,CONFIG_LUCI_LANG_%=y,$(GRAVITON_LANGS))' \
			| sed -e 's/ /\n/g'; \
	) > $(BOARD_BUILDDIR)/config.tmp
	scripts/config/conf --defconfig=$(BOARD_BUILDDIR)/config.tmp Config.in
	+$(SUBMAKE) tools/install

prepare-target: $(GRAVITON_OPKG_KEY).pub
	rm $(GRAVITON_OPENWRTDIR)/tmp || true
	mkdir -p $(GRAVITON_OPENWRTDIR)/tmp

	for link in build_dir config Config.in dl include Makefile package rules.mk scripts staging_dir target toolchain tools; do \
		ln -sf $(GRAVITON_ORIGOPENWRTDIR)/$$link $(GRAVITON_OPENWRTDIR); \
	done

	+$(GRAVITONMAKE) config
	touch $(target_prepared_stamp)

$(target_prepared_stamp):
	+$(GRAVITONMAKE_EARLY) prepare-target

maybe-prepare-target: $(target_prepared_stamp)
	+$(GRAVITONMAKE_EARLY) $(GRAVITON_OPKG_KEY).pub

$(BUILD_DIR)/.prepared: Makefile
	@mkdir -p $$(dirname $@)
	@touch $@

$(toolchain/stamp-install): $(tools/stamp-install)
$(package/stamp-compile): $(package/stamp-cleanup)


clean: FORCE
	+$(SUBMAKE) clean
	rm -f $(graviton_prepared_stamp)


download: FORCE
	+$(SUBMAKE) tools/download
	+$(SUBMAKE) toolchain/download
	+$(SUBMAKE) package/download
	+$(SUBMAKE) target/download

toolchain: $(toolchain/stamp-install) $(tools/stamp-install)

include $(INCLUDE_DIR)/kernel.mk

kernel: FORCE
	+$(NO_TRACE_MAKE) -C $(TOPDIR)/target/linux/$(BOARD) $(LINUX_DIR)/.image TARGET_BUILD=1
	+$(NO_TRACE_MAKE) -C $(TOPDIR)/target/linux/$(BOARD) $(LINUX_DIR)/.modules TARGET_BUILD=1

packages: $(package/stamp-compile)
	$(_SINGLE)$(SUBMAKE) -r package/index

prepare-image: FORCE
	rm -rf $(BOARD_KDIR)
	mkdir -p $(BOARD_KDIR)
	-cp $(KERNEL_BUILD_DIR)/* $(BOARD_KDIR)/
	+$(SUBMAKE) -C $(TOPDIR)/target/linux/$(BOARD)/image image_prepare KDIR="$(BOARD_KDIR)"

prepare: FORCE
	@$(STAGING_DIR_HOST)/bin/lua $(GRAVITONDIR)/scripts/site_config.lua \
		|| (echo 'Your site configuration did not pass validation.'; false)

	mkdir -p $(GRAVITON_IMAGEDIR) $(BOARD_BUILDDIR)
	echo 'src packages file:../openwrt/bin/$(BOARD)/packages' > $(BOARD_BUILDDIR)/opkg.conf

	+$(GRAVITONMAKE) toolchain
	+$(GRAVITONMAKE) kernel
	+$(GRAVITONMAKE) packages
	+$(GRAVITONMAKE) prepare-image

	echo "$(GRAVITON_RELEASE)" > $(graviton_prepared_stamp)

$(graviton_prepared_stamp):
	+$(GRAVITONMAKE) prepare

modules: FORCE $(graviton_prepared_stamp)
	-rm -f $(GRAVITON_MODULEDIR)/*/$(BOARD)/$(if $(SUBTARGET),$(SUBTARGET),generic)/*
	-rmdir -p $(GRAVITON_MODULEDIR)/*/$(BOARD)/$(if $(SUBTARGET),$(SUBTARGET),generic)
	mkdir -p $(GRAVITON_MODULEDIR)/$(MODULE_PREFIX)/$(BOARD)/$(if $(SUBTARGET),$(SUBTARGET),generic)
	cp $(PACKAGE_DIR)/kmod-*.ipk $(GRAVITON_MODULEDIR)/$(MODULE_PREFIX)/$(BOARD)/$(if $(SUBTARGET),$(SUBTARGET),generic)

	$(_SINGLE)$(SUBMAKE) -r package/index PACKAGE_DIR=$(GRAVITON_MODULEDIR)/$(MODULE_PREFIX)/$(BOARD)/$(if $(SUBTARGET),$(SUBTARGET),generic)


include $(INCLUDE_DIR)/package-ipkg.mk

# override variables from rules.mk
PACKAGE_DIR = $(GRAVITON_OPENWRTDIR)/bin/$(BOARD)/packages

PROFILE_BUILDDIR = $(BOARD_BUILDDIR)/profiles/$(PROFILE)
PROFILE_KDIR = $(PROFILE_BUILDDIR)/kernel
BIN_DIR = $(PROFILE_BUILDDIR)/images

TARGET_DIR = $(PROFILE_BUILDDIR)/root

OPKG:= \
  TMPDIR="$(TMP_DIR)" \
  IPKG_INSTROOT="$(TARGET_DIR)" \
  IPKG_CONF_DIR="$(TMP_DIR)" \
  IPKG_OFFLINE_ROOT="$(TARGET_DIR)" \
  $(STAGING_DIR_HOST)/bin/opkg \
	-f $(BOARD_BUILDDIR)/opkg.conf \
	--cache $(TMP_DIR)/dl \
	--offline-root $(TARGET_DIR) \
	--force-postinstall \
	--add-dest root:/ \
	--add-arch all:100 \
	--add-arch $(ARCH_PACKAGES):200

EnableInitscript = ! grep -q '\#!/bin/sh /etc/rc.common' $(1) || bash ./etc/rc.common $(1) enable


enable_initscripts: FORCE
	cd $(TARGET_DIR) && ( export IPKG_INSTROOT=$(TARGET_DIR); \
		$(foreach script,$(wildcard $(TARGET_DIR)/etc/init.d/*), \
			$(call EnableInitscript,$(script)); \
		) : \
	)


# Generate package list
$(eval $(call merge-lists,INSTALL_PACKAGES,DEFAULT_PACKAGES GRAVITON_DEFAULT_PACKAGES GRAVITON_SITE_PACKAGES GRAVITON_$(PROFILE)_DEFAULT_PACKAGES GRAVITON_$(PROFILE)_SITE_PACKAGES))

package_install: FORCE
	$(OPKG) update
	$(OPKG) install $(PACKAGE_DIR)/base-files_*.ipk $(PACKAGE_DIR)/libc_*.ipk
	$(OPKG) install $(PACKAGE_DIR)/kernel_*.ipk

	$(OPKG) install $(INSTALL_PACKAGES)
	+$(GRAVITONMAKE) enable_initscripts

	rm -f $(TARGET_DIR)/usr/lib/opkg/lists/* $(TARGET_DIR)/tmp/opkg.lock
	rm -f $(TARGET_DIR)/usr/lib/opkg/info/*.postinst*

# Remove opkg database when opkg is not intalled
	if [ ! -x $(TARGET_DIR)/bin/opkg ]; then rm -rf $(TARGET_DIR)/usr/lib/opkg; fi


include $(INCLUDE_DIR)/version.mk

opkg_config: FORCE
	for d in base packages luci routing telephony management; do \
		echo "src/gz %n_$$d %U/$$d"; \
	done > $(TARGET_DIR)/etc/opkg/distfeeds.conf
	$(VERSION_SED) $(TARGET_DIR)/etc/opkg/distfeeds.conf


image: FORCE
	rm -rf $(TARGET_DIR) $(BIN_DIR) $(PROFILE_KDIR)
	mkdir -p $(TARGET_DIR) $(BIN_DIR) $(TARGET_DIR)/tmp $(GRAVITON_IMAGEDIR)/factory $(GRAVITON_IMAGEDIR)/sysupgrade
	cp -r $(BOARD_KDIR) $(PROFILE_KDIR)

	+$(GRAVITONMAKE) package_install
	+$(GRAVITONMAKE) opkg_config

	$(call Image/mkfs/prepare)
	$(_SINGLE)$(NO_TRACE_MAKE) -C $(TOPDIR)/target/linux/$(BOARD)/image install TARGET_BUILD=1 IMG_PREFIX=graviton \
		PROFILE="$(GRAVITON_$(PROFILE)_PROFILE)" KDIR="$(PROFILE_KDIR)" TARGET_DIR="$(TARGET_DIR)" BIN_DIR="$(BIN_DIR)" TMP_DIR="$(TMP_DIR)"

	$(foreach model,$(GRAVITON_$(PROFILE)_MODELS), \
		$(if $(GRAVITON_$(PROFILE)_SYSUPGRADE_EXT), \
			rm -f $(GRAVITON_IMAGEDIR)/sysupgrade/graviton-*-$(model)-sysupgrade$(GRAVITON_$(PROFILE)_SYSUPGRADE_EXT) && \
			cp $(BIN_DIR)/graviton-$(GRAVITON_$(PROFILE)_MODEL_$(model))$(GRAVITON_$(PROFILE)_SYSUPGRADE_SUFFIX)$(GRAVITON_$(PROFILE)_SYSUPGRADE_EXT) $(GRAVITON_IMAGEDIR)/sysupgrade/$(IMAGE_PREFIX)-$(model)-sysupgrade$(GRAVITON_$(PROFILE)_SYSUPGRADE_EXT) && \
		) \
		$(if $(GRAVITON_$(PROFILE)_FACTORY_EXT), \
			rm -f $(GRAVITON_IMAGEDIR)/factory/graviton-*-$(model)$(GRAVITON_$(PROFILE)_FACTORY_EXT) && \
			cp $(BIN_DIR)/graviton-$(GRAVITON_$(PROFILE)_MODEL_$(model))$(GRAVITON_$(PROFILE)_FACTORY_SUFFIX)$(GRAVITON_$(PROFILE)_FACTORY_EXT) $(GRAVITON_IMAGEDIR)/factory/$(IMAGE_PREFIX)-$(model)$(GRAVITON_$(PROFILE)_FACTORY_EXT) && \
		) \
		\
		$(if $(GRAVITON_$(PROFILE)_SYSUPGRADE_EXTRA), \
			rm -f $(GRAVITON_IMAGEDIR)/sysupgrade/graviton-*-$(model)-sysupgrade$(GRAVITON_$(PROFILE)_SYSUPGRADE_EXTRA) && \
			cp $(BIN_DIR)/graviton$(GRAVITON_$(PROFILE)_SYSUPGRADE_EXTRA) $(GRAVITON_IMAGEDIR)/sysupgrade/$(IMAGE_PREFIX)-$(model)-sysupgrade$(GRAVITON_$(PROFILE)_SYSUPGRADE_EXTRA) && \
		) \
		$(if $(GRAVITON_$(PROFILE)_FACTORY_EXTRA), \
			rm -f $(GRAVITON_IMAGEDIR)/factory/graviton-*-$(model)$(GRAVITON_$(PROFILE)_FACTORY_EXTRA) && \
			cp $(BIN_DIR)/graviton$(GRAVITON_$(PROFILE)_FACTORY_EXTRA) $(GRAVITON_IMAGEDIR)/factory/$(IMAGE_PREFIX)-$(model)$(GRAVITON_$(PROFILE)_FACTORY_EXTRA) && \
		) \
		\
		$(foreach alias,$(GRAVITON_$(PROFILE)_MODEL_$(model)_ALIASES), \
			$(if $(GRAVITON_$(PROFILE)_SYSUPGRADE_EXT), \
				rm -f $(GRAVITON_IMAGEDIR)/sysupgrade/graviton-*-$(alias)-sysupgrade$(GRAVITON_$(PROFILE)_SYSUPGRADE_EXT) && \
				ln -s $(IMAGE_PREFIX)-$(model)-sysupgrade$(GRAVITON_$(PROFILE)_SYSUPGRADE_EXT) $(GRAVITON_IMAGEDIR)/sysupgrade/$(IMAGE_PREFIX)-$(alias)-sysupgrade$(GRAVITON_$(PROFILE)_SYSUPGRADE_EXT) && \
			) \
			$(if $(GRAVITON_$(PROFILE)_FACTORY_EXT), \
				rm -f $(GRAVITON_IMAGEDIR)/factory/graviton-*-$(alias)$(GRAVITON_$(PROFILE)_FACTORY_EXT) && \
				ln -s $(IMAGE_PREFIX)-$(model)$(GRAVITON_$(PROFILE)_FACTORY_EXT) $(GRAVITON_IMAGEDIR)/factory/$(IMAGE_PREFIX)-$(alias)$(GRAVITON_$(PROFILE)_FACTORY_EXT) && \
			) \
		) \
	) :


image/%: $(graviton_prepared_stamp)
	+$(GRAVITONMAKE) image PROFILE="$(patsubst image/%,%,$@)" V=s$(OPENWRT_VERBOSE)

call_image/%: FORCE
	+$(GRAVITONMAKE) $(patsubst call_image/%,image/%,$@)

images: $(patsubst %,call_image/%,$(PROFILES)) ;

manifest: FORCE
	( \
		cd $(GRAVITON_IMAGEDIR)/sysupgrade; \
		$(foreach profile,$(PROFILES), \
			$(if $(GRAVITON_$(profile)_SYSUPGRADE_EXT), \
				$(foreach model,$(GRAVITON_$(profile)_MODELS), \
					file="$(IMAGE_PREFIX)-$(model)-sysupgrade$(GRAVITON_$(profile)_SYSUPGRADE_EXT)"; \
					[ -e "$$file" ] && echo '$(model)' "$(PREPARED_RELEASE)" "$$($(SHA512SUM) "$$file")" "$$file"; \
					\
					$(foreach alias,$(GRAVITON_$(profile)_MODEL_$(model)_ALIASES), \
						file="$(IMAGE_PREFIX)-$(alias)-sysupgrade$(GRAVITON_$(profile)_SYSUPGRADE_EXT)"; \
						[ -e "$$file" ] && echo '$(alias)' "$(PREPARED_RELEASE)" "$$($(SHA512SUM) "$$file")" "$$file"; \
					) \
				) \
			) \
		) : \
	) >> $(GRAVITON_BUILDDIR)/$(GRAVITON_BRANCH).manifest.tmp

.PHONY: all create-key prepare images modules clean graviton-tools manifest

endif
endif
