/*	$NetBSD: file.c,v 1.5 1998/02/07 00:03:22 cgd Exp $	*/

/*
 * Copyright (c) 1995-96 Mats O Jansson.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *	This product includes software developed by Mats O Jansson.
 * 4. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <sys/cdefs.h>
#ifndef lint
static char rcsid[]="$NetBSD: file.c,v 1.5 1998/02/07 00:03:22 cgd Exp $";
#endif

#include "os.h"
#include "common.h"
#include "file.h"
#include "mopdef.h"

#ifndef NOAOUT
#if defined(__NetBSD__) || defined(__OpenBSD__)
#include <sys/exec_aout.h>
#endif
#if defined(__bsdi__) 
#define NOAOUT
#endif
#if defined(__FreeBSD__)
#include <sys/imgact_aout.h>
#endif
#if !defined(MID_VAX)
#define MID_VAX 140
#endif
#if defined(__linux__)
#define NOAOUT
#include <a.out.h>
#define MID_I386 100
#define MID_SPARC 3
#endif
#endif

int	getCLBYTES __P((int));
int	getMID __P((int, int));

void
mopFilePutLX(buf, index, value, cnt)
	u_char	       *buf;
	int		index, cnt;
	u_int32_t	value;
{
	int i;
	for (i = 0; i < cnt; i++) {
		buf[index+i] = value % 256;
		value = value / 256;
	}
}

void
mopFilePutBX(buf, index, value, cnt)
	u_char	       *buf;
	int		index, cnt;
	u_int32_t	value;
{
	int i;
	for (i = 0; i < cnt; i++) {
		buf[index+cnt-1-i] = value % 256;
		value = value / 256;
	}
}

u_int32_t
mopFileGetLX(buf, index, cnt)
	u_char	*buf;
	int	index, cnt;
{
	u_int32_t ret = 0;
	int i;

	for (i = 0; i < cnt; i++) {
		ret = ret*256 + buf[index+cnt-1-i];
	}

	return(ret);
}

u_int32_t
mopFileGetBX(buf, index, cnt)
	u_char	*buf;
	int	index, cnt;
{
	u_int32_t ret = 0;
	int i;

	for (i = 0; i < cnt; i++) {
		ret = ret*256 + buf[index+i];
	}

	return(ret);
}

void
mopFileSwapX(buf, index, cnt)
	u_char	*buf;
	int	index, cnt;
{
	int i;
	u_char c;

	for (i = 0; i < (cnt / 2); i++) {
		c = buf[index+i];
		buf[index+i] = buf[index+cnt-1-i];
		buf[index+cnt-1-i] = c;
	}

}

int
CheckMopFile(fd)
	int	fd;
{
	u_char	header[512];
	short	image_type;

	if (read(fd, header, 512) != 512)
		return(-1);

	(void)lseek(fd, (off_t) 0, SEEK_SET);

	image_type = (u_short)(header[IHD_W_ALIAS+1]*256 +
			       header[IHD_W_ALIAS]);

	switch(image_type) {
		case IHD_C_NATIVE:		/* Native mode image (VAX)   */
		case IHD_C_RSX:			/* RSX image produced by TKB */
		case IHD_C_BPA:			/* BASIC plus analog         */
		case IHD_C_ALIAS:		/* Alias		     */
		case IHD_C_CLI:			/* Image is CLI		     */
		case IHD_C_PMAX:		/* PMAX system image	     */
		case IHD_C_ALPHA:		/* ALPHA system image	     */
			break;
		default:
			return(-1);
	}

	return(0);
}

