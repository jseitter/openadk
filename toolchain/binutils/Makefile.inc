# This file is part of the OpenADK project. OpenADK is copyrighted
# material, please see the LICENCE file in the top-level directory.

PKG_NAME:=		binutils
ifeq ($(ADK_TOOLCHAIN_BINUTILS_2_35),y)
PKG_VERSION:=		2.35
PKG_RELEASE:=		1
PKG_HASH:=		1b11659fb49e20e18db460d44485f09442c8c56d5df165de9461eb09c8302f85
PKG_SITES:=		${MASTER_SITE_GNU:=binutils/}
DISTFILES:=		${PKG_NAME}-${PKG_VERSION}.tar.xz
endif
ifeq ($(ADK_TOOLCHAIN_BINUTILS_2_34),y)
PKG_VERSION:=		2.34
PKG_RELEASE:=		1
PKG_HASH:=		f00b0e8803dc9bab1e2165bd568528135be734df3fabf8d0161828cd56028952
PKG_SITES:=		${MASTER_SITE_GNU:=binutils/}
DISTFILES:=		${PKG_NAME}-${PKG_VERSION}.tar.xz
endif
ifeq ($(ADK_TOOLCHAIN_BINUTILS_2_33),y)
PKG_VERSION:=		2.33.1
PKG_RELEASE:=		1
PKG_HASH:=		ab66fc2d1c3ec0359b8e08843c9f33b63e8707efdff5e4cc5c200eae24722cbf
PKG_SITES:=		${MASTER_SITE_GNU:=binutils/}
DISTFILES:=		${PKG_NAME}-${PKG_VERSION}.tar.xz
endif
ifeq ($(ADK_TOOLCHAIN_BINUTILS_2_32),y)
PKG_VERSION:=		2.32
PKG_RELEASE:=		1
PKG_HASH:=		0ab6c55dd86a92ed561972ba15b9b70a8b9f75557f896446c82e8b36e473ee04
PKG_SITES:=		${MASTER_SITE_GNU:=binutils/}
DISTFILES:=		${PKG_NAME}-${PKG_VERSION}.tar.xz
endif
ifeq ($(ADK_TOOLCHAIN_BINUTILS_2_28),y)
PKG_VERSION:=		2.28
PKG_RELEASE:=		1
PKG_HASH:=		cd717966fc761d840d451dbd58d44e1e5b92949d2073d75b73fccb476d772fcf
PKG_SITES:=		${MASTER_SITE_GNU:=binutils/}
DISTFILES:=		${PKG_NAME}-${PKG_VERSION}.tar.gz
endif
ifeq ($(ADK_TOOLCHAIN_BINUTILS_ARC),y)
PKG_VERSION:=          arc-2020.09
PKG_GIT:=              tag
PKG_RELEASE:=          1
PKG_SITES:=            https://github.com/foss-for-synopsys-dwc-arc-processors/binutils-gdb.git
DISTFILES:=            ${PKG_NAME}-${PKG_VERSION}.tar.xz
endif
ifeq ($(ADK_TOOLCHAIN_BINUTILS_KVX),y)
PKG_VERSION:=		c5e8437af055869c8666a1c1e5a391d9af5be0c0
PKG_GIT:=		hash
PKG_RELEASE:=		1
PKG_SITES:=		https://github.com/kalray/gdb-binutils.git
DISTFILES:=		${PKG_NAME}-${PKG_VERSION}.tar.xz
endif
ifeq ($(ADK_TOOLCHAIN_BINUTILS_NDS32),y)
PKG_VERSION:=		nds32-binutils-2.30-branch-open
PKG_GIT:=		branch
PKG_RELEASE:=		1
PKG_SITES:=		https://github.com/andestech/binutils.git
DISTFILES:=		${PKG_NAME}-${PKG_VERSION}.tar.xz
endif
ifeq ($(ADK_TOOLCHAIN_BINUTILS_AVR32),y)
PKG_VERSION:=		2.20.1
PKG_RELEASE:=		1
PKG_HASH:=		71d37c96451333c5c0b84b170169fdcb138bbb27397dc06281905d9717c8ed64
PKG_SITES:=		${MASTER_SITE_GNU:=binutils/}
DISTFILES:=		${PKG_NAME}-${PKG_VERSION}.tar.bz2
endif
ifeq ($(ADK_TOOLCHAIN_BINUTILS_GIT),y)
PKG_VERSION:=		git
PKG_RELEASE:=		1
PKG_SITES:=		git://sourceware.org/git/binutils-gdb.git
DISTFILES:=		${PKG_NAME}-${PKG_VERSION}.tar.xz
endif
