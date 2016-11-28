$(eval $(call GravitonProfile,RaspberryPi))
$(eval $(call GravitonProfileFactorySuffix,RaspberryPi,-vfat-ext4,.img.gz))
$(eval $(call GravitonProfileSysupgradeSuffix,RaspberryPi,-vfat-ext4,.img.gz))
$(eval $(call GravitonModel,RaspberryPi,sdcard,raspberry-pi))
