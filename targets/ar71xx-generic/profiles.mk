# List of hardware profiles

ATH10K_FIRMWARE :=

ifeq ($(GRAVITON_ATH10K_MESH),11s)
ATH10K_FIRMWARE := ath10k-firmware-qca988x-11s
endif
ifeq ($(GRAVITON_ATH10K_MESH),ibss)
ATH10K_FIRMWARE := ath10k-firmware-qca988x-ct
endif

## TP-Link

# CPE210/220/510/520
$(eval $(call GravitonProfile,CPE510,rssileds))

$(eval $(call GravitonModel,CPE510,cpe210-220,tp-link-cpe210-v1.0))
$(eval $(call GravitonModelAlias,CPE510,tp-link-cpe210-v1.0,tp-link-cpe210-v1.1))
$(eval $(call GravitonModelAlias,CPE510,tp-link-cpe210-v1.0,tp-link-cpe220-v1.0))
$(eval $(call GravitonModelAlias,CPE510,tp-link-cpe210-v1.0,tp-link-cpe220-v1.1))

$(eval $(call GravitonModel,CPE510,cpe510-520,tp-link-cpe510-v1.0))
$(eval $(call GravitonModelAlias,CPE510,tp-link-cpe510-v1.0,tp-link-cpe510-v1.1))
$(eval $(call GravitonModelAlias,CPE510,tp-link-cpe510-v1.0,tp-link-cpe520-v1.0))
$(eval $(call GravitonModelAlias,CPE510,tp-link-cpe510-v1.0,tp-link-cpe520-v1.1))

# TL-WA701N/ND v1, v2
$(eval $(call GravitonProfile,TLWA701))
$(eval $(call GravitonModel,TLWA701,tl-wa701n-v1,tp-link-tl-wa701n-nd-v1))
$(eval $(call GravitonModel,TLWA701,tl-wa701nd-v2,tp-link-tl-wa701n-nd-v2))

# TL-WA7510 v1
$(eval $(call GravitonProfile,TLWA7510))
$(eval $(call GravitonModel,TLWA7510,tl-wa7510n,tp-link-tl-wa7510n-v1))

# TL-WR703N v1
$(eval $(call GravitonProfile,TLWR703))
$(eval $(call GravitonModel,TLWR703,tl-wr703n-v1,tp-link-tl-wr703n-v1))

# TL-WR710N v1, v2, v2.1
$(eval $(call GravitonProfile,TLWR710))
$(eval $(call GravitonModel,TLWR710,tl-wr710n-v1,tp-link-tl-wr710n-v1))
$(eval $(call GravitonModel,TLWR710,tl-wr710n-v2,tp-link-tl-wr710n-v2))
$(eval $(call GravitonModel,TLWR710,tl-wr710n-v2.1,tp-link-tl-wr710n-v2.1))

# TL-WR740N v1, v3, v4, v5
$(eval $(call GravitonProfile,TLWR740))
$(eval $(call GravitonModel,TLWR740,tl-wr740n-v1,tp-link-tl-wr740n-nd-v1))
$(eval $(call GravitonModel,TLWR740,tl-wr740n-v3,tp-link-tl-wr740n-nd-v3))
$(eval $(call GravitonModel,TLWR740,tl-wr740n-v4,tp-link-tl-wr740n-nd-v4))
$(eval $(call GravitonModel,TLWR740,tl-wr740n-v5,tp-link-tl-wr740n-nd-v5))

# TL-WR741N/ND v1, v2, v4, v5
$(eval $(call GravitonProfile,TLWR741))
$(eval $(call GravitonModel,TLWR741,tl-wr741nd-v1,tp-link-tl-wr741n-nd-v1))
$(eval $(call GravitonModel,TLWR741,tl-wr741nd-v2,tp-link-tl-wr741n-nd-v2))
$(eval $(call GravitonModel,TLWR741,tl-wr741nd-v4,tp-link-tl-wr741n-nd-v4))
$(eval $(call GravitonModel,TLWR741,tl-wr741nd-v5,tp-link-tl-wr741n-nd-v5))

# TL-WR743N/ND v1, v1.1, v2
$(eval $(call GravitonProfile,TLWR743))
$(eval $(call GravitonModel,TLWR743,tl-wr743nd-v1,tp-link-tl-wr743n-nd-v1))
$(eval $(call GravitonModel,TLWR743,tl-wr743nd-v2,tp-link-tl-wr743n-nd-v2))

