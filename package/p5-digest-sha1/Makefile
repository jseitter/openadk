# This file is part of the OpenADK project. OpenADK is copyrighted
# material, please see the LICENCE file in the top-level directory.

include $(ADK_TOPDIR)/rules.mk

PKG_NAME:=		p5-digest-sha1
PKG_VERSION:=		2.13
PKG_RELEASE:=		1
PKG_HASH:=		68c1dac2187421f0eb7abf71452a06f190181b8fc4b28ededf5b90296fb943cc
PKG_DESCR:=		interface to the sha-1 algorithm
PKG_SECTION:=		dev/perl
PKG_DEPENDS:=		perl
PKG_BUILDDEP:=		perl-host perl
PKG_SITES:=		http://cpan.metacpan.org/authors/id/G/GA/GAAS/

DISTFILES:=             Digest-SHA1-${PKG_VERSION}.tar.gz
WRKDIST=		${WRKDIR}/Digest-SHA1-${PKG_VERSION}

include $(ADK_TOPDIR)/mk/package.mk

$(eval $(call PKG_template,P5_DIGEST_SHA1,p5-digest-sha1,$(PKG_VERSION)-${PKG_RELEASE},${PKG_DEPENDS},${PKG_DESCR},${PKG_SECTION}))

include $(ADK_TOPDIR)/mk/perl.mk

CONFIG_STYLE:=		perl
XAKE_FLAGS+=		$(PERL_ENV)

p5-digest-sha1-install:
	$(INSTALL_DIR) $(IDIR_P5_DIGEST_SHA1)$(PERL_SITEDIR)
	$(CP) $(WRKINST)$(PERL_SITEDIR)/* \
		$(IDIR_P5_DIGEST_SHA1)$(PERL_SITEDIR)

include ${ADK_TOPDIR}/mk/pkg-bottom.mk
