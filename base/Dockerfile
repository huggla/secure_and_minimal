ARG TAG="20190802"
ARG BASEIMAGE="huggla/busybox:$TAG"
ARG BUILDIMAGE="huggla/build:test"
ARG RUNDEPS="sudo dash argon2 libcap"
ARG MAKEFILES="/etc/sudoers.d/docker1 /etc/sudoers.d/docker2"
ARG REMOVEFILES="/usr/sbin/visudo /usr/bin/sudoreplay /usr/bin/cvtsudoers /usr/bin/sudoedit"
ARG EXECUTABLES="/usr/bin/sudo /usr/bin/dash /usr/bin/argon2"
ARG FINALCMDS=\
"   echo 'Defaults lecture=\"never\"' > ./etc/sudoers.d/docker1 "\
"&& echo 'Defaults secure_path=\"/start:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\"' >> ./etc/sudoers.d/docker1 "\
"&& echo 'Defaults env_keep = \"VAR_*\"' > ./etc/sudoers.d/docker2 "\
"&& echo 'Defaults !root_sudo' >> ./etc/sudoers.d/docker2 "\
"&& echo 'starter ALL=(root) NOPASSWD: /start/start' >> ./etc/sudoers.d/docker2 "\
"&& echo 'root ALL=(ALL) ALL' > ./etc/sudoers "\
"&& echo '#includedir /etc/sudoers.d' >> ./etc/sudoers "\
"&& echo 'exec /bin/sh' > ./usr/bin/script "\
"&& chmod u+x ./usr/bin/script "\
"&& cd ./start "\
"&& ln -s stage1 start "\
"&& cd ../stop "\
"&& ln -s ../start/includeFunctions ./ "\
"&& cd ./functions "\
"&& ln -s ../../start/functions/readEnvironmentVars ../../start/functions/sourceDirs ./ "\
"&& cd ../../ "\
"&& chmod u=rx,g= ./start/stage1 ./start/stage2 ./start/delayedDisableStartupExecutables "\
"&& chmod -R g=r ./stop "\
"&& chmod g=rx ./stop ./stop/functions "\
"&& chmod u=rwx,g=rx ./stop/stage1"

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