# TL-WR801N/ND v1, v2, v3
$(eval $(call GravitonProfile,TLWA801))
$(eval $(call GravitonModel,TLWA801,tl-wa801nd-v1,tp-link-tl-wa801n-nd-v1))
$(eval $(call GravitonModel,TLWA801,tl-wa801nd-v2,tp-link-tl-wa801n-nd-v2))
ifneq ($(BROKEN),)
$(eval $(call GravitonModel,TLWA801,tl-wa801nd-v3,tp-link-tl-wa801n-nd-v3)) # BROKEN: untested
endif

# TL-WR841N/ND v3, v5, v7, v8, v9, v10
$(eval $(call GravitonProfile,TLWR841))
$(eval $(call GravitonModel,TLWR841,tl-wr841nd-v3,tp-link-tl-wr841n-nd-v3))
$(eval $(call GravitonModel,TLWR841,tl-wr841nd-v5,tp-link-tl-wr841n-nd-v5))
$(eval $(call GravitonModel,TLWR841,tl-wr841nd-v7,tp-link-tl-wr841n-nd-v7))
$(eval $(call GravitonModel,TLWR841,tl-wr841n-v8,tp-link-tl-wr841n-nd-v8))
$(eval $(call GravitonModel,TLWR841,tl-wr841n-v9,tp-link-tl-wr841n-nd-v9))
$(eval $(call GravitonModel,TLWR841,tl-wr841n-v10,tp-link-tl-wr841n-nd-v10))

# TL-WR841N/ND v11
$(eval $(call GravitonProfile,TLWR841_REGION,,TLWR841))
$(eval $(call GravitonModel,TLWR841_REGION,tl-wr841n-v11,tp-link-tl-wr841n-nd-v11))
$(eval $(call GravitonProfileFactorySuffix,TLWR841_REGION,-squashfs-factory$(if $(GRAVITON_REGION),-$(GRAVITON_REGION)),.bin))

# TL-WR842N/ND v1, v2
$(eval $(call GravitonProfile,TLWR842))
$(eval $(call GravitonModel,TLWR842,tl-wr842n-v1,tp-link-tl-wr842n-nd-v1))
$(eval $(call GravitonModel,TLWR842,tl-wr842n-v2,tp-link-tl-wr842n-nd-v2))
$(eval $(call GravitonModel,TLWR842,tl-wr842n-v3,tp-link-tl-wr842n-nd-v3))

# TL-WR843N/ND v1
$(eval $(call GravitonProfile,TLWR843))
$(eval $(call GravitonModel,TLWR843,tl-wr843nd-v1,tp-link-tl-wr843n-nd-v1))

# TL-WR941N/ND v2, v3, v4, v5, v6; TL-WR940N/ND v1, v2, v3
$(eval $(call GravitonProfile,TLWR941))
$(eval $(call GravitonModel,TLWR941,tl-wr941nd-v2,tp-link-tl-wr941n-nd-v2))
$(eval $(call GravitonModel,TLWR941,tl-wr941nd-v3,tp-link-tl-wr941n-nd-v3))
$(eval $(call GravitonModel,TLWR941,tl-wr941nd-v4,tp-link-tl-wr941n-nd-v4))
$(eval $(call GravitonModel,TLWR941,tl-wr941nd-v5,tp-link-tl-wr941n-nd-v5))
$(eval $(call GravitonModel,TLWR941,tl-wr941nd-v6,tp-link-tl-wr941n-nd-v6))

$(eval $(call GravitonModelAlias,TLWR941,tp-link-tl-wr941n-nd-v4,tp-link-tl-wr940n-nd-v1))
$(eval $(call GravitonModelAlias,TLWR941,tp-link-tl-wr941n-nd-v5,tp-link-tl-wr940n-nd-v2))
$(eval $(call GravitonModelAlias,TLWR941,tp-link-tl-wr941n-nd-v6,tp-link-tl-wr940n-nd-v3))

# TL-WR1043N/ND v1, v2, v3
$(eval $(call GravitonProfile,TLWR1043))
$(eval $(call GravitonModel,TLWR1043,tl-wr1043nd-v1,tp-link-tl-wr1043n-nd-v1))
$(eval $(call GravitonModel,TLWR1043,tl-wr1043nd-v2,tp-link-tl-wr1043n-nd-v2))
$(eval $(call GravitonModel,TLWR1043,tl-wr1043nd-v3,tp-link-tl-wr1043n-nd-v3))

