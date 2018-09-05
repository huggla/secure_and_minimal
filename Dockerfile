FROM alpine:edge as stage1

ARG APKS="sudo argon2 dash"

COPY ./rootfs /rootfs

RUN find bin usr lib etc var home sbin root run srv tmp -type d -print0 | sed -e 's|^|/rootfs/|' | xargs -0 mkdir -p \
 && cp -a /lib/apk/db /rootfs/lib/apk/ \
 && cp -a /etc/apk /rootfs/etc/ \
 && cd / \
 && cp -a /bin/busybox /bin/sh /rootfs/bin/ \
 && apk --no-cache --quiet info | xargs apk --quiet --no-cache --root /rootfs fix \
 && apk --no-cache --quiet --root /rootfs add $APKS \
 && mkdir -p /rootfs/environment \
 && cd /rootfs/start \
 && ln -s stage1 start \
 && echo 'Defaults lecture="never"' > /rootfs/etc/sudoers.d/docker1 \
 && echo 'Defaults secure_path="/start:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' >> /rootfs/etc/sudoers.d/docker1 \
 && echo 'Defaults env_keep = "VAR_*"' > /rootfs/etc/sudoers.d/docker2 \
 && echo 'Defaults !root_sudo' >> /rootfs/etc/sudoers.d/docker2 \
 && echo "starter ALL=(root) NOPASSWD: /start/start" >> /rootfs/etc/sudoers.d/docker2 \
 && addgroup -S -g 101 starter \
 && adduser -D -S -H -s /bin/false -u 101 -G starter starter \
 && cp -p /etc/group /etc/passwd /etc/shadow /rootfs/etc/ \
 && mv /rootfs/usr/bin/sudo /rootfs/usr/bin/dash /rootfs/usr/local/bin/ \
 && chmod go= /rootfs/bin /rootfs/sbin /rootfs/usr/bin /rootfs/usr/sbin  \
 && chmod -R go= /rootfs/environment \
 && cd /rootfs/usr/bin \
 && ln -s ../local/bin/sudo sudo \
 && ln -s ../local/bin/dash dash \
 && chmod -R o= /rootfs/usr/local/bin/dash /rootfs/start \
 && chmod u=rx,go= /rootfs/start/stage1 /rootfs/start/stage2 \
 && chmod u=rw,go= /rootfs/etc/sudoers.d/docker* \
 && chmod -R g=r,o= /rootfs/stop \
 && chmod g=rx /rootfs/stop /rootfs/stop/functions \
 && chmod u=rwx,g=rx /rootfs/stop/stage1 \
 && cd /rootfs/stop \
 && ln -s ../start/includeFunctions ./ \
 && cd /rootfs/stop/functions \
 && ln -s ../../start/functions/readEnvironmentVars ../../start/functions/tryRunStage ./
 
FROM alpine:edge

COPY --from=stage1 /rootfs /

#RUN chmod u+s /usr/local/bin/sudo

ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/start" \
    VAR_LINUX_USER="root" \
    VAR_FINAL_COMMAND="pause" \
    VAR_ARGON2_PARAMS="-r" \
    VAR_SALT_FILE="/proc/sys/kernel/hostname" \
    HISTFILE="/dev/null"

USER starter

CMD ["sudo","start"]

ONBUILD USER root
