FROM alpine:edge as stage1

COPY ./start /rootfs/start

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
 && cp -p /etc/group /etc/passwd /etc/shadow /rootfs/etc/
 
 RUN tar -cpf /installed_files.tar $(apk manifest $(apk info) | awk -F "  " '{print $2;}') \
  && tar -cpf /installed_files2.tar $(find /bin/* /sbin/* /usr/bin/* /usr/sbin/* -type l) \
  && tar -cpf /installed_files3.tar $(find /etc/* /var/* /lib/* -type d) \
  && tar -cpf /installed_files4.tar $(find */apk/* -type f) \
  && tar -xpf /installed_files.tar -C /rootfs/ \
  && tar -xpf /installed_files2.tar -C /rootfs/ \
  && tar -xpf /installed_files3.tar -C /rootfs/ \
  && tar -xpf /installed_files4.tar -C /rootfs/ \
  && mv /rootfs/usr/bin/sudo /rootfs/usr/local/bin/sudo \
  && cd /rootfs/usr/bin \
  && ln -s ../local/bin/sudo sudo
 
FROM scratch

COPY --from=stage1 /rootfs /

ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/start" \
    VAR_LINUX_USER="root" \
    VAR_ARGON2_PARAMS="-r" \
    VAR_SALT_FILE="/proc/sys/kernel/hostname" \
    HISTFILE="/dev/null"

RUN chmod o= /bin /sbin /usr/bin /usr/sbin \
 && chmod 7700 /environment /start \
 && chmod u+x /start/stage1 /start/stage2 \
 && chown :starter /usr/bin/sudo \
 && chmod u+s,o-rx /usr/bin/sudo \
 && chmod u=rw,go= /etc/sudoers.d/docker*

USER starter

CMD ["sudo","start"]
