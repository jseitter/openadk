OBJS=mopchk.o
INCL=-I../ -I../common
LIBS=../common/libcommon.a

all: mopchk

mopchk: ${OBJS} version.o $(LIBS)
	$(CC) -o mopchk version.o ${OBJS} ${LIBS}

.c.o: .c
	$(CC) -c $(CFLAGS) ${INCL} $<
	
clean:
	rm -f *.o *~ mopchk VERSION version.*
	
version.o: version.c
version.c version.h: 
	ln -sf ../common/VERSION VERSION
	rm -f version.c ; sed 's/.*/char version[] = "&";/' VERSION > version.c
	set `sed 's/\([0-9]*\)\.\([0-9]*\).*/\1 \2/' VERSION` ; \
		{ echo '#define VERSION_MAJOR' $$1 ; \
		  echo '#define VERSION_MINOR' $$2 ; } > version.h
 
