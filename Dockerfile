FROM alpine:edge as stage1

# Build-only variables
ENV LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    argonv="20171227"

COPY ./start /start

RUN apk add --no-cache build-base \
 && downloadDir="$(mktemp -d)" \
 && wget -O "$downloadDir/argon2.tar.gz" https://github.com/P-H-C/phc-winner-argon2/archive/$argonv.tar.gz \
 && buildDir="$(mktemp -d)" \
 && tar -xvf "$downloadDir/argon2.tar.gz" -C "$buildDir" --strip-components=1 \
 && rm -rf "$downloadDir" \
 && cd "$buildDir" \
 && /usr/bin/make OPTTARGET=none \
 && /usr/bin/make install PREFIX=/usr OPTTARGET=none \
 && cd / \
 && rm -rf "$buildDir" \
 && apk del build-base \
 && addgroup -S starter \
 && adduser -D -S -H -s /bin/false -u 101 -G starter starter \
 && apk add --no-cache sudo \
 && mkdir /environment \
 && ln -s /start/stage1 /start/start \
 && echo 'Defaults lecture="never"' > /etc/sudoers.d/docker1 \
 && echo 'Defaults secure_path="/start:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' >> /etc/sudoers.d/docker1 \
 && echo 'Defaults env_keep = "VAR_*"' > /etc/sudoers.d/docker2 \
 && echo 'Defaults !root_sudo' >> /etc/sudoers.d/docker2 \
 && echo "starter ALL=(root) NOPASSWD: /start/start" >> /etc/sudoers.d/docker2

FROM scratch

COPY --from=stage1 / /

RUN chmod o= /bin /sbin /usr/bin /usr/sbin \
 && chmod 7700 /environment /start \
 && chmod u+x /start/stage1 /start/stage2 \
 && chown :starter /usr/bin/sudo \
 && chmod u+s,o-rx /usr/bin/sudo \
 && chmod u=rw,go= /etc/sudoers.d/docker* \
 && ln /usr/bin/sudo /usr/local/bin/sudo

ENV VAR_LINUX_USER="root" \
    VAR_ARGON2_PARAMS="-r" \
    VAR_SALT_FILE="/proc/sys/kernel/hostname" \
    PATH="$PATH:/start" \
    HISTFILE="/dev/null"

USER starter

CMD ["sudo","start"]
