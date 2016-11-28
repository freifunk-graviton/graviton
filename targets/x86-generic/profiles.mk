X86_GENERIC_NETWORK_MODULES := kmod-3c59x kmod-8139too kmod-e100 kmod-e1000 kmod-e1000e kmod-forcedeth kmod-igb kmod-natsemi kmod-ne2k-pci kmod-pcnet32 kmod-r8169 kmod-sis900 kmod-sky2 kmod-tg3 kmod-tulip kmod-via-rhine kmod-via-velocity


$(eval $(call GravitonProfile,GENERIC,$(X86_GENERIC_NETWORK_MODULES)))
$(eval $(call GravitonProfileFactorySuffix,GENERIC,-ext4,.img.gz))
$(eval $(call GravitonProfileSysupgradeSuffix,GENERIC,-ext4,.img.gz))
$(eval $(call GravitonModel,GENERIC,combined,x86-generic))

$(eval $(call GravitonProfile,VDI,$(X86_GENERIC_NETWORK_MODULES)))
$(eval $(call GravitonProfileFactorySuffix,VDI,-ext4,.vdi))
$(eval $(call GravitonProfileSysupgradeSuffix,VDI))
$(eval $(call GravitonModel,VDI,combined,x86-virtualbox))

$(eval $(call GravitonProfile,VMDK,$(X86_GENERIC_NETWORK_MODULES)))
$(eval $(call GravitonProfileFactorySuffix,VMDK,-ext4,.vmdk))
$(eval $(call GravitonProfileSysupgradeSuffix,VMDK))
$(eval $(call GravitonModel,VMDK,combined,x86-vmware))
