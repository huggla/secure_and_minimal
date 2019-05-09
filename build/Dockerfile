FROM huggla/alpine as image

COPY ./rootfs /

RUN chmod u+x /usr/sbin/relpath

ONBUILD ARG CONTENTSOURCE1
ONBUILD ARG CONTENTSOURCE1="${CONTENTSOURCE1:-/}"
ONBUILD ARG CONTENTDESTINATION1
ONBUILD ARG CONTENTDESTINATION1="${CONTENTDESTINATION1:-/buildfs/}"
ONBUILD ARG CONTENTSOURCE2
ONBUILD ARG CONTENTSOURCE2="${CONTENTSOURCE2:-/}"
ONBUILD ARG CONTENTDESTINATION2
ONBUILD ARG CONTENTDESTINATION2="${CONTENTDESTINATION2:-/buildfs/}"
ONBUILD ARG CONTENTSOURCE3
ONBUILD ARG CONTENTSOURCE3="${CONTENTSOURCE3:-/}"
ONBUILD ARG CONTENTDESTINATION3
ONBUILD ARG CONTENTDESTINATION3="${CONTENTDESTINATION3:-/buildfs/}"
ONBUILD ARG DESTDIR
ONBUILD ARG DESTDIR="${DESTDIR:-/imagefs/app}"
ONBUILD ARG CLONEGITS
ONBUILD ARG CLONEGITSDIR
ONBUILD ARG CLONEGITSDIR="${CLONEGITSDIR:+/buildfs$CLONEGITSDIR}"
ONBUILD ARG DOWNLOADS
ONBUILD ARG DOWNLOADSDIR
ONBUILD ARG DOWNLOADSDIR="${DOWNLOADSDIR:+/buildfs$DOWNLOADSDIR}"
ONBUILD ARG ADDREPOS
ONBUILD ARG EXCLUDEAPKS
ONBUILD ARG EXCLUDEDEPS
ONBUILD ARG BUILDDEPS
ONBUILD ARG BUILDDEPS_UNTRUSTED
ONBUILD ARG RUNDEPS
ONBUILD ARG RUNDEPS_UNTRUSTED
ONBUILD ARG INITCMDS
ONBUILD ARG MAKEDIRS
ONBUILD ARG MAKEFILES
ONBUILD ARG GID0WRITABLESRECURSIVE
ONBUILD ARG GID0WRITABLES
ONBUILD ARG LINUXUSEROWNEDRECURSIVE
ONBUILD ARG REMOVEDIRS
ONBUILD ARG REMOVEFILES
ONBUILD ARG EXECUTABLES
ONBUILD ARG STARTUPEXECUTABLES
ONBUILD ARG EXPOSEFUNCTIONS
ONBUILD ARG BUILDCMDS
ONBUILD ARG CPATH="$CPATH:/buildfs/usr/include:/buildfs/usr/local/include"
ONBUILD ARG LIBRARY_PATH="$LIBRARY_PATH:/buildfs/lib:/buildfs/usr/lib:/buildfs/usr/local/lib"
ONBUILD ARG LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/buildfs/lib:/buildfs/usr/lib:/buildfs/usr/local/lib"
ONBUILD ARG PATH="$PATH:/buildfs/bin:/buildfs/usr/bin:/buildfs/usr/local/bin"

ONBUILD RUN mkdir -p /imagefs /buildfs/tmp /buildfs/run /buildfs/var /buildfs/usr/local/bin \
         && chmod 770 /buildfs/tmp \
         && cd /buildfs/var \
         && ln -s ../tmp tmp \
         && ln -s ../run run \
         && cp -a /buildfs/tmp /buildfs/run /buildfs/var /imagefs/