# TL-WDR3500/3600/4300 v1
$(eval $(call GravitonProfile,TLWDR4300))
$(eval $(call GravitonModel,TLWDR4300,tl-wdr3500-v1,tp-link-tl-wdr3500-v1))
$(eval $(call GravitonModel,TLWDR4300,tl-wdr3600-v1,tp-link-tl-wdr3600-v1))
$(eval $(call GravitonModel,TLWDR4300,tl-wdr4300-v1,tp-link-tl-wdr4300-v1))

# TL-WA750RE v1
$(eval $(call GravitonProfile,TLWA750))
$(eval $(call GravitonModel,TLWA750,tl-wa750re-v1,tp-link-tl-wa750re-v1))

# TL-WA830RE v1, v2
$(eval $(call GravitonProfile,TLWA830))
$(eval $(call GravitonModel,TLWA830,tl-wa830re-v1,tp-link-tl-wa830re-v1))
$(eval $(call GravitonModel,TLWA830,tl-wa830re-v2,tp-link-tl-wa830re-v2))

# TL-WA850RE v1
$(eval $(call GravitonProfile,TLWA850))
$(eval $(call GravitonModel,TLWA850,tl-wa850re-v1,tp-link-tl-wa850re-v1))

# TL-WA860RE v1
$(eval $(call GravitonProfile,TLWA860))
$(eval $(call GravitonModel,TLWA860,tl-wa860re-v1,tp-link-tl-wa860re-v1))

# TL-WA901N/ND v1, v2, v3, v4
$(eval $(call GravitonProfile,TLWA901))
$(eval $(call GravitonModel,TLWA901,tl-wa901nd-v1,tp-link-tl-wa901n-nd-v1))
$(eval $(call GravitonModel,TLWA901,tl-wa901nd-v2,tp-link-tl-wa901n-nd-v2))
$(eval $(call GravitonModel,TLWA901,tl-wa901nd-v3,tp-link-tl-wa901n-nd-v3))
$(eval $(call GravitonModel,TLWA901,tl-wa901nd-v4,tp-link-tl-wa901n-nd-v4))

# TL-MR13U v1
$(eval $(call GravitonProfile,TLMR13U))
$(eval $(call GravitonModel,TLMR13U,tl-mr13u-v1,tp-link-tl-mr13u-v1))

# TL-MR3020 v1
$(eval $(call GravitonProfile,TLMR3020))
$(eval $(call GravitonModel,TLMR3020,tl-mr3020-v1,tp-link-tl-mr3020-v1))

# TL-MR3040 v1, v2
$(eval $(call GravitonProfile,TLMR3040))
$(eval $(call GravitonModel,TLMR3040,tl-mr3040-v1,tp-link-tl-mr3040-v1))
$(eval $(call GravitonModel,TLMR3040,tl-mr3040-v2,tp-link-tl-mr3040-v2))

# TL-MR3220 v1, v2
$(eval $(call GravitonProfile,TLMR3220))
$(eval $(call GravitonModel,TLMR3220,tl-mr3220-v1,tp-link-tl-mr3220-v1))
$(eval $(call GravitonModel,TLMR3220,tl-mr3220-v2,tp-link-tl-mr3220-v2))

# TL-MR3420 v1, v2
$(eval $(call GravitonProfile,TLMR3420))
$(eval $(call GravitonModel,TLMR3420,tl-mr3420-v1,tp-link-tl-mr3420-v1))
$(eval $(call GravitonModel,TLMR3420,tl-mr3420-v2,tp-link-tl-mr3420-v2))

# TL-WR2543N/ND v1
$(eval $(call GravitonProfile,TLWR2543))
$(eval $(call GravitonModel,TLWR2543,tl-wr2543-v1,tp-link-tl-wr2543n-nd-v1))

ifneq ($(ATH10K_FIRMWARE),)
# Archer C5 v1
$(eval $(call GravitonProfile,ARCHERC5,kmod-ath10k-ct $(ATH10K_FIRMWARE),ARCHERC7))
$(eval $(call GravitonModel,ARCHERC5,archer-c5,tp-link-archer-c5-v1))

# Archer C7 v2
$(eval $(call GravitonProfile,ARCHERC7,kmod-ath10k-ct $(ATH10K_FIRMWARE)))
$(eval $(call GravitonProfileFactorySuffix,ARCHERC7,-squashfs-factory$(if $(GRAVITON_REGION),-$(GRAVITON_REGION)),.bin))
$(eval $(call GravitonModel,ARCHERC7,archer-c7-v2,tp-link-archer-c7-v2))
endif

