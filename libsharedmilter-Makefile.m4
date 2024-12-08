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
define(`conf_libmilter_SOMAJOR', runCtest(`printf(\"%d\", SM_LM_VRS_MAJOR(SMFI_VERSION))'))dnl
define(`conf_libmilter_SOMINOR', runCtest(`printf(\"%d\", SM_LM_VRS_MINOR(SMFI_VERSION))'))dnl
define(`conf_libmilter_SOPATCH', runCtest(`printf(\"%d\", SM_LM_VRS_PLVL(SMFI_VERSION))'))dnl

ifelse(bldOS, `Linux',
dnl Linux so-version is Major.Minor.Patchlevel
`
	define(`conf_libmilter_SOVERSION', `conf_libmilter_SOMAJOR.conf_libmilter_SOMINOR.conf_libmilter_SOPATCH')
',
dnl If not Linux, only use Major
`
	define(`conf_libmilter_SOVERSION', `conf_libmilter_SOMAJOR')
')

ifdef(`conf_libmilter_CUSTOM_SOMAJOR', `undefine(`conf_libmilter_SOMAJOR', `conf_libmilter_SOMINOR', `conf_libmilter_SOPATCH')')dnl
ifdef(`conf_libmilter_CUSTOM_SOMAJOR', `define(`conf_libmilter_SOMAJOR', conf_libmilter_CUSTOM_SOMAJOR)')dnl
ifdef(`conf_libmilter_CUSTOM_SOMINOR', `define(`conf_libmilter_SOMINOR', conf_libmilter_CUSTOM_SOMINOR)')dnl
ifdef(`conf_libmilter_CUSTOM_SOPATCH', `define(`conf_libmilter_SOPATCH', conf_libmilter_CUSTOM_SOPATCH)')dnl

divert(bldTARGETS_SECTION)
ifdef(`conf_libmilter_SOMAJOR', `define(`conf_libmilter_SOVERSION', conf_libmilter_SOMAJOR)')dnl
ifdef(`conf_libmilter_SOMINOR', `define(`conf_libmilter_SOVERSION', conf_libmilter_SOMAJOR.conf_libmilter_SOMINOR)')dnl
ifdef(`conf_libmilter_SOPATCH', `define(`conf_libmilter_SOVERSION', conf_libmilter_SOMAJOR.conf_libmilter_SOMINOR.conf_libmilter_SOPATCH)')dnl

ifdef(`conf_libmilter_SOMINOR', `define(`conf_libmilter_SONAME', `.conf_libmilter_SOMAJOR')', `define(conf_libmilter_SONAME, `')')dnl

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