int
GetMopFileInfo(fd, load, xfr)
	int		fd;
	u_int32_t      *load, *xfr;
{
	u_char		header[512];
	short		image_type;
	u_int32_t	load_addr, xfr_addr, isd, iha, hbcnt, isize;

	if (read(fd, header, 512) != 512)
		return(-1);

	image_type = (u_short)(header[IHD_W_ALIAS+1]*256 +
			       header[IHD_W_ALIAS]);

	switch(image_type) {
		case IHD_C_NATIVE:		/* Native mode image (VAX)   */
			isd = (header[IHD_W_SIZE+1]*256 +
			       header[IHD_W_SIZE]);
			iha = (header[IHD_W_ACTIVOFF+1]*256 +
			       header[IHD_W_ACTIVOFF]);
			hbcnt = (header[IHD_B_HDRBLKCNT]);
			isize = (header[isd+ISD_W_PAGCNT+1]*256 +
				 header[isd+ISD_W_PAGCNT]) * 512;
			load_addr = ((header[isd+ISD_V_VPN+1]*256 +
				      header[isd+ISD_V_VPN]) & ISD_M_VPN)
					* 512;
			xfr_addr = (header[iha+IHA_L_TFRADR1+3]*0x1000000 +
				    header[iha+IHA_L_TFRADR1+2]*0x10000 +
				    header[iha+IHA_L_TFRADR1+1]*0x100 +
				    header[iha+IHA_L_TFRADR1]) & 0x7fffffff;
			printf("Native Image (VAX)\n");
			printf("Header Block Count: %d\n",hbcnt);
			printf("Image Size:         %08x\n",isize);
			printf("Load Address:       %08x\n",load_addr);
			printf("Transfer Address:   %08x\n",xfr_addr);
			break;
		case IHD_C_RSX:			/* RSX image produced by TKB */
			hbcnt = header[L_BBLK+1]*256 + header[L_BBLK];
			isize = (header[L_BLDZ+1]*256 + header[L_BLDZ]) * 64;
			load_addr = header[L_BSA+1]*256 + header[L_BSA];
			xfr_addr  = header[L_BXFR+1]*256 + header[L_BXFR];
			printf("RSX Image\n");
			printf("Header Block Count: %d\n",hbcnt);
			printf("Image Size:         %08x\n",isize);
			printf("Load Address:       %08x\n",load_addr);
			printf("Transfer Address:   %08x\n",xfr_addr);
			break;
		case IHD_C_BPA:			/* BASIC plus analog         */
			printf("BASIC-Plus Image, not supported\n");
			return(-1);
			break;
		case IHD_C_ALIAS:		/* Alias		     */
			printf("Alias, not supported\n");
			return(-1);
			break;
		case IHD_C_CLI:			/* Image is CLI		     */
			printf("CLI, not supported\n");
			return(-1);
			break;
		case IHD_C_PMAX:		/* PMAX system image	     */
			isd = (header[IHD_W_SIZE+1]*256 +
			       header[IHD_W_SIZE]);
			iha = (header[IHD_W_ACTIVOFF+1]*256 +
			       header[IHD_W_ACTIVOFF]);
			hbcnt = (header[IHD_B_HDRBLKCNT]);
			isize = (header[isd+ISD_W_PAGCNT+1]*256 +
				 header[isd+ISD_W_PAGCNT]) * 512;
			load_addr = (header[isd+ISD_V_VPN+1]*256 +
				     header[isd+ISD_V_VPN]) * 512;
			xfr_addr = (header[iha+IHA_L_TFRADR1+3]*0x1000000 +
				    header[iha+IHA_L_TFRADR1+2]*0x10000 +
				    header[iha+IHA_L_TFRADR1+1]*0x100 +
				    header[iha+IHA_L_TFRADR1]);
			printf("PMAX Image \n");
			printf("Header Block Count: %d\n",hbcnt);
			printf("Image Size:         %08x\n",isize);
			printf("Load Address:       %08x\n",load_addr);
			printf("Transfer Address:   %08x\n",xfr_addr);
			break;
		case IHD_C_ALPHA:		/* ALPHA system image	     */
			isd = (header[EIHD_L_ISDOFF+3]*0x1000000 +
			       header[EIHD_L_ISDOFF+2]*0x10000 +
			       header[EIHD_L_ISDOFF+1]*0x100 +
			       header[EIHD_L_ISDOFF]);
			hbcnt = (header[EIHD_L_HDRBLKCNT+3]*0x1000000 +
				 header[EIHD_L_HDRBLKCNT+2]*0x10000 +
				 header[EIHD_L_HDRBLKCNT+1]*0x100 +
				 header[EIHD_L_HDRBLKCNT]);
			isize = (header[isd+EISD_L_SECSIZE+3]*0x1000000 +
				 header[isd+EISD_L_SECSIZE+2]*0x10000 +
				 header[isd+EISD_L_SECSIZE+1]*0x100 +
				 header[isd+EISD_L_SECSIZE]);
			load_addr = 0;
			xfr_addr = 0;
			printf("Alpha Image \n");
			printf("Header Block Count: %d\n",hbcnt);
			printf("Image Size:         %08x\n",isize);
			printf("Load Address:       %08x\n",load_addr);
			printf("Transfer Address:   %08x\n",xfr_addr);
			break;
		default:
			printf("Unknown Image (%d)\n",image_type);
			return(-1);
	}

	if (load != NULL) {
		*load = load_addr;
	}

	if (xfr != NULL) {
		*xfr  = xfr_addr;
	}

	return(0);
}

