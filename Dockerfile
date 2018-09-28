FROM huggla/alpine-slim as stage1

ARG APKS="sudo dash argon2"

COPY ./rootfs /rootfs

RUN mkdir -p /rootfs/environment /rootfs/usr/bin /rootfs/etc/sudoers.d /rootfs/usr/lib/sudo /rootfs/bin /rootfs/sbin /rootfs/usr/sbin /rootfs/tmp /rootfs/var/cache /rootfs/run \
 && apk --no-cache add $APKS \
 && cp -a /usr/bin/sudo /rootfs/usr/local/bin/ \
 && cp -a /usr/lib/sudo/libsudo* /usr/lib/sudo/sudoers* /rootfs/usr/lib/sudo/ \
 && echo 'Defaults lecture="never"' > /rootfs/etc/sudoers.d/docker1 \
 && echo 'Defaults secure_path="/start:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' >> /rootfs/etc/sudoers.d/docker1 \
 && echo 'Defaults env_keep = "VAR_*"' > /rootfs/etc/sudoers.d/docker2 \
 && echo 'Defaults !root_sudo' >> /rootfs/etc/sudoers.d/docker2 \
 && echo "starter ALL=(root) NOPASSWD: /start/start" >> /rootfs/etc/sudoers.d/docker2 \
 && echo 'root ALL=(ALL) ALL' > /rootfs/etc/sudoers \
 && echo '#includedir /etc/sudoers.d' >> /rootfs/etc/sudoers \
 && cp -a /etc/passwd /etc/group /etc/shadow /rootfs/etc/ \
 && echo 'root:x:0:0:root:/dev/null:/sbin/nologin' > /rootfs/etc/passwd \
 && echo 'root:x:0:root' > /rootfs/etc/group \
 && echo 'root:::0:::::' > /rootfs/etc/shadow \
 && echo 'starter:x:101:101:starter:/dev/null:/sbin/nologin' >> /rootfs/etc/passwd \
 && echo 'starter:x:0:starter' >> /rootfs/etc/group \
 && echo 'starter:::0:::::' >> /rootfs/etc/shadow \
 && cp -a /usr/bin/argon2 /rootfs/usr/bin/ \
 && cp -a /usr/bin/dash /rootfs/usr/local/bin/ \
 && find /rootfs/usr/local/bin/* ! -name sudo | xargs chmod ug=rx,o= \
 && chmod go= /rootfs/environment /rootfs/bin /rootfs/sbin /rootfs/usr/bin /rootfs/usr/sbin /rootfs/etc/sudoers \
 && chmod -R o= /rootfs/start \
 && chmod u=rx,go= /rootfs/start/stage1 /rootfs/start/stage2 \
 && chmod u=rw,go= /rootfs/etc/sudoers.d/docker* \
 && chmod -R g=r,o= /rootfs/stop \
 && chmod g=rx /rootfs/stop /rootfs/stop/functions \
 && chmod u=rwx,g=rx /rootfs/stop/stage1 \
 && cd /rootfs/start \
 && ln -s stage1 start \
 && cd /rootfs/stop \
 && ln -s ../start/includeFunctions ./ \
 && cd /rootfs/stop/functions \
 && ln -s ../../start/functions/readEnvironmentVars ../../start/functions/tryRunStage ./ \
 && cp -a /lib/libz.so* /lib/*musl* /rootfs/lib/ \
 && cp -a /bin/busybox /bin/sh /rootfs/bin/ \
 && cp -a $(find /bin/* -type l | xargs) /rootfs/bin/ \
 && cp -a $(find /sbin/* -type l | xargs) /rootfs/sbin/ \
 && cp -a $(find /usr/bin/* -type l | xargs) /rootfs/usr/bin/ \
 && cp -a $(find /usr/sbin/* -type l | xargs) /rootfs/usr/sbin/ \
 && chmod o= /rootfs/etc/* \
 && chmod ugo=rwx /rootfs/tmp \
 && cd /rootfs/var \
 && ln -s ../tmp tmp \
 && find /rootfs -type l -exec sh -c 'for x; do [ -e "$x" ] || rm "$x"; done' _ {} +
 
FROM scratch
 
COPY --from=stage1 /rootfs /

ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/start" \
    VAR_LINUX_USER="root" \
    VAR_FINAL_COMMAND="pause" \
    VAR_ARGON2_PARAMS="-r" \
    VAR_SALT_FILE="/proc/sys/kernel/hostname" \
    HISTFILE="/dev/null"

ONBUILD COPY --from=stage1 /rootfs /

ONBUILD RUN rm -rf /lib/apk /etc/apk \
         && cp -a /rootfs/lib/apk /lib/ \
         && rm -rf /rootfs \
         && chmod u+s /usr/local/bin/sudo \
         && find /usr/local/bin/* ! -name sudo | xargs chmod o-rwx \
         && chmod go= /environment /bin /sbin /usr/bin /usr/sbin /etc/sudoers \
         && chmod -R o= /start /tmp \
         && chmod u=rx,go= /start/stage1 /start/stage2 \
         && chmod u=rw,go= /etc/sudoers.d/docker* \
         && chmod -R g=r,o= /stop \
         && chmod g=rx /stop /stop/functions \
         && chmod u=rwx,g=rx /stop/stage1

ONBUILD USER starter

ONBUILD CMD ["sudo","start"]
