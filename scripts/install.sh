#!/usr/bin/env bash
#-
# Copyright © 2010-2014
#	Waldemar Brodkorb <wbx@openadk.org>
#	Thorsten Glaser <tg@mirbsd.org>
#
# Provided that these terms and disclaimer and all copyright notices
# are retained or reproduced in an accompanying document, permission
# is granted to deal in this work without restriction, including un‐
# limited rights to use, publicly perform, distribute, sell, modify,
# merge, give away, or sublicence.
#
# This work is provided “AS IS” and WITHOUT WARRANTY of any kind, to
# the utmost extent permitted by applicable law, neither express nor
# implied; without malicious intent or gross negligence. In no event
# may a licensor, author or contributor be held liable for indirect,
# direct, other damage, loss, or other issues arising in any way out
# of dealing in the work, even if advised of the possibility of such
# damage or existence of a defect, except proven that it results out
# of said person’s immediate fault when using the work as intended.
#
# Alternatively, this work may be distributed under the terms of the
# General Public License, any version, as published by the Free Soft-
# ware Foundation.
#-
# Prepare a USB stick or CF/SD/MMC card or hard disc for installation
# of OpenADK

ADK_TOPDIR=$(pwd)
HOST=$(gcc -dumpmachine)
me=$0

case :$PATH: in
(*:$ADK_TOPDIR/host_$HOST/usr/bin:*) ;;
(*) export PATH=$PATH:$ADK_TOPDIR/host_$HOST/usr/bin ;;
esac

test -n "$KSH_VERSION" || exec mksh "$me" "$@"
if test -z "$KSH_VERSION"; then
	echo >&2 Fatal error: could not run myself with mksh!
	exit 255
fi

### run with mksh from here onwards ###

