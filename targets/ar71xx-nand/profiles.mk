# List of hardware profiles

## NETGEAR

# WNDR3700 v4, WNDR4300 v1
$(eval $(call GravitonProfile,WNDR4300))
$(eval $(call GravitonProfileFactorySuffix,WNDR4300,-ubi-factory,.img))
$(eval $(call GravitonProfileSysupgradeSuffix,WNDR4300,-squashfs-sysupgrade,.tar))
$(eval $(call GravitonModel,WNDR4300,wndr3700v4,netgear-wndr3700v4))
$(eval $(call GravitonModel,WNDR4300,wndr4300,netgear-wndr4300))