## Ubiquiti (almost everything)
$(eval $(call GravitonProfile,UBNT))
$(eval $(call GravitonModel,UBNT,ubnt-air-gateway,ubiquiti-airgateway))
$(eval $(call GravitonModel,UBNT,ubnt-airrouter,ubiquiti-airrouter))

$(eval $(call GravitonModel,UBNT,ubnt-bullet-m,ubiquiti-bullet-m))
$(eval $(call GravitonModelAlias,UBNT,ubiquiti-bullet-m,ubiquiti-nanostation-loco-m2))
$(eval $(call GravitonModelAlias,UBNT,ubiquiti-bullet-m,ubiquiti-nanostation-loco-m5))
$(eval $(call GravitonModelAlias,UBNT,ubiquiti-bullet-m,ubiquiti-rocket-m2))
$(eval $(call GravitonModelAlias,UBNT,ubiquiti-bullet-m,ubiquiti-rocket-m5))
$(eval $(call GravitonModelAlias,UBNT,ubiquiti-bullet-m,ubiquiti-bullet-m2))
$(eval $(call GravitonModelAlias,UBNT,ubiquiti-bullet-m,ubiquiti-bullet-m5))
$(eval $(call GravitonModelAlias,UBNT,ubiquiti-bullet-m,ubiquiti-picostation-m2))

$(eval $(call GravitonModel,UBNT,ubnt-nano-m,ubiquiti-nanostation-m))
$(eval $(call GravitonModelAlias,UBNT,ubiquiti-nanostation-m,ubiquiti-nanostation-m2))
$(eval $(call GravitonModelAlias,UBNT,ubiquiti-nanostation-m,ubiquiti-nanostation-m5))

$(eval $(call GravitonModel,UBNT,ubnt-loco-m-xw,ubiquiti-loco-m-xw))
$(eval $(call GravitonModel,UBNT,ubnt-nano-m-xw,ubiquiti-nanostation-m-xw))
$(eval $(call GravitonModel,UBNT,ubnt-rocket-m-xw,ubiquiti-rocket-m-xw))
$(eval $(call GravitonModel,UBNT,ubnt-uap-pro,ubiquiti-unifi-ap-pro))
$(eval $(call GravitonModel,UBNT,ubnt-unifi,ubiquiti-unifi))
$(eval $(call GravitonModel,UBNT,ubnt-unifi-outdoor,ubiquiti-unifiap-outdoor))
$(eval $(call GravitonModel,UBNT,ubnt-unifi-outdoor-plus,ubiquiti-unifiap-outdoor+))

ifneq ($(BROKEN),)
$(eval $(call GravitonModel,UBNT,ubnt-ls-sr71,ubiquiti-ls-sr71)) # BROKEN: Untested
endif

# Ubiquiti (ath10k)
ifneq ($(ATH10K_FIRMWARE),)
$(eval $(call GravitonProfile,UBNTUNIFIACLITE,kmod-ath10k-ct $(ATH10K_FIRMWARE)))
$(eval $(call GravitonProfileFactorySuffix,UBNTUNIFIACLITE))
$(eval $(call GravitonModel,UBNTUNIFIACLITE,ubnt-unifiac-lite,ubiquiti-unifi-ac-lite))

$(eval $(call GravitonProfile,UBNTUNIFIACPRO,kmod-ath10k-ct $(ATH10K_FIRMWARE)))
$(eval $(call GravitonProfileFactorySuffix,UBNTUNIFIACPRO))
$(eval $(call GravitonModel,UBNTUNIFIACPRO,ubnt-unifiac-pro,ubiquiti-unifi-ac-pro))
endif

## D-Link

# D-Link DIR-505 rev. A1/A2

$(eval $(call GravitonProfile,DIR505A1))
$(eval $(call GravitonModel,DIR505A1,dir-505-a1,d-link-dir-505-rev-a1))
$(eval $(call GravitonModelAlias,DIR505A1,d-link-dir-505-rev-a1,d-link-dir-505-rev-a2))

# D-Link DIR-615 rev. C1
$(eval $(call GravitonProfile,DIR615C1))
$(eval $(call GravitonModel,DIR615C1,dir-615-c1,d-link-dir-615-rev-c1))

# D-Link DIR-825 rev. B1
$(eval $(call GravitonProfile,DIR825B1))
$(eval $(call GravitonModel,DIR825B1,dir-825-b1,d-link-dir-825-rev-b1))


## Linksys by Cisco

# WRT160NL
$(eval $(call GravitonProfile,WRT160NL))
$(eval $(call GravitonModel,WRT160NL,wrt160nl,linksys-wrt160nl))

