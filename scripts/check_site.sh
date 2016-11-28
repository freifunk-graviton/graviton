#!/bin/sh

SITE_CONFIG_LUA=scripts/site_config.lua
CHECK_SITE_LIB=scripts/check_site_lib.lua

"$GRAVITONDIR"/openwrt/staging_dir/host/bin/lua -e "site = dofile(os.getenv('GRAVITONDIR') .. '/${SITE_CONFIG_LUA}'); dofile(os.getenv('GRAVITONDIR') .. '/${CHECK_SITE_LIB}'); dofile()"
