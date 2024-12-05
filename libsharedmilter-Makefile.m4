dnl $Id: Makefile.m4,v 8.96 2013-10-14 16:16:44 ca Exp $

include(confBUILDTOOLSDIR`/M4/switch.m4')

dnl only required for compilation of EXTRAS
define(`confREQUIRE_SM_OS_H', `true')
define(`confMT', `true')

# sendmail dir
SMSRCDIR=ifdef(`confSMSRCDIR', `confSMSRCDIR', `${SRCDIR}/sendmail')
PREPENDDEF(`confINCDIRS', `-I${SMSRCDIR} ')

bldPRODUCT_START(`sharedlibrary', `libmilter')

dnl Extract shared object version number from `mfapi.h' file
define(`runCtest', `esyscmd(`echo -e "#include <stdio.h>\n#include \"../include/libmilter/mfapi.h\"\nint main(){'$1`;return 0;}" | cc -x c -I../include -o ctest - && ./ctest && rm -f ctest')')dnl
define(`confSOMAJ', runCtest(`printf(\"%d\", SM_LM_VRS_MAJOR(SMFI_VERSION))'))dnl
define(`confSOMIN', runCtest(`printf(\"%d\", SM_LM_VRS_MINOR(SMFI_VERSION))'))dnl
define(`confSOPLVL', runCtest(`printf(\"%d\", SM_LM_VRS_PLVL(SMFI_VERSION))'))dnl

ifelse(bldOS, `Linux',
dnl Linux so-version is Major.Minor.Patchlevel
`
	define(`confMILTER_SOVER', `confSOMAJ.confSOMIN.confSOPLVL')
',
dnl If not Linux, only use Major
`
	define(`confMILTER_SOVER', `confSOMAJ')
')

dnl define(`confCUSTOM_MILTER_SOVER', `222222222222')

ifdef(`confCUSTOM_MILTER_SOVER', `define(`confCUSTOM_MILTER_SOVER_DOT', `confCUSTOM_MILTER_SOVER.')')
ifdef(`confCUSTOM_MILTER_SOVER', `define(`confSOMAJ', `substr(confCUSTOM_MILTER_SOVER_DOT, 0, index(confCUSTOM_MILTER_SOVER_DOT, `.'))')')

define(`bldINSTALLABLE', `true')
define(`LIBMILTER_EXTRAS', `errstring.c strl.c')
APPENDDEF(`confCCOPTS', `-fPIC')
APPENDDEF(`confENVDEF', `-DNOT_SENDMAIL -Dsm_snprintf=snprintf')
define(`bldSOURCES', `main.c engine.c listener.c worker.c handler.c comm.c smfi.c signal.c sm_gethost.c monitor.c LIBMILTER_EXTRAS ')
define(`confBEFORE', `LIBMILTER_EXTRAS')
bldPUSH_INSTALL_TARGET(`install-mfapi')
bldPRODUCT_END

PUSHDIVERT(3)
errstring.c:
	${LN} ${LNOPTS} ${SRCDIR}/libsm/errstring.c .

strl.c:
	${LN} ${LNOPTS} ${SRCDIR}/libsm/strl.c .
POPDIVERT


divert(bldTARGETS_SECTION)
# Install the API header files
MFAPI=	${SRCDIR}/inc`'lude/libmilter/mfapi.h
MFDEF=	${SRCDIR}/inc`'lude/libmilter/mfdef.h
install-mfapi: ${MFAPI}
	if [ ! -d ${DESTDIR}${INCLUDEDIR}/libmilter ]; then mkdir -p ${DESTDIR}${INCLUDEDIR}/libmilter; else :; fi
	${INSTALL} -c -o ${INCOWN} -g ${INCGRP} -m ${INCMODE} ${MFAPI} ${DESTDIR}${INCLUDEDIR}/libmilter/mfapi.h
	${INSTALL} -c -o ${INCOWN} -g ${INCGRP} -m ${INCMODE} ${MFDEF} ${DESTDIR}${INCLUDEDIR}/libmilter/mfdef.h
divert(0)

bldFINISH