## Buffalo

# WZR-HP-G450H
$(eval $(call GravitonProfile,WZRHPG450H))
$(eval $(call GravitonModel,WZRHPG450H,wzr-hp-g450h,buffalo-wzr-hp-g450h))

# WZR-HP-G300NH
$(eval $(call GravitonProfile,WZRHPG300NH))
$(eval $(call GravitonModel,WZRHPG300NH,wzr-hp-g300nh,buffalo-wzr-hp-g300nh))

# WZR-HP-G300NH2
$(eval $(call GravitonProfile,WZRHPG300NH2))
$(eval $(call GravitonModel,WZRHPG300NH2,wzr-hp-g300nh2,buffalo-wzr-hp-g300nh2))

# WZR-HP-AG300H (factory)
$(eval $(call GravitonProfile,WZRHPAG300H))
$(eval $(call GravitonProfileSysupgradeSuffix,WZRHPAG300H))
$(eval $(call GravitonModel,WZRHPAG300H,wzr-hp-ag300h,buffalo-wzr-hp-ag300h))

# WZR-600DHP (factory)
$(eval $(call GravitonProfile,WZR600DHP))
$(eval $(call GravitonProfileSysupgradeSuffix,WZR600DHP))
$(eval $(call GravitonModel,WZR600DHP,wzr-600dhp,buffalo-wzr-600dhp))

# WZR-HP-AG300H/WZR-600DHP (sysupgrade)
$(eval $(call GravitonProfile,WZRHPAG300H_WZR600DHP,,WZRHPAG300H))
$(eval $(call GravitonProfileFactorySuffix,WZRHPAG300H_WZR600DHP))
$(eval $(call GravitonModel,WZRHPAG300H_WZR600DHP,wzr-hp-ag300h,buffalo-wzr-hp-ag300h-wzr-600dhp))

# WHR-HP-G300N
#$(eval $(call GravitonProfile,WHRHPG300N))
#$(eval $(call GravitonModel,WHRHPG300N,whr-hp-g300n,buffalo-whr-hp-g300n))

## Netgear

# WNDR3700 (v1, v2) / WNDR3800 / WNDRMAC (v1, v2)
$(eval $(call GravitonProfile,WNDR3700))
$(eval $(call GravitonProfileFactorySuffix,WNDR3700,-squashfs-factory,.img))
$(eval $(call GravitonModel,WNDR3700,wndr3700,netgear-wndr3700))
$(eval $(call GravitonModel,WNDR3700,wndr3700v2,netgear-wndr3700v2))
$(eval $(call GravitonModel,WNDR3700,wndr3800,netgear-wndr3800))
ifneq ($(BROKEN),)
$(eval $(call GravitonModel,WNDR3700,wndrmac,netgear-wndrmac)) # BROKEN: untested
endif
$(eval $(call GravitonModel,WNDR3700,wndrmacv2,netgear-wndrmacv2))

ifneq ($(BROKEN),)
# WNR2200
$(eval $(call GravitonProfile,WNR2200)) # BROKEN: untested
$(eval $(call GravitonModel,WNR2200,wnr2200,netgear-wnr2200))
$(eval $(call GravitonProfileFactorySuffix,WNR2200,.img))
endif


## Allnet

# ALL0315N
$(eval $(call GravitonProfile,ALL0315N,uboot-envtools rssileds))
$(eval $(call GravitonProfileFactorySuffix,ALL0315N))
$(eval $(call GravitonModel,ALL0315N,all0315n,allnet-all0315n))

## GL-iNet

# GL-iNet 1.0
$(eval $(call GravitonProfile,GLINET))
$(eval $(call GravitonModel,GLINET,gl-inet-6408A-v1,gl-inet-6408a-v1))
$(eval $(call GravitonModel,GLINET,gl-inet-6416A-v1,gl-inet-6416a-v1))

$(eval $(call GravitonProfile,GL-AR150))
$(eval $(call GravitonModel,GL-AR150,gl-ar150,gl-ar150))
$(eval $(call GravitonProfileFactorySuffix,GL-AR150))

## Western Digital

# WD MyNet N600
$(eval $(call GravitonProfile,MYNETN600))
$(eval $(call GravitonModel,MYNETN600,mynet-n600,wd-my-net-n600))

# WD MyNet N750
$(eval $(call GravitonProfile,MYNETN750))
$(eval $(call GravitonModel,MYNETN750,mynet-n750,wd-my-net-n750))

