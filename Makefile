all:

LC_ALL:=C
LANG:=C
export LC_ALL LANG

empty:=
space:= $(empty) $(empty)

GRAVITONMAKE_EARLY = $(SUBMAKE) -C $(GRAVITON_ORIGOPENWRTDIR) -f $(GRAVITONDIR)/Makefile GRAVITON_TOOLS=0
GRAVITONMAKE = $(SUBMAKE) -C $(GRAVITON_OPENWRTDIR) -f $(GRAVITONDIR)/Makefile

ifneq ($(OPENWRT_BUILD),1)

GRAVITONDIR:=${CURDIR}

include $(GRAVITONDIR)/include/graviton.mk

TOPDIR:=$(GRAVITON_ORIGOPENWRTDIR)
export TOPDIR


GRAVITON_TARGET ?= ar71xx-generic
export GRAVITON_TARGET


update: FORCE
	$(GRAVITONDIR)/scripts/update.sh $(GRAVITONDIR)
	$(GRAVITONDIR)/scripts/patch.sh $(GRAVITONDIR)

patch: FORCE
	$(GRAVITONDIR)/scripts/patch.sh $(GRAVITONDIR)

unpatch: FORCE
	$(GRAVITONDIR)/scripts/unpatch.sh $(GRAVITONDIR)

update-patches: FORCE
	$(GRAVITONDIR)/scripts/update.sh $(GRAVITONDIR)
	$(GRAVITONDIR)/scripts/update-patches.sh $(GRAVITONDIR)
	$(GRAVITONDIR)/scripts/patch.sh $(GRAVITONDIR)

-include $(TOPDIR)/include/host.mk

_SINGLE=export MAKEFLAGS=$(space);

override OPENWRT_BUILD=1
override GRAVITON_TOOLS=1
GREP_OPTIONS=
export OPENWRT_BUILD GRAVITON_TOOLS GREP_OPTIONS

-include $(TOPDIR)/include/debug.mk
-include $(TOPDIR)/include/depends.mk
include $(GRAVITONDIR)/include/toplevel.mk

define GravitonProfile
image/$(1): FORCE
	+@$$(GRAVITONMAKE) $$@
endef

define GravitonModel
endef

include $(GRAVITONDIR)/targets/targets.mk
include $(GRAVITONDIR)/targets/$(GRAVITON_TARGET)/profiles.mk


CheckExternal := test -d $(GRAVITON_ORIGOPENWRTDIR) || (echo 'You don'"'"'t seem to have obtained the external repositories needed by Graviton; please call `make update` first!'; false)


prepare-target: FORCE
	@$(CheckExternal)
	+@$(GRAVITONMAKE_EARLY) prepare-target


all: prepare-target
	+@$(GRAVITONMAKE) prepare
	+@$(GRAVITONMAKE) images

prepare: prepare-target
	+@$(GRAVITONMAKE) $@

clean dirclean download images: FORCE
	@$(CheckExternal)
	+@$(GRAVITONMAKE_EARLY) maybe-prepare-target
	+@$(GRAVITONMAKE) $@

toolchain/% package/% target/%: FORCE
	@$(CheckExternal)
	+@$(GRAVITONMAKE_EARLY) maybe-prepare-target
	+@$(GRAVITONMAKE) $@

manifest: FORCE
	[ -n '$(GRAVITON_BRANCH)' ] || (echo 'Please set GRAVITON_BRANCH to create a manifest.'; false)
	echo '$(GRAVITON_PRIORITY)' | grep -qE '^([0-9]*\.)?[0-9]+$$' || (echo 'Please specify a numeric value for GRAVITON_PRIORITY to create a manifest.'; false)
	@$(CheckExternal)
	+@$(GRAVITONMAKE_EARLY) maybe-prepare-target
	+@$(GRAVITONMAKE) $@

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
GRAVITON_$(1)_DEFAULT_PACKAGES := $(2)
GRAVITON_$(1)_MODELS :=
endef

define GravitonModel
GRAVITON_$(1)_MODELS += $(3)
GRAVITON_$(1)_MODEL_$(3) := $(2)
endef


