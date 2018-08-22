# $FreeBSD$

PORTNAME=	gmt5
DISTVERSION=	5.4.4
DISTVERSIONSUFFIX=	-src
CATEGORIES=	graphics
MASTER_SITES=	ftp://ftp.soest.hawaii.edu/%SUBDIR%/ \
		ftp://ftp.geologi.uio.no/pub/%SUBDIR%/ \
		ftp://ftp.iag.usp.br/%SUBDIR%/ \
		ftp://ftp.scc.u-tokai.ac.jp/pub/%SUBDIR%/ \
		http://gd.tuwien.ac.at/graphics/visual/%SUBDIR%/ \
		http://gmt.mirror.ac.za/%SUBDIR%/ \
		ftp://ftp.soest.hawaii.edu/gshhg/:gshhg \
		ftp://ftp.scc.u-tokai.ac.jp/pub/gmt/:gshhg
MASTER_SITE_SUBDIR=	gmt gmt/legacy
DISTNAME=	gmt-${DISTVERSION}${DISTVERSIONSUFFIX}
DISTFILES=	${DISTNAME}${EXTRACT_SUFX} \
		${GSHHG_DISTNAME}${EXTRACT_SUFX}:gshhg \
		${DCW_DISTNAME}${EXTRACT_SUFX}

MAINTAINER=	lbartoletti@tuxfamily.org
COMMENT=	Generic Mapping Tools - data processing and display software package

LICENSE=	GPLv3 LGPL3
LICENSE_COMB=	multi
LICENSE_DISTFILES_GPLv3=	${DISTNAME}${EXTRACT_SUFX}
LICENSE_DISTFILES_LGPL3=	${GSHHG_DISTNAME}${EXTRACT_SUFX}

LIB_DEPENDS=	libnetcdf.so:science/netcdf \
		libcurl.so:ftp/curl \
		libpcre.so:devel/pcre \
		libfftw3f_threads.so:math/fftw3-float \
		libgdal.so:graphics/gdal
RUN_DEPENDS=	bash:shells/bash

GSHHG_DISTNAME=	gshhg-gmt-2.3.7
DCW_DISTNAME=	dcw-gmt-1.1.4

WRKSRC=		${WRKDIR}/gmt-${PORTVERSION}

USES=		shebangfix cmake:outsource
SHEBANG_GLOB=	*.sh *.in
SHEBANG_FILES=	share/tools/ncdeflate src/img/img2google src/gmtswitch

USE_LDCONFIG=	yes

CMAKE_ARGS+=	-DCMAKE_BUILD_TYPE=RelWithDebInfo \
		-DCMAKE_C_FLAGS=-fstrict-aliasing \
		-DCMAKE_INSTALL_PREFIX=${PREFIX} \
		-DDCW_ROOT=${PREFIX}/share/${PORTNAME}/dcw \
		-DGSHHG_ROOT=${PREFIX}/share/${PORTNAME}/gshhg \
		-DGMT_INSTALL_MODULE_LINKS=off \
		-DGMT_INSTALL_TRADITIONAL_FOLDERNAMES=off \
		-DGMT_DATADIR=${PREFIX}/share/${PORTNAME} \
		-DGMT_DOCDIR=${PREFIX}/share/doc/${PORTNAME} \
		-DGMT_MANDIR=${PREFIX}/share/doc/${PORTNAME}/man \
		-DGMT_INSTALL_NAME_SUFFIX=-gmt5

#STRIP_BINS=	gmtff gmtswitch isogmt
#STRIP_LIBS=	libgmt5.so.4 libgmtps.so.4 libpsl.so.4

.include <bsd.port.mk>
