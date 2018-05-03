FROM alpine:3.7

# Build-only variables
ENV LANG="en_US.UTF-8"

COPY ./start /start

RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/main/ argon2 \
 && addgroup -S starter \
 && adduser -D -S -H -s /bin/false -u 101 -G starter starter \
 && chmod go= /bin /sbin /usr/bin /usr/sbin \
 && apk add --no-cache sudo \
 && mkdir /environment \
 && chmod 7700 /environment /start \
 && chmod u+x /start/stage1 /start/stage2 \
 && touch /environment/firstrun /environment/restart \
 && chown :starter /usr/bin/sudo \
 && chmod u+s,o-rx /usr/bin/sudo \
 && ln /usr/bin/sudo /usr/local/bin/sudo \
 && ln -s /start/stage1 /start/start \
 && echo 'Defaults lecture="never"' > /etc/sudoers.d/docker1 \
 && echo 'Defaults secure_path="/start:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' >> /etc/sudoers.d/docker1 \
 && echo 'Defaults env_keep = "VAR_*"' > /etc/sudoers.d/docker2 \
 && echo 'Defaults !root_sudo' >> /etc/sudoers.d/docker2 \
 && echo "starter ALL=(root) NOPASSWD: /start/start" >> /etc/sudoers.d/docker2 \
 && chmod u=rw,go= /etc/sudoers.d/docker*

# Variables
ENV VAR_LINUX_USER="root" \
    PATH="$PATH:/start" \
    HISTFILE="/dev/null"

USER starter

CMD ["sudo","start"]
