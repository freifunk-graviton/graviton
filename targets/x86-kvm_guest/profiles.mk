$(eval $(call GravitonProfile,KVM,kmod-virtio-balloon kmod-virtio-net kmod-virtio-random))
$(eval $(call GravitonProfileFactorySuffix,KVM,-ext4,.img.gz))
$(eval $(call GravitonProfileSysupgradeSuffix,KVM,-ext4,.img.gz))
$(eval $(call GravitonModel,KVM,combined,x86-kvm))