me=${me##*/}

if (( USER_ID )); then
	print -u2 Installation is only possible as root!
	exit 1
fi

ADK_TOPDIR=$(realpath .)
ostype=$(uname -s)

fs=ext4
cfgfs=1
datafssz=0
noformat=0
quiet=0
serial=0
speed=115200
panicreboot=10
keep=0

function usage {
cat >&2 <<EOF
Syntax: $me [-f filesystem] [-c cfgfssize] [-d datafssize] [-k] [-n]
    [-p panictime] [±q] [-s serialspeed] [±t] <target> <device> <archive>
Partition sizes are in MiB. Filesystem type is currently ignored (ext4).
To keep filesystem on data partition use -k.
Use -n to not format boot/root partition.
Defaults: -c 1 -p 10 -s 115200; -t = enable serial console
EOF
	exit $1
}

while getopts "c:d:f:hknp:qs:t" ch; do
	case $ch {
	(c)	if (( (cfgfs = OPTARG) < 0 || cfgfs > 16 )); then
			print -u2 "$me: -c $OPTARG out of bounds"
			exit 1
		fi ;;
	(d)	if (( (datafssz = OPTARG) < 0 )); then
			print -u2 "$me: -d $OPTARG out of bounds"
			exit 1
		fi ;;
	(f)	if [[ $OPTARG != @(ext2|ext3|ext4|xfs) ]]; then
			print -u2 "$me: filesystem $OPTARG invalid"
			exit 1
		fi
		fs=$OPTARG ;;
	(h)	usage 0 ;;
	(k)	keep=1 ;;
	(p)	if (( (panicreboot = OPTARG) < 0 || panicreboot > 300 )); then
			print -u2 "$me: -p $OPTARG out of bounds"
			exit 1
		fi ;;
	(q)	quiet=1 ;;
	(+q)	quiet=0 ;;
	(s)	if [[ $OPTARG != @(96|192|384|576|1152)00 ]]; then
			print -u2 "$me: serial speed $OPTARG invalid"
			exit 1
		fi
		speed=$OPTARG ;;
	(n)	noformat=1 ;;
	(t)	serial=1 ;;
	(+t)	serial=0 ;;
	(*)	usage 1 ;;
	}
done
shift $((OPTIND - 1))

(( $# == 3 )) || usage 1

f=0
case $ostype {
(Linux)
	tools="bc mkfs.$fs tune2fs partprobe"
	;;
(Darwin)
	tools="bc diskutil"
	;;
(*)
	print -u2 Sorry, not ported to the OS "'$ostype'" yet.
	exit 1
	;;
}
for tool in $tools; do
	print -n Checking if $tool is installed...
	if whence -p $tool >/dev/null; then
		print " okay"
	else
		print " failed"
		f=1
	fi
done
(( f )) && exit 1

target=$1
tgt=$2
src=$3

case $target {
(raspberry-pi|solidrun-imx6|default) ;;
(*)
	print -u2 "Unknown target '$target', exiting"
	exit 1 ;;
}
if [[ ! -b $tgt ]]; then
	print -u2 "'$tgt' is not a block device, exiting"
	exit 1
fi
if [[ ! -f $src ]]; then
	print -u2 "'$src' is not a file, exiting"
	exit 1
fi
(( quiet )) || print "Installing $src on $tgt."

case $ostype {
(Darwin)
	R=/Volumes/ADKROOT; diskutil unmount $R
	B=/Volumes/ADKBOOT; diskutil unmount $B
	D=/Volumes/ADKDATA; diskutil unmount $D
	basedev=$tgt
	rootpart=${basedev}s1
	datapart=${basedev}s2
	if [[ $target = raspberry-pi ]]; then
		bootpart=${basedev}s1
		rootpart=${basedev}s2
		datapart=${basedev}s3
	fi
	match=\'${basedev}\''?(s+([0-9]))'
	function mount_fs {
	}
	function umount_fs {
		diskutil unmount "$1"
	}
	function create_fs {
		if [[ $3 = ext4 ]]; then
			fstype=UFSD_EXTFS4
		fi
		if [[ $3 = vfat ]]; then
			fstype=fat32
		fi
		diskutil eraseVolume $fstype "$2" "$1"
	}
	function tune_fs {
	}
	;;
(Linux)
	basedev=$tgt
	rootpart=${basedev}1
	datapart=${basedev}2
	if [[ $target = raspberry-pi ]]; then
		bootpart=${basedev}1
		rootpart=${basedev}2
		datapart=${basedev}3
	fi

	match=\'${basedev}\''+([0-9])'
	function mount_fs {
		mount -t "$3" "$1" "$2"
	}
	function umount_fs {
		umount "$1"
	}
	function create_fs {
		(( quiet )) || print "Creating filesystem on ${1}..."
		partprobe $tgt
		mkfs.$3 "$1"
	}
	function tune_fs {
		tune2fs -c 0 -i 0 "$1"
	}
	;;
}

mount |&
while read -p dev rest; do
	eval [[ \$dev = $match ]] || continue
	print -u2 "Block device $tgt is in use, please umount first."
	exit 1
done

if (( !quiet )); then
	print "WARNING: This will overwrite $basedev - type Yes to continue!"
	read x
	[[ $x = Yes ]] || exit 0
fi

if ! T=$(mktemp -d /tmp/openadk.XXXXXXXXXX); then
	print -u2 Error creating temporary directory.
	exit 1
fi
if [[ $ostype != Darwin ]]; then
	R=$T/rootmnt
	B=$T/bootmnt
	D=$T/datamnt
	mkdir -p "$R" "$B" "$D"
fi

# get disk size
dksz=$(dkgetsz "$tgt")

# partition layouts:
# n̲a̲m̲e̲		p̲a̲r̲t̲#̲0̲		p̲̲a̲r̲t̲#̲1̲		p̲̲a̲r̲t̲#̲2̲		p̲̲a̲r̲t̲#̲3̲
# default:	0x83(system)	0x83(?data)	-(unused)	0x88(cfgfs)
# raspberry:	0x0B(boot)	0x83(system)	0x83(?data)	0x88(cfgfs)

syspartno=0

# sizes:
# boot(raspberry) - fixed (100 MiB)
# cfgfs - fixed (parameter, max. 16 MiB)
# data - flexible (parameter)
# system - everything else

if [[ $target = raspberry-pi ]]; then
	syspartno=1
	bootfssz=100
	if (( grub )); then
		print -u2 "Cannot combine GRUB with $target"
		rm -rf "$T"
		exit 1
	fi
else
	bootfssz=0
fi

heads=64
secs=32
(( cyls = dksz / heads / secs ))
if (( cyls < (bootfssz + cfgfs + datafssz + 2) )); then
	print -u2 "Size of $tgt is $dksz, this looks fishy?"
	rm -rf "$T"
	exit 1
fi

if stat -qs .>/dev/null 2>&1; then
	statcmd='stat -f %z'	# BSD stat (or so we assume)
else
	statcmd='stat -c %s'	# GNU stat
fi

if (( grub )); then
	tar -xOzf "$src" boot/grub/core.img >"$T/core.img"
	integer coreimgsz=$($statcmd "$T/core.img")
else
	coreimgsz=65024
fi
if (( coreimgsz < 1024 )); then
	print -u2 core.img is probably too small: $coreimgsz
	rm -rf "$T"
	exit 1
fi
if (( coreimgsz > 65024 )); then
	print -u2 core.img is larger than 64K-512: $coreimgsz
	rm -rf "$T"
	exit 1
fi
(( coreendsec = (coreimgsz + 511) / 512 ))
if [[ $basedev = /dev/svnd+([0-9]) ]]; then
	# BSD svnd0 mode: protect sector #1
	corestartsec=2
	(( ++coreendsec ))
	corepatchofs=$((0x614))
else
	corestartsec=1
	corepatchofs=$((0x414))
fi
# partition offset: at least coreendsec+1 but aligned on a multiple of secs
#(( partofs = ((coreendsec / secs) + 1) * secs ))
# we just use 2048 all the time, since some loaders are longer
partofs=2048
if [[ $target = raspberry-pi ]]; then
	(( spartofs = partofs + (100 * 2048) ))
else
	spartofs=$partofs
fi

(( quiet )) || if (( grub )); then
	print Preparing MBR and GRUB2...
else
	print Preparing MBR...
fi
dd if=/dev/zero of="$T/firsttrack" count=$partofs 2>/dev/null
# add another MiB to clear the first partition
dd if=/dev/zero bs=1048576 count=1 >>"$T/firsttrack" 2>/dev/null
echo $corestartsec $coreendsec | mksh "$ADK_TOPDIR/scripts/bootgrub.mksh" \
    -A -g $((cyls - bootfssz - cfgfs - datafssz)):$heads:$secs -M 1:0x83 \
    -O $spartofs | dd of="$T/firsttrack" conv=notrunc 2>/dev/null
(( grub )) && dd if="$T/core.img" of="$T/firsttrack" conv=notrunc \
    seek=$corestartsec 2>/dev/null
# set partition where it can find /boot/grub
(( grub )) && print -n '\0\0\0\0' | \
    dd of="$T/firsttrack" conv=notrunc bs=1 seek=$corepatchofs 2>/dev/null

# create cfgfs partition (mostly taken from bootgrub.mksh)
set -A thecode
typeset -Uui8 thecode
mbrpno=0
set -A g_code $cyls $heads $secs
(( psz = g_code[0] * g_code[1] * g_code[2] ))
(( pofs = (cyls - cfgfs) * g_code[1] * g_code[2] ))
set -A o_code	# g_code equivalent for partition offset
(( o_code[2] = pofs % g_code[2] + 1 ))
(( o_code[1] = pofs / g_code[2] ))
(( o_code[0] = o_code[1] / g_code[1] + 1 ))
(( o_code[1] = o_code[1] % g_code[1] + 1 ))
# boot flag; C/H/S offset
thecode[mbrpno++]=0x00
(( thecode[mbrpno++] = o_code[1] - 1 ))
(( cylno = o_code[0] > 1024 ? 1023 : o_code[0] - 1 ))
(( thecode[mbrpno++] = o_code[2] | ((cylno & 0x0300) >> 2) ))
(( thecode[mbrpno++] = cylno & 0x00FF ))
# partition type; C/H/S end
(( thecode[mbrpno++] = 0x88 ))
(( thecode[mbrpno++] = g_code[1] - 1 ))
(( cylno = g_code[0] > 1024 ? 1023 : g_code[0] - 1 ))
(( thecode[mbrpno++] = g_code[2] | ((cylno & 0x0300) >> 2) ))
(( thecode[mbrpno++] = cylno & 0x00FF ))
# partition offset, size (LBA)
(( thecode[mbrpno++] = pofs & 0xFF ))
(( thecode[mbrpno++] = (pofs >> 8) & 0xFF ))
(( thecode[mbrpno++] = (pofs >> 16) & 0xFF ))
(( thecode[mbrpno++] = (pofs >> 24) & 0xFF ))
(( pssz = psz - pofs ))
(( thecode[mbrpno++] = pssz & 0xFF ))
(( thecode[mbrpno++] = (pssz >> 8) & 0xFF ))
(( thecode[mbrpno++] = (pssz >> 16) & 0xFF ))
(( thecode[mbrpno++] = (pssz >> 24) & 0xFF ))
# write partition table entry
ostr=
curptr=0
while (( curptr < 16 )); do
	ostr=$ostr\\0${thecode[curptr++]#8#}
done
print -n "$ostr" | \
    dd of="$T/firsttrack" conv=notrunc bs=1 seek=$((0x1EE)) 2>/dev/null

if (( datafssz )); then
	# create data partition (copy of the above :)
	set -A thecode
	typeset -Uui8 thecode
	mbrpno=0
	set -A g_code $cyls $heads $secs
	(( psz = (cyls - cfgfs) * g_code[1] * g_code[2] ))
	(( pofs = (cyls - cfgfs - datafssz) * g_code[1] * g_code[2] ))
	set -A o_code	# g_code equivalent for partition offset
	(( o_code[2] = pofs % g_code[2] + 1 ))
	(( o_code[1] = pofs / g_code[2] ))
	(( o_code[0] = o_code[1] / g_code[1] + 1 ))
	(( o_code[1] = o_code[1] % g_code[1] + 1 ))
	# boot flag; C/H/S offset
	thecode[mbrpno++]=0x00
	(( thecode[mbrpno++] = o_code[1] - 1 ))
	(( cylno = o_code[0] > 1024 ? 1023 : o_code[0] - 1 ))
	(( thecode[mbrpno++] = o_code[2] | ((cylno & 0x0300) >> 2) ))
	(( thecode[mbrpno++] = cylno & 0x00FF ))
	# partition type; C/H/S end
	(( thecode[mbrpno++] = 0x83 ))
	(( thecode[mbrpno++] = g_code[1] - 1 ))
	(( cylno = (g_code[0] - cfgfs) > 1024 ? 1023 : g_code[0] - cfgfs - 1 ))
	(( thecode[mbrpno++] = g_code[2] | ((cylno & 0x0300) >> 2) ))
	(( thecode[mbrpno++] = cylno & 0x00FF ))
	# partition offset, size (LBA)
	(( thecode[mbrpno++] = pofs & 0xFF ))
	(( thecode[mbrpno++] = (pofs >> 8) & 0xFF ))
	(( thecode[mbrpno++] = (pofs >> 16) & 0xFF ))
	(( thecode[mbrpno++] = (pofs >> 24) & 0xFF ))
	(( pssz = psz - pofs ))
	(( thecode[mbrpno++] = pssz & 0xFF ))
	(( thecode[mbrpno++] = (pssz >> 8) & 0xFF ))
	(( thecode[mbrpno++] = (pssz >> 16) & 0xFF ))
	(( thecode[mbrpno++] = (pssz >> 24) & 0xFF ))
	# write partition table entry
	ostr=
	curptr=0
	while (( curptr < 16 )); do
		ostr=$ostr\\0${thecode[curptr++]#8#}
	done
	print -n "$ostr" | \
	    dd of="$T/firsttrack" conv=notrunc bs=1 seek=$((0x1CE)) 2>/dev/null
fi

if [[ $target = raspberry-pi ]]; then
	# move system and data partition from #0/#1 to #1/#2
	dd if="$T/firsttrack" bs=1 skip=$((0x1BE)) count=32 of="$T/x" 2>/dev/null
	dd of="$T/firsttrack" conv=notrunc bs=1 seek=$((0x1CE)) if="$T/x" 2>/dev/null
	# create boot partition (copy of the above :)
	set -A thecode
	typeset -Uui8 thecode
	mbrpno=0
	set -A g_code $cyls $heads $secs
	psz=$spartofs
	pofs=$partofs
	set -A o_code	# g_code equivalent for partition offset
	(( o_code[2] = pofs % g_code[2] + 1 ))
	(( o_code[1] = pofs / g_code[2] ))
	(( o_code[0] = o_code[1] / g_code[1] + 1 ))
	(( o_code[1] = o_code[1] % g_code[1] + 1 ))
	# boot flag; C/H/S offset
	thecode[mbrpno++]=0x00
	(( thecode[mbrpno++] = o_code[1] - 1 ))
	(( cylno = o_code[0] > 1024 ? 1023 : o_code[0] - 1 ))
	(( thecode[mbrpno++] = o_code[2] | ((cylno & 0x0300) >> 2) ))
	(( thecode[mbrpno++] = cylno & 0x00FF ))
	# partition type; C/H/S end
	(( thecode[mbrpno++] = 0x0B ))
	(( thecode[mbrpno++] = g_code[1] - 1 ))
	(( cylno = (spartofs / 2048) > 1024 ? 1023 : (spartofs / 2048) - 1 ))
	(( thecode[mbrpno++] = g_code[2] | ((cylno & 0x0300) >> 2) ))
	(( thecode[mbrpno++] = cylno & 0x00FF ))
	# partition offset, size (LBA)
	(( thecode[mbrpno++] = pofs & 0xFF ))
	(( thecode[mbrpno++] = (pofs >> 8) & 0xFF ))
	(( thecode[mbrpno++] = (pofs >> 16) & 0xFF ))
	(( thecode[mbrpno++] = (pofs >> 24) & 0xFF ))
	(( pssz = psz - pofs ))
	(( thecode[mbrpno++] = pssz & 0xFF ))
	(( thecode[mbrpno++] = (pssz >> 8) & 0xFF ))
	(( thecode[mbrpno++] = (pssz >> 16) & 0xFF ))
	(( thecode[mbrpno++] = (pssz >> 24) & 0xFF ))
	# write partition table entry
	ostr=
	curptr=0
	while (( curptr < 16 )); do
		ostr=$ostr\\0${thecode[curptr++]#8#}
	done
	print -n "$ostr" | \
	    dd of="$T/firsttrack" conv=notrunc bs=1 seek=$((0x1BE)) 2>/dev/null
fi

# disk signature
rnddev=/dev/urandom
[[ -c /dev/arandom ]] && rnddev=/dev/arandom
dd if=$rnddev bs=4 count=1 2>/dev/null | \
    dd of="$T/firsttrack" conv=notrunc bs=1 seek=$((0x1B8)) 2>/dev/null
print -n '\0\0' | \
    dd of="$T/firsttrack" conv=notrunc bs=1 seek=$((0x1BC)) 2>/dev/null
partuuid=$(dd if="$T/firsttrack" bs=1 count=4 skip=$((0x1B8)) 2>/dev/null | \
    hexdump -e '1/4 "%08x"')-0$((syspartno+1))

((keep)) || if (( datafssz )); then
	(( quiet )) || print Cleaning out data partition...
	dd if=/dev/zero of="$tgt" bs=1048576 count=1 seek=$((cyls - cfgfs - datafssz)) > /dev/null 2>&1
fi
(( quiet )) || print Cleaning out root partition...
dd if=/dev/zero bs=1048576 of="$tgt" count=1 seek=$((spartofs / 2048)) > /dev/null 2>&1

(( quiet )) || if (( grub )); then
	print Writing MBR and GRUB2 to target device... system PARTUUID=$partuuid
else
	print Writing MBR to target device... system PARTUUID=$partuuid
fi
dd if="$T/firsttrack" of="$tgt" > /dev/null 2>&1

fwdir=$(dirname "$src")

case $target {
(solidrun-imx6)
	dd if="$fwdir/SPL" of="$tgt" bs=1024 seek=1 > /dev/null 2>&1
	dd if="$fwdir/u-boot.img" of="$tgt" bs=1024 seek=42 > /dev/null 2>&1
	;;
(raspberry-pi)
	(( noformat )) || create_fs "$bootpart" ADKBOOT vfat
	;;
}

(( noformat )) || create_fs "$rootpart" ADKROOT ext4
(( noformat )) || tune_fs "$rootpart"

(( quiet )) || print Extracting installation archive...
mount_fs "$rootpart" "$R" ext4
xz -dc "$src" | (cd "$R"; tar -xpf -)

if (( datafssz )); then
	mkdir -m0755 "$R"/data
	((keep)) || create_fs "$datapart" ADKDATA ext4
	((keep)) || tune_fs "$datapart"
	mount_fs "$datapart" "$D" ext4
	mkdir -m0755 "$D/mpd" "$D/kodi" 2>/dev/null
	umount_fs "$D"
	case $target {
	(raspberry-pi)
		echo "/dev/mmcblk0p3	/data	ext4	rw	0	0" >> "$R"/etc/fstab 
	;;
	(solidrun-imx6)
		echo "/dev/mmcblk0p2	/data	ext4	rw	0	0" >> "$R"/etc/fstab
	;;
	}
fi

case $target {
(raspberry-pi)
	mount_fs "$bootpart" "$B" vfat
	for x in "$R"/boot/.*; do
		[[ -e "$x" ]] && mv -f "$R"/boot/.* "$B/"
		break
	done
	for x in "$R"/boot/*; do
		[[ -e "$x" ]] && mv -f "$R"/boot/* "$B/"
		break
	done
	for x in "$fwdir"/*.dtb; do
		[[ -e "$x" ]] && cp "$fwdir"/*.dtb "$B/"
		break
	done
	mkdir "$B/"overlay
	for x in "$B/"*-overlay.dtb; do
		[[ -e "$x" ]] && mv "$B/"*-overlay.dtb "$B/"overlay
		break
	done
	umount_fs "$B"
	;;
(solidrun-imx6)
	for x in "$fwdir"/*.dtb; do
		[[ -e "$x" ]] && cp "$fwdir"/*.dtb "$R/boot/"
		break
	done
	;;
}

cd "$R"
dd if=$rnddev bs=16 count=1 >>etc/.rnd 2>/dev/null
(( quiet )) || print Fixing up permissions...
chown 0:0 tmp
chmod 1777 tmp
[[ -f usr/bin/sudo ]] && chmod 4755 usr/bin/sudo

if (( grub )); then
	(( quiet )) || print Configuring GRUB2 bootloader...
	mkdir -p boot/grub
	(
		print set default=0
		print set timeout=1
		if (( serial )); then
			print serial --unit=0 --speed=$speed
			print terminal_output serial
			print terminal_input serial
			consargs="console=ttyS0,$speed console=tty0"
		else
			print terminal_output console
			print terminal_input console
			consargs="console=tty0"
		fi
		print
		print 'menuentry "GNU/Linux (OpenADK)" {'
		linuxargs="root=PARTUUID=$partuuid $consargs"
		(( panicreboot )) && linuxargs="$linuxargs panic=$panicreboot"
		print "\tlinux /boot/kernel $linuxargs"
		print '}'
	) >boot/grub/grub.cfg
fi

(( quiet )) || print Finishing up...
cd "$ADK_TOPDIR"
sync
umount_fs "$R"
sync

rm -rf "$T"
exit 0
