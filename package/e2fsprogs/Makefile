# This file is part of the OpenADK project. OpenADK is copyrighted
# material, please see the LICENCE file in the top-level directory.

include $(ADK_TOPDIR)/rules.mk

PKG_NAME:=		e2fsprogs
PKG_VERSION:=		1.44.2
PKG_RELEASE:=		1
PKG_HASH:=		8324cf0b6e81805a741d94087b00e99f7e16144f1ee5a413709a1fa6948b126c
PKG_DESCR:=		ext2/3/4 filesystem utilities
PKG_SECTION:=		sys/fs
PKG_BUILDDEP:=		util-linux
PKG_NEEDS:=		threads
PKG_URL:=		http://e2fsprogs.sourceforge.net/
PKG_SITES:=		https://www.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v$(PKG_VERSION)/
PKG_OPTS:=		dev
PKG_NOPARALLEL:=	1

PKG_CFLINE_E2FSPROGS:=	select BUSYBOX_FSCK

PKG_SUBPKGS:=		LIBE2FS LIBCOM_ERR LIBSS
PKG_SUBPKGS+=		RESIZE2FS TUNE2FS E2FSCK MKE2FS
PKG_SUBPKGS+=		E2FSCK_STATIC TUNE2FS_STATIC
PKGSD_LIBE2FS:=		e2fsprogs library
PKGSC_LIBE2FS:=		libs/misc
PKGSD_LIBCOM_ERR:=	common error library
PKGSC_LIBCOM_ERR:=	libs/misc
PKGSD_LIBSS:=		subsystem command parsing library
PKGSC_LIBSS:=		libs/misc
PKGSD_E2FSCK_STATIC:=	static build of e2fsck
PKGSC_E2FSCK_STATIC:=	sys/fs
PKGSD_TUNE2FS_STATIC:=	static build of tune2fs
PKGSC_TUNE2FS_STATIC:=	sys/fs
PKGSD_RESIZE2FS:=	ext2/3/4 resize utility
PKGSC_RESIZE2FS:=	sys/fs
PKGSS_RESIZE2FS:=	libe2fs libcom-err libblkid
PKGSD_TUNE2FS:=		ext2/3/4 tune utility
PKGSC_TUNE2FS:=		sys/fs
PKGSS_TUNE2FS:=		libe2fs libcom-err libblkid libuuid
PKGSD_E2FSCK:=		ext2/3/4 filesystem check utility
PKGSC_E2FSCK:=		sys/fs
PKGSS_E2FSCK:=		libe2fs libcom-err libblkid libuuid
PKGSD_MKE2FS:=		ext2/3/4 filesystem creation utility
PKGSC_MKE2FS:=		sys/fs
PKGSS_MKE2FS:=		libe2fs libcom-err libblkid libuuid libncurses

include $(ADK_TOPDIR)/mk/host.mk
include $(ADK_TOPDIR)/mk/package.mk

$(eval $(call HOST_template,E2FSPROGS,e2fsprogs,$(PKG_VERSION)-$(PKG_RELEASE)))
$(eval $(call PKG_template,LIBE2FS,libe2fs,$(PKG_VERSION)-$(PKG_RELEASE),,$(PKGSD_LIBE2FS),$(PKGSC_LIBE2FS),$(PKG_OPTS)))
$(eval $(call PKG_template,LIBCOM_ERR,libcom-err,$(PKG_VERSION)-$(PKG_RELEASE),,$(PKGSD_LIBCOM_ERR),$(PKGSC_LIBCOM_ERR),$(PKG_OPTS)))
$(eval $(call PKG_template,LIBSS,libss,$(PKG_VERSION)-$(PKG_RELEASE),,$(PKGSD_LIBSS),$(PKGSC_LIBSS),$(PKG_OPTS)))
$(eval $(call PKG_template,TUNE2FS,tune2fs,$(PKG_VERSION)-$(PKG_RELEASE),$(PKGSS_TUNE2FS),$(PKGSD_TUNE2FS),$(PKGSC_TUNE2FS)))
$(eval $(call PKG_template,RESIZE2FS,resize2fs,$(PKG_VERSION)-$(PKG_RELEASE),$(PKGSS_RESIZE2FS),$(PKGSD_RESIZE2FS),$(PKGSC_RESIZE2FS)))
$(eval $(call PKG_template,MKE2FS,mke2fs,$(PKG_VERSION)-$(PKG_RELEASE),$(PKGSS_MKE2FS),$(PKGSD_MKE2FS),$(PKGSC_MKE2FS)))
$(eval $(call PKG_template,E2FSCK,e2fsck,$(PKG_VERSION)-$(PKG_RELEASE),$(PKGSS_E2FSCK),$(PKGSD_E2FSCK),$(PKGSC_E2FSCK)))
$(eval $(call PKG_template,E2FSCK_STATIC,e2fsck-static,${PKG_VERSION}-${PKG_RELEASE},,${PKGSD_E2FSCK_STATIC},${PKGSC_E2FSCK_STATIC}))
$(eval $(call PKG_template,TUNE2FS_STATIC,tune2fs-static,${PKG_VERSION}-${PKG_RELEASE},,${PKGSD_E2FSCK_STATIC},${PKGSC_E2FSCK_STATIC}))

