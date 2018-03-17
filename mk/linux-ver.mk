# This file is part of the OpenADK project. OpenADK is copyrighted
# material, please see the LICENCE file in the top-level directory.
#
# On the various kernel version variables:
#
# KERNEL_FILE_VER: version numbering used for tarball and contained top level
#                  directory (e.g. linux-4.1.2.tar.bz2 -> linux-4.1.2) (not
#                  necessary equal to kernel's version, e.g. linux-3.19
#                  contains kernel version 3.19.0)
# KERNEL_RELEASE:  OpenADK internal versioning
# KERNEL_VERSION:  final kernel version how we want to identify a specific kernel

ifeq ($(ADK_TARGET_LINUX_KERNEL_VERSION_GIT),y)
KERNEL_FILE_VER:=	$(ADK_TARGET_LINUX_KERNEL_GIT)
KERNEL_RELEASE:=	1
KERNEL_VERSION:=	$(ADK_TARGET_LINUX_KERNEL_GIT_VER)-$(KERNEL_RELEASE)
endif
ifeq ($(ADK_TARGET_LINUX_KERNEL_VERSION_4_15),y)
KERNEL_FILE_VER:=	4.15.4
KERNEL_RELEASE:=	1
KERNEL_VERSION:=	$(KERNEL_FILE_VER)-$(KERNEL_RELEASE)
KERNEL_HASH:=		a23d7e1a9c1f72528531d9933e59e4cc4556752a2ea029fdc66a1b0fd24c8a3a
endif
ifeq ($(ADK_TARGET_LINUX_KERNEL_VERSION_4_14),y)
KERNEL_FILE_VER:=	4.14.24
KERNEL_RELEASE:=	1
KERNEL_VERSION:=	$(KERNEL_FILE_VER)-$(KERNEL_RELEASE)
KERNEL_HASH:=		ba512d1bd7f5910bae0f5d66554810f097f82e5df6fccb8c7cc4a11410839801
endif
ifeq ($(ADK_TARGET_LINUX_KERNEL_VERSION_4_9),y)
KERNEL_FILE_VER:=	4.9.87
KERNEL_RELEASE:=	1
KERNEL_VERSION:=	$(KERNEL_FILE_VER)-$(KERNEL_RELEASE)
KERNEL_HASH:=		7ac9f6af69dc5a7e38bf35cc3fa889e3a4b22504a85f57fdc87734a8abe4c917
endif
ifeq ($(ADK_TARGET_LINUX_KERNEL_VERSION_4_4),y)
KERNEL_FILE_VER:=	4.4.112
KERNEL_RELEASE:=	1
KERNEL_VERSION:=	$(KERNEL_FILE_VER)-$(KERNEL_RELEASE)
KERNEL_HASH:=		544b42cbeed022896115c76a18fc97b4507d5b41d7ac0ce1dce9afd6ffd11ecd
endif
ifeq ($(ADK_TARGET_LINUX_KERNEL_VERSION_4_1),y)
KERNEL_FILE_VER:=	4.1.45
KERNEL_RELEASE:=	1
KERNEL_VERSION:=	$(KERNEL_FILE_VER)-$(KERNEL_RELEASE)
KERNEL_HASH:=		76700a6a788c5750e3421eba004190cdc5b63f62726fce3b5fa27bd1c2cd5912
endif
ifeq ($(ADK_TARGET_LINUX_KERNEL_VERSION_3_16),y)
KERNEL_FILE_VER:=	3.16.49
KERNEL_RELEASE:=	1
KERNEL_VERSION:=	$(KERNEL_FILE_VER)-$(KERNEL_RELEASE)
KERNEL_HASH:=		7ab9ab2efb584b36685bae83f8005a699186ad0d70e6b659de58c89d0ec55f96
endif
ifeq ($(ADK_TARGET_LINUX_KERNEL_VERSION_3_10),y)
KERNEL_FILE_VER:=	3.10.107
KERNEL_RELEASE:=	1
KERNEL_VERSION:=	$(KERNEL_FILE_VER)-$(KERNEL_RELEASE)
KERNEL_HASH:=		948ae756ba90b3b981fb8245789ea1426d43c351921df566dd5463171883edc3
endif
ifeq ($(ADK_TARGET_LINUX_KERNEL_VERSION_3_2),y)
KERNEL_FILE_VER:=	3.2.94
KERNEL_RELEASE:=	1
KERNEL_VERSION:=	$(KERNEL_FILE_VER)-$(KERNEL_RELEASE)
KERNEL_HASH:=		0bc5856e6de4ad1a941c6d2b0014493c31800dcd51db3e561c38a19b99621f60
endif
ifeq ($(ADK_TARGET_LINUX_KERNEL_VERSION_2_6_32),y)
KERNEL_FILE_VER:=	2.6.32.70
KERNEL_RELEASE:=	1
KERNEL_VERSION:=	$(KERNEL_FILE_VER)-$(KERNEL_RELEASE)
KERNEL_HASH:=		d7d0ee4588711d4f85ed67b65d447b4bbbe215e600a771fb87a62524b6341c43
endif
ifeq ($(ADK_TARGET_LINUX_KERNEL_VERSION_3_10_NDS32),y)
KERNEL_FILE_VER:=	3.10-nds32
KERNEL_RELEASE:=	1
KERNEL_VERSION:=	$(KERNEL_FILE_VER)-$(KERNEL_RELEASE)
KERNEL_HASH:=		2f3e06924b850ca4d383ebb6baed154e1bb20440df6f38ca47c33950ec0e05c5
endif
