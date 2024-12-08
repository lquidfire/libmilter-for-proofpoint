divert(-1)
#
# Copyright (c) 1999-2001, 2006 Proofpoint, Inc. and its suppliers.
#	All rights reserved.
#
# By using this file, you agree to the terms and conditions set
# forth in the LICENSE file which can be found at the top level of
# the sendmail distribution.
#
#
#  Definitions for Makefile construction for sendmail
#
#	$Id: library.m4,v 8.12 2013-11-22 20:51:23 ca Exp $
#
divert(0)dnl
include(confBUILDTOOLSDIR`/M4/'bldM4_TYPE_DIR`/links.m4')dnl
bldLIST_PUSH_ITEM(`bldC_PRODUCTS', bldCURRENT_PRODUCT)dnl
bldPUSH_TARGET(bldCURRENT_PRODUCT)dnl
bldPUSH_INSTALL_TARGET(`install-'bldCURRENT_PRODUCT)dnl
bldPUSH_CLEAN_TARGET(bldCURRENT_PRODUCT`-clean')dnl

include(confBUILDTOOLSDIR`/M4/'bldM4_TYPE_DIR`/defines.m4')

dnl for testing


divert(bldTARGETS_SECTION)
ifdef(`conf_libmilter_SOMAJOR', `define(`conf_libmilter_SOVERSION', conf_libmilter_SOMAJOR)')dnl
ifdef(`conf_libmilter_SOMINOR', `define(`conf_libmilter_SOVERSION', conf_libmilter_SOMAJOR.conf_libmilter_SOMINOR)')dnl
ifdef(`conf_libmilter_SOPATCH', `define(`conf_libmilter_SOVERSION', conf_libmilter_SOMAJOR.conf_libmilter_SOMINOR.conf_libmilter_SOPATCH)')dnl

ifdef(`conf_libmilter_SOMINOR', `define(`conf_libmilter_SONAME', `.conf_libmilter_SOMAJOR')', `define(conf_libmilter_SONAME, `')')dnl

bldCURRENT_PRODUCT: ${BEFORE} ${bldCURRENT_PRODUCT`OBJS'}
	${CC} -shared -pthread ${CFLAGS} ${confCCOPTS} -fPIC ${confLDOPTS} ${LDOPTS_SO} -o bldCURRENT_PRODUCT.so.conf_libmilter_SOVERSION -Wl,-soname,bldCURRENT_PRODUCT.so.conf_libmilter_SOMAJOR ${bldCURRENT_PRODUCT`OBJS'}
	${LN} ${LNOPTS} bldCURRENT_PRODUCT.so.conf_libmilter_SOVERSION bldCURRENT_PRODUCT.so${conf_libmilter_SONAME}
	${LN} ${LNOPTS} bldCURRENT_PRODUCT.so.conf_libmilter_SOMAJOR bldCURRENT_PRODUCT.so
ifdef(`bldLINK_SOURCES', `bldMAKE_SOURCE_LINKS(bldLINK_SOURCES)')

install-`'bldCURRENT_PRODUCT: bldCURRENT_PRODUCT
ifdef(`bldINSTALLABLE', `	ifdef(`confMKDIR', `if [ ! -d ${DESTDIR}${bldINSTALL_DIR`'LIBDIR} ]; then confMKDIR -p ${DESTDIR}${bldINSTALL_DIR`'LIBDIR}; else :; fi ')
	${INSTALL} -c -o ${LIBOWN} -g ${LIBGRP} -m ${LIBMODE} bldCURRENT_PRODUCT.so.conf_libmilter_SOVERSION ${DESTDIR}${LIBDIR}
	${LN} ${LNOPTS} bldCURRENT_PRODUCT.so.conf_libmilter_SOVERSION ${DESTDIR}${LIBDIR}/bldCURRENT_PRODUCT.so`'conf_libmilter_SONAME
	${LN} ${LNOPTS} bldCURRENT_PRODUCT.so.conf_libmilter_SOMAJOR ${DESTDIR}${LIBDIR}/bldCURRENT_PRODUCT.so')

bldCURRENT_PRODUCT-clean:
	rm -f ${OBJS} bldCURRENT_PRODUCT.so* ${MANPAGES}

divert(0)
