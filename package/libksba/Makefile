# This file is part of the OpenADK project. OpenADK is copyrighted
# material, please see the LICENCE file in the top-level directory.

include $(ADK_TOPDIR)/rules.mk

PKG_NAME:=		libksba
PKG_VERSION:=		1.3.5
PKG_RELEASE:=		1
PKG_HASH:=		41444fd7a6ff73a79ad9728f985e71c9ba8cd3e5e53358e70d5f066d35c1a340
PKG_DESCR:=		working with X.509 certificates
PKG_SECTION:=		libs/crypto
PKG_DEPENDS:=		libgpg-error
PKG_BUILDDEP:=		libgpg-error
PKG_URL:=		https://www.gnupg.org/(fr)/related_software/libksba/index.html
PKG_SITES:=		https://www.gnupg.org/ftp/gcrypt/libksba/
PKG_OPTS:=		dev

DISTFILES:=             $(PKG_NAME)-$(PKG_VERSION).tar.bz2

include $(ADK_TOPDIR)/mk/package.mk

$(eval $(call PKG_template,LIBKSBA,libksba,$(PKG_VERSION)-$(PKG_RELEASE),$(PKG_DEPENDS),$(PKG_DESCR),$(PKG_SECTION),$(PKG_OPTS)))

libksba-install:
	$(INSTALL_DIR) $(IDIR_LIBKSBA)/usr/lib
	$(CP) $(WRKINST)/usr/lib/libksba*.so* \
		$(IDIR_LIBKSBA)/usr/lib

include $(ADK_TOPDIR)/mk/pkg-bottom.mk
