# This file is part of the OpenADK project. OpenADK is copyrighted
# material, please see the LICENCE file in the top-level directory.

include $(ADK_TOPDIR)/rules.mk

PKG_NAME:=		libICE
PKG_VERSION:=		1.0.9
PKG_RELEASE:=		1
PKG_HASH:=		7812a824a66dd654c830d21982749b3b563d9c2dfe0b88b203cefc14a891edc0
PKG_DESCR:=		inter-client exchange library
PKG_SECTION:=		x11/libs
PKG_BUILDDEP:=		xtrans xproto
HOST_BUILDDEP:=		xtrans-host xproto-host
PKG_SITES:=		http://www.x.org/releases/individual/lib/
PKG_LIBNAME:=		libice
PKG_OPTS:=		dev

DISTFILES:=		${PKG_NAME}-${PKG_VERSION}.tar.gz

include $(ADK_TOPDIR)/mk/host.mk
include $(ADK_TOPDIR)/mk/package.mk

$(eval $(call HOST_template,LIBICE,libice,$(PKG_VERSION)-${PKG_RELEASE}))
$(eval $(call PKG_template,LIBICE,libice,$(PKG_VERSION)-${PKG_RELEASE},${PKG_DEPENDS},${PKG_DESCR},${PKG_SECTION},${PKG_OPTS}))

HOST_STYLE:=		auto

libice-install:
	${INSTALL_DIR} ${IDIR_LIBICE}/usr/lib
	${CP} ${WRKINST}/usr/lib/libICE.so* ${IDIR_LIBICE}/usr/lib

include ${ADK_TOPDIR}/mk/host-bottom.mk
include ${ADK_TOPDIR}/mk/pkg-bottom.mk
