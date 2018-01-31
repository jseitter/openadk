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

ifeq ($(ADK_TARGET_KERNEL_VERSION_GIT),y)
KERNEL_FILE_VER:=	$(ADK_TARGET_KERNEL_GIT)
KERNEL_RELEASE:=	1
KERNEL_VERSION:=	$(ADK_TARGET_KERNEL_GIT_VER)-$(KERNEL_RELEASE)
endif
ifeq ($(ADK_TARGET_KERNEL_VERSION_4_15),y)
KERNEL_FILE_VER:=	4.15
KERNEL_RELEASE:=	1
KERNEL_VERSION:=	$(KERNEL_FILE_VER)-$(KERNEL_RELEASE)
KERNEL_HASH:=		5a26478906d5005f4f809402e981518d2b8844949199f60c4b6e1f986ca2a769
endif
ifeq ($(ADK_TARGET_KERNEL_VERSION_4_14),y)
KERNEL_FILE_VER:=	4.14.8
KERNEL_RELEASE:=	1
KERNEL_VERSION:=	$(KERNEL_FILE_VER)-$(KERNEL_RELEASE)
KERNEL_HASH:=		6ebcc57ba31d714af872347184d1de32f4ab0b7096ef4e062d1ca6b3234d9333
endif
ifeq ($(ADK_TARGET_KERNEL_VERSION_4_9),y)
KERNEL_FILE_VER:=	4.9.77
KERNEL_RELEASE:=	1
KERNEL_VERSION:=	$(KERNEL_FILE_VER)-$(KERNEL_RELEASE)
KERNEL_HASH:=		7c29bc3fb96f1e23d98f664e786dddd53a1599f56431b9b7fdfba402a4b3705c
endif
ifeq ($(ADK_TARGET_KERNEL_VERSION_4_4),y)
KERNEL_FILE_VER:=	4.4.112
KERNEL_RELEASE:=	1
KERNEL_VERSION:=	$(KERNEL_FILE_VER)-$(KERNEL_RELEASE)
KERNEL_HASH:=		544b42cbeed022896115c76a18fc97b4507d5b41d7ac0ce1dce9afd6ffd11ecd
endif
ifeq ($(ADK_TARGET_KERNEL_VERSION_4_1),y)
KERNEL_FILE_VER:=	4.1.45
KERNEL_RELEASE:=	1
KERNEL_VERSION:=	$(KERNEL_FILE_VER)-$(KERNEL_RELEASE)
KERNEL_HASH:=		76700a6a788c5750e3421eba004190cdc5b63f62726fce3b5fa27bd1c2cd5912
endif
ifeq ($(ADK_TARGET_KERNEL_VERSION_3_16),y)
KERNEL_FILE_VER:=	3.16.49
KERNEL_RELEASE:=	1
KERNEL_VERSION:=	$(KERNEL_FILE_VER)-$(KERNEL_RELEASE)
KERNEL_HASH:=		7ab9ab2efb584b36685bae83f8005a699186ad0d70e6b659de58c89d0ec55f96
endif
ifeq ($(ADK_TARGET_KERNEL_VERSION_3_10),y)
KERNEL_FILE_VER:=	3.10.107
KERNEL_RELEASE:=	1
KERNEL_VERSION:=	$(KERNEL_FILE_VER)-$(KERNEL_RELEASE)
KERNEL_HASH:=		948ae756ba90b3b981fb8245789ea1426d43c351921df566dd5463171883edc3
endif
ifeq ($(ADK_TARGET_KERNEL_VERSION_3_2),y)
KERNEL_FILE_VER:=	3.2.94
KERNEL_RELEASE:=	1
KERNEL_VERSION:=	$(KERNEL_FILE_VER)-$(KERNEL_RELEASE)
KERNEL_HASH:=		0bc5856e6de4ad1a941c6d2b0014493c31800dcd51db3e561c38a19b99621f60
endif
ifeq ($(ADK_TARGET_KERNEL_VERSION_2_6_32),y)
KERNEL_FILE_VER:=	2.6.32.70
KERNEL_RELEASE:=	1
KERNEL_VERSION:=	$(KERNEL_FILE_VER)-$(KERNEL_RELEASE)
KERNEL_HASH:=		d7d0ee4588711d4f85ed67b65d447b4bbbe215e600a771fb87a62524b6341c43
endif
ifeq ($(ADK_TARGET_KERNEL_VERSION_3_10_NDS32),y)
KERNEL_FILE_VER:=	3.10-nds32
KERNEL_RELEASE:=	1
KERNEL_VERSION:=	$(KERNEL_FILE_VER)-$(KERNEL_RELEASE)
KERNEL_HASH:=		2f3e06924b850ca4d383ebb6baed154e1bb20440df6f38ca47c33950ec0e05c5
endif
