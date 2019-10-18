ARG SaM_VERSION="1.0"
ARG TAG="20191018"
# =========================================================================
# FROM
# =========================================================================
    FROM huggla/alpine:$SaM_VERSION-$TAG as image
# =========================================================================
# COPY
# =========================================================================
    COPY ./rootfs /
# =========================================================================
# RUN
# =========================================================================
    RUN exec 2>&1 \
     && set -x \
     && chmod u+x /usr/sbin/relpath /usr/sbin/onbuildrun.sh \
     && mkdir /excludefs /finalfs \
     && apk --no-cache --initramfs-diskless-boot --clean-protected add acl bash build-base libtool cmake automake autoconf linux-headers git libcurl \
     && apk info
# =========================================================================
# ONBUILD - Executed/available when building the main Docker image
# =========================================================================
    # ---------------------------------------------------------------------
    # ARG - Set in main Docker image
    # ---------------------------------------------------------------------
        ONBUILD ARG HUBPROFILE
        ONBUILD ARG HUBREPO
        ONBUILD ARG HUBVERSION
        ONBUILD ARG IMAGEID
        ONBUILD ARG IMAGETYPE
        ONBUILD ARG CONTENTIMAGE1
        ONBUILD ARG CONTENTSOURCE1
        ONBUILD ARG CONTENTDESTINATION1
        ONBUILD ARG CONTENTIMAGE2
        ONBUILD ARG CONTENTSOURCE2
        ONBUILD ARG CONTENTDESTINATION2
        ONBUILD ARG CONTENTIMAGE3
        ONBUILD ARG CONTENTSOURCE3
        ONBUILD ARG CONTENTDESTINATION3
        ONBUILD ARG CONTENTIMAGE4
        ONBUILD ARG CONTENTSOURCE4
        ONBUILD ARG CONTENTDESTINATION4
        ONBUILD ARG CONTENTIMAGE5
        ONBUILD ARG CONTENTSOURCE5
        ONBUILD ARG CONTENTDESTINATION5
        ONBUILD ARG ADDREPOS
        ONBUILD ARG RUNDEPS
        ONBUILD ARG RUNDEPS_UNTRUSTED
        ONBUILD ARG EXCLUDEAPKS
        ONBUILD ARG EXCLUDEDEPS
        ONBUILD ARG MAKEDIRS
        ONBUILD ARG MAKEFILES
        ONBUILD ARG BUILDDIR
        ONBUILD ARG CLONEGITS
        ONBUILD ARG CLONEGITSDIR
        ONBUILD ARG DOWNLOADS
        ONBUILD ARG DOWNLOADSDIR
        ONBUILD ARG BUILDDEPS
        ONBUILD ARG BUILDDEPS_UNTRUSTED
        ONBUILD ARG DESTDIR
        ONBUILD ARG CHARSET
        ONBUILD ARG CC
        ONBUILD ARG MPICC
        ONBUILD ARG MPICXX
        ONBUILD ARG JAVA_HOME
        ONBUILD ARG JRE_HOME
        ONBUILD ARG ADDTO_CFLAGS
        ONBUILD ARG CFLAGS
        ONBUILD ARG ADDTO_PATH
        ONBUILD ARG PATH
        ONBUILD ARG ADDTO_CPATH
        ONBUILD ARG CPATH
        ONBUILD ARG ADDTO_LIBRARY_PATH
        ONBUILD ARG LIBRARY_PATH
        ONBUILD ARG ADDTO_LD_LIBRARY_PATH
        ONBUILD ARG LD_LIBRARY_PATH
        ONBUILD ARG COMMON_CONFIGUREPREFIX
        ONBUILD ARG COMMON_CONFIGURECMD
        ONBUILD ARG COMMON_CMAKECMD
        ONBUILD ARG COMMON_MAKECMDS
        ONBUILD ARG COMMON_INSTALLSRC
        ONBUILD ARG EXECUTABLES
        ONBUILD ARG STARTUPEXECUTABLES
        ONBUILD ARG EXPOSEFUNCTIONS
        ONBUILD ARG GID0WRITABLES
        ONBUILD ARG GID0WRITABLESRECURSIVE
        ONBUILD ARG LINUXUSEROWNED
        ONBUILD ARG LINUXUSEROWNEDRECURSIVE
        ONBUILD ARG REMOVEDIRS
        ONBUILD ARG REMOVEFILES
        ONBUILD ARG INITCMDS
        ONBUILD ARG BUILDCMDS
        ONBUILD ARG KEEPEMPTYDIRS
        ONBUILD ARG FINALCMDS
    # ---------------------------------------------------------------------
    # ENV
    # ---------------------------------------------------------------------
        ONBUILD ENV HUBPROFILE="${HUBPROFILE}"
        ONBUILD ENV HUBREPO="${HUBREPO}"
        ONBUILD ENV HUBVERSION="${HUBVERSION}"
        ONBUILD ENV IMAGEID="${IMAGEID:-${HUBPROFILE:+$HUBPROFILE-}${HUBREPO:+$HUBREPO-}${HUBVERSION:+$HUBVERSION}}"
        ONBUILD ENV IMAGETYPE="${IMAGETYPE:-application}"
        ONBUILD ENV BUILDDIR="${BUILDDIR:-/builddir}"
        ONBUILD ENV CONTENTIMAGE1="$CONTENTIMAGE1"
        ONBUILD ENV CONTENTSOURCE1="${CONTENTSOURCE1:-/}"
        ONBUILD ENV CONTENTDESTINATION1="${CONTENTDESTINATION1:-$BUILDDIR}"
        ONBUILD ENV CONTENTIMAGE2="$CONTENTIMAGE2"
        ONBUILD ENV CONTENTSOURCE2="${CONTENTSOURCE2:-/}"
        ONBUILD ENV CONTENTDESTINATION2="${CONTENTDESTINATION2:-$BUILDDIR}"
        ONBUILD ENV CONTENTIMAGE3="$CONTENTIMAGE3"
        ONBUILD ENV CONTENTSOURCE3="${CONTENTSOURCE3:-/}"
        ONBUILD ENV CONTENTDESTINATION3="${CONTENTDESTINATION3:-$BUILDDIR}"
        ONBUILD ENV CONTENTIMAGE4="$CONTENTIMAGE4"
        ONBUILD ENV CONTENTSOURCE4="${CONTENTSOURCE4:-/}"
        ONBUILD ENV CONTENTDESTINATION4="${CONTENTDESTINATION4:-$BUILDDIR}"
        ONBUILD ENV CONTENTIMAGE5="$CONTENTIMAGE5"
        ONBUILD ENV CONTENTSOURCE5="${CONTENTSOURCE5:-/}"
        ONBUILD ENV CONTENTDESTINATION5="${CONTENTDESTINATION5:-$BUILDDIR}"
        ONBUILD ENV ADDREPOS="${ADDREPOS}"
        ONBUILD ENV RUNDEPS="${RUNDEPS}"
        ONBUILD ENV RUNDEPS_UNTRUSTED="${RUNDEPS_UNTRUSTED}"
        ONBUILD ENV EXCLUDEAPKS="${EXCLUDEAPKS}"
        ONBUILD ENV EXCLUDEDEPS="${EXCLUDEDEPS}"
        ONBUILD ENV MAKEDIRS="${MAKEDIRS}"
        ONBUILD ENV MAKEFILES="${MAKEFILES}"
        ONBUILD ENV CLONEGITS="${CLONEGITS}"
        ONBUILD ENV CLONEGITSDIR="${CLONEGITSDIR:-$BUILDDIR}"
        ONBUILD ENV DOWNLOADS="${DOWNLOADS}"
        ONBUILD ENV DOWNLOADSDIR="${DOWNLOADSDIR:-$BUILDDIR}"
        ONBUILD ENV BUILDDEPS="${BUILDDEPS}"
        ONBUILD ENV BUILDDEPS_UNTRUSTED="${BUILDDEPS_UNTRUSTED}"
        ONBUILD ENV DESTDIR="${DESTDIR}"
        ONBUILD ENV CHARSET="${CHARSET:-UTF-8}"
        ONBUILD ENV MPICC="${MPICC:-/usr/bin/mpicc}"
        ONBUILD ENV MPICXX="${MPICXX:-/usr/bin/mpicxx}"
        ONBUILD ENV CC="${CC}"
        ONBUILD ENV JAVA_HOME="${JAVA_HOME}"
        ONBUILD ENV JRE_HOME="${JRE_HOME}"
        ONBUILD ENV ADDTO_CFLAGS="${ADDTO_CFLAGS}"
        ONBUILD ENV CFLAGS="${CFLAGS:--O2 -fomit-frame-pointer -fno-reorder-blocks -fno-reorder-functions ${ADDTO_CFLAGS}}"
        ONBUILD ENV ADDTO_PATH="${ADDTO_PATH}"
        ONBUILD ENV PATH="${ADDTO_PATH}${ADDTO_PATH:+:}${PATH:-/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin::}"
        ONBUILD ENV ADDTO_CPATH="${ADDTO_CPATH}"
        ONBUILD ENV CPATH="${ADDTO_CPATH}${ADDTO_CPATH:+:}$CPATH"
        ONBUILD ENV ADDTO_LIBRARY_PATH="${ADDTO_LIBRARY_PATH}"
        ONBUILD ENV LIBRARY_PATH="${ADDTO_LIBRARY_PATH}${ADDTO_LIBRARY_PATH:+:}$LIBRARY_PATH"
        ONBUILD ENV ADDTO_LD_LIBRARY_PATH="${ADDTO_LD_LIBRARY_PATH}"
        ONBUILD ENV LD_LIBRARY_PATH="${ADDTO_LD_LIBRARY_PATH}${ADDTO_LD_LIBRARY_PATH:+:}${LD_LIBRARY_PATH:-${LIBRARY_PATH}}"
        ONBUILD ENV COMMON_CONFIGUREPREFIX="${COMMON_CONFIGUREPREFIX:-/usr}"
        ONBUILD ENV COMMON_CONFIGURECMD="${COMMON_CONFIGURECMD:-./configure --prefix=${COMMON_CONFIGUREPREFIX}}"
        ONBUILD ENV COMMON_CMAKECMD="${COMMON_CMAKECMD:-cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=/usr/lib -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_C_FLAGS=\"${CFLAGS}\"}"
        ONBUILD ENV COMMON_MAKECMDS="${COMMON_MAKECMDS:-make -s && make -s install}"
        ONBUILD ENV COMMON_INSTALLSRC="${COMMON_INSTALLSRC:-$COMMON_CONFIGURECMD && $COMMON_MAKECMDS}"
        ONBUILD ENV EXECUTABLES="${EXECUTABLES}"
        ONBUILD ENV STARTUPEXECUTABLES="${STARTUPEXECUTABLES}"
        ONBUILD ENV EXPOSEFUNCTIONS="${EXPOSEFUNCTIONS}"
        ONBUILD ENV GID0WRITABLES="${GID0WRITABLES}"
        ONBUILD ENV GID0WRITABLESRECURSIVE="${GID0WRITABLESRECURSIVE}"
        ONBUILD ENV LINUXUSEROWNED="${LINUXUSEROWNED}"
        ONBUILD ENV LINUXUSEROWNEDRECURSIVE="${LINUXUSEROWNEDRECURSIVE}"
        ONBUILD ENV REMOVEDIRS="${REMOVEDIRS}"
        ONBUILD ENV REMOVEFILES="${REMOVEFILES}"
        ONBUILD ENV INITCMDS="${INITCMDS}"
        ONBUILD ENV BUILDCMDS="${BUILDCMDS}"
        ONBUILD ENV KEEPEMPTYDIRS="${KEEPEMPTYDIRS:-no}"
        ONBUILD ENV FINALCMDS="${FINALCMDS}"
    # ---------------------------------------------------------------------
    # COPY
    # ---------------------------------------------------------------------
        ONBUILD COPY --from=init / /finalfs/
        ONBUILD COPY --from=init /environment /environment/
        ONBUILD COPY --from=content1 "$CONTENTSOURCE1" "$CONTENTDESTINATION1"
        ONBUILD COPY --from=content2 "$CONTENTSOURCE2" "$CONTENTDESTINATION2"
        ONBUILD COPY --from=content3 "$CONTENTSOURCE3" "$CONTENTDESTINATION3"
        ONBUILD COPY --from=content4 "$CONTENTSOURCE4" "$CONTENTDESTINATION4"
        ONBUILD COPY --from=content5 "$CONTENTSOURCE5" "$CONTENTDESTINATION5"
        ONBUILD COPY ./ /tmp/
    # ---------------------------------------------------------------------
    # RUN
    # ---------------------------------------------------------------------
        ONBUILD RUN /usr/sbin/onbuildrun.sh || ( echo "BUILD FAILED!" && touch "/fail" )
        ONBUILD RUN cat /build.log \
                 && [ ! -e "/fail" ]
    # ---------------------------------------------------------------------
# =========================================================================
