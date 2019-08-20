# =========================================================================
# FROM
# =========================================================================
    FROM huggla/alpine as image
# =========================================================================
# COPY
# =========================================================================
    COPY ./rootfs /
# =========================================================================
# RUN
# =========================================================================
    RUN exec 2>&1 \
     && set -x \
     && chmod u+x /usr/sbin/relpath \
     && mkdir /excludefs /finalfs \
     && apk --no-cache --initramfs-diskless-boot --clean-protected add acl bash build-base libtool automake autoconf
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
        ONBUILD ARG FINALCMDS
    # ---------------------------------------------------------------------
    # ENV
    # ---------------------------------------------------------------------
        ONBUILD ENV HUBPROFILE="${HUBPROFILE}"
	ONBUILD ENV HUBREPO="${HUBREPO}"
	ONBUILD ENV HUBVERSION="${HUBVERSION}"
        ONBUILD ENV IMAGEID="${IMAGEID:-${HUBPROFILE:+$HUBPROFILE-}${HUBREPO:+$HUBREPO-}${HUBVERSION:+$HUBVERSION-}}"
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
        ONBUILD ENV ADDTO_CFLAGS="${ADDTO_CFLAGS}"
        ONBUILD ENV CFLAGS="${CFLAGS:--O2 -fomit-frame-pointer -march=native -fno-reorder-blocks -fno-reorder-functions ${ADDTO_CFLAGS}}"
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
        ONBUILD COPY ./ /tmp/
    # ---------------------------------------------------------------------
    # RUN
    # ---------------------------------------------------------------------
        ONBUILD RUN ( \
                    exec > /build.log 2>&1 \
                 && set -x \
                 && if [ -n "$ADDREPOS" ]; \
                    then \
                       for repo in $ADDREPOS; \
                       do \
                          echo $repo >> /etc/apk/repositories; \
                       done; \
                    fi \
                 && cd /finalfs \
                 && rm -rf environment \
                 && getfacl -R . > /tmp/init-permissions.txt \
                 && tar -xp -f /environment/onbuild.tar.gz -C /tmp \
                 && if [ -n "$RUNDEPS" ]; \
                    then \
                       if [ -n "$EXCLUDEDEPS" ] || [ -n "$EXCLUDEAPKS" ]; \
                       then \
                          cd /excludefs && \
                          apk --repositories-file /etc/apk/repositories --keys-dir /etc/apk/keys --no-cache --initramfs-diskless-boot --clean-protected --root /excludefs add --quiet --initdb $EXCLUDEDEPS $EXCLUDEAPKS && \
                          excludeFilesDeps="$(apk --no-cache --quiet --root /excludefs info --depends $EXCLUDEDEPS | xargs apk --no-cache --quiet --root /excludefs info --contents)" && \
                          excludeFilesApks="$(apk --no-cache --quiet --root /excludefs info --contents $EXCLUDEAPKS)" && \
                          excludeFiles="$(echo ${excludeFilesDeps}${excludeFilesApks} | grep -v '^$' | sort -u -)" && \
                          for file in $excludeFiles; \
                          do \
                             if find "$file" -maxdepth 0 ! -path 'var/cache/*' ! -path 'tmp/*' | grep -q -e .; \
                             then \
                                if [ -L "$file" ]; \
                                then \
                                   (echo -n "/$file>" && readlink "$file") >> /tmp/onbuild/exclude.filelist; \
                                elif [ -f "$file" ]; \
                                then \
                                   md5sum "$file" | awk '{first=$1; $1=""; print $0">"first}' | sed 's|^ |/|' >> /tmp/onbuild/exclude.filelist || exit 1; \
                                fi; \
                             fi; \
                          done && \
                          rm -rf /excludefs && \
                          sort -u -o /tmp/onbuild/exclude.filelist /tmp/onbuild/exclude.filelist; \
                       fi && \
                       cd / && \
                       if [ -n "$RUNDEPS" ] || [ -n "$RUNDEPS_UNTRUSTED" ]; \
                       then \
                          apk --repositories-file /etc/apk/repositories --keys-dir /etc/apk/keys --no-cache --initramfs-diskless-boot --clean-protected --root /finalfs add --quiet --initdb && \
                          set +x && \
                          echo '++++++++++++++++++++++++++++++++++' && \
                          echo '+++++++++ RUNDEPS <begin> ++++++++' && \
                          echo '++++++++++++++++++++++++++++++++++' && \
                          set -x && \
                          if [ -n "$RUNDEPS" ]; \
                          then \
                             apk --repositories-file /etc/apk/repositories --keys-dir /etc/apk/keys --no-cache --initramfs-diskless-boot --clean-protected --root /finalfs add $RUNDEPS; \
                          fi && \
                          if [ -n "$RUNDEPS_UNTRUSTED" ]; \
                          then \
                             apk --repositories-file /etc/apk/repositories --keys-dir /etc/apk/keys --no-cache --initramfs-diskless-boot --clean-protected --root /finalfs --allow-untrusted add $RUNDEPS_UNTRUSTED; \
                          fi && \
                          set +x && \
                          echo '----------------------------------' && \
                          echo '---------- RUNDEPS </end> --------' && \
                          echo '----------------------------------' && \
                          set -x; \
                       fi; \
                    fi \
                 && cd /finalfs \
                 && for dir in $MAKEDIRS; \
                    do \
                       dir="$(eval "echo $dir")" && \
                       mkdir -p "${dir#/}"; \
                    done \
                 && for file in $MAKEFILES; \
                    do \
                       file="$(eval "echo $file")" && \
                       file="${file#/}" && \
                       mkdir -p "$(dirname "$file")" && \
                       touch "$file"; \
                    done \
                 && find /tmp -path "/tmp/buildfs/*" -mindepth 2 -maxdepth 2 -exec cp -a "{}" / \; \
                 && find /tmp -path "/tmp/rootfs/*"  -mindepth 2 -maxdepth 2 -exec cp -a "{}" ./ \; \
                 && chmod -R o= ./ \
                 && n="0" \
                 && for contentimage in $CONTENTIMAGE1 $CONTENTIMAGE2 $CONTENTIMAGE3 $CONTENTIMAGE4; \
                    do \
                       n="$(expr $n + 1)" && \
                       if [ "${contentimage#huggla}" == "$contentimage" ] && [ "$contentimage" != "scratch" ]; \
                       then \
                          eval "find \"\$CONTENTDESTINATION$n\" -maxdepth 0 -exec chmod -R g-w,o= \"{}\" \\\\\;" && \
                          eval "find \"\$CONTENTDESTINATION$n\" -type f -perm +010 -exec chmod g-x \"{}\" \\\\\;"; \
                       fi; \
                    done \
                 && find ./usr/local/bin -type f -exec chmod u=rx,go= "{}" \; \
                 && find / -path "/usr/local/bin/*" -type f -mindepth 3 -maxdepth 3 -exec chmod u=rx,go= "{}" \; \
                 && if [ -n "$INITCMDS" ]; \
                    then \
                       cd / && \
                       set +x && \
                       echo '++++++++++++++++++++++++++++++++++' && \
                       echo '+++++++++ INITCMDS <begin> +++++++' && \
                       echo '++++++++++++++++++++++++++++++++++' && \
                       eval "set -x && $INITCMDS" && \
                       echo '----------------------------------' && \
                       echo '--------- INITCMDS </end> --------' && \
                       echo '----------------------------------' && \
                       set -x; \
                    fi \
                 && if [ -n "$BUILDCMDS" ]; \
                    then \
                       cd /finalfs && \
                       find * -type d -exec mkdir -p "/{}" \; && \
                       find * -type f -o -type l -exec cp -a "{}" "/{}" \; ; \
                    fi \
                 && mkdir -p /root/.config "$BUILDDIR" "$CLONEGITSDIR" "$DOWNLOADSDIR" "/finalfs$DESTDIR" \
                 && if [ -n "$CLONEGITS" ]; \
                    then \
                       apk --no-cache --initramfs-diskless-boot --clean-protected add --quiet git && \
                       cd "$CLONEGITSDIR" && \
                       CLONEGITS="$(echo "$CLONEGITS" | sed "s/ '/,'/g" | sed "s/' /',/g")" && \
                       IFS="$(echo -en ",")" && \
                       set +x && \
                       echo '++++++++++++++++++++++++++++++++++' && \
                       echo '++++++++ CLONEGITS <begin> +++++++' && \
                       echo '++++++++++++++++++++++++++++++++++' && \
                       set -x && \
                       for git in $CLONEGITS; \
                       do \
                          eval "git clone $(eval "echo $git")"; \
                       done && \
                       set +x && \
                       echo '----------------------------------' && \
                       echo '-------- CLONEGITS </end> --------' && \
                       echo '----------------------------------' && \
                       set -x && \
                       unset IFS; \
                    fi \
                 && if [ -n "$DOWNLOADS" ]; \
                    then \
                       cd "$DOWNLOADSDIR" && \
                       set +x && \
                       echo '++++++++++++++++++++++++++++++++++' && \
                       echo '++++++++ DOWNLOADS <begin> +++++++' && \
                       echo '++++++++++++++++++++++++++++++++++' && \
                       set -x && \
                       for download in $DOWNLOADS; \
                       do \
                          wget "$download"; \
                       done && \
                       set +x && \
                       echo '----------------------------------' && \
                       echo '-------- DOWNLOADS </end> --------' && \
                       echo '----------------------------------' && \
                       set -x && \
                       if [ "$DOWNLOADSDIR" == "$BUILDDIR" ]; \
                       then \
                          find * -type f \( -name "*.tar" -o -name "*.tar.*" \) -maxdepth 0 -exec tar -xp -f "{}" \; && \
                          find * -type f -name "*.zip" -maxdepth 0 -exec unzip -o -d ./ "{}" \; ; \
                       fi; \
                    fi \
                 && if [ -n "$BUILDCMDS" ]; \
                    then \
                       if [ -n "${BUILDDEPS}" ] || [ -n "${BUILDDEPS_UNTRUSTED}" ]; \
                       then \
                          set +x && \
                          echo '++++++++++++++++++++++++++++++++++' && \
                          echo '++++++++ BUILDDEPS <begin> +++++++' && \
                          echo '++++++++++++++++++++++++++++++++++' && \
                          set -x && \
                          if [ -n "${BUILDDEPS}" ]; \
                          then \
                             apk --no-cache --purge --force-overwrite --force-refresh --clean-protected --initramfs-diskless-boot add $BUILDDEPS; \
                          fi && \
                          if [ -n "${BUILDDEPS_UNTRUSTED}" ]; \
                          then \
                             apk --no-cache --purge --force-overwrite --force-refresh --clean-protected --initramfs-diskless-boot allow-untrusted add $BUILDDEPS_UNTRUSTED; \
                          fi && \
                          set +x && \
                          echo '----------------------------------' && \
                          echo '-------- BUILDDEPS </end> --------' && \
                          echo '----------------------------------' && \
                          set -x; \
                       fi && \
                       tmpDESTDIR="$DESTDIR" && \
                       DESTDIR="/finalfs$DESTDIR" && \
                       buildstr="$(eval "echo \"$(eval 'echo $BUILDCMDS')\"")" && \
                       cd "$BUILDDIR" && \
                       set +x && \
                       echo '++++++++++++++++++++++++++++++++++' && \
                       echo '++++++++ BUILDCMDS <begin> +++++++' && \
                       echo '++++++++++++++++++++++++++++++++++' && \
                       set -x && \
                       eval "$buildstr" && \
                       set +x && \
                       echo '----------------------------------' && \
                       echo '-------- BUILDCMDS </end> --------' && \
                       echo '----------------------------------' && \
                       set -x && \
                       DESTDIR="$tmpDESTDIR"; \
                    fi \
                 && cd / \
                 && if [ -n "$FINALCMDS" ]; \
                    then \
                       set +x && \
                       echo '++++++++++++++++++++++++++++++++++' && \
                       echo '++++++++ FINALCMDS <begin> +++++++' && \
                       echo '++++++++++++++++++++++++++++++++++' && \
                       chroot /finalfs sh -c "set -x && $FINALCMDS" && \
                       echo '----------------------------------' && \
                       echo '-------- FINALCMDS </end> --------' && \
                       echo '----------------------------------' && \
                       set -x; \
                    fi \
                 && cd /finalfs \
                 && if [ -n "$EXECUTABLES" ] || [ -n "$STARTUPEXECUTABLES" ]; \
                    then \
                       if [ -n "$EXECUTABLES" ] && [ -n "$STARTUPEXECUTABLES" ]; \
                       then \
                          EXECUTABLES="$EXECUTABLES $STARTUPEXECUTABLES"; \
                       elif [ -z "$EXECUTABLES" ]; \
                       then \
                          EXECUTABLES="$STARTUPEXECUTABLES"; \
                       fi && \
                       for exe in $EXECUTABLES; \
                       do \
                          exe="${exe#/}" && \
                          exeDir="$(dirname "$exe")" && \
                          exeName="$(basename "$exe")" && \
                          if [ "$exeDir" != "usr/local/bin" ]; \
                          then \
                             cp -a "$exe" "usr/local/bin/" && \
                             ln -sf "usr/local/bin/$exeName" "$exe"; \
                          fi && \
                          if [ "$exeName" == "sudo" ]; \
                          then \
                             chmod ug=rx,o= "usr/local/bin/$exeName"; \
                          else \
                             chmod u=rx,go= "usr/local/bin/$exeName"; \
                          fi; \
                       done; \
                    fi \
                 && if [ -n "$EXPOSEFUNCTIONS" ]; \
                    then \
                       mkdir -p usr/local/bin/functions && \
                       ln -s start/includeFunctions usr/local/bin/ && \
                       for func in $EXPOSEFUNCTIONS; \
                       do \
                          ln -s start/functions/$func usr/local/bin/functions/; \
                       done; \
                    fi \
                 && set -f \
                 && for exe in $STARTUPEXECUTABLES; \
                    do \
                       set +f && \
                       echo "$exe" >> /environment/startupexecutables; \
                    done \
                 && sort -u -o /environment/startupexecutables /environment/startupexecutables \
                 && set -f \
                 && for file in $GID0WRITABLES; \
                    do \
                       set +f && \
                       echo "$file" >> /environment/gid0writables; \
                    done \
                 && sort -u -o /environment/gid0writables /environment/gid0writables \
                 && set -f \
                 && while read file; \
                    do \
                       set +f && \
                       find ".$(dirname "$file")" -name "$(basename "$file")" -maxdepth 1 -exec chmod g+w "{}" \; ; \
                    done </environment/gid0writables \
                 && set -f \
                 && for dir in $GID0WRITABLESRECURSIVE; \
                    do \
                       set +f && \
                       echo "$dir" >> /environment/gid0writablesrecursive; \
                    done \
                 && sort -u -o /environment/gid0writablesrecursive /environment/gid0writablesrecursive \
                 && set -f \
                 && while read dir; \
                    do \
                       set +f && \
                       find ".$(dirname "$dir")" -name "$(basename "$dir")" -maxdepth 1 -exec chmod -R g+w "{}" \; ; \
                    done </environment/gid0writablesrecursive \
                 && set -f \
                 && for file in $LINUXUSEROWNED; \
                    do \
                       set +f && \
                       echo "$file" >> /environment/linuxuserowned; \
                    done \
                 && sort -u -o /environment/linuxuserowned /environment/linuxuserowned \
                 && set -f \
                 && for dir in $LINUXUSEROWNEDRECURSIVE; \
                    do \
                       set +f && \
                       echo "$dir" >> /environment/linuxuserownedrecursive; \
                    done \
                 && sort -u -o /environment/linuxuserownedrecursive /environment/linuxuserownedrecursive \
                 && set +f \
                 && find * -xdev \( -path "var/cache/*" -o -path "tmp/*" -o -path "sys/*" -o -path "proc/*" -o -path "dev/*" -o -path "lib/apk/*" -o -path "etc/apk/*" \) \( -type f -o -type l \) -perm +0200 -delete \
                 && find * -depth -xdev \( -path "var/cache/*" -o -path "tmp/*" -o -path "sys/*" -o -path "proc/*" -o -path "dev/*" -o -path "lib/apk/*" -o -path "etc/apk/*" \) -type d -perm +0200 -exec [ -z "\$(ls -A "{}")" ] \&\& rm -r "{}" \; \
                 && for dir in $REMOVEDIRS; \
                    do \
                       dir="$(eval "echo $dir")" && \
                       dir="${dir#/finalfs}" && \
                       dir="/finalfs$dir" && \
                       if [ -d "$dir" ]; \
                       then \
                          rm -rf "$dir"; \
                       fi; \
                    done \
                 && for file in $REMOVEFILES; \
                    do \
                       file="$(eval "echo $file")" && \
                       file="${file#/finalfs}" && \
                       file="/finalfs$dir" && \
                       if [ -f "$file" ] || [ -l "$file" ]; \
                       then \
                          rm -f "$file"; \
                       fi; \
                    done \
                 && find * -type d -maxdepth 0 | sort - > /tmp/topDirs \
                 && find * -type d -maxdepth 0 | awk '{system("find \""$1"\" -type f -exec find \""$1"\" -maxdepth 0 \\;")}' | sort -u - > /tmp/usedTopDirs \
                 && comm -23 /tmp/topDirs /tmp/usedTopDirs | xargs rm -rf \
                 && if [ "$DESTDIR" == "/app" ] && [ -n "$(ls -A "${DESTDIR#/}")" ]; \
                    then \
                       if [ -n "$RUNDEPS" ]; \
                       then \
                          echo "$RUNDEPS" >> "${DESTDIR#/}/RUNDEPS.txt"; \
                       fi && \
                       (find * -type l -exec echo -n "/{}>" \; -exec readlink "{}" \; && find * -type f -exec md5sum "{}" \; | awk '{first=$1; $1=""; print $0">"first}' | sed 's|^ |/|') | sort -u - > /tmp/onbuild/exclude.filelist.new && \
                       comm -12 /tmp/onbuild/exclude.filelist /tmp/onbuild/exclude.filelist.new | awk -F '>' '{system("rm -f \"."$1"\"")}' && \
                       if [ ! -e "start" ] && [ ! -e "stop" ]; \
                       then \
			  for dir in /finalfs$DESTDIR*; \
			  do \
			     cp -a $dir/* /finalfs/ && \
			     cd "$dir" && \
			     subdir="${dir#/finalfs$DESTDIR}" && \
			     contentfile="$dir/${subdir:+$subdir.}${IMAGEID}content" && \
			     find * > "$contentfile" && \
			     gzip "$contentfile"; \
			  done && \
			  cd /finalfs; \
                       fi; \
                    fi \
                 && rm -f RUNDEPS.txt \
                 && (find * -type l -exec echo -n "/{}>" \; -exec readlink "{}" \; && find * -type f -exec md5sum "{}" \; | awk '{first=$1; $1=""; print $0">"first}' | sed 's|^ |/|') | sort -u - > /tmp/onbuild/exclude.filelist.new \
                 && comm -12 /tmp/onbuild/exclude.filelist /tmp/onbuild/exclude.filelist.new | awk -F '>' '{system("rm -f \"."$1"\"")}' \
                 && sort -u -o /tmp/onbuild/exclude.filelist /tmp/onbuild/exclude.filelist /tmp/onbuild/exclude.filelist.new \
                 && rm -f /tmp/onbuild/exclude.filelist.* \
                 && tar -c -z -f /environment/onbuild.tar.gz -C /tmp onbuild \
                 && mv /environment ./ \
                 && ( \
		       chmod 755 ./ ./lib ./usr ./usr/lib ./usr/local ./usr/local/bin; \
                       chmod 700 ./bin ./sbin ./usr/bin ./usr/sbin; \
                       chmod 750 ./etc ./var ./run ./var/cache ./start ./stop; \
                       setfacl --restore=/tmp/init-permissions.txt; \
		       true; \
		    ) \
                 ) || ( echo "BUILD FAILED!" && touch "/fail"; )
	    ONBUILD RUN cat /build.log \
	             && [ ! -e "/fail" ]
    # ---------------------------------------------------------------------
# =========================================================================
