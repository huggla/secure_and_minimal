ARG TAG="20190401"
ARG BASEIMAGE="huggla/busybox:$TAG"
ARG RUNDEPS="sudo dash argon2 libcap"
ARG MAKEFILES="/etc/sudoers.d/docker1 /etc/sudoers.d/docker2"
ARG REMOVEFILES="/usr/sbin/visudo /usr/bin/sudoreplay /usr/bin/cvtsudoers /usr/bin/sudoedit"
ARG EXECUTABLES="/usr/bin/sudo /usr/bin/dash /usr/bin/argon2"
ARG BUILDCMDS=\
"   echo 'Defaults lecture=\"never\"' > /imagefs/etc/sudoers.d/docker1 "\
"&& echo 'Defaults secure_path=\"/start:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\"' >> /imagefs/etc/sudoers.d/docker1 "\
"&& echo 'Defaults env_keep = \"VAR_*\"' > /imagefs/etc/sudoers.d/docker2 "\
"&& echo 'Defaults !root_sudo' >> /imagefs/etc/sudoers.d/docker2 "\
"&& echo 'starter ALL=(root) NOPASSWD: /start/start' >> /imagefs/etc/sudoers.d/docker2 "\
"&& echo 'root ALL=(ALL) ALL' > /imagefs/etc/sudoers "\
"&& echo '#includedir /etc/sudoers.d' >> /imagefs/etc/sudoers "\
"&& echo 'exec /bin/sh' > /imagefs/usr/bin/script "\
"&& chmod u+x /imagefs/usr/bin/script "\
"&& cd /imagefs/start "\
"&& ln -s stage1 start "\
"&& cd /imagefs/stop "\
"&& ln -s ../start/includeFunctions ./ "\
"&& cd /imagefs/stop/functions "\
"&& ln -s ../../start/functions/readEnvironmentVars ../../start/functions/sourceDirs ./ "\
"&& chmod u=rx,g= /imagefs/start/stage1 /imagefs/start/stage2 /imagefs/start/delayedDisableStartupExecutables "\
"&& chmod -R g=r /imagefs/stop "\
"&& chmod g=rx /imagefs/stop /imagefs/stop/functions "\
"&& chmod u=rwx,g=rx /imagefs/stop/stage1"

#--------Generic template (don't edit)--------
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${CONTENTIMAGE3:-scratch} as content3
FROM ${INITIMAGE:-${BASEIMAGE:-huggla/base:$TAG}} as init
FROM ${BUILDIMAGE:-huggla/build} as build
FROM ${BASEIMAGE:-huggla/base:$TAG} as image
ARG CONTENTSOURCE1
ARG CONTENTSOURCE1="${CONTENTSOURCE1:-/}"
ARG CONTENTDESTINATION1
ARG CONTENTDESTINATION1="${CONTENTDESTINATION1:-/buildfs/}"
ARG CONTENTSOURCE2
ARG CONTENTSOURCE2="${CONTENTSOURCE2:-/}"
ARG CONTENTDESTINATION2
ARG CONTENTDESTINATION2="${CONTENTDESTINATION2:-/buildfs/}"
ARG CONTENTSOURCE3
ARG CONTENTSOURCE3="${CONTENTSOURCE3:-/}"
ARG CONTENTDESTINATION3
ARG CONTENTDESTINATION3="${CONTENTDESTINATION3:-/buildfs/}"
ARG CLONEGITSDIR
ARG DOWNLOADSDIR
ARG MAKEDIRS
ARG MAKEFILES
ARG EXECUTABLES
ARG STARTUPEXECUTABLES
ARG EXPOSEFUNCTIONS
ARG GID0WRITABLES
ARG GID0WRITABLESRECURSIVE
ARG LINUXUSEROWNED
COPY --from=build /imagefs /
RUN [ -n "$LINUXUSEROWNED" ] && chown 102 $LINUXUSEROWNED || true
#---------------------------------------------

RUN chgrp -R 101 /usr/lib/sudo /usr/local/bin/sudo \
 && chmod u+s /usr/local/bin/sudo

ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/start" \
    VAR_LINUX_USER="root" \
    VAR_FINAL_COMMAND="pause" \
    VAR_ARGON2_PARAMS="-r" \
    VAR_SALT_FILE="/proc/sys/kernel/hostname" \
    HISTFILE="/dev/null"

#--------Generic template (don't edit)--------
USER starter
ONBUILD USER root
#---------------------------------------------

CMD ["sudo","start"]
