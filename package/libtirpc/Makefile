# This file is part of the OpenADK project. OpenADK is copyrighted
# material, please see the LICENCE file in the top-level directory.

include ${ADK_TOPDIR}/rules.mk

PKG_NAME:=		libtirpc
PKG_VERSION:=		1.0.3
PKG_RELEASE:=		1
PKG_HASH:=		86c3a78fc1bddefa96111dd233124c703b22a78884203c55c3e06b3be6a0fd5e
PKG_DESCR:=		transport independent rpc library
PKG_SECTION:=		libs/net
PKG_URL:=		http://sourceforge.net/projects/libtirpc/
PKG_SITES:=		${MASTER_SITE_SOURCEFORGE:=libtirpc/}
PKG_OPTS:=		dev

PKG_FLAVOURS_LIBTIRPC:=	WITH_IPV6 WITH_GSS
PKGFD_WITH_IPV6:=	enable ipv6 support
PKGFD_WITH_GSS:=	enable gss support
PKGFB_WITH_GSS:=	libgssglue krb5
PKGFS_WITH_GSS:=	libgssglue

DISTFILES:=		$(PKG_NAME)-$(PKG_VERSION).tar.bz2

include ${ADK_TOPDIR}/mk/package.mk

$(eval $(call PKG_template,LIBTIRPC,libtirpc,${PKG_VERSION}-${PKG_RELEASE},${PKG_DEPENDS},${PKG_DESCR},${PKG_SECTION},${PKG_OPTS}))

MAKE_ENV+=		V=1
AUTOTOOL_STYLE:=	autoreconf
HOST_CPPFLAGS+=		-I/usr/include/tirpc

ifeq (${ADK_PACKAGE_LIBTIRPC_WITH_GSS},y)
CONFIGURE_ARGS+=	--enable-gssapi
else
CONFIGURE_ARGS+=	--disable-gssapi
endif

ifeq (${ADK_PACKAGE_LIBTIRPC_WITH_IPV6},y)
CONFIGURE_ARGS+=	--enable-ipv6
CFG:=			.ipv6
else
CONFIGURE_ARGS+=	--disable-ipv6
endif

post-extract:
	rm $(WRKBUILD)/tirpc/rpcsvc/crypt.h
	rm $(WRKBUILD)/tirpc/rpc/rpcb_prot.h

libtirpc-install:
	${INSTALL_DIR} ${IDIR_LIBTIRPC}/usr/lib ${IDIR_LIBTIRPC}/etc
	${CP} ${WRKINST}/usr/lib/libtirpc*.so* ${IDIR_LIBTIRPC}/usr/lib/
	${CP} ./files/netconfig$(CFG) ${IDIR_LIBTIRPC}/etc/netconfig

include ${ADK_TOPDIR}/mk/pkg-bottom.mk