HOST_CONFIGURE_ARGS+=	--disable-rpath \
			--disable-nls \
			--disable-uuidd \
			--disable-defrag \
			--disable-debugfs

ifeq ($(ADK_TARGET_USE_STATIC_LIBS_ONLY),y)
CONFIGURE_ARGS+=	--disable-elf-shlibs
else
CONFIGURE_ARGS+=	--enable-elf-shlibs
endif

CONFIGURE_ARGS+=	--disable-rpath \
			--disable-uuidd \
			--disable-testio-debug \
			--disable-defrag \
			--disable-libblkid \
			--disable-libuuid \
			--disable-debugfs
TARGET_CFLAGS+=		$(TARGET_CPPFLAGS) -I$(STAGING_TARGET_DIR)/usr/include
MAKE_FLAGS+=		BUILD_CC="$(HOST_CC)" \
			BUILD_CFLAGS="$(HOST_CFLAGS) $(HOST_CPPFLAGS) -I$(WRKSRC)/lib -I." \
			BUILD_LDFLAGS="$(HOST_LDFLAGS)"

post-install:
	$(CP) $(WRKBUILD)/lib/libext*.a $(STAGING_TARGET_DIR)/usr/lib
	$(INSTALL_DIR) $(STAGING_TARGET_DIR)/usr/include/ext2fs
	$(INSTALL_DIR) $(STAGING_TARGET_DIR)/usr/include/et
	$(CP) $(WRKBUILD)/lib/ext2fs/*.h \
		$(STAGING_TARGET_DIR)/usr/include/ext2fs
	$(CP) $(WRKBUILD)/lib/et/*.h \
		$(STAGING_TARGET_DIR)/usr/include/et

libe2fs-install:
	$(INSTALL_DIR) $(IDIR_LIBE2FS)/etc
	$(INSTALL_DATA) $(WRKBUILD)/misc/mke2fs.conf $(IDIR_LIBE2FS)/etc
	$(INSTALL_DIR) $(IDIR_LIBE2FS)/usr/lib
	$(CP) $(WRKINST)/usr/lib/lib{e2p,ext2fs}.so.* \
		$(IDIR_LIBE2FS)/usr/lib

e2fsck-install:
	$(INSTALL_DIR) $(IDIR_E2FSCK)/usr/sbin
	$(INSTALL_BIN) $(WRKINST)/usr/sbin/e2fsck $(IDIR_E2FSCK)/usr/sbin
	cd $(IDIR_E2FSCK)/usr/sbin && ln -sf e2fsck fsck.ext2
	cd $(IDIR_E2FSCK)/usr/sbin && ln -sf e2fsck fsck.ext3
	cd $(IDIR_E2FSCK)/usr/sbin && ln -sf e2fsck fsck.ext4

mke2fs-install:
	$(INSTALL_DIR) $(IDIR_MKE2FS)/usr/sbin
	$(INSTALL_BIN) $(WRKINST)/usr/sbin/mke2fs $(IDIR_MKE2FS)/usr/sbin
	cd $(IDIR_MKE2FS)/usr/sbin && ln -sf mke2fs mkfs.ext2
	cd $(IDIR_MKE2FS)/usr/sbin && ln -sf mke2fs mkfs.ext3
	cd $(IDIR_MKE2FS)/usr/sbin && ln -sf mke2fs mkfs.ext4

tune2fs-install:
	$(INSTALL_DIR) $(IDIR_TUNE2FS)/usr/sbin
	$(INSTALL_BIN) $(WRKINST)/usr/sbin/tune2fs $(IDIR_TUNE2FS)/usr/sbin

resize2fs-install:
	$(INSTALL_DIR) $(IDIR_RESIZE2FS)/usr/sbin
	$(INSTALL_BIN) $(WRKINST)/usr/sbin/resize2fs $(IDIR_RESIZE2FS)/usr/sbin

libcom-err-install:
	$(INSTALL_DIR) $(IDIR_LIBCOM_ERR)/usr/lib
	$(CP) $(WRKINST)/usr/lib/libcom_err.so* \
		$(IDIR_LIBCOM_ERR)/usr/lib

libss-install:
	$(INSTALL_DIR) $(IDIR_LIBSS)/usr/lib
	$(CP) $(WRKINST)/usr/lib/libss.so* \
		$(IDIR_LIBSS)/usr/lib

e2fsck-static-install:
	${MAKE} -C ${WRKBUILD}/e2fsck e2fsck.static
	${INSTALL_DIR} ${IDIR_E2FSCK_STATIC}/usr/sbin
	${INSTALL_BIN} ${WRKBUILD}/e2fsck/e2fsck.static \
			${IDIR_E2FSCK_STATIC}/usr/sbin/e2fsck

tune2fs-static-install:
	${MAKE} -C ${WRKBUILD}/misc tune2fs.static
	${INSTALL_DIR} ${IDIR_TUNE2FS_STATIC}/usr/sbin
	${INSTALL_BIN} ${WRKBUILD}/misc/tune2fs.static \
		${IDIR_TUNE2FS_STATIC}/usr/sbin/tune2fs

include $(ADK_TOPDIR)/mk/host-bottom.mk
include $(ADK_TOPDIR)/mk/pkg-bottom.mk
