FROM huggla/alpine-slim as stage1

ARG APKS="sudo dash argon2"

COPY ./rootfs /rootfs

RUN mkdir -p /rootfs/environment /rootfs/etc/sudoers.d /rootfs/usr/local/lib/sudo \
 && cp -a /lib/apk /rootfs/lib/ \
 && apk --no-cache add $APKS \
 && cp -a /usr/bin/sudo /rootfs/usr/local/bin/ \
 && cp -a /usr/lib/sudo/libsudo* /usr/lib/sudo/sudoers* /rootfs/usr/local/lib/sudo/ \
 && echo 'Defaults lecture="never"' > /rootfs/etc/sudoers.d/docker1 \
 && echo 'Defaults secure_path="/start:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' >> /rootfs/etc/sudoers.d/docker1 \
 && echo 'Defaults env_keep = "VAR_*"' > /rootfs/etc/sudoers.d/docker2 \
 && echo 'Defaults !root_sudo' >> /rootfs/etc/sudoers.d/docker2 \
 && echo "starter ALL=(root) NOPASSWD: /start/start" >> /rootfs/etc/sudoers.d/docker2 \
 && echo 'root ALL=(ALL) ALL' > /rootfs/etc/sudoers \
 && echo '#includedir /etc/sudoers.d' >> /rootfs/etc/sudoers \
 && cp -a /etc/passwd /etc/group /etc/shadow /rootfs/etc/ \
 && echo 'starter:x:101:101:starter:/dev/null:/sbin/nologin' >> /rootfs/etc/passwd \
 && echo 'starter:x:0:starter' >> /rootfs/etc/group \
 && echo 'starter:::0:::::' >> /rootfs/etc/shadow \
 && cp -a /usr/bin/argon2 /rootfs/usr/bin/ \
 && cp -a /usr/bin/dash /rootfs/usr/local/bin/ \
 && find /rootfs/usr/local/bin/* ! -name sudo | xargs chmod ug=rx,o= \
 && chmod go= /rootfs/environment /rootfs/bin /rootfs/sbin /rootfs/usr/bin /rootfs/usr/sbin /rootfs/etc/sudoers \
 && chmod -R o= /rootfs/start /tmp \
 && chmod u=rx,go= /rootfs/start/stage1 /rootfs/start/stage2 \
 && chmod u=rw,go= /rootfs/etc/sudoers.d/docker* \
 && chmod -R g=r,o= /rootfs/stop \
 && chmod g=rx /rootfs/stop /rootfs/stop/functions \
 && chmod u=rwx,g=rx /rootfs/stop/stage1 \
 && cd /rootfs/usr/bin \
 && ln -s ../local/bin/dash dash \
 && cd /rootfs/start \
 && ln -s stage1 start \
 && cd /rootfs/stop \
 && ln -s ../start/includeFunctions ./ \
 && cd /rootfs/stop/functions \
 && ln -s ../../start/functions/readEnvironmentVars ../../start/functions/tryRunStage ./

FROM huggla/busybox

COPY --from=stage1 /rootfs /

RUN chmod u+s /usr/local/bin/sudo

ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/start" \
    VAR_LINUX_USER="root" \
    VAR_FINAL_COMMAND="pause" \
    VAR_ARGON2_PARAMS="-r" \
    VAR_SALT_FILE="/proc/sys/kernel/hostname" \
    HISTFILE="/dev/null"

USER starter

CMD ["sudo","start"]

ONBUILD USER root
