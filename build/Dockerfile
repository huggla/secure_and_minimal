FROM huggla/alpine as image

COPY ./rootfs /

RUN chmod u+x /usr/sbin/relpath \
 && apk add acl

ONBUILD ARG CONTENTSOURCE1
ONBUILD ARG CONTENTSOURCE1="${CONTENTSOURCE1:-/}"
ONBUILD ARG CONTENTDESTINATION1
ONBUILD ARG CONTENTDESTINATION1="${CONTENTDESTINATION1:-/initfs/}"
ONBUILD ARG CONTENTSOURCE2
ONBUILD ARG CONTENTSOURCE2="${CONTENTSOURCE2:-/}"
ONBUILD ARG CONTENTDESTINATION2
ONBUILD ARG CONTENTDESTINATION2="${CONTENTDESTINATION2:-/initfs/}"
ONBUILD ARG CONTENTSOURCE3
ONBUILD ARG CONTENTSOURCE3="${CONTENTSOURCE3:-/}"
ONBUILD ARG CONTENTDESTINATION3
ONBUILD ARG CONTENTDESTINATION3="${CONTENTDESTINATION3:-/initfs/}"
ONBUILD ARG DESTDIR
ONBUILD ARG DESTDIR="${DESTDIR:-/finalfs/app}"
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
ONBUILD ARG FINALCMDS
ONBUILD ARG CPATH="$CPATH:/buildfs/usr/include:/buildfs/usr/local/include"
ONBUILD ARG LIBRARY_PATH="$LIBRARY_PATH:/buildfs/lib:/buildfs/usr/lib:/buildfs/usr/local/lib"
ONBUILD ARG LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/buildfs/lib:/buildfs/usr/lib:/buildfs/usr/local/lib"
ONBUILD ARG PATH="$PATH:/buildfs/bin:/buildfs/usr/bin:/buildfs/usr/local/bin"

ONBUILD COPY --from=init / /buildfs/
ONBUILD COPY --from=content1 "$CONTENTSOURCE1" "$CONTENTDESTINATION1"
ONBUILD COPY --from=content2 "$CONTENTSOURCE2" "$CONTENTDESTINATION2"
ONBUILD COPY --from=content3 "$CONTENTSOURCE3" "$CONTENTDESTINATION3"
ONBUILD COPY ./ /tmp/

