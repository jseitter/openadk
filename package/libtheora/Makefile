# This file is part of the OpenADK project. OpenADK is copyrighted
# material, please see the LICENCE file in the top-level directory.

include $(ADK_TOPDIR)/rules.mk

PKG_NAME:=		libtheora
PKG_VERSION:=		1.1.1
PKG_RELEASE:=		2
PKG_HASH:=		b6ae1ee2fa3d42ac489287d3ec34c5885730b1296f0801ae577a35193d3affbc
PKG_DESCR:=		open source video codec library
PKG_SECTION:=		libs/video
PKG_DEPENDS:=		libogg libvorbis
PKG_BUILDDEP:=		libogg libvorbis
PKG_URL:=		http://www.theora.org/
PKG_SITES:=		http://downloads.xiph.org/releases/theora/
PKG_OPTS:=		dev

DISTFILES:=             ${PKG_NAME}-${PKG_VERSION}.tar.bz2

include $(ADK_TOPDIR)/mk/package.mk

$(eval $(call PKG_template,LIBTHEORA,libtheora,$(PKG_VERSION)-${PKG_RELEASE},${PKG_DEPENDS},${PKG_DESCR},${PKG_SECTION},${PKG_OPTS}))

CONFIGURE_ARGS+=	--disable-examples

libtheora-install:
	$(INSTALL_DIR) $(IDIR_LIBTHEORA)/usr/lib
	$(CP) $(WRKINST)/usr/lib/libtheora*.so* \
		$(IDIR_LIBTHEORA)/usr/lib

include ${ADK_TOPDIR}/mk/pkg-bottom.mk