#ifndef NOAOUT
int
getMID(old_mid,new_mid)
	int	old_mid, new_mid;
{
	int	mid;

	mid = old_mid;

	switch (new_mid) {
	case MID_I386:
		mid = MID_I386;
		break;
#ifdef MID_M68K
	case MID_M68K:
		mid = MID_M68K;
		break;
#endif
#ifdef MID_M68K4K
	case MID_M68K4K:
		mid = MID_M68K4K;
		break;
#endif
#ifdef MID_NS32532
	case MID_NS32532:
		mid = MID_NS32532;
		break;
#endif
	case MID_SPARC:
		mid = MID_SPARC;
		break;
#ifdef MID_PMAX
	case MID_PMAX:
		mid = MID_PMAX;
		break;
#endif
#ifdef MID_VAX
	case MID_VAX:
		mid = MID_VAX;
		break;
#endif
#ifdef MID_ALPHA
	case MID_ALPHA:
		mid = MID_ALPHA;
		break;
#endif
#ifdef MID_MIPS
	case MID_MIPS:
		mid = MID_MIPS;
		break;
#endif
#ifdef MID_ARM6
	case MID_ARM6:
		mid = MID_ARM6;
		break;
#endif
	default:
		break;
	}

	return(mid);
}

int
getCLBYTES(mid)
	int	mid;
{
	int	clbytes;

	switch (mid) {
#ifdef MID_VAX
	case MID_VAX:
		clbytes = 1024;
		break;
#endif
#ifdef MID_I386
	case MID_I386:
#endif
#ifdef MID_M68K4K
	case MID_M68K4K:
#endif
#ifdef MID_NS32532
	case MID_NS32532:
#endif
#ifdef MID_PMAX
	case MID_PMAX:
#endif
#ifdef MID_MIPS
	case MID_MIPS:
#endif
#ifdef MID_ARM6
	case MID_ARM6:
#endif
#if defined(MID_I386) || defined(MID_M68K4K) || defined(MID_NS32532) || \
    defined(MID_PMAX) || defined(MID_MIPS) || defined(MID_ARM6)
		clbytes = 4096;
		break;
#endif
#ifdef MID_M68K
	case MID_M68K:
#endif
#ifdef MID_ALPHA
	case MID_ALPHA:
#endif
#ifdef MID_SPARC
	case MID_SPARC:
#endif
#if defined(MID_M68K) || defined(MID_ALPHA) || defined(MID_SPARC)
		clbytes = 8192;
		break;
#endif
	default:
		clbytes = 0;
	}

	return(clbytes);
}
#endif

