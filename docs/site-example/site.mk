##	graviton site.mk makefile example

##	GRAVITON_SITE_PACKAGES
#		specify graviton/openwrt packages to include here
#		The graviton-mesh-batman-adv-* package must come first because of the dependency resolution

GRAVITON_SITE_PACKAGES := \
	graviton-autoupdater \
	graviton-admin-core \
	graviton-admin-luci \
	graviton-admin-wireless \
	graviton-admin-advanced \
	iwinfo \
	iptables \
	haveged

##	DEFAULT_GRAVITON_RELEASE
#		version string to use for images
#		graviton relies on
#			opkg compare-versions "$1" '>>' "$2"
#		to decide if a version is newer or not.

DEFAULT_GRAVITON_RELEASE := 2016.1


##	GRAVITON_RELEASE
#		call make with custom GRAVITON_RELEASE flag, to use your own release version scheme.
#		e.g.:
#			$ make images GRAVITON_RELEASE=23.42+5
#		would generate images named like this:
#			graviton-ff%site_code%-23.42+5-%router_model%.bin

# Allow overriding the release number from the command line
GRAVITON_RELEASE ?= $(DEFAULT_GRAVITON_RELEASE)

# Default priority for updates.
GRAVITON_PRIORITY ?= 0
