ifneq ($(__graviton_inc),1)
__graviton_inc=1

GRAVITON_SITEDIR ?= $(GRAVITONDIR)/site
GRAVITON_IMAGEDIR ?= $(GRAVITONDIR)/images
GRAVITON_BUILDDIR ?= $(GRAVITONDIR)/build

GRAVITON_ORIGOPENWRTDIR := $(GRAVITONDIR)/openwrt
GRAVITON_SITE_CONFIG := $(GRAVITON_SITEDIR)/site.conf

GRAVITON_OPENWRTDIR = $(GRAVITON_BUILDDIR)/$(GRAVITON_TARGET)/openwrt

BOARD_BUILDDIR = $(GRAVITON_BUILDDIR)/$(BOARD)$(if $(SUBTARGET),-$(SUBTARGET))
BOARD_KDIR = $(BOARD_BUILDDIR)/kernel

export GRAVITONDIR GRAVITON_SITEDIR GRAVITON_SITE_CONFIG GRAVITON_IMAGEDIR GRAVITON_OPENWRTDIR GRAVITON_BUILDDIR

$(GRAVITON_SITEDIR)/site.mk:
	$(error There was no site configuration found. Please check out a site configuration to $(GRAVITON_SITEDIR))

-include $(GRAVITON_SITEDIR)/site.mk


GRAVITON_VERSION := $(shell cd $(GRAVITONDIR) && git describe --always 2>/dev/null || echo unknown)
export GRAVITON_VERSION


ifeq ($(OPENWRT_BUILD),1)
ifeq ($(GRAVITON_TOOLS),1)

CONFIG_VERSION_REPO := $(shell $(GRAVITONDIR)/scripts/site.sh opkg_repo || echo http://downloads.openwrt.org/barrier_breaker/14.07/%S/packages)
export CONFIG_VERSION_REPO

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

regex-escape = $(shell echo '$(1)' | sed -e 's/[]\/()$*.^|[]/\\&/g')

GRAVITON_DEFAULT_PACKAGES := graviton-core kmod-ipv6 firewall ip6tables -uboot-envtools

override DEFAULT_PACKAGES.router :=

endif #__graviton_inc
