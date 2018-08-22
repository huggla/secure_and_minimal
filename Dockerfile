FROM alpine:edge as stage1

USER root

COPY ./rootfs /rootfs

RUN apk add --no-cache sudo argon2 \
 && mkdir -p /rootfs/environment /rootfs/etc/sudoers.d /rootfs/usr/local/bin \
 && cd /rootfs/start \
 && ln -s stage1 start \
 && echo 'Defaults lecture="never"' > /rootfs/etc/sudoers.d/docker1 \
 && echo 'Defaults secure_path="/start:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' >> /rootfs/etc/sudoers.d/docker1 \
 && echo 'Defaults env_keep = "VAR_*"' > /rootfs/etc/sudoers.d/docker2 \
 && echo 'Defaults !root_sudo' >> /rootfs/etc/sudoers.d/docker2 \
 && echo "starter ALL=(root) NOPASSWD: /start/start" >> /rootfs/etc/sudoers.d/docker2 \
 && addgroup -S starter \
 && adduser -D -S -H -s /bin/false -u 101 -G starter starter \
 && cp -p /etc/group /etc/passwd /etc/shadow /rootfs/etc/ \
 && cd / \
 && tar -cvp -f /installed_files.tar $(apk manifest sudo argon2 | awk -F "  " '{print $2;}') \
 && tar -xvp -f /installed_files.tar -C /rootfs/ \
 && mv /rootfs/usr/bin/sudo /rootfs/usr/local/bin/sudo \
 && cd /rootfs/usr/bin \
 && ln -s ../local/bin/sudo sudo \
 && mkdir -p /rootfs/bin /rootfs/sbin /rootfs/usr/bin /rootfs/usr/sbin \
 && chmod o= /rootfs/bin /rootfs/sbin /rootfs/usr/bin /rootfs/usr/sbin \
 && chmod 7700 /rootfs/environment /rootfs/start /rootfs/stop \
 && chmod u=rx,go= /rootfs/start/stage1 /rootfs/start/stage2 /rootfs/stop/stage1 \
 && chmod u=rw,go= /rootfs/etc/sudoers.d/docker* \
 && cd /rootfs/stop \
 && ln -s ../start/includeFunctions ./ \
 && cd /rootfs/stop/functions \
 && ln -s ../../start/functions/readEnvironmentVars ../../start/functions/tryRunStage ./
 
FROM alpine:edge

COPY --from=stage1 /rootfs /

RUN chmod u+s /usr/local/bin/sudo

ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/start" \
    VAR_LINUX_USER="root" \
    VAR_FINAL_COMMAND="/bin/sh" \
    VAR_ARGON2_PARAMS="-r" \
    VAR_SALT_FILE="/proc/sys/kernel/hostname" \
    HISTFILE="/dev/null"

USER starter

CMD ["sudo","start"]