include $(GRAVITONDIR)/targets/targets.mk
include $(GRAVITONDIR)/targets/$(GRAVITON_TARGET)/profiles.mk

BOARD := $(GRAVITON_TARGET_$(GRAVITON_TARGET)_BOARD)
override SUBTARGET := $(GRAVITON_TARGET_$(GRAVITON_TARGET)_SUBTARGET)

target_prepared_stamp := $(BOARD_BUILDDIR)/target-prepared
graviton_prepared_stamp := $(BOARD_BUILDDIR)/prepared


include $(INCLUDE_DIR)/target.mk


prereq: FORCE
	+$(NO_TRACE_MAKE) prereq

graviton-tools: FORCE
	+$(GRAVITONMAKE_EARLY) tools/sed/install
	+$(GRAVITONMAKE_EARLY) package/lua/host/install

prepare-tmpinfo: FORCE
	mkdir -p tmp/info
	$(_SINGLE)$(NO_TRACE_MAKE) -j1 -r -s -f include/scan.mk SCAN_TARGET="packageinfo" SCAN_DIR="package" SCAN_NAME="package" SCAN_DEPS="$(TOPDIR)/include/package*.mk $(TOPDIR)/overlay/*/*.mk" SCAN_EXTRA=""
	$(_SINGLE)$(NO_TRACE_MAKE) -j1 -r -s -f include/scan.mk SCAN_TARGET="targetinfo" SCAN_DIR="target/linux" SCAN_NAME="target" SCAN_DEPS="profiles/*.mk $(TOPDIR)/include/kernel*.mk $(TOPDIR)/include/target.mk" SCAN_DEPTH=2 SCAN_EXTRA="" SCAN_MAKEOPTS="TARGET_BUILD=1"
	for type in package target; do \
		f=tmp/.$${type}info; t=tmp/.config-$${type}.in; \
		[ "$$t" -nt "$$f" ] || ./scripts/metadata.pl $${type}_config "$$f" > "$$t" || { rm -f "$$t"; echo "Failed to build $$t"; false; break; }; \
	done
	./scripts/metadata.pl package_mk tmp/.packageinfo > tmp/.packagedeps || { rm -f tmp/.packagedeps; false; }
	touch $(TOPDIR)/tmp/.build

feeds: FORCE
	rm -rf $(TOPDIR)/package/feeds
	mkdir $(TOPDIR)/package/feeds
	[ ! -f $(GRAVITON_SITEDIR)/modules ] || . $(GRAVITON_SITEDIR)/modules && for feed in $$GRAVITON_SITE_FEEDS; do ln -s ../../../packages/$$feed $(TOPDIR)/package/feeds/$$feed; done
	. $(GRAVITONDIR)/modules && for feed in $$GRAVITON_FEEDS; do ln -s ../../../packages/$$feed $(TOPDIR)/package/feeds/$$feed; done
	+$(GRAVITONMAKE_EARLY) prepare-tmpinfo

config: FORCE
	( \
		cat $(GRAVITONDIR)/include/config $(GRAVITONDIR)/targets/$(GRAVITON_TARGET)/config; \
		echo '$(patsubst %,CONFIG_PACKAGE_%=m,$(sort $(filter-out -%,$(GRAVITON_DEFAULT_PACKAGES) $(GRAVITON_SITE_PACKAGES) $(PROFILE_PACKAGES))))' \
			| sed -e 's/ /\n/g'; \
	) > .config
	+$(NO_TRACE_MAKE) defconfig OPENWRT_BUILD=0

prepare-target: FORCE
	mkdir -p $(GRAVITON_OPENWRTDIR)
	for dir in build_dir dl staging_dir tmp; do \
		mkdir -p $(GRAVITON_ORIGOPENWRTDIR)/$$dir; \
	done
	for link in build_dir config Config.in dl include Makefile package rules.mk scripts staging_dir target tmp toolchain tools; do \
		ln -sf $(GRAVITON_ORIGOPENWRTDIR)/$$link $(GRAVITON_OPENWRTDIR); \
	done
	+$(GRAVITONMAKE_EARLY) feeds
	+$(GRAVITONMAKE_EARLY) graviton-tools
	+$(GRAVITONMAKE) config
	touch $(target_prepared_stamp)

