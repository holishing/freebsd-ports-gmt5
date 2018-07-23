# Created by: 
# $FreeBSD$

PORTNAME=	gmt5
DISTVERSION=	5.4.4
DISTVERSIONSUFFIX=	-src
DISTNAME=	gmt-${DISTVERSION}${DISTVERSIONSUFFIX}
#DISTNAME=	gmt-5.4.4-src
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
		${GSHHG_DISTNAME}.tar.gz:gshhg

MAINTAINER=	
COMMENT=	Generic Mapping Tools - data processing and display software package

LICENSE=	GPLv2 LGPL3
LICENSE_COMB=	multi
LICENSE_DISTFILES_GPLv2=	${DISTNAME}${EXTRACT_SUFX}
LICENSE_DISTFILES_LGPL3=	${GSHHG_DISTNAME}${EXTRACT_SUFX}

LIB_DEPENDS=	libnetcdf.so:science/netcdf
RUN_DEPENDS=	bash:shells/bash

WRKSRC=		${WRKDIR}/${PORTNAME}-${PORTVERSION}

USES=		cmake:outsource
CMAKE_SOURCE_PATH=	${WRKSRC}/build
SHEBANG_FILES=	gmtswitch doc/examples/*/*.sh src/GMT.in \
		src/gmt_shell_functions.sh.in src/gmtget.in \
		src/gmtlogo.in src/isogmt.in
GNU_CONFIGURE=	yes
CONFIGURE_ARGS=	--datadir=${DATADIR} \
		--with-gshhg-dir=${DATADIR}/coast
INSTALL_TARGET=	install-gmt install-data install-man install-doc
MAKE_JOBS_UNSAFE=	yes

PORTDOCS=	*

PORTSCOUT=	limitw:0,even

OPTIONS_DEFINE=		DEBUG DOCS EPS GDAL IMPERIAL OCTAVE SHARED X11
OPTIONS_DEFAULT=	GDAL SHARED X11
OPTIONS_SUB=		yes

DEBUG_CONFIGURE_ON=	--enable-debug --enable-devdebug
EPS_DESC=		Set .eps as default output format, otherwise .ps
EPS_CONFIGURE_ON=	--enable-eps
GDAL_DESC=		Compile in experimental GDAL support
GDAL_LIB_DEPENDS=	libgdal.so:graphics/gdal
GDAL_CONFIGURE_ON=	--enable-gdal
IMPERIAL_DESC=		Choose Imperial (inch) units over metric (cm)
IMPERIAL_CONFIGURE_ON=	--enable-US
OCTAVE_DESC=		Build GMT-octave interface
OCTAVE_RUN_DEPENDS=	octave:math/octave
OCTAVE_CONFIGURE_ON=	--enable-octave --enable-mex
OCTAVE_CONFIGURE_OFF=	--disable-mex
SHARED_DESC=		Build shared (dynamic) libraries
SHARED_CONFIGURE_ON=	--enable-shared
SHARED_USE=		LDCONFIG=yes
X11_USE=		XORG=x11,xaw,xmu,xt
X11_CONFIGURE_OFF=	--disable-xgrid

STRIP_BINS=	gmt gmtswitch isogmt
STRIP_LIBS=	libgmt.so.4 libgmtps.so.4 libpsl.so.4

# http://www.soest.hawaii.edu/pwessel/gshhg/
GSHHG_DISTNAME=	gshhg-gmt-2.3.7

pre-configure:
	@cd ${CONFIGURE_WRKSRC} && ${SETENV} AUTOHEADER="${TRUE}" \
		${AUTORECONF} -f -i

post-install:
	@${MKDIR} ${STAGEDIR}${DATADIR}/coast
	cd ${WRKDIR}/${GSHHG_DISTNAME} && ${INSTALL_DATA} README.TXT *.nc \
		${STAGEDIR}${DATADIR}/coast
.for i in ${STRIP_BINS}
	@${STRIP_CMD} ${STAGEDIR}${PREFIX}/bin/${i}
.endfor

post-install-X11-on:
	cd ${WRKSRC}/src/xgrid && ${INSTALL_PROGRAM} xgridedit \
		${STAGEDIR}${PREFIX}/bin

post-install-SHARED-on:
.for i in ${STRIP_LIBS}
	@${STRIP_CMD} ${STAGEDIR}${PREFIX}/lib/${i}
.endfor

.include <bsd.port.mk>
