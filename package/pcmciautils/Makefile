# This file is part of the OpenADK project. OpenADK is copyrighted
# material, please see the LICENCE file in the top-level directory.

include $(ADK_TOPDIR)/rules.mk

PKG_NAME:=		pcmciautils
PKG_VERSION:=		018
PKG_RELEASE:=		1
PKG_HASH:=		b94b71347fa11b7c0eb8dae034b5f7f649b135ffacb80cf60572a5bcb118f095
PKG_DESCR:=		utilities for pcmcia subsystem
PKG_SECTION:=		sys/utils
PKG_BUILDDEP:=		sysfsutils bison-host flex-host
PKG_URL:=		http://www.kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html
PKG_SITES:=		http://www.kernel.org/pub/linux/utils/kernel/pcmcia/

PKG_CFLINE_PCMCIAUTILS:=depends on ADK_TARGET_WITH_CARDBUS
DISTFILES:=		${PKG_NAME}-${PKG_VERSION}.tar.gz

include $(ADK_TOPDIR)/mk/package.mk

$(eval $(call PKG_template,PCMCIAUTILS,pcmciautils,$(PKG_VERSION)-${PKG_RELEASE},${PKG_DEPENDS},${PKG_DESCR},${PKG_SECTION}))

CONFIG_STYLE=		manual

pcmciautils-install:
	$(INSTALL_DIR) $(IDIR_PCMCIAUTILS)/etc/pcmcia
	$(INSTALL_DATA) ./files/config.opts \
		$(IDIR_PCMCIAUTILS)/etc/pcmcia
	$(INSTALL_DIR) $(IDIR_PCMCIAUTILS)/usr/sbin
	$(INSTALL_BIN) $(WRKINST)/sbin/pccardctl \
		$(IDIR_PCMCIAUTILS)/usr/sbin
	$(INSTALL_BIN) $(WRKINST)/lib/udev/pcmcia-socket-startup \
		$(IDIR_PCMCIAUTILS)/usr/sbin

include ${ADK_TOPDIR}/mk/pkg-bottom.mk
