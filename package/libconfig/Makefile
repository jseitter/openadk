# This file is part of the OpenADK project. OpenADK is copyrighted
# material, please see the LICENCE file in the top-level directory.

include $(ADK_TOPDIR)/rules.mk

PKG_NAME:=		libconfig
PKG_VERSION:=		1.7.2
PKG_RELEASE:=		1
PKG_HASH:=		7c3c7a9c73ff3302084386e96f903eb62ce06953bb1666235fac74363a16fad9
PKG_DESCR:=		configuration library	
PKG_SECTION:=		libs/misc
PKG_URL:=		https://github.com/hyperrealm/libconfig
PKG_SITES:=		https://github.com/hyperrealm/libconfig/raw/master/docs/dist/
PKG_OPTS:=		dev

DISTFILES:=             $(PKG_NAME)-$(PKG_VERSION).tar.gz

include $(ADK_TOPDIR)/mk/package.mk

$(eval $(call PKG_template,LIBCONFIG,libconfig,$(PKG_VERSION)-$(PKG_RELEASE),$(PKG_DEPENDS),$(PKG_DESCR),$(PKG_SECTION),$(PKG_OPTS)))

libconfig-install:
	$(INSTALL_DIR) $(IDIR_LIBCONFIG)/usr/lib
	$(CP) $(WRKINST)/usr/lib/libconfig*.so* \
		$(IDIR_LIBCONFIG)/usr/lib

include $(ADK_TOPDIR)/mk/pkg-bottom.mk