ONBUILD RUN if [ -n "$ADDREPOS" ]; \
            then \
               for repo in $ADDREPOS; \
               do \
                  echo $repo >> /etc/apk/repositories; \
               done; \
            fi \
         && apk update \
         && apk upgrade \
         && cd /buildfs \
         && getfacl -R . > /tmp/init-permissions.txt \
         && mkdir -p /excludefs /initfs /buildfs /finalfs \
         && if [ "${DESTDIR::1}" == "/" ] && [ "${DESTDIR::8}" != "/buildfs" ] && [ "${DESTDIR::8}" != "/finalfs" ]; \
            then \
               DESTDIR="/finalfs$DESTDIR"; \
            fi \
         && mv /buildfs/environment /environment \
         && tar -x -f /environment/onbuild.tar.gz -C /tmp \
         && if [ -n "$RUNDEPS" ]; \
            then \
               if [ -n "$EXCLUDEDEPS" ] || [ -n "$EXCLUDEAPKS" ]; \
               then \
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
               apk --root /initfs add --initdb; \
               ln -s /var/cache/apk/* /initfs/var/cache/apk/; \
               apk --repositories-file /etc/apk/repositories --keys-dir /etc/apk/keys --root /initfs --virtual .rundeps add $RUNDEPS; \
               apk --repositories-file /etc/apk/repositories --keys-dir /etc/apk/keys --root /initfs --allow-untrusted --virtual .rundeps_untrusted add $RUNDEPS_UNTRUSTED; \
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
               dir="${dir#/}"; \
               dir="${dir#initfs/}"; \
               dir="${dir#buildfs/}"; \
               dir="${dir#finalfs/}"; \
               mkdir -p "/$dir" "/initfs/$dir"; \
            done \
  && echo "$MAKEFILES" \
         && for file in $MAKEFILES; \
            do \
               file="$(eval "echo $file")"; \
               file="${file#/}"; \
               file="${file#initfs/}"; \
               file="${file#buildfs/}"; \
               file="${file#finalfs/}"; \
   echo "$file"; \
               mkdir -p "/$(dirname "$file")" "/initfs/$(dirname "$file")"; \
   ls -la /initfs; \
               touch "/$file" "/initfs/$file"; \
   ls -la /initfs/etc; \
            done \
         && cp -a /tmp/rootfs/* /initfs/ || true \
         && chmod -R o= /initfs /buildfs /finalfs \
         && chmod -R g-w,o= "$CONTENTDESTINATION1" "$CONTENTDESTINATION2" \
         && find "$CONTENTDESTINATION1" -type f -perm +010 -exec chmod g-x "{}" + \
         && find "$CONTENTDESTINATION2" -type f -perm +010 -exec chmod g-x "{}" + \
         && chmod u=rx,go= /initfs/usr/local/bin/* || true \
         && cd /initfs \
         && if [ -n "$INITCMDS" ]; \
            then \
               eval "$INITCMDS || exit 1"; \
            fi \
         && rm -rf /initfs/tmp /initfs/var/cache/* \
         && cd /initfs \
         && find * -type d -exec mkdir -p -m 750 "/buildfs/{}" \; \
         && (find * -type l -exec echo -n "/{}>" \; -exec readlink "{}" \; && find * -type f -exec md5sum "{}" \; | awk '{first=$1; $1=""; print $0">"first}' | sed 's|^ |/|') | sort -u - > /tmp/onbuild/exclude.filelist.new \
         && comm -13 /tmp/onbuild/exclude.filelist /tmp/onbuild/exclude.filelist.new | awk -F '>' '{system("cp -a \"."$1"\" \"/buildfs/"$1"\"")}' \
         && rm -f /tmp/onbuild/exclude.filelist.new \
         && cp -a /buildfs/* /finalfs/ \
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
               for git in $CLONEGITS; \
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
         && rm -rf /initfs /buildfs \
         && if [ -n "$FINALCMDS" ]; \
            then \
               cd $finalfs; \
               eval "$FINALCMDS || exit 1"; \
            fi \
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
                  exe="/finalfs$exe"; \
                  exeDir="$(dirname "$exe")"; \
                  exeName="$(basename "$exe")"; \
                  if [ "$exeDir" != "/finalfs/usr/local/bin" ]; \
                  then \
                     cp -a "$exe" "/finalfs/usr/local/bin/"; \
                     cd "$exeDir"; \
                     ln -sf "$(relpath "$exeDir" "/finalfs/usr/local/bin")/$exeName" "$exeName"; \
                  fi; \
                  if [ "$exeName" == "sudo" ]; \
                  then \
                     chmod ug=rx,o= "/finalfs/usr/local/bin/$exeName"; \
                  else \
                     chmod u=rx,go= "/finalfs/usr/local/bin/$exeName"; \
                  fi \
               done; \
            fi \
         && if [ -n "$EXPOSEFUNCTIONS" ]; \
            then \
               mkdir -p /finalfs/usr/local/bin/functions; \
               cd /finalfs/usr/local/bin; \
               ln -s ../../../start/includeFunctions ./; \
               cd /finalfs/usr/local/bin/functions; \
               for func in $EXPOSEFUNCTIONS; \
               do \
                  ln -s ../../../../start/functions/$func ./; \
               done; \
            fi \
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
               find "/finalfs$(dirname "$file")" -name "$(basename "$file")" -maxdepth 1 -exec chmod g+w "{}" +; \
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
               find "/finalfs$(dirname "$dir")" -name "$(basename "$dir")" -maxdepth 1 -exec chmod -R g+w "{}" +; \
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
         && rm -rf /finalfs/sys /finalfs/dev /finalfs/proc /finalfs/lib/apk /finalfs/etc/apk; \
            find /finalfs/var/cache ! -type d ! -type c -delete; \
            find /finalfs/tmp ! -type d ! -type c -delete \
         && for dir in $REMOVEDIRS; \
            do \
               dir="$(eval "echo $dir")"; \
               dir="${dir#/initfs}"; \
               dir="${dir#/buildfs}"; \
               dir="${dir#/finalfs}"; \
               dir="/finalfs$dir"; \
               if [ -d "$dir" ]; \
               then \
                  rm -rf "$dir"; \
               fi; \
            done \
         && for file in $REMOVEFILES; \
            do \
               file="$(eval "echo $file")"; \
               file="${file#/initfs}"; \
               file="${file#/buildfs}"; \
               file="${file#/finalfs}"; \
               file="/finalfs$dir"; \
               if [ -f "$file" ] || [ -l "$file" ]; \
               then \
                  rm -f "$file"; \
               fi; \
            done \
         && cd /finalfs \
         && find * -type d -maxdepth 0 | sort - > /tmp/topDirs \
         && find * -type d -maxdepth 0 | awk '{system("find \""$1"\" -type f -exec find \""$1"\" -maxdepth 0 \\;")}' | sort -u - > /tmp/usedTopDirs \
         && comm -23 /tmp/topDirs /tmp/usedTopDirs | xargs rm -rf \
         && if [ -d "$DESTDIR" ] && [ "$DESTDIR" != "/finalfs" ] && [ "${DESTDIR::8}" == "/finalfs" ]; \
            then \
               if [ -n "$RUNDEPS" ]; \
               then \
                  echo "$RUNDEPS" >> "$DESTDIR/RUNDEPS.txt"; \
               fi; \
               (find * -type l -exec echo -n "/{}>" \; -exec readlink "{}" \; && find * -type f -exec md5sum "{}" \; | awk '{first=$1; $1=""; print $0">"first}' | sed 's|^ |/|') | sort -u - > /tmp/onbuild/exclude.filelist.new; \
               comm -12 /tmp/onbuild/exclude.filelist /tmp/onbuild/exclude.filelist.new | awk -F '>' '{system("rm -f \"."$1"\"")}'; \
               if [ -s "$DESTDIR" ] && [ ! -e "/finalfs/start" ] && [ ! -e "/finalfs/stop" ]; \
               then \
                  cp -a $DESTDIR*/* /finalfs/; \
               fi; \
            fi \
         && rm -f /finalfs/RUNDEPS.txt \
         && (find * -type l -exec echo -n "/{}>" \; -exec readlink "{}" \; && find * -type f -exec md5sum "{}" \; | awk '{first=$1; $1=""; print $0">"first}' | sed 's|^ |/|') | sort -u - > /tmp/onbuild/exclude.filelist.new \
         && comm -12 /tmp/onbuild/exclude.filelist /tmp/onbuild/exclude.filelist.new | awk -F '>' '{system("rm -f \"."$1"\"")}' \
         && sort -u -o /tmp/onbuild/exclude.filelist /tmp/onbuild/exclude.filelist /tmp/onbuild/exclude.filelist.new \
         && rm -f /tmp/onbuild/exclude.filelist.* \
         && tar -c -z -f /environment/onbuild.tar.gz -C /tmp onbuild \
         && mv /environment /finalfs/ \
         && chmod 755 /finalfs /finalfs/lib /finalfs/usr /finalfs/usr/lib /finalfs/usr/local /finalfs/usr/local/bin || true \
         && chmod 700 /finalfs/bin /finalfs/sbin /finalfs/usr/bin /finalfs/usr/sbin || true \
         && chmod 750 /finalfs/etc /finalfs/var /finalfs/run /finalfs/var/cache /finalfs/start /finalfs/stop || true \
         && setfacl --restore=/tmp/init-permissions.txt || true \
         && apk --purge del .builddeps .builddeps_untrusted
