ARG RUNDEPS="sudo dash argon2"
ARG MAKEDIRS="/environment"
ARG EXECUTABLES="/usr/bin/sudo /usr/bin/dash /usr/bin/argon2"
ARG RUNCMDS=\
#"    mkdir -p /rootfs/environment /rootfs/usr/bin /rootfs/etc/sudoers.d /rootfs/usr/lib/sudo /rootfs/bin /rootfs/sbin /rootfs/usr/sbin /rootfs/tmp /rootfs/var/cache /rootfs/run "\
#"    cp -a /usr/bin/sudo /rootfs/usr/local/bin/ "\
#" && cp -a /usr/lib/sudo/libsudo* /usr/lib/sudo/sudoers* /rootfs/usr/lib/sudo/ "\
"    echo 'Defaults lecture=\"never\"' > /imagefs/etc/sudoers.d/docker1 "\
" && echo 'Defaults secure_path=\"/start:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\"' >> /imagefs/etc/sudoers.d/docker1 "\
" && echo 'Defaults env_keep = \"VAR_*\"' > /imagefs/etc/sudoers.d/docker2 "\
" && echo 'Defaults !root_sudo' >> /imagefs/etc/sudoers.d/docker2 "\
" && echo 'starter ALL=(root) NOPASSWD: /start/start' >> /imagefs/etc/sudoers.d/docker2 "\
" && echo 'root ALL=(ALL) ALL' > /imagefs/etc/sudoers "\
" && echo '#includedir /etc/sudoers.d' >> /imagefs/etc/sudoers "\
#" && cp -a /etc/passwd /etc/group /etc/shadow /rootfs/etc/ "\
" && echo 'starter:x:101:101:starter:/dev/null:/sbin/nologin' >> /imagefs/etc/passwd "\
" && echo 'starter:x:0:starter' >> /imagefs/etc/group "\
" && echo 'starter:::0:::::' >> /rootfs/etc/shadow "\
#" && cp -a /usr/bin/argon2 /rootfs/usr/bin/ "\
#" && cp -a /usr/bin/dash /rootfs/usr/local/bin/ "\
#" && find /rootfs/usr/local/bin/* ! -name sudo | xargs chmod ug=rx,o= "\
#" && chmod go= /rootfs/environment /rootfs/bin /rootfs/sbin /rootfs/usr/bin /rootfs/usr/sbin /rootfs/etc/sudoers "\
#" && chmod -R o= /rootfs/start "\
#" && chmod u=rx,go= /rootfs/start/stage1 /rootfs/start/stage2 "\
#" && chmod u=rw,go= /rootfs/etc/sudoers.d/docker* "\
#" && chmod -R g=r,o= /rootfs/stop "\
#" && chmod g=rx /rootfs/stop /rootfs/stop/functions "\
#" && chmod u=rwx,g=rx /rootfs/stop/stage1 "\
" && cd /rootfs/start "\
" && ln -s stage1 start "\
" && cd /rootfs/stop "\
" && ln -s ../start/includeFunctions ./ "\
" && cd /rootfs/stop/functions "\
" && ln -s ../../start/functions/readEnvironmentVars ../../start/functions/tryRunStage ./ "
#" && cp -a /lib/libz.so* /lib/*musl* /rootfs/lib/ "\
#" && cp -a /bin/busybox /bin/sh /rootfs/bin/ "\
#" && cp -a $(find /bin/* -type l | xargs) /rootfs/bin/ "\
#" && cp -a $(find /sbin/* -type l | xargs) /rootfs/sbin/ "\
#" && cp -a $(find /usr/bin/* -type l | xargs) /rootfs/usr/bin/ "\
#" && cp -a $(find /usr/sbin/* -type l | xargs) /rootfs/usr/sbin/ "\
#" && chmod o= /rootfs/etc/* "\
#" && chmod ugo=rwx /rootfs/tmp "\
#" && cd /rootfs/var "\
#" && ln -s ../tmp tmp "\
#" && find /rootfs -type l -exec sh -c 'for x; do [ -e \"\$x\" ] || rm \"\$x\"; done' _ {} + "

FROM huggla/busybox as init

FROM huggla/build as build

FROM scratch as final-image

COPY --from=build /imagefs /

ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/start" \
    VAR_LINUX_USER="root" \
    VAR_FINAL_COMMAND="pause" \
    VAR_ARGON2_PARAMS="-r" \
    VAR_SALT_FILE="/proc/sys/kernel/hostname" \
    HISTFILE="/dev/null"

ONBUILD COPY --from=build /imagefs /
#ONBUILD RUN rm -rf /lib/apk /etc/apk \

ONBUILD RUN chmod u+s,o+rx /usr/local/bin/sudo \
         && chmod go= /environment /etc/sudoers* \
         && chmod -R o= /start \
         && chmod u=rx,go= /start/stage1 /start/stage2 \
         && chmod -R g=r,o= /stop \
         && chmod g=rx /stop /stop/functions \
         && chmod u=rwx,g=rx /stop/stage1

ONBUILD USER starter

ONBUILD CMD ["sudo","start"]