int
CheckAOutFile(fd)
	int	fd;
{
#ifdef NOAOUT
	return(-1);
#else
	struct exec ex, ex_swap;
	int	mid = -1;

	if (read(fd, (char *)&ex, sizeof(ex)) != sizeof(ex))
		return(-1);

	(void)lseek(fd, (off_t) 0, SEEK_SET);
	
	if (read(fd, (char *)&ex_swap, sizeof(ex_swap)) != sizeof(ex_swap))
		return(-1);

	(void)lseek(fd, (off_t) 0, SEEK_SET);
	
	mid = getMID(mid, N_GETMID (ex));

	if (mid == -1) {
		mid = getMID(mid, N_GETMID (ex_swap));
	}

	if (mid != -1) {
		return(0);
	} else {
		return(-1);
	}
#endif NOAOUT
}

int
GetAOutFileInfo(fd, load, xfr, a_text, a_text_fill,
		a_data, a_data_fill, a_bss, a_bss_fill, aout)
	int		 fd;
	u_int32_t	*load, *xfr, *a_text, *a_text_fill;
	u_int32_t	*a_data, *a_data_fill, *a_bss, *a_bss_fill;
	int		 *aout;
{
#ifdef NOAOUT
	return(-1);
#else
	struct exec ex, ex_swap;
	u_int32_t	mid = -1;
	u_int32_t	magic, clbytes, clofset;

	if (read(fd, (char *)&ex, sizeof(ex)) != sizeof(ex))
		return(-1);

	(void)lseek(fd, (off_t) 0, SEEK_SET);

	if (read(fd, (char *)&ex_swap, sizeof(ex_swap)) != sizeof(ex_swap))
		return(-1);

	mopFileSwapX((u_char *)&ex_swap, 0, 4);

	mid = getMID(mid, N_GETMID (ex));

	if (mid == -1) {
		mid = getMID(mid, N_GETMID (ex_swap));
		if (mid != -1) {
			mopFileSwapX((u_char *)&ex, 0, 4);
		}
	}

	if (mid == -1) {
		return(-1);
	}

	if (N_BADMAG (ex)) {
		return(-1);
	}

	switch (mid) {
	case MID_I386:
#ifdef MID_NS32532
	case MID_NS32532:
#endif
#ifdef MID_PMAX
	case MID_PMAX:
#endif
#ifdef MID_VAX
	case MID_VAX:
#endif
#ifdef MID_ALPHA
	case MID_ALPHA:
#endif
#ifdef MID_ARM6
	case MID_ARM6:
#endif
		ex.a_text  = mopFileGetLX((u_char *)&ex_swap,  4, 4);
		ex.a_data  = mopFileGetLX((u_char *)&ex_swap,  8, 4);
		ex.a_bss   = mopFileGetLX((u_char *)&ex_swap, 12, 4);
		ex.a_syms  = mopFileGetLX((u_char *)&ex_swap, 16, 4);
		ex.a_entry = mopFileGetLX((u_char *)&ex_swap, 20, 4);
		ex.a_trsize= mopFileGetLX((u_char *)&ex_swap, 24, 4);
		ex.a_drsize= mopFileGetLX((u_char *)&ex_swap, 28, 4);
		break;
#ifdef MID_M68K
	case MID_M68K:
#endif
#ifdef MID_M68K4K
	case MID_M68K4K:
#endif
	case MID_SPARC:
#ifdef MID_MIPS
	case MID_MIPS:
#endif
		ex.a_text  = mopFileGetBX((u_char *)&ex_swap,  4, 4);
		ex.a_data  = mopFileGetBX((u_char *)&ex_swap,  8, 4);
		ex.a_bss   = mopFileGetBX((u_char *)&ex_swap, 12, 4);
		ex.a_syms  = mopFileGetBX((u_char *)&ex_swap, 16, 4);
		ex.a_entry = mopFileGetBX((u_char *)&ex_swap, 20, 4);
		ex.a_trsize= mopFileGetBX((u_char *)&ex_swap, 24, 4);
		ex.a_drsize= mopFileGetBX((u_char *)&ex_swap, 28, 4);
		break;
	default:
		break;
	}

	printf("a.out image (");
	switch (N_GETMID (ex)) {
	case MID_I386:
		printf("i386");
		break;
#ifdef MID_M68K
	case MID_M68K:
		printf("m68k");
		break;
#endif
#ifdef MID_M68K4K
	case MID_M68K4K:
		printf("m68k 4k");
		break;
#endif
#ifdef MID_NS32532
	case MID_NS32532:
		printf("pc532");
		break;
#endif
	case MID_SPARC:
		printf("sparc");
		break;
#ifdef MID_PMAX
	case MID_PMAX:
		printf("pmax");
		break;
#endif
#ifdef MID_VAX
	case MID_VAX:
		printf("vax");
		break;
#endif
#ifdef MID_ALPHA
	case MID_ALPHA:
		printf("alpha");
		break;
#endif
#ifdef MID_MIPS
	case MID_MIPS:
		printf("mips");
		break;
#endif
#ifdef MID_ARM6
	case MID_ARM6:
		printf("arm32");
		break;
#endif
	default:
		break;
	}
	printf(") Magic: ");
	switch (N_GETMAGIC (ex)) {
	case OMAGIC:
		printf("OMAGIC");
		break;
	case NMAGIC:
		printf("NMAGIC");
		break;
	case ZMAGIC:
		printf("ZMAGIC");
		break;
	case QMAGIC:
		printf("QMAGIC");
		break;
	default:
		printf("Unknown %ld", (long) N_GETMAGIC (ex));
	}
	printf("\n");
	printf("Size of text:       %08lx\n", (long)ex.a_text);
	printf("Size of data:       %08lx\n", (long)ex.a_data);
	printf("Size of bss:        %08lx\n", (long)ex.a_bss);
	printf("Size of symbol tab: %08lx\n", (long)ex.a_syms);
	printf("Transfer Address:   %08lx\n", (long)ex.a_entry);
	printf("Size of reloc text: %08lx\n", (long)ex.a_trsize);
	printf("Size of reloc data: %08lx\n", (long)ex.a_drsize);

	magic = N_GETMAGIC (ex);
	clbytes = getCLBYTES(mid);
	clofset = clbytes - 1;

	if (load != NULL) {
		*load   = 0;
	}

	if (xfr != NULL) {
		*xfr    = ex.a_entry;
	}

	if (a_text != NULL) {
		*a_text = ex.a_text;
	}

	if (a_text_fill != NULL) {
		if (magic == ZMAGIC || magic == NMAGIC) {
			*a_text_fill = clbytes - (ex.a_text & clofset);
			if (*a_text_fill == clbytes) {
				*a_text_fill = 0;
			}
		} else {
			*a_text_fill = 0;
	        }
	}

	if (a_data != NULL) {
		*a_data = ex.a_data;
	}

	if (a_data_fill != NULL) {
		if (magic == ZMAGIC || magic == NMAGIC) {
			*a_data_fill = clbytes - (ex.a_data & clofset);
			if (*a_data_fill == clbytes) {
				*a_data_fill = 0;
			}
		} else {
			*a_data_fill = 0;
	        }
	}

	if (a_bss != NULL) {
		*a_bss  = ex.a_bss;
	}

	if (a_bss_fill != NULL) {
		if (magic == ZMAGIC || magic == NMAGIC) {
			*a_bss_fill = clbytes - (ex.a_bss & clofset);
			if (*a_bss_fill == clbytes) {
				*a_bss_fill = 0;
			}
		} else {
			*a_bss_fill = clbytes -
				((ex.a_text+ex.a_data+ex.a_bss) & clofset);
			if (*a_text_fill == clbytes) {
				*a_text_fill = 0;
			}
	        }
	}

	if (aout != NULL) {
		*aout = mid;
	}

	return(0);
#endif NOAOUT
}

