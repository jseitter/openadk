# arm default is little endian, this target uses EABI
ARCH:=			arm
CPU_ARCH:=		arm
KERNEL_VERSION:=	2.6.32.2
KERNEL_RELEASE:=	1
KERNEL_MD5SUM:=		260551284ac224c3a43c4adac7df4879
TARGET_OPTIMIZATION:=	-Os -pipe
TARGET_CFLAGS_ARCH:=    -march=armv5te -mtune=arm926ej-s
