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
 && rm /rootfs/usr/bin/sudo \
 && ln /usr/bin/sudo /rootfs/usr/local/bin/sudo \
 && cd /rootfs/usr/bin \
 && ln -s ../local/bin/sudo sudo \
 && chown root:root /rootfs/usr/local/bin/sudo \
 && chmod ugo+s /rootfs/usr/local/bin/sudo \
 && mkdir -p /rootfs/bin /rootfs/sbin /rootfs/usr/bin /rootfs/usr/sbin \
 && chmod o= /rootfs/bin /rootfs/sbin /rootfs/usr/bin /rootfs/usr/sbin \
# && chmod 7700 /rootfs/environment /rootfs/start /rootfs/usr/local/bin/sudo \
 && chmod u+x /rootfs/start/stage1 /rootfs/start/stage2 \
 && chmod u=rw,go= /rootfs/etc/sudoers.d/docker*
 
RUN chmod ugo+s /rootfs/usr/local/bin/sudo
 
FROM alpine:edge

COPY --from=stage1 /rootfs /

ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/start" \
    VAR_LINUX_USER="root" \
    VAR_ARGON2_PARAMS="-r" \
    VAR_SALT_FILE="/proc/sys/kernel/hostname" \
    HISTFILE="/dev/null"

USER starter

CMD ["sudo","start"]
