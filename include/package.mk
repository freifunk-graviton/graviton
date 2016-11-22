include $(INCLUDE_DIR)/package.mk

# Annoyingly, make's shell function replaces all newlines with spaces, so we have to do some escaping work. Yuck.
define GravitonCheckSite
[ -z "$$GRAVITONDIR" ] || sed -e 's/-@/\n/g' -e 's/+@/@/g' <<'END__GRAVITON__CHECK__SITE' | "$$GRAVITONDIR"/scripts/check_site.sh
$(shell cat $(1) | sed -ne '1h; 1!H; $$ {g; s/@/+@/g; s/\n/-@/g; p}')
END__GRAVITON__CHECK__SITE
endef
