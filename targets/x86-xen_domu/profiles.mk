$(eval $(call GravitonProfile,GENERIC))
$(eval $(call GravitonProfileFactorySuffix,GENERIC,-ext4,.img.gz))
$(eval $(call GravitonProfileSysupgradeSuffix,GENERIC,-ext4,.img.gz))
$(eval $(call GravitonModel,GENERIC,combined,x86-xen))
