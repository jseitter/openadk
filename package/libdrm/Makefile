# This file is part of the OpenADK project. OpenADK is copyrighted
# material, please see the LICENCE file in the top-level directory.

include $(ADK_TOPDIR)/rules.mk

PKG_NAME:=		libdrm
PKG_VERSION:=		2.4.99
PKG_RELEASE:=		1
PKG_HASH:=		597fb879e2f45193431a0d352d10cd79ef61a24ab31f44320168583e10cb6302
PKG_DESCR:=		direct rendering manager library
PKG_SECTION:=		libs/video
PKG_BUILDDEP:=		libpthread-stubs cairo libpciaccess
PKG_URL:=		http://dri.freedesktop.org/wiki/
PKG_SITES:=		http://dri.freedesktop.org/libdrm/
PKG_OPTS:=		dev

DISTFILES:=		${PKG_NAME}-${PKG_VERSION}.tar.gz

include $(ADK_TOPDIR)/mk/package.mk

$(eval $(call PKG_template,LIBDRM,libdrm,$(PKG_VERSION)-${PKG_RELEASE},${PKG_DEPENDS},${PKG_DESCR},${PKG_SECTION},${PKG_OPTS}))

CONFIGURE_ARGS+=	--disable-manpages \
			--disable-valgrind

libdrm-install:
	$(INSTALL_DIR) $(IDIR_LIBDRM)/usr/lib
	$(CP) $(WRKINST)/usr/lib/libdrm*.so* \
		$(IDIR_LIBDRM)/usr/lib

include ${ADK_TOPDIR}/mk/pkg-bottom.mk
