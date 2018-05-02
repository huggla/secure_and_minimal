FROM alpine:3.7

# Build-only variables
ENV LANG="en_US.UTF-8"

COPY ./start /start

RUN addgroup -S starter \
 && adduser -D -S -H -s /bin/false -u 101 -G starter starter \
 && chmod go= /bin /sbin /usr/bin /usr/sbin \
 && apk add --no-cache sudo \
 && mkdir /environment \
 && chmod 7700 /environment /start \
 && chmod u+x /start/stage1 \
 && touch /environment/firstrun /environment/restart \
 && chown root:starter /usr/bin/sudo \
 && ln /usr/bin/sudo /usr/local/bin/sudo \
 && chmod o-rx /usr/local/bin/sudo \
 && chown root /usr/local/bin/sudo \
 && chmod u+s /usr/local/bin/sudo \
 && ln -s /start/stage1 /start/start \
 && echo 'Defaults lecture="never"' > /etc/sudoers.d/docker1 \
 && echo 'Defaults secure_path="/start:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' >> /etc/sudoers.d/docker1 \
 && echo 'Defaults env_keep = "CONST_ VAR_"' > /etc/sudoers.d/docker2 \
 && echo 'Defaults !root_sudo' >> /etc/sudoers.d/docker2 \
 && echo "starter ALL=(root) NOPASSWD: /start/stage1" >> /etc/sudoers.d/docker2 \
 && chmod u=rw,go= /etc/sudoers.d/docker* \
 && echo "unset \$(/usr/bin/env | /usr/bin/awk -F '=' '{print \$1\}' | /usr/bin/tr \"\\n\" \" \")" > /start/test

# Variables
ENV VAR_LINUX_USER="root" \
    PATH="$PATH:/start" \
    HISTFILE="/dev/null"

USER starter

CMD ["sudo","start"]
