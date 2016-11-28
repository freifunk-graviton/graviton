. "$GRAVITONDIR"/modules
[ ! -f "$GRAVITON_SITEDIR"/modules ] || . "$GRAVITON_SITEDIR"/modules

GRAVITON_MODULES=openwrt

for feed in $GRAVITON_SITE_FEEDS $GRAVITON_FEEDS; do
	GRAVITON_MODULES="$GRAVITON_MODULES packages/$feed"
done
