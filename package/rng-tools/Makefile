# This file is part of the OpenADK project. OpenADK is copyrighted
# material, please see the LICENCE file in the top-level directory.

include $(ADK_TOPDIR)/rules.mk

PKG_NAME:=		rng-tools
PKG_VERSION:=		4
PKG_RELEASE:=		1
PKG_HASH:=		b71bdfd4222c05e8316001556be90e1606f2a1bac3efde60153bd84e873cc195
PKG_DESCR:=		daemon to use hardware random number generators
PKG_SECTION:=		app/crypto
PKG_URL:=		http://gkernel.sourceforge.net/
PKG_SITES:=		${MASTER_SITE_SOURCEFORGE:=gkernel/}

# argp.h required
PKG_LIBC_DEPENDS:=	glibc
DISTFILES:=		${PKG_NAME}-${PKG_VERSION}.tar.gz

include $(ADK_TOPDIR)/mk/package.mk

$(eval $(call PKG_template,RNG_TOOLS,rng-tools,$(PKG_VERSION)-${PKG_RELEASE},${PKG_DEPENDS},${PKG_DESCR},${PKG_SECTION}))

rng-tools-install:
	$(INSTALL_DIR) $(IDIR_RNG_TOOLS)/usr/sbin
	$(INSTALL_BIN) $(WRKINST)/usr/sbin/rngd $(IDIR_RNG_TOOLS)/usr/sbin

include ${ADK_TOPDIR}/mk/pkg-bottom.mk