ONBUILD COPY --from=init / /buildfs/
ONBUILD COPY --from=content1 "$CONTENTSOURCE1" "$CONTENTDESTINATION1"
ONBUILD COPY --from=content2 "$CONTENTSOURCE2" "$CONTENTDESTINATION2"
ONBUILD COPY --from=content3 "$CONTENTSOURCE3" "$CONTENTDESTINATION3"
ONBUILD COPY ./ /tmp/

ONBUILD RUN if [ "${DESTDIR::1}" == "/" ] && [ "${DESTDIR::8}" != "/buildfs" ] && [ "${DESTDIR::8}" != "/imagefs" ]; \
            then \
               DESTDIR="/imagefs$DESTDIR"; \
            fi \
         && mv /buildfs/environment /environment \
         && tar -x -f /environment/onbuild.tar.gz -C /tmp \
         && if [ -n "$ADDREPOS" ]; \
            then \
               for repo in $ADDREPOS; \
               do \
                  echo $repo >> /etc/apk/repositories; \
               done; \
            fi \
         && apk update \
         && apk upgrade \
         && if [ -n "$RUNDEPS" ]; \
            then \
               if [ -n "$EXCLUDEDEPS" ] || [ -n "$EXCLUDEAPKS" ]; \
               then \
                  mkdir /excludefs; \
                  cd /excludefs; \
                  apk --root /excludefs add --initdb; \
                  ln -s /var/cache/apk/* /excludefs/var/cache/apk/; \
                  if [ -n "$EXCLUDEDEPS" ]; \
                  then \
                     apk --repositories-file /etc/apk/repositories --keys-dir /etc/apk/keys --root /excludefs add $EXCLUDEDEPS; \
                     excludeFiles="$(apk --root /excludefs info -R $EXCLUDEDEPS | grep -v 'depends on:$' | grep -v '^$' | sort -u - | xargs apk --root /excludefs info -L | grep -v 'contains:$' | grep -v '^$')"; \
                     for file in $excludeFiles; \
                     do \
                        if find "$file" -maxdepth 0 ! -path 'var/cache/*' ! -path 'tmp/*' | grep -q -e .; \
                        then \
                           if [ -L "$file" ]; \
                           then \
                              (echo -n "/$file>" && readlink "$file") >> /tmp/onbuild/exclude.filelist; \
                           elif [ -f "$file" ]; \
                           then \
                              md5sum "$file" | awk '{first=$1; $1=""; print $0">"first}' | sed 's|^ |/|' >> /tmp/onbuild/exclude.filelist; \
                           fi; \
                        fi; \
                     done; \
                     unset excludeFiles; \
                  fi; \
                  if [ -n "$EXCLUDEAPKS" ]; \
                  then \
                     apk --repositories-file /etc/apk/repositories --keys-dir /etc/apk/keys --root /excludefs add $EXCLUDEAPKS; \
                     excludeFiles="$(apk --root /excludefs info -L $EXCLUDEAPKS | grep -v 'contains:$' | grep -v '^$')"; \
                     for file in $excludeFiles; \
                     do \
                        if find "$file" -maxdepth 0 ! -path 'var/cache/*' ! -path 'tmp/*' | grep -q -e .; \
                        then \
                           if [ -L "$file" ]; \
                           then \
                              (echo -n "/$file>" && readlink "$file") >> /tmp/onbuild/exclude.filelist; \
                           elif [ -f "$file" ]; \
                           then \
                              md5sum "$file" | awk '{first=$1; $1=""; print $0">"first}' | sed 's|^ |/|' >> /tmp/onbuild/exclude.filelist; \
                           fi; \
                        fi; \
                     done; \
                     unset excludeFiles; \
                  fi; \
                  cd /; \
                  rm -rf /excludefs; \
                  sort -u -o /tmp/onbuild/exclude.filelist /tmp/onbuild/exclude.filelist; \
               fi; \
               apk --root /buildfs add --initdb; \
               ln -s /var/cache/apk/* /buildfs/var/cache/apk/; \
               apk --repositories-file /etc/apk/repositories --keys-dir /etc/apk/keys --root /buildfs --virtual .rundeps add $RUNDEPS; \
               apk --repositories-file /etc/apk/repositories --keys-dir /etc/apk/keys --root /buildfs --allow-untrusted --virtual .rundeps_untrusted add $RUNDEPS_UNTRUSTED; \
            fi \
         && if [ -n "$CLONEGITSDIR" ]; \
            then \
               if [ -n "$MAKEDIRS" ]; \
               then \
                  MAKEDIRS="$MAKEDIRS "; \
               fi; \
               MAKEDIRS="$MAKEDIRS$CLONEGITSDIR"; \
            fi \
         && if [ -n "$DOWNLOADSDIR" ]; \
            then \
               if [ -n "$MAKEDIRS" ]; \
               then \
                  MAKEDIRS="$MAKEDIRS "; \
               fi; \
               MAKEDIRS=$MAKEDIRS$DOWNLOADSDIR; \
            fi \
         && for dir in $MAKEDIRS; \
            do \
               dir="$(eval "echo $dir")"; \
               mkdir -p "${dir#/buildfs}" "/buildfs${dir#/buildfs}"; \
            done \
         && for file in $MAKEFILES; \
            do \
               file="$(eval "echo $file")"; \
               mkdir -p "$(dirname ${file#/buildfs})" "/buildfs$(dirname ${file#/buildfs})"; \
               touch "${file#/buildfs}" "/buildfs${file#/buildfs}"; \
            done \
         && cp -a /tmp/rootfs/* /buildfs/ || true \
         && chmod -R o= /imagefs /buildfs \
         && chmod -R g-w,o= "$CONTENTDESTINATION1" "$CONTENTDESTINATION2" \
         && find "$CONTENTDESTINATION1" -type f -perm +010 -exec chmod g-x "{}" + \
         && find "$CONTENTDESTINATION2" -type f -perm +010 -exec chmod g-x "{}" + \
         && chmod u=rx,go= /buildfs/usr/local/bin/* || true \
         && cd /buildfs \
         && if [ -n "$INITCMDS" ]; \
            then \
               eval "$INITCMDS || exit 1"; \
            fi \
         && find * -type d ! -path 'tmp' ! -path 'var' ! -path 'run' ! -path 'var/tmp' ! -path 'var/run' -exec mkdir -p -m 750 "/imagefs/{}" + \
         && (find * ! -type d ! -type c -type l ! -path 'var/cache/*' ! -path 'tmp/*' -prune -exec echo -n "/{}>" \; -exec readlink "{}" \; && find * ! -type d ! -type c ! -type l ! -path 'var/cache/*' ! -path 'tmp/*' -prune -exec md5sum "{}" \; | awk '{first=$1; $1=""; print $0">"first}' | sed 's|^ |/|') | sort -u - > /tmp/onbuild/exclude.filelist.new \
         && comm -13 /tmp/onbuild/exclude.filelist /tmp/onbuild/exclude.filelist.new | awk -F '>' '{system("cp -a \"."$1"\" \"/imagefs/"$1"\"")}' \
         && rm -f /tmp/onbuild/exclude.filelist.new \
         && apk add --initdb \
         && cp -a /tmp/buildfs/* /buildfs/ || true \
         && apk --virtual .builddeps add $BUILDDEPS \
         && apk --allow-untrusted --virtual .builddeps_untrusted add $BUILDDEPS_UNTRUSTED \
         && buildDir="$(mktemp -d -p /buildfs/tmp)" \
         && if [ -n "$CLONEGITS" ]; \
            then \
               apk add git; \
               if [ -z "$CLONEGITSDIR" ]; \
               then \
                  CLONEGITSDIR=$buildDir; \
               fi; \
               cd $CLONEGITSDIR; \
               for git in "$CLONEGITS"; \
               do \
                  cloneStr="git clone $(eval "echo $(echo $git)")"; \
                  eval "$cloneStr"; \
               done; \
            fi \
         && if [ -n "$DOWNLOADS" ]; \
            then \
               if [ -z "$DOWNLOADSDIR" ]; \
               then \
                  DOWNLOADSDIR=$buildDir; \
               fi; \
               cd $DOWNLOADSDIR; \
               for download in $DOWNLOADS; \
               do \
                  wget "$download"; \
               done; \
               if [ "$DOWNLOADSDIR" == "$buildDir" ]; \
               then \
                  tarFiles="$(ls *.tar *.tar.*)"; \
                  for tar in $tarFiles; \
                  do \
                     tar -xvp -f "$tar" -C $buildDir; \
                  done; \
                  zipFiles="$(ls *.zip)"; \
                  for zip in $zipFiles; \
                  do \
                     unzip -o "$zip" -d $buildDir; \
                  done; \
               fi; \
            fi \
         && if [ -n "$BUILDCMDS" ]; \
            then \
               cd $buildDir; \
               mkdir -p $DESTDIR; \
               eval "$BUILDCMDS || exit 1"; \
            fi \
         && rm -rf /buildfs \
         && if [ -n "$EXECUTABLES" ] || [ -n "$STARTUPEXECUTABLES" ]; \
            then \
               if [ -n "$EXECUTABLES" ] && [ -n "$STARTUPEXECUTABLES" ]; \
               then \
                  EXECUTABLES="$EXECUTABLES $STARTUPEXECUTABLES"; \
               elif [ -z "$EXECUTABLES" ]; \
               then \
                  EXECUTABLES="$STARTUPEXECUTABLES"; \
               fi; \
               for exe in $EXECUTABLES; \
               do \
                  exe="/imagefs$exe"; \
                  exeDir="$(dirname "$exe")"; \
                  exeName="$(basename "$exe")"; \
                  if [ "$exeDir" != "/imagefs/usr/local/bin" ]; \
                  then \
                     cp -a "$exe" "/imagefs/usr/local/bin/"; \
                     cd "$exeDir"; \
                     ln -sf "$(relpath "$exeDir" "/imagefs/usr/local/bin")/$exeName" "$exeName"; \
                  fi; \
                  if [ "$exeName" == "sudo" ]; \
                  then \
                     chmod ug=rx,o= "/imagefs/usr/local/bin/$exeName"; \
                  else \
                     chmod u=rx,go= "/imagefs/usr/local/bin/$exeName"; \
                  fi \
               done; \
            fi \
         && if [ -n "$EXPOSEFUNCTIONS" ]; \
            then \
               mkdir -p /imagefs/usr/local/bin/functions; \
               cd /imagefs/usr/local/bin; \
               ln -s ../../../start/includeFunctions ./; \
               cd /imagefs/usr/local/bin/functions; \
               for func in $EXPOSEFUNCTIONS; \
               do \
                  ln -s ../../../../start/functions/$func ./; \
               done; \
            fi \
         && rm -rf /imagefs/sys /imagefs/dev /imagefs/proc /imagefs/lib/apk /imagefs/etc/apk \
         && find /imagefs/var/cache ! -type d ! -type c -delete; \
            find /imagefs/tmp ! -type d ! -type c -delete \
         && if [ ! -s "$DESTDIR" ] || [ "${DESTDIR::8}" != "/imagefs" ]; \
            then \
               rm -rf "$DESTDIR"; \
            else \
               if [ -n "$RUNDEPS" ]; \
               then \
                  echo "$RUNDEPS" >> "$DESTDIR/RUNDEPS.txt"; \
               fi \
               topDir="${DESTDIR#/imagefs/}"; \
               topDir="${topDir%%/*}"; \
               if ! ls /imagefs | grep -vq -e "^$topDir"; \
               then \
                  cp -a $DESTDIR*/* /imagefs/; \
               fi \
            fi \
         && set -f \
         && for dir in $REMOVEDIRS; \
            do \
               set +f; \
               find "/imagefs$(dirname "$dir")" -name "$(basename "$dir")" -type d -maxdepth 1 -exec rm -rf "{}" +; \
            done \
         && set -f \
         && for file in $REMOVEFILES; \
            do \
               set +f; \
               find "/imagefs$(dirname "$file")" -name "$(basename "$file")" ! -type d ! -type c -maxdepth 1 -exec rm -f "{}" +; \
            done \
         && set -f \
         && for exe in $STARTUPEXECUTABLES; \
            do \
               set +f; \
               echo "$exe" >> /environment/startupexecutables; \
            done \
         && sort -u -o /environment/startupexecutables /environment/startupexecutables \
         && set -f \
         && for file in $GID0WRITABLES; \
            do \
               set +f; \
               echo "$file" >> /environment/gid0writables; \
            done \
         && sort -u -o /environment/gid0writables /environment/gid0writables \
         && set -f \
         && while read file; \
            do \
               set +f; \
               find "/imagefs$(dirname "$file")" -name "$(basename "$file")" -maxdepth 1 -exec chmod g+w "{}" +; \
            done </environment/gid0writables \
         && set -f \
         && for dir in $GID0WRITABLESRECURSIVE; \
            do \
               set +f; \
               echo "$dir" >> /environment/gid0writablesrecursive; \
            done \
         && sort -u -o /environment/gid0writablesrecursive /environment/gid0writablesrecursive \
         && set -f \
         && while read dir; \
            do \
               set +f; \
               find "/imagefs$(dirname "$dir")" -name "$(basename "$dir")" -maxdepth 1 -exec chmod -R g+w "{}" +; \
            done </environment/gid0writablesrecursive \
         && set -f \
         && for file in $LINUXUSEROWNED; \
            do \
               set +f; \
               echo "$file" >> /environment/linuxuserowned; \
            done \
         && sort -u -o /environment/linuxuserowned /environment/linuxuserowned \
         && set -f \
         && for dir in $LINUXUSEROWNEDRECURSIVE; \
            do \
               set +f; \
               echo "$dir" >> /environment/linuxuserownedrecursive; \
            done \
         && sort -u -o /environment/linuxuserownedrecursive /environment/linuxuserownedrecursive \
         && set +f \
         && chmod 755 /imagefs /imagefs/lib /imagefs/usr /imagefs/usr/lib /imagefs/usr/local /imagefs/usr/local/bin || true \
         && chmod 700 /imagefs/bin /imagefs/sbin /imagefs/usr/bin /imagefs/usr/sbin || true \
         && chmod 750 /imagefs/etc /imagefs/var /imagefs/run /imagefs/var/cache /imagefs/start /imagefs/stop || true \
         && cd /imagefs \
         && (find * ! -type d ! -type c -type l ! -path 'var/cache/*' ! -path 'tmp/*' -prune -exec echo -n "/{}>" \; -exec readlink "{}" \; && find * ! -type d ! -type c ! -type l ! -path 'var/cache/*' ! -path 'tmp/*' -prune -exec md5sum "{}" \; | awk '{first=$1; $1=""; print $0">"first}' | sed 's|^ |/|') | sort -u - > /tmp/onbuild/exclude.filelist.new \
         && comm -12 /tmp/onbuild/exclude.filelist /tmp/onbuild/exclude.filelist.new | awk -F '>' '{system("rm -f \"."$1"\"")}' \
         && sort -u -o /tmp/onbuild/exclude.filelist /tmp/onbuild/exclude.filelist /tmp/onbuild/exclude.filelist.new \
         && rm -f /tmp/onbuild/exclude.filelist.* \
         && tar -c -z -f /environment/onbuild.tar.gz -C /tmp onbuild \
         && mv /environment /imagefs/ \
         && apk --purge del .builddeps .builddeps_untrusted
