# List of hardware profiles

## Mikrotik

# Will contain both ath5k and ath9k
# ath5k cards are commonly used with Mikrotik hardware
$(eval $(call GravitonProfile,DefaultNoWifi,kmod-ath5k))
$(eval $(call GravitonProfileFactorySuffix,DefaultNoWifi,,-rootfs.tar.gz,-vmlinux-lzma.elf))
$(eval $(call GravitonProfileSysupgradeSuffix,DefaultNoWifi))
$(eval $(call GravitonModel,DefaultNoWifi,DefaultNoWifi,mikrotik))