$(target_prepared_stamp):
	+$(GRAVITONMAKE_EARLY) prepare-target

maybe-prepare-target: $(target_prepared_stamp)

$(BUILD_DIR)/.prepared: Makefile
	@mkdir -p $$(dirname $@)
	@touch $@

$(toolchain/stamp-install): $(tools/stamp-install)
$(package/stamp-compile): $(package/stamp-cleanup)


clean: FORCE
	+$(SUBMAKE) clean
	rm -f $(graviton_prepared_stamp)

dirclean: FORCE
	+$(SUBMAKE) dirclean
	rm -rf $(GRAVITON_BUILDDIR)


export MD5SUM := $(GRAVITONDIR)/scripts/md5sum.sh
export SHA512SUM := $(GRAVITONDIR)/scripts/sha512sum.sh


download: FORCE
	+$(SUBMAKE) tools/download
	+$(SUBMAKE) toolchain/download
	+$(SUBMAKE) package/download
	+$(SUBMAKE) target/download

toolchain: $(toolchain/stamp-install) $(tools/stamp-install)

include $(INCLUDE_DIR)/kernel.mk

kernel: FORCE
	+$(NO_TRACE_MAKE) -C $(TOPDIR)/target/linux/$(BOARD) -f $(GRAVITONDIR)/include/Makefile.target $(LINUX_DIR)/.image TARGET_BUILD=1
	+$(NO_TRACE_MAKE) -C $(TOPDIR)/target/linux/$(BOARD) -f $(GRAVITONDIR)/include/Makefile.target $(LINUX_DIR)/.modules TARGET_BUILD=1

packages: $(package/stamp-compile)
	$(_SINGLE)$(SUBMAKE) -r package/index

prepare-image: FORCE
	rm -rf $(BOARD_KDIR)
	mkdir -p $(BOARD_KDIR)
	cp $(KERNEL_BUILD_DIR)/vmlinux $(KERNEL_BUILD_DIR)/vmlinux.elf $(BOARD_KDIR)/
	+$(SUBMAKE) -C $(TOPDIR)/target/linux/$(BOARD)/image -f $(GRAVITONDIR)/include/Makefile.image prepare KDIR="$(BOARD_KDIR)"

prepare: FORCE
	@$(STAGING_DIR_HOST)/bin/lua $(GRAVITONDIR)/packages/graviton/graviton/graviton-core/files/usr/lib/lua/graviton/site_config.lua \
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


include $(INCLUDE_DIR)/package-ipkg.mk

# override variables from rules.mk
PACKAGE_DIR = $(GRAVITON_OPENWRTDIR)/bin/$(BOARD)/packages

PROFILE_BUILDDIR = $(BOARD_BUILDDIR)/$(PROFILE)
PROFILE_KDIR = $(PROFILE_BUILDDIR)/kernel
BIN_DIR = $(PROFILE_BUILDDIR)/images

TMP_DIR = $(PROFILE_BUILDDIR)/tmp
TARGET_DIR = $(PROFILE_BUILDDIR)/root

IMAGE_PREFIX = graviton-$(GRAVITON_SITE_CODE)-$$(cat $(graviton_prepared_stamp))

