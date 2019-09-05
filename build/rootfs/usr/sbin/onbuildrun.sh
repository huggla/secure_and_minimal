#!/bin/sh
exec > /build.log 2>&1
set -ex +fam
(
   if [ "${IMAGETYPE#*content}" != "$IMAGETYPE" ] && [ -z "$DESTDIR" ]
   then
      DESTDIR="/content"
   fi
   if [ -n "$ADDREPOS" ]
   then
      for repo in $ADDREPOS
      do
         echo $repo >> /etc/apk/repositories
      done
   fi
   cd /finalfs
   rm -rf environment
   getfacl -R . > /tmp/init-permissions.txt
   tar -xp -f /environment/onbuild.tar.gz -C /tmp
   if [ -n "$RUNDEPS" ]
   then
      if [ -n "$EXCLUDEDEPS" ] || [ -n "$EXCLUDEAPKS" ]
      then
         cd /excludefs
         apk --repositories-file /etc/apk/repositories --keys-dir /etc/apk/keys --no-cache --initramfs-diskless-boot --clean-protected --root /excludefs add --quiet --initdb $EXCLUDEDEPS $EXCLUDEAPKS
         excludeFilesDeps="$(apk --no-cache --quiet --root /excludefs info --depends $EXCLUDEDEPS | xargs apk --no-cache --quiet --root /excludefs info --contents)"
         excludeFilesApks="$(apk --no-cache --quiet --root /excludefs info --contents $EXCLUDEAPKS)"
         excludeFiles="$(echo ${excludeFilesDeps}${excludeFilesApks} | grep -v '^$' | sort -u -)"
         for file in $excludeFiles
         do
            if find "$file" -maxdepth 0 ! -path 'var/cache/*' ! -path 'tmp/*' | grep -q -e .
            then
               if [ -L "$file" ]
               then
                  (echo -n "/$file>" && readlink "$file") >> /tmp/onbuild/exclude.filelist
               elif [ -f "$file" ]
               then
                  md5sum "$file" | awk '{first=$1; $1=""; print $0">"first}' | sed 's|^ |/|' >> /tmp/onbuild/exclude.filelist || exit 1
               fi
            fi
         done
         rm -rf /excludefs
         sort -u -o /tmp/onbuild/exclude.filelist /tmp/onbuild/exclude.filelist
      fi
      cd /
      if [ -n "$RUNDEPS" ] || [ -n "$RUNDEPS_UNTRUSTED" ]
      then
         apk --repositories-file /etc/apk/repositories --keys-dir /etc/apk/keys --no-cache --initramfs-diskless-boot --clean-protected --root /finalfs add --quiet --initdb
         set +x
         echo '++++++++++++++++++++++++++++++++++'
         echo '+++++++++ RUNDEPS <begin> ++++++++'
         echo '++++++++++++++++++++++++++++++++++'
         set -x
         if [ -n "$RUNDEPS" ]
         then
            apk --repositories-file /etc/apk/repositories --keys-dir /etc/apk/keys --no-cache --initramfs-diskless-boot --clean-protected --root /finalfs add $RUNDEPS
         fi
         if [ -n "$RUNDEPS_UNTRUSTED" ]
         then
            apk --repositories-file /etc/apk/repositories --keys-dir /etc/apk/keys --no-cache --initramfs-diskless-boot --clean-protected --root /finalfs --allow-untrusted add $RUNDEPS_UNTRUSTED
         fi
         set +x
         echo '----------------------------------'
         echo '---------- RUNDEPS </end> --------'
         echo '----------------------------------'
         set -x
      fi
   fi
   cd /finalfs
   for dir in $MAKEDIRS
   do
      dir="$(eval "echo $dir")"
      mkdir -p "${dir#/}"
   done
   for file in $MAKEFILES
   do
      file="$(eval "echo $file")"
      file="${file#/}"
      mkdir -p "$(dirname "$file")"
      touch "$file"
   done
   find /tmp -path "/tmp/buildfs/*" -mindepth 2 -maxdepth 2 -exec cp -a "{}" / \;
   find /tmp -path "/tmp/rootfs/*"  -mindepth 2 -maxdepth 2 -exec cp -a "{}" ./ \;
   chmod -R o= ./
   n="0"
   for contentimage in $CONTENTIMAGE1 $CONTENTIMAGE2 $CONTENTIMAGE3 $CONTENTIMAGE4
   do
      n="$(expr $n + 1)"
      if [ "${contentimage#huggla}" == "$contentimage" ] && [ "$contentimage" != "scratch" ]
      then
         eval "find \"\$CONTENTDESTINATION$n\" -maxdepth 0 -exec chmod -R g-w,o= \"{}\" \\\\\;"
         eval "find \"\$CONTENTDESTINATION$n\" -type f -perm +010 -exec chmod g-x \"{}\" \\\\\;"
      fi
   done
   find ./usr/local/bin -type f -exec chmod u=rx,go= "{}" \;
   find / -path "/usr/local/bin/*" -type f -mindepth 3 -maxdepth 3 -exec chmod u=rx,go= "{}" \;
   if [ -n "$INITCMDS" ]
   then
      cd /
      set +x
      echo '++++++++++++++++++++++++++++++++++'
      echo '+++++++++ INITCMDS <begin> +++++++'
      echo '++++++++++++++++++++++++++++++++++'
      eval "set -x && $INITCMDS"
      echo '----------------------------------'
      echo '--------- INITCMDS </end> --------'
      echo '----------------------------------'
      set -x
   fi
   if [ -n "$BUILDCMDS" ]
   then
      if [ -z "$DESTDIR" ]
      then
         if [ "${IMAGETYPE#*content}" != "$IMAGETYPE" ]
         then
            DESTDIR="content"
         fi
      fi
      cd /finalfs
      find * -type d -exec mkdir -p "/{}" \;
      find * -type f -o -type l -exec cp -a "{}" "/{}" \;
      mkdir -p "/root/.config" "$BUILDDIR" "/finalfs$DESTDIR"
      ln -sf /bin/bash /bin/sh
   fi
   if [ -n "$CLONEGITS" ]
   then
      mkdir -p "$CLONEGITSDIR"
      cd "$CLONEGITSDIR"
      CLONEGITS="$(echo "$CLONEGITS" | sed "s/ '/,'/g" | sed "s/' /',/g")"
      IFS="$(echo -en ",")"
      set +x
      echo '++++++++++++++++++++++++++++++++++'
      echo '++++++++ CLONEGITS <begin> +++++++'
      echo '++++++++++++++++++++++++++++++++++'
      set -x
      for git in $CLONEGITS
      do
         eval "git clone $(eval "echo $git")"
      done
      set +x
      echo '----------------------------------'
      echo '-------- CLONEGITS </end> --------'
      echo '----------------------------------'
      set -x
      unset IFS
   fi
   if [ -n "$DOWNLOADS" ]
   then
      mkdir -p "$DOWNLOADSDIR"
      cd "$DOWNLOADSDIR"
      set +x
      echo '++++++++++++++++++++++++++++++++++'
      echo '++++++++ DOWNLOADS <begin> +++++++'
      echo '++++++++++++++++++++++++++++++++++'
      set -x
      for download in $DOWNLOADS
      do
         wget "$download"
      done
      set +x
      echo '----------------------------------'
      echo '-------- DOWNLOADS </end> --------'
      echo '----------------------------------'
      set -x
      if [ "$DOWNLOADSDIR" == "$BUILDDIR" ]
      then
         find * -type f \( -name "*.tar" -o -name "*.tar.*" \) -maxdepth 0 -exec tar -xp -f "{}" \;
         find * -type f -name "*.zip" -maxdepth 0 -exec unzip -o -d ./ "{}" \;
      fi
   fi
   if [ -n "$BUILDCMDS" ]
   then
      if [ -n "${BUILDDEPS}" ] || [ -n "${BUILDDEPS_UNTRUSTED}" ]
      then
         set +x
         echo '++++++++++++++++++++++++++++++++++'
         echo '++++++++ BUILDDEPS <begin> +++++++'
         echo '++++++++++++++++++++++++++++++++++'
         set -x
         if [ -n "${BUILDDEPS}" ]
         then
            apk --no-cache --purge --force-overwrite --force-refresh --clean-protected --initramfs-diskless-boot add $BUILDDEPS
         fi
         if [ -n "${BUILDDEPS_UNTRUSTED}" ]
         then
            apk --no-cache --purge --force-overwrite --force-refresh --clean-protected --initramfs-diskless-boot allow-untrusted add $BUILDDEPS_UNTRUSTED
         fi
         set +x
         echo '----------------------------------'
         echo '-------- BUILDDEPS </end> --------'
         echo '----------------------------------'
         set -x
      fi
      tmpDESTDIR="$DESTDIR"
      DESTDIR="/finalfs$DESTDIR"
      cd "$BUILDDIR"
      set +x
      echo '++++++++++++++++++++++++++++++++++'
      echo '++++++++ BUILDCMDS <begin> +++++++'
      echo '++++++++++++++++++++++++++++++++++'
      set -x
      eval "$BUILDCMDS"
      set +x
      echo '----------------------------------'
      echo '-------- BUILDCMDS </end> --------'
      echo '----------------------------------'
      set -x
      DESTDIR="$tmpDESTDIR"
   fi
   cd /
   if [ -n "$FINALCMDS" ]
   then
      set +x
      echo '++++++++++++++++++++++++++++++++++'
      echo '++++++++ FINALCMDS <begin> +++++++'
      echo '++++++++++++++++++++++++++++++++++'
      chroot /finalfs sh -c "set -x && $FINALCMDS"
      echo '----------------------------------'
      echo '-------- FINALCMDS </end> --------'
      echo '----------------------------------'
      set -x
   fi
   cd /finalfs
   if [ -n "$EXECUTABLES" ] || [ -n "$STARTUPEXECUTABLES" ]
   then
      if [ -n "$EXECUTABLES" ] && [ -n "$STARTUPEXECUTABLES" ]
      then
         EXECUTABLES="$EXECUTABLES $STARTUPEXECUTABLES"
      elif [ -z "$EXECUTABLES" ]
      then
         EXECUTABLES="$STARTUPEXECUTABLES"
      fi
      for exe in $EXECUTABLES
      do
         exe="${exe#/}"
         exeDir="$(dirname "$exe")"
         exeName="$(basename "$exe")"
         if [ "$exeDir" != "usr/local/bin" ]
         then
            cp -a "$exe" "usr/local/bin/"
            ln -sf "usr/local/bin/$exeName" "$exe"
         fi
         if [ "$exeName" == "sudo" ]
         then
            chmod ug=rx,o= "usr/local/bin/$exeName"
         else
            chmod u=rx,go= "usr/local/bin/$exeName"
         fi
      done
   fi
   if [ -n "$EXPOSEFUNCTIONS" ]
   then
      mkdir -p usr/local/bin/functions
      ln -s start/includeFunctions usr/local/bin/
      for func in $EXPOSEFUNCTIONS
      do
         ln -s start/functions/$func usr/local/bin/functions/
      done
   fi
   set -f
   for exe in $STARTUPEXECUTABLES
   do
      set +f
      echo "$exe" >> /environment/startupexecutables
   done
   sort -u -o /environment/startupexecutables /environment/startupexecutables
   set -f
   for file in $GID0WRITABLES
   do
      set +f
      echo "$file" >> /environment/gid0writables
   done
   sort -u -o /environment/gid0writables /environment/gid0writables
   set -f
   while read file
   do
      set +f
      find ".$(dirname "$file")" -name "$(basename "$file")" -maxdepth 1 -exec chmod g+w "{}" \;
   done </environment/gid0writables
   set -f
   for dir in $GID0WRITABLESRECURSIVE
   do
      set +f
      echo "$dir" >> /environment/gid0writablesrecursive
   done
   sort -u -o /environment/gid0writablesrecursive /environment/gid0writablesrecursive
   set -f
   while read dir
   do
      set +f
      find ".$(dirname "$dir")" -name "$(basename "$dir")" -maxdepth 1 -exec chmod -R g+w "{}" \;
   done </environment/gid0writablesrecursive
   set -f
   for file in $LINUXUSEROWNED
   do
      set +f
      echo "$file" >> /environment/linuxuserowned
   done
   sort -u -o /environment/linuxuserowned /environment/linuxuserowned
   set -f
   for dir in $LINUXUSEROWNEDRECURSIVE
   do
      set +f
      echo "$dir" >> /environment/linuxuserownedrecursive
   done
   sort -u -o /environment/linuxuserownedrecursive /environment/linuxuserownedrecursive
   set +f
   find * -xdev \( -path "var/cache/*" -o -path "tmp/*" -o -path "sys/*" -o -path "proc/*" -o -path "dev/*" -o -path "lib/apk/*" -o -path "etc/apk/*" \) \( -type f -o -type l \) -perm +0200 -delete
   find * -depth -xdev \( -path "var/cache/*" -o -path "tmp/*" -o -path "sys/*" -o -path "proc/*" -o -path "dev/*" -o -path "lib/apk/*" -o -path "etc/apk/*" \) -type d -perm +0200 -exec [ -z "\$(ls -A "{}")" ] \&\& rm -r "{}" \;
   for dir in $REMOVEDIRS
   do
      dir="$(eval "echo $dir")"
      dir="${dir#/finalfs}"
      dir="/finalfs$dir"
      if [ -d "$dir" ]
      then
         rm -rf "$dir"
      fi
   done
   for file in $REMOVEFILES
   do
      file="$(eval "echo $file")"
      file="${file#/finalfs}"
      file="/finalfs$dir"
      if [ -f "$file" ] || [ -l "$file" ]
      then
         rm -f "$file"
      fi
   done
   find * -type d -maxdepth 0 | sort - > /tmp/topDirs
   find * -type d -maxdepth 0 | awk '{system("find \""$1"\" -type f -exec find \""$1"\" -maxdepth 0 \\;")}' | sort -u - > /tmp/usedTopDirs
   comm -23 /tmp/topDirs /tmp/usedTopDirs | xargs rm -rf
   if [ -n "${DESTDIR#/}" ] && [ -n "$(ls -A "${DESTDIR#/}")" ] && ( [ "${IMAGETYPE#*content}" != "$IMAGETYPE" ] || [ "${IMAGETYPE#*base}" != "$IMAGETYPE" ] || [ "${IMAGETYPE#*application}" != "$IMAGETYPE" ] )
   then
      DESTDIR="${DESTDIR#/}"
      (find * -type l -exec echo -n "/{}>" \; -exec readlink "{}" \; && find * -type f -exec md5sum "{}" \; | awk '{first=$1; $1=""; print $0">"first}' | sed 's|^ |/|') | sort -u - > /tmp/onbuild/exclude.filelist.new
      comm -12 /tmp/onbuild/exclude.filelist /tmp/onbuild/exclude.filelist.new | awk -F '>' '{system("rm -f \"."$1"\"")}'
      subdests="dev doc static"
      dev="${COMMON_CONFIGUREPREFIX#/}/lib/pkgconfig usr/include"
      doc="${COMMON_CONFIGUREPREFIX#/}/share/man usr/share/doc"
      if [ "${IMAGETYPE#*application}" != "$IMAGETYPE" ]
      then
         rm -rf "$DESTDIR-dev" "$DESTDIR-doc"
      fi
      if [ "${IMAGETYPE#*content}" != "$IMAGETYPE" ] || [ "${IMAGETYPE#*base}" != "$IMAGETYPE" ]
      then
         if [ -n "$RUNDEPS" ]
         then
            echo "$RUNDEPS" >> "$DESTDIR/RUNDEPS.txt"
         fi
         if [ "${IMAGETYPE#*content}" != "$IMAGETYPE" ]
         then
            cd "$DESTDIR"
            static="$(find ${COMMON_CONFIGUREPREFIX#/}/lib/*.a | xargs)"
            cd /finalfs
            for subdest in $subdests
            do
               eval "files=\$$subdest"
               for file in $files
               do
                  destfile="$DESTDIR/$file"
                  if [ -e "$destfile" ]
                  then
                     subdestdir="$DESTDIR-$subdest$(dirname "/$file")"
                     mkdir -p "$subdestdir"
                     cp -a "$destfile" "$subdestdir/"
                     rm -r "$destfile"
                  fi
               done
            done
            mv "$DESTDIR" "$DESTDIR-app"
            for siblingdir in $DESTDIR*
            do
               cp -a $siblingdir/* ./
               sibling="${siblingdir#$DESTDIR}"
               sibling="${sibling#-}"
               contentfile="${IMAGEID}${sibling:+-$sibling}"
               cd "$siblingdir"
               find * > "$contentfile"
               gzip "$contentfile"
               cd ..
            done
         fi
      fi
   fi
   rm -f RUNDEPS.txt
   (find * -type l -exec echo -n "/{}>" \; -exec readlink "{}" \; && find * -type f -exec md5sum "{}" \; | awk '{first=$1; $1=""; print $0">"first}' | sed 's|^ |/|') | sort -u - > /tmp/onbuild/exclude.filelist.new
   comm -12 /tmp/onbuild/exclude.filelist /tmp/onbuild/exclude.filelist.new | awk -F '>' '{system("rm -f \"."$1"\"")}'
   sort -u -o /tmp/onbuild/exclude.filelist /tmp/onbuild/exclude.filelist /tmp/onbuild/exclude.filelist.new
   rm -f /tmp/onbuild/exclude.filelist.*
   tar -c -z -f /environment/onbuild.tar.gz -C /tmp onbuild
   mv /environment ./
   (
      chmod 755 ./ ./lib ./usr ./usr/lib ./usr/local ./usr/local/bin
      chmod 700 ./bin ./sbin ./usr/bin ./usr/sbin
      chmod 750 ./etc ./var ./run ./var/cache ./start ./stop
      setfacl --restore=/tmp/init-permissions.txt
      true
   )
) || ( echo "BUILD FAILED!" && touch "/fail" )
