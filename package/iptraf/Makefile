# This file is part of the OpenADK project. OpenADK is copyrighted
# material, please see the LICENCE file in the top-level directory.

include ${ADK_TOPDIR}/rules.mk

PKG_NAME:=		iptraf
PKG_VERSION:=		3.0.1
PKG_RELEASE:=		1
PKG_HASH:=		95a069af8c4d22206985f6ce69acc27cfcfef1d58ad6ab8dbb10c698642ac08a
PKG_DESCR:=		console-based network monitoring program.
PKG_SECTION:=		net/perf
PKG_DEPENDS:=		libncurses
PKG_BUILDDEP:=		ncurses
PKG_URL:=		http://iptraf.seul.org/
PKG_SITES:=		ftp://iptraf.seul.org/pub/iptraf/

DISTFILES:=		${PKG_NAME}-${PKG_VERSION}.tar.gz
WRKSRC=			${WRKDIST}/src

include ${ADK_TOPDIR}/mk/package.mk

$(eval $(call PKG_template,IPTRAF,iptraf,${PKG_VERSION}-${PKG_RELEASE},${PKG_DEPENDS},${PKG_DESCR},${PKG_SECTION}))

CONFIG_STYLE:=		manual
INSTALL_STYLE:=		manual

TARGET_CPPFLAGS+=	-D_GNU_SOURCE
TARGET_LDFLAGS+=	-ltinfo
XAKE_FLAGS+=		PLATFORM="-DPLATFORM=\\\"Linux/${ARCH}\\\"" \
			TARGET="/usr/bin" \
			WORKDIR="/var/lib/iptraf"

do-install:
	${INSTALL_DIR} ${IDIR_IPTRAF}/usr/bin
	${INSTALL_BIN} ${WRKBUILD}/iptraf ${IDIR_IPTRAF}/usr/bin/

include ${ADK_TOPDIR}/mk/pkg-bottom.mk
