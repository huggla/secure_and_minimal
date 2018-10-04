ARG RUNDEPS="sudo dash argon2"
ARG MAKEDIRS="/environment"
ARG EXECUTABLES="/usr/bin/sudo /usr/bin/dash /usr/bin/argon2"
ARG RUNCMDS=\
"    echo 'Defaults lecture=\"never\"' > /imagefs/etc/sudoers.d/docker1 "\
" && echo 'Defaults secure_path=\"/start:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\"' >> /imagefs/etc/sudoers.d/docker1 "\
" && echo 'Defaults env_keep = \"VAR_*\"' > /imagefs/etc/sudoers.d/docker2 "\
" && echo 'Defaults !root_sudo' >> /imagefs/etc/sudoers.d/docker2 "\
" && echo 'starter ALL=(root) NOPASSWD: /start/start' >> /imagefs/etc/sudoers.d/docker2 "\
" && echo 'root ALL=(ALL) ALL' > /imagefs/etc/sudoers "\
" && echo '#includedir /etc/sudoers.d' >> /imagefs/etc/sudoers "\
" && echo 'starter:x:101:101:starter:/dev/null:/sbin/nologin' >> /imagefs/etc/passwd "\
" && echo 'starter:x:0:starter' >> /imagefs/etc/group "\
" && echo 'starter:::0:::::' >> /imagefs/etc/shadow "\
" && ls -la /imagefs "\
" && cd /imagefs/start "\
" && ln -s stage1 start "\
" && cd /imagefs/stop "\
" && ln -s ../start/includeFunctions ./ "\
" && cd /imagefs/stop/functions "\
" && ln -s ../../start/functions/readEnvironmentVars ../../start/functions/tryRunStage ./ "

FROM huggla/busybox as init

FROM huggla/build as build

FROM scratch as image

COPY --from=build /imagefs /

ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/start" \
    VAR_LINUX_USER="root" \
    VAR_FINAL_COMMAND="pause" \
    VAR_ARGON2_PARAMS="-r" \
    VAR_SALT_FILE="/proc/sys/kernel/hostname" \
    HISTFILE="/dev/null"

ONBUILD COPY --from=build /imagefs /

ONBUILD RUN chmod u+s,o+rx /usr/local/bin/sudo \
         && chmod go= /environment /etc/sudoers* \
         && chmod -R o= /start \
         && chmod u=rx,go= /start/stage1 /start/stage2 \
         && chmod -R g=r,o= /stop \
         && chmod g=rx /stop /stop/functions \
         && chmod u=rwx,g=rx /stop/stage1

ONBUILD USER starter

ONBUILD CMD ["sudo","start"]
