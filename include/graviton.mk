ifneq ($(__graviton_inc),1)
__graviton_inc=1

GRAVITON_SITEDIR ?= $(GRAVITONDIR)/site
GRAVITON_BUILDDIR ?= $(GRAVITONDIR)/build

GRAVITON_ORIGOPENWRTDIR := $(GRAVITONDIR)/openwrt
GRAVITON_SITE_CONFIG := $(GRAVITON_SITEDIR)/site.conf

GRAVITON_OUTPUTDIR ?= $(GRAVITONDIR)/output
GRAVITON_IMAGEDIR ?= $(GRAVITON_OUTPUTDIR)/images
GRAVITON_MODULEDIR ?= $(GRAVITON_OUTPUTDIR)/modules

GRAVITON_OPKG_KEY ?= $(GRAVITON_BUILDDIR)/graviton-opkg-key

export GRAVITONDIR GRAVITON_SITEDIR GRAVITON_BUILDDIR GRAVITON_SITE_CONFIG GRAVITON_OUTPUTDIR GRAVITON_IMAGEDIR GRAVITON_MODULEDIR


BOARD_BUILDDIR = $(GRAVITON_BUILDDIR)/$(GRAVITON_TARGET)
BOARD_KDIR = $(BOARD_BUILDDIR)/kernel

export BOARD_BUILDDIR


LINUX_RELEASE := 2
export LINUX_RELEASE


GRAVITON_OPENWRTDIR = $(BOARD_BUILDDIR)/openwrt


$(GRAVITON_SITEDIR)/site.mk:
	$(error There was no site configuration found. Please check out a site configuration to $(GRAVITON_SITEDIR))

-include $(GRAVITON_SITEDIR)/site.mk


GRAVITON_VERSION := $(shell cd $(GRAVITONDIR) && git describe --always 2>/dev/null || echo unknown)
export GRAVITON_VERSION

GRAVITON_LANGS ?= en
export GRAVITON_LANGS


ifeq ($(OPENWRT_BUILD),1)
ifeq ($(GRAVITON_TOOLS),1)

GRAVITON_OPENWRT_FEEDS := base packages luci routing telephony management
export GRAVITON_OPENWRT_FEEDS

GRAVITON_SITE_CODE := $(shell $(GRAVITONDIR)/scripts/site.sh site_code)
export GRAVITON_SITE_CODE

ifeq ($(GRAVITON_RELEASE),)
$(error GRAVITON_RELEASE not set. GRAVITON_RELEASE can be set in site.mk or on the command line.)
endif
export GRAVITON_RELEASE

endif
endif


define merge-lists
$(1) :=
$(foreach var,$(2),$(1) := $$(filter-out -% $$(patsubst -%,%,$$(filter -%,$$($(var)))),$$($(1)) $$($(var)))
)
endef

GRAVITON_TARGETS :=

define GravitonTarget
graviton_target := $(1)$$(if $(2),-$(2))
GRAVITON_TARGETS += $$(graviton_target)
GRAVITON_TARGET_$$(graviton_target)_BOARD := $(1)
GRAVITON_TARGET_$$(graviton_target)_SUBTARGET := $(2)
endef

GRAVITON_DEFAULT_PACKAGES := graviton-core firewall ip6tables -uboot-envtools -wpad-mini hostapd-mini

override DEFAULT_PACKAGES.router :=

endif #__graviton_inc
