ARG BASEIMAGE="huggla/busybox:20181017-edge"
ARG RUNDEPS="sudo dash argon2"
ARG MAKEDIRS="/environment"
ARG MAKEFILES="/etc/sudoers.d/docker1 /etc/sudoers.d/docker2"
ARG REMOVEFILES="/usr/sbin/visudo /usr/bin/sudoreplay /usr/bin/cvtsudoers /usr/bin/sudoedit"
ARG EXECUTABLES="/usr/bin/sudo /usr/bin/dash /usr/bin/argon2"

#---------------Don't edit----------------
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${BASEIMAGE:-huggla/base} as base
FROM huggla/build as build
FROM ${BASEIMAGE:-huggla/base} as image
COPY --from=build /imagefs /
#-----------------------------------------

RUN echo 'starter:x:101:101:starter:/dev/null:/sbin/nologin' >> /etc/passwd \
 && echo 'starter:x:101:' >> /etc/group \
 && echo -n 'users:x:112:root,starter' >> /etc/group \
 && echo 'Defaults lecture=\"never\"' > /etc/sudoers.d/docker1 \
 && echo 'Defaults secure_path=\"/start:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\"' >> /etc/sudoers.d/docker1 \
 && echo 'Defaults env_keep = \"VAR_*\"' > /etc/sudoers.d/docker2 \
 && echo 'Defaults !root_sudo' >> /etc/sudoers.d/docker2 \
 && echo 'starter ALL=(root) NOPASSWD: /start/start' >> /etc/sudoers.d/docker2 \
 && echo 'root ALL=(ALL) ALL' > /etc/sudoers \
 && echo '#includedir /etc/sudoers.d' >> /etc/sudoers \
 && chgrp -R 101 /etc/sudoers* /usr/bin/sudo /usr/lib/sudo \
 && cd /start \
 && ln -s stage1 start \
 && cd /stop \
 && ln -s ../start/includeFunctions ./ \
 && cd /stop/functions \
 && ln -s ../../start/functions/readEnvironmentVars ../../start/functions/tryRunStage ./ \
 && chmod u+s /usr/local/bin/sudo \
 && chmod go= /environment \
 && chmod u=rx,g= /start/stage1 /start/stage2 \
 && chmod -R g=r /stop \
 && chmod g=rx /stop /stop/functions \
 && chmod u=rwx,g=rx /stop/stage1

ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/start" \
    VAR_LINUX_USER="root" \
    VAR_FINAL_COMMAND="pause" \
    VAR_ARGON2_PARAMS="-r" \
    VAR_SALT_FILE="/proc/sys/kernel/hostname" \
    HISTFILE="/dev/null"

#---------------Don't edit----------------
USER starter
ONBUILD USER root
#-----------------------------------------

CMD ["sudo","start"]
