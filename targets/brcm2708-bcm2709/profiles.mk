$(eval $(call GravitonProfile,RaspberryPi2))
$(eval $(call GravitonProfileFactorySuffix,RaspberryPi2,-vfat-ext4,.img.gz))
$(eval $(call GravitonProfileSysupgradeSuffix,RaspberryPi2,-vfat-ext4,.img.gz))
$(eval $(call GravitonModel,RaspberryPi2,sdcard,raspberry-pi-2))
