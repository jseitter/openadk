# This file is part of the OpenADK project. OpenADK is copyrighted
# material, please see the LICENCE file in the top-level directory.

include ${ADK_TOPDIR}/rules.mk

PKG_NAME:=		less
PKG_VERSION:=		481
PKG_RELEASE:=		1
PKG_HASH:=		3fa38f2cf5e9e040bb44fffaa6c76a84506e379e47f5a04686ab78102090dda5
PKG_DESCR:=		text mode pager
PKG_SECTION:=		app/editor
PKG_DEPENDS:=		libncurses
PKG_BUILDDEP:=		ncurses
PKG_URL:=		http://www.greenwoodsoftware.com/less/
PKG_SITES:=		http://www.greenwoodsoftware.com/less/
PKG_BB:=		1

DISTFILES:=		${PKG_NAME}-${PKG_VERSION}.tar.gz

include ${ADK_TOPDIR}/mk/package.mk

$(eval $(call PKG_template,LESS,less,${PKG_VERSION}-${PKG_RELEASE},${PKG_DEPENDS},${PKG_DESCR},${PKG_SECTION}))

less-install:
	${INSTALL_DIR} ${IDIR_LESS}/usr/bin
	${INSTALL_BIN} ${WRKINST}/usr/bin/less ${IDIR_LESS}/usr/bin

include ${ADK_TOPDIR}/mk/pkg-bottom.mk