int
GetFileInfo(fd, load, xfr, aout,
	    a_text, a_text_fill, a_data, a_data_fill, a_bss, a_bss_fill)
	int	fd, *aout;
	u_int32_t	*load, *xfr, *a_text, *a_text_fill;
	u_int32_t	*a_data, *a_data_fill, *a_bss, *a_bss_fill;
{
	int	err;

	err = CheckAOutFile(fd);

	if (err == 0) {
		err = GetAOutFileInfo(fd, load, xfr,
				      a_text, a_text_fill,
				      a_data, a_data_fill,
				      a_bss, a_bss_fill,
				      aout);
		if (err != 0) {
			return(-1);
		}
	} else {
		err = CheckMopFile(fd);
		
		if (err == 0) {
			err = GetMopFileInfo(fd, load, xfr);
			if (err != 0) {
				return(-1);
			}
			*aout = -1;
		} else {
			return(-1);
		}
	}

	return(0);
}

ssize_t
mopFileRead(dlslot, buf)
	struct dllist *dlslot;
	u_char	*buf;
{
	ssize_t len, outlen;
	int	bsz;
	int32_t	pos, notdone, total;

	if (dlslot->aout == -1) {
		len = read(dlslot->ldfd,buf,dlslot->dl_bsz);
	} else {
		bsz = dlslot->dl_bsz;
		pos = dlslot->a_lseek;
		len = 0;

		total = dlslot->a_text;
		
		if (pos < total) {
			notdone = total - pos;
			if (notdone <= bsz) {
				outlen = read(dlslot->ldfd,&buf[len],notdone);
			} else {
				outlen = read(dlslot->ldfd,&buf[len],bsz);
			}
			len = len + outlen;
			pos = pos + outlen;
			bsz = bsz - outlen;
		}

		total = total + dlslot->a_text_fill;

		if ((bsz > 0) && (pos < total)) {
			notdone = total - pos;
			if (notdone <= bsz) {
				outlen = notdone;
			} else {
				outlen = bsz;
			}
			memset(&buf[len], 0, outlen);
			len = len + outlen;
			pos = pos + outlen;
			bsz = bsz - outlen;
		}

		total = total + dlslot->a_data;
		
		if ((bsz > 0) && (pos < total)) {
			notdone = total - pos;
			if (notdone <= bsz) {
				outlen = read(dlslot->ldfd,&buf[len],notdone);
			} else {
				outlen = read(dlslot->ldfd,&buf[len],bsz);
			}
			len = len + outlen;
			pos = pos + outlen;
			bsz = bsz - outlen;
		}

		total = total + dlslot->a_data_fill;

		if ((bsz > 0) && (pos < total)) {
			notdone = total - pos;
			if (notdone <= bsz) {
				outlen = notdone;
			} else {
				outlen = bsz;
			}
			memset(&buf[len], 0, outlen);
			len = len + outlen;
			pos = pos + outlen;
			bsz = bsz - outlen;
		}
		
		total = total + dlslot->a_bss;

		if ((bsz > 0) && (pos < total)) {
			notdone = total - pos;
			if (notdone <= bsz) {
				outlen = notdone;
			} else {
				outlen = bsz;
			}
			memset(&buf[len], 0, outlen);
			len = len + outlen;
			pos = pos + outlen;
			bsz = bsz - outlen;
		}
		
		total = total + dlslot->a_bss_fill;

		if ((bsz > 0) && (pos < total)) {
			notdone = total - pos;
			if (notdone <= bsz) {
				outlen = notdone;
			} else {
				outlen = bsz;
			}
			memset(&buf[len], 0, outlen);
			len = len + outlen;
			pos = pos + outlen;
			bsz = bsz - outlen;
		}
		
		dlslot->a_lseek = pos;

	}

	return(len);
}
