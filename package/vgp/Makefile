# This file is part of the OpenADK project. OpenADK is copyrighted
# material, please see the LICENCE file in the top-level directory.

include ${ADK_TOPDIR}/rules.mk

PKG_NAME:=		vgp
PKG_VERSION:=		0.2.1
PKG_RELEASE:=		1
PKG_HASH:=		38669e5dea80d2fa6e6ef577f04caef9326896908efc37cb92b8f938ce5f9c15
PKG_DESCR:=		daemon working like cisco hsrp
PKG_SECTION:=		net/misc
PKG_SITES:=		http://distfiles.openadk.org/

DISTFILES:=		${PKG_NAME}-${PKG_VERSION}.tar.gz

include ${ADK_TOPDIR}/mk/package.mk

$(eval $(call PKG_template,VGP,vgp,${PKG_VERSION}-${PKG_RELEASE},${PKG_DEPENDS},${PKG_DESCR},${PKG_SECTION}))

vgp-install:
	${INSTALL_DIR} ${IDIR_VGP}/usr/bin/
	${INSTALL_BIN} ${WRKINST}/usr/bin/vgpd ${IDIR_VGP}/usr/bin/

include ${ADK_TOPDIR}/mk/pkg-bottom.mk
