ARG TAG="20190517"
ARG BASEIMAGE="huggla/busybox:$TAG"
ARG RUNDEPS="sudo dash argon2 libcap"
ARG MAKEFILES="/etc/sudoers.d/docker1 /etc/sudoers.d/docker2"
ARG REMOVEFILES="/usr/sbin/visudo /usr/bin/sudoreplay /usr/bin/cvtsudoers /usr/bin/sudoedit"
ARG EXECUTABLES="/usr/bin/sudo /usr/bin/dash /usr/bin/argon2"
ARG BUILDCMDS=\
"   echo 'Defaults lecture=\"never\"' > /finalfs/etc/sudoers.d/docker1 "\
"&& echo 'Defaults secure_path=\"/start:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\"' >> /finalfs/etc/sudoers.d/docker1 "\
"&& echo 'Defaults env_keep = \"VAR_*\"' > /finalfs/etc/sudoers.d/docker2 "\
"&& echo 'Defaults !root_sudo' >> /finalfs/etc/sudoers.d/docker2 "\
"&& echo 'starter ALL=(root) NOPASSWD: /start/start' >> /finalfs/etc/sudoers.d/docker2 "\
"&& echo 'root ALL=(ALL) ALL' > /finalfs/etc/sudoers "\
"&& echo '#includedir /etc/sudoers.d' >> /finalfs/etc/sudoers "\
"&& echo 'exec /bin/sh' > /finalfs/usr/bin/script "\
"&& chmod u+x /finalfs/usr/bin/script "\
"&& cd /finalfs/start "\
"&& ln -s stage1 start "\
"&& cd /finalfs/stop "\
"&& ln -s ../start/includeFunctions ./ "\
"&& cd /finalfs/stop/functions "\
"&& ln -s ../../start/functions/readEnvironmentVars ../../start/functions/sourceDirs ./ "\
"&& chmod u=rx,g= /finalfs/start/stage1 /finalfs/start/stage2 /finalfs/start/delayedDisableStartupExecutables "\
"&& chmod -R g=r /finalfs/stop "\
"&& chmod g=rx /finalfs/stop /finalfs/stop/functions "\
"&& chmod u=rwx,g=rx /finalfs/stop/stage1"

#--------Generic template (don't edit)--------
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${CONTENTIMAGE3:-scratch} as content3
FROM ${INITIMAGE:-${BASEIMAGE:-huggla/base:$TAG}} as init
FROM ${BUILDIMAGE:-huggla/build} as build
FROM ${BASEIMAGE:-huggla/base:$TAG} as final
ARG CONTENTSOURCE1
ARG CONTENTSOURCE1="${CONTENTSOURCE1:-/}"
ARG CONTENTDESTINATION1
ARG CONTENTDESTINATION1="${CONTENTDESTINATION1:-/}"
ARG CONTENTSOURCE2
ARG CONTENTSOURCE2="${CONTENTSOURCE2:-/}"
ARG CONTENTDESTINATION2
ARG CONTENTDESTINATION2="${CONTENTDESTINATION2:-/}"
ARG CONTENTSOURCE3
ARG CONTENTSOURCE3="${CONTENTSOURCE3:-/}"
ARG CONTENTDESTINATION3
ARG CONTENTDESTINATION3="${CONTENTDESTINATION3:-/}"
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
ARG LINUXUSEROWNEDRECURSIVE
COPY --from=build /finalfs /
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