OPKG:= \
  IPKG_TMP="$(TMP_DIR)/ipkgtmp" \
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
	$(OPKG) install $(PACKAGE_DIR)/libc_*.ipk
	$(OPKG) install $(PACKAGE_DIR)/kernel_*.ipk

	$(OPKG) install $(INSTALL_PACKAGES)
	+$(GRAVITONMAKE) enable_initscripts

	rm -f $(TARGET_DIR)/usr/lib/opkg/lists/* $(TARGET_DIR)/tmp/opkg.lock

ifeq ($(GRAVITON_OPKG_CONFIG),1)
include $(INCLUDE_DIR)/version.mk
endif

opkg_config: FORCE
	cp $(GRAVITON_OPENWRTDIR)/package/system/opkg/files/opkg.conf $(TARGET_DIR)/etc/opkg.conf
	for d in base luci packages routing telephony management oldpackages; do \
		echo "src/gz %n_$$d %U/$$d" >> $(TARGET_DIR)/etc/opkg.conf; \
	done
	$(VERSION_SED) $(TARGET_DIR)/etc/opkg.conf


image: FORCE
	rm -rf $(TARGET_DIR) $(BIN_DIR) $(TMP_DIR) $(PROFILE_KDIR)
	mkdir -p $(TARGET_DIR) $(BIN_DIR) $(TMP_DIR) $(TARGET_DIR)/tmp $(GRAVITON_IMAGEDIR)/factory $(GRAVITON_IMAGEDIR)/sysupgrade
	cp -r $(BOARD_KDIR) $(PROFILE_KDIR)

	+$(GRAVITONMAKE) package_install
	+$(GRAVITONMAKE) opkg_config GRAVITON_OPKG_CONFIG=1

	$(call Image/mkfs/prepare)
	$(_SINGLE)$(NO_TRACE_MAKE) -C $(TOPDIR)/target/linux/$(BOARD)/image install TARGET_BUILD=1 IB=1 IMG_PREFIX=graviton \
		PROFILE="$(PROFILE)" KDIR="$(PROFILE_KDIR)" TARGET_DIR="$(TARGET_DIR)" BIN_DIR="$(BIN_DIR)" TMP_DIR="$(TMP_DIR)"

	$(foreach model,$(GRAVITON_$(PROFILE)_MODELS), \
		rm -f $(GRAVITON_IMAGEDIR)/factory/graviton-*-$(model).bin && \
		rm -f $(GRAVITON_IMAGEDIR)/sysupgrade/graviton-*-$(model)-sysupgrade.bin && \
		\
		cp $(BIN_DIR)/graviton-$(GRAVITON_$(PROFILE)_MODEL_$(model))-factory.bin $(GRAVITON_IMAGEDIR)/factory/$(IMAGE_PREFIX)-$(model).bin && \
		cp $(BIN_DIR)/graviton-$(GRAVITON_$(PROFILE)_MODEL_$(model))-sysupgrade.bin $(GRAVITON_IMAGEDIR)/sysupgrade/$(IMAGE_PREFIX)-$(model)-sysupgrade.bin && \
	) :

image/%: $(graviton_prepared_stamp)
	+$(GRAVITONMAKE) image PROFILE="$(patsubst image/%,%,$@)" V=s$(OPENWRT_VERBOSE)

call_image/%: FORCE
	+$(GRAVITONMAKE) $(patsubst call_image/%,image/%,$@)

images: $(patsubst %,call_image/%,$(PROFILES)) ;

manifest: FORCE
	mkdir -p $(GRAVITON_IMAGEDIR)/sysupgrade
	(cd $(GRAVITON_IMAGEDIR)/sysupgrade && \
		echo 'BRANCH=$(GRAVITON_BRANCH)' && \
		echo 'DATE=$(shell $(STAGING_DIR_HOST)/bin/lua $(GRAVITONDIR)/scripts/rfc3339date.lua)' && \
		echo 'PRIORITY=$(GRAVITON_PRIORITY)' && \
		echo && \
		($(foreach profile,$(PROFILES), \
			$(foreach model,$(GRAVITON_$(profile)_MODELS), \
				for file in graviton-*-'$(model)-sysupgrade.bin'; do \
					[ -e "$$file" ] && echo \
						'$(model)' \
						"$$(echo "$$file" | sed -n -r -e 's/^graviton-$(call regex-escape,$(GRAVITON_SITE_CODE))-(.*)-$(call regex-escape,$(model))-sysupgrade\.bin$$/\1/p')" \
						"$$($(SHA512SUM) "$$file")" \
						"$$file" && break; \
				done; \
			) \
		) :) \
	) > $(GRAVITON_IMAGEDIR)/sysupgrade/$(GRAVITON_BRANCH).manifest


.PHONY: all images prepare clean graviton-tools

endif
