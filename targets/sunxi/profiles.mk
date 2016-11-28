#Banana Pi/M1
$(eval $(call GravitonProfile,Bananapi,uboot-sunxi-Bananapi kmod-rtc-sunxi))
$(eval $(call GravitonProfileFactorySuffix,Bananapi,-sdcard-vfat-ext4,.img.gz))
$(eval $(call GravitonProfileSysupgradeSuffix,Bananapi))
$(eval $(call GravitonModel,Bananapi,Bananapi,lemaker-banana-pi))

#BananaPi R1 / Lamobo R1
$(eval $(call GravitonProfile,Lamobo_R1,uboot-sunxi-Lamobo_R1 kmod-ata-sunxi kmod-rtl8192cu kmod-rtc-sunxi swconfig))
$(eval $(call GravitonProfileFactorySuffix,Lamobo_R1,-sdcard-vfat-ext4,.img.gz))
$(eval $(call GravitonProfileSysupgradeSuffix,Lamobo_R1))
$(eval $(call GravitonModel,Lamobo_R1,Lamobo_R1,lemaker-lamobo-r1))

# Banana Pro
$(eval $(call GravitonProfile,Bananapro,uboot-sunxi-Bananapro kmod-rtc-sunxi kmod-brcmfmac))
$(eval $(call GravitonProfileFactorySuffix,Bananapro,-sdcard-vfat-ext4,.img.gz))
$(eval $(call GravitonProfileSysupgradeSuffix,Bananapro))
$(eval $(call GravitonModel,Bananapro,Bananapro,lemaker-banana-pro))
