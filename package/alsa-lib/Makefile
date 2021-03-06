# This file is part of the OpenADK project. OpenADK is copyrighted
# material, please see the LICENCE file in the top-level directory.

include ${ADK_TOPDIR}/rules.mk

PKG_NAME:=		alsa-lib
PKG_VERSION:=		1.1.4
PKG_RELEASE:=		1
PKG_HASH:=		82f50a09487079755d93e4c9384912196995bade6280bce9bfdcabf094bfb515
PKG_DESCR:=		sound library
PKG_SECTION:=		libs/audio
PKG_URL:=		http://www.alsa-project.org/
PKG_SITES:=		ftp://ftp.alsa-project.org/pub/lib/
PKG_OPTS:=		dev

DISTFILES:=             ${PKG_NAME}-${PKG_VERSION}.tar.bz2

include ${ADK_TOPDIR}/mk/host.mk
include ${ADK_TOPDIR}/mk/package.mk

$(eval $(call HOST_template,ALSA_LIB,alsa-lib,${PKG_VERSION}-${PKG_RELEASE}))
$(eval $(call PKG_template,ALSA_LIB,alsa-lib,${PKG_VERSION}-${PKG_RELEASE},${PKG_DEPENDS},${PKG_DESCR},${PKG_SECTION},${PKG_OPTS}))

ifneq ($(ADK_HOST_LINUX),y)
HOST_LINUX_ONLY:=	1
endif

HOST_STYLE:=		auto
HOST_CONFIGURE_ARGS+=	--disable-python
CONFIGURE_ARGS+=	--disable-python \
			--without-versioned

alsa-lib-install:
	${INSTALL_DIR} ${IDIR_ALSA_LIB}/usr/lib 
	${INSTALL_DIR} ${IDIR_ALSA_LIB}/usr/share/alsa
	${CP} ${WRKINST}/usr/lib/libasound.so* ${IDIR_ALSA_LIB}/usr/lib
	${CP} ${WRKINST}//usr/share/alsa/* \
		${IDIR_ALSA_LIB}/usr/share/alsa
	$(CP) ./files/imx-{hdmi-soc,spdif}.conf \
		${IDIR_ALSA_LIB}/usr/share/alsa/cards

include ${ADK_TOPDIR}/mk/host-bottom.mk
include ${ADK_TOPDIR}/mk/pkg-bottom.mk
