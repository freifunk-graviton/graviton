$(eval $(call GravitonTarget,ar71xx,generic))
$(eval $(call GravitonTarget,ar71xx,nand))
$(eval $(call GravitonTarget,brcm2708,bcm2708))
$(eval $(call GravitonTarget,brcm2708,bcm2709))
$(eval $(call GravitonTarget,mpc85xx,generic))
$(eval $(call GravitonTarget,x86,generic))
$(eval $(call GravitonTarget,x86,kvm_guest))
$(eval $(call GravitonTarget,x86,64))
$(eval $(call GravitonTarget,x86,xen_domu))

ifneq ($(BROKEN),)
$(eval $(call GravitonTarget,ar71xx,mikrotik)) # BROKEN: no sysupgrade support
$(eval $(call GravitonTarget,ramips,mt7621)) # BROKEN: No AP+IBSS support, 11s has high packet loss
$(eval $(call GravitonTarget,ramips,rt305x)) # BROKEN: No AP+IBSS support
$(eval $(call GravitonTarget,sunxi)) # BROKEN: Untested, no sysupgrade support
endif
