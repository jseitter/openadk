# This file is part of the OpenADK project. OpenADK is copyrighted
# material, please see the LICENCE file in the top-level directory.

include $(ADK_TOPDIR)/rules.mk

PKG_NAME:=		libXcursor
PKG_VERSION:=		1.1.14
PKG_RELEASE:=		1
PKG_HASH:=		be0954faf274969ffa6d95b9606b9c0cfee28c13b6fc014f15606a0c8b05c17b
PKG_DESCR:=		cursor library
PKG_SECTION:=		x11/libs
PKG_BUILDDEP:=		libXfixes libXrender
PKG_SITES:=		http://www.x.org/releases/individual/lib/
PKG_LIBNAME:=		libxcursor
PKG_OPTS:=		dev

DISTFILES:=		${PKG_NAME}-${PKG_VERSION}.tar.gz

include $(ADK_TOPDIR)/mk/package.mk

$(eval $(call PKG_template,LIBXCURSOR,libxcursor,$(PKG_VERSION)-${PKG_RELEASE},${PKG_DEPENDS},${PKG_DESCR},${PKG_SECTION},${PKG_OPTS}))

libxcursor-install:
	$(INSTALL_DIR) $(IDIR_LIBXCURSOR)/usr/lib
	$(CP) $(WRKINST)/usr/lib/libXcursor*.so* \
		$(IDIR_LIBXCURSOR)/usr/lib

include ${ADK_TOPDIR}/mk/pkg-bottom.mk