## Onion

# Omega
$(eval $(call GravitonProfile,OMEGA))
$(eval $(call GravitonModel,OMEGA,onion-omega,onion-omega))

## OpenMesh

ifneq ($(ATH10K_FIRMWARE),)
# MR1750
$(eval $(call GravitonProfile,MR1750,om-watchdog uboot-envtools kmod-ath10k-ct $(ATH10K_FIRMWARE)))
$(eval $(call GravitonModel,MR1750,mr1750,openmesh-mr1750))
$(eval $(call GravitonModelAlias,MR1750,openmesh-mr1750,openmesh-mr1750v2))
endif

# MR600
$(eval $(call GravitonProfile,MR600,om-watchdog uboot-envtools))
$(eval $(call GravitonModel,MR600,mr600,openmesh-mr600))
$(eval $(call GravitonModelAlias,MR600,openmesh-mr600,openmesh-mr600v2))

# MR900
$(eval $(call GravitonProfile,MR900,om-watchdog uboot-envtools))
$(eval $(call GravitonModel,MR900,mr900,openmesh-mr900))
$(eval $(call GravitonModelAlias,MR900,openmesh-mr900,openmesh-mr900v2))

# OM2P
$(eval $(call GravitonProfile,OM2P,om-watchdog uboot-envtools))
$(eval $(call GravitonModel,OM2P,om2p,openmesh-om2p))
$(eval $(call GravitonModelAlias,OM2P,openmesh-om2p,openmesh-om2pv2))
$(eval $(call GravitonModelAlias,OM2P,openmesh-om2p,openmesh-om2p-hs))
$(eval $(call GravitonModelAlias,OM2P,openmesh-om2p,openmesh-om2p-hsv2))
$(eval $(call GravitonModelAlias,OM2P,openmesh-om2p,openmesh-om2p-hsv3))
$(eval $(call GravitonModelAlias,OM2P,openmesh-om2p,openmesh-om2p-lc))

# OM5P
$(eval $(call GravitonProfile,OM5P,om-watchdog uboot-envtools))
$(eval $(call GravitonModel,OM5P,om5p,openmesh-om5p))
$(eval $(call GravitonModelAlias,OM5P,openmesh-om5p,openmesh-om5p-an))

ifneq ($(ATH10K_FIRMWARE),)
# OM5P-AC
$(eval $(call GravitonProfile,OM5PAC,om-watchdog uboot-envtools kmod-ath10k-ct $(ATH10K_FIRMWARE)))
$(eval $(call GravitonModel,OM5PAC,om5pac,openmesh-om5p-ac))
$(eval $(call GravitonModelAlias,OM5PAC,openmesh-om5p-ac,openmesh-om5p-acv2))
endif

## ALFA NETWORK

# Hornet-UB
$(eval $(call GravitonProfile,HORNETUB))
$(eval $(call GravitonModel,HORNETUB,hornet-ub,alfa-network-hornet-ub))
$(eval $(call GravitonModelAlias,HORNETUB,alfa-network-hornet-ub,alfa-network-ap121))
$(eval $(call GravitonModelAlias,HORNETUB,alfa-network-hornet-ub,alfa-network-ap121u))

# Tube2H
$(eval $(call GravitonProfile,TUBE2H))
$(eval $(call GravitonModel,TUBE2H,tube2h-8M,alfa-network-tube2h))

# N2/N5
$(eval $(call GravitonProfile,ALFANX))
$(eval $(call GravitonModel,ALFANX,alfa-nx,alfa-network-n2-n5))

## Meraki

# Meraki MR12/MR62
$(eval $(call GravitonProfile,MR12,rssileds))
$(eval $(call GravitonProfileFactorySuffix,MR12))
$(eval $(call GravitonModel,MR12,mr12,meraki-mr12))
$(eval $(call GravitonModelAlias,MR12,meraki-mr12,meraki-mr62))

# Meraki MR16/MR66
$(eval $(call GravitonProfile,MR16,rssileds))
$(eval $(call GravitonProfileFactorySuffix,MR16))
$(eval $(call GravitonModel,MR16,mr16,meraki-mr16))
$(eval $(call GravitonModelAlias,MR16,meraki-mr16,meraki-mr66))

## 8devices

# Carambola 2
$(eval $(call GravitonProfile,CARAMBOLA2))
$(eval $(call GravitonModel,CARAMBOLA2,carambola2,8devices-carambola2-board))
$(eval $(call GravitonProfileFactorySuffix,CARAMBOLA2))
