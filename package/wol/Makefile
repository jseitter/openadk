# This file is part of the OpenADK project. OpenADK is copyrighted
# material, please see the LICENCE file in the top-level directory.

include ${ADK_TOPDIR}/rules.mk

PKG_NAME:=		wol
PKG_VERSION:=		0.7.1
PKG_RELEASE:=		1
PKG_HASH:=		e0086c9b9811df2bdf763ec9016dfb1bcb7dba9fa6d7858725b0929069a12622
PKG_DESCR:=		program to send magic wake-on-lan packets
PKG_SECTION:=		net/misc
PKG_SITES:=		${MASTER_SITE_SOURCEFORGE:=ahh/}

DISTFILES:=		${PKG_NAME}-${PKG_VERSION}.tar.gz

include ${ADK_TOPDIR}/mk/package.mk

$(eval $(call PKG_template,WOL,wol,${PKG_VERSION}-${PKG_RELEASE},${PKG_DEPENDS},${PKG_DESCR},${PKG_SECTION}))

CONFIGURE_ARGS+=	ac_cv_func_mmap_fixed_mapped=yes \
			jm_cv_func_working_malloc=yes \
			ac_cv_func_alloca_works=yes

wol-install:
	${INSTALL_DIR} ${IDIR_WOL}/usr/bin
	${INSTALL_BIN} ${WRKINST}/usr/bin/wol ${IDIR_WOL}/usr/bin/

include ${ADK_TOPDIR}/mk/pkg-bottom.mk
