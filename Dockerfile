ARG BUILDDEPS="sudo dash argon2"
ARG RUNCMDS="mkdir -p /rootfs/environment /rootfs/usr/bin /rootfs/etc/sudoers.d /rootfs/usr/lib/sudo /rootfs/bin /rootfs/sbin /rootfs/usr/sbin /rootfs/tmp /rootfs/var/cache /rootfs/run \
 && cp -a /usr/bin/sudo /rootfs/usr/local/bin/"

FROM huggla/alpine-slim as stage1
 
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
