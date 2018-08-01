# Created by: 
# $FreeBSD$

PORTNAME=	gmt5
DISTVERSION=	5.4.4
DISTVERSIONSUFFIX=	-src
DISTNAME=	gmt-${DISTVERSION}${DISTVERSIONSUFFIX}
GSHHG_DISTNAME=	gshhg-gmt-2.3.7
DCW_DISTNAME=	dcw-gmt-1.1.4
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
DISTFILES=	${DISTNAME}${EXTRACT_SUFX} \
		${GSHHG_DISTNAME}${EXTRACT_SUFX}:gshhg \
		${DCW_DISTNAME}${EXTRACT_SUFX}

MAINTAINER=	
COMMENT=	Generic Mapping Tools - data processing and display software package

LICENSE=	GPLv3 LGPL3
LICENSE_COMB=	multi
LICENSE_DISTFILES_GPLv3=	${DISTNAME}${EXTRACT_SUFX}
LICENSE_DISTFILES_LGPL3=	${GSHHG_DISTNAME}${EXTRACT_SUFX}

LIB_DEPENDS=	libnetcdf.so:science/netcdf \
		libcurl.so:ftp/curl \
		libpcre.so:devel/pcre
RUN_DEPENDS=	bash:shells/bash

WRKSRC=		${WRKDIR}/gmt-${PORTVERSION}

DATADIR=	${PREFIX}/share/gmt

NO_MTREE=	yes

USES=shebangfix
SHEBANG_REGEX=	./scripts/.*\.(sh|pl|cgi)

SHEBANG_FILES=	gmtswitch doc/examples/*/*.sh src/GMT.in \
		src/gmt_shell_functions.sh.in src/gmtget.in \
		src/gmtlogo.in src/isogmt.in

USES=		cmake:outsource

CMAKE_ARGS+=	-DCMAKE_BUILD_TYPE=RelWithDebInfo \
		-DCMAKE_C_FLAGS=-fstrict-aliasing \
		-DCMAKE_INSTALL_PREFIX=${PREFIX} \
		-DGMT_DATADIR= ${DATADIR} \
		-DDCW_ROOT=${DATADIR}/dcw \
		-DGSHHG_ROOT=${DATADIR}/gshhg \
		-DNETCDF_ROOT=${PREFIX} \
		-DFFTW3_ROOT=${PREFIX} \
		-DGDAL_ROOT=${PREFIX} \
		-DPCRE_ROOT=${PREFIX} \
		-DGMT_INSTALL_MODULE_LINKS=off \
		-DGMT_INSTALL_TRADITIONAL_FOLDERNAMES=off \

STRIP_BINS=	gmt gmtswitch isogmt
STRIP_LIBS=	libgmt.so.4 libgmtps.so.4 libpsl.so.4

echo:
	@echo ${INSTALL_PROGRAM}

.include <bsd.port.mk>
