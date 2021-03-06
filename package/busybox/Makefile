# This file is part of the OpenADK project. OpenADK is copyrighted
# material, please see the LICENCE file in the top-level directory.

include $(ADK_TOPDIR)/rules.mk

PKG_NAME:=		busybox
PKG_VERSION:=		1.32.0
PKG_RELEASE:=		1
PKG_HASH:=		c35d87f1d04b2b153d33c275c2632e40d388a88f19a9e71727e0bbbff51fe689
PKG_DESCR:=		core utilities for embedded systems
PKG_SECTION:=		base/apps
PKG_URL:=		http://www.busybox.net/
PKG_SITES:=		https://www.busybox.net/downloads/

DISTFILES:=		${PKG_NAME}-${PKG_VERSION}.tar.bz2

include $(ADK_TOPDIR)/mk/package.mk

$(eval $(call PKG_template,BUSYBOX,busybox,${PKG_VERSION}-${PKG_RELEASE},${PKG_DEPENDS},${PKG_DESCR},${PKG_SECTION}))

# disable lto
TARGET_CFLAGS:=		$(filter-out -flto,$(TARGET_CFLAGS))

CONFIG_STYLE:=		manual
BUILD_STYLE:=		manual
INSTALL_STYLE:=		manual

BB_MAKE_FLAGS:=		V=1 \
			ARCH="${ADK_TARGET_ARCH}" \
			IPKG_ARCH="${ADK_TARGET_CPU_ARCH}" \
			HOSTCC="${CC_FOR_BUILD}" \
			HOSTCFLAGS="$(CFLAGS_FOR_BUILD)" \
			CROSS_COMPILE="$(TARGET_CROSS)" \
			SKIP_STRIP=y

do-configure:
	# get all symbols from top level config
	grep "^BUSYBOX_\|# BUSYBOX" $(ADK_TOPDIR)/.config|grep -v BUSYBOX_DISABLE|sed -e 's/BUSYBOX_/CONFIG_/' > \
		${WRKBUILD}/.config
	# convert all disabled symbols
	for i in $$(grep ^BUSYBOX_DISABLE $(ADK_TOPDIR)/.config);do \
		sym=$${i#BUSYBOX_DISABLE_}; \
		symbol=$$(echo $$sym|sed -e "s#=y##"); \
		case $$symbol in \
		  GREP) \
			printf "# CONFIG_GREP is not set\n" >> ${WRKBUILD}/.config; \
			printf "# CONFIG_EGREP is not set\n" >> ${WRKBUILD}/.config; \
			printf "# CONFIG_FGREP is not set\n" >> ${WRKBUILD}/.config; \
			;; \
		  KMOD) \
			printf "# CONFIG_MODINFO is not set\n" >> ${WRKBUILD}/.config; \
			printf "# CONFIG_MODPROBE_SMALL is not set\n" >> ${WRKBUILD}/.config; \
			printf "# CONFIG_INSMOD is not set\n" >> ${WRKBUILD}/.config; \
			printf "# CONFIG_RMMOD is not set\n" >> ${WRKBUILD}/.config; \
			printf "# CONFIG_LSMOD is not set\n" >> ${WRKBUILD}/.config; \
			printf "# CONFIG_MODPROBE is not set\n" >> ${WRKBUILD}/.config; \
			printf "# CONFIG_DEPMOD is not set\n" >> ${WRKBUILD}/.config; \
			;; \
		  *) \
			printf "# CONFIG_$${symbol} is not set\n" >> ${WRKBUILD}/.config; \
			;; \
		esac \
	done
	$(SED) 's;@IDIR@;${WRKINST};' ${WRKBUILD}/.config

do-build:
	PATH='$(HOST_PATH)' $(MAKE) ${BB_MAKE_FLAGS} -C ${WRKBUILD} busybox

do-install:
	PATH='$(HOST_PATH)' $(MAKE) ${BB_MAKE_FLAGS} -C ${WRKBUILD} install $(MAKE_TRACE)
	$(CP) $(WRKINST)/* $(IDIR_BUSYBOX)/
ifeq ($(ADK_RUNTIME_INIT_SYSTEMD),)
ifeq ($(BUSYBOX_IFUP),y)
	$(INSTALL_DIR) $(IDIR_BUSYBOX)/etc/init.d
ifeq ($(ADK_RUNTIME_WAIT_FOR_ETHERNET),y)
	$(INSTALL_BIN) ./files/network.wait $(IDIR_BUSYBOX)/etc/init.d/network
else
	$(INSTALL_BIN) ./files/network $(IDIR_BUSYBOX)/etc/init.d/network
endif
endif
endif
ifeq ($(ADK_DEBUG),y)
	${INSTALL_BIN} $(WRKBUILD)/busybox_unstripped \
		$(IDIR_BUSYBOX)/bin/busybox
endif
ifneq ($(strip ${ADK_PACKAGE_CFGFS}),)
	cd ${IDIR_BUSYBOX}/sbin && rm -f halt poweroff reboot
endif

include ${ADK_TOPDIR}/mk/pkg-bottom.mk
