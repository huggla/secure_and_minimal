FROM alpine:3.7

# Build only variable
ENV LANG="en_US.UTF-8"

# Constants
ENV CONST_BIN_DIR="/usr/local/bin" \
    CONST_SUDOERS_DIR="/etc/sudoers.d"

COPY ./bin ${CONST_BIN_DIR}

RUN addgroup -S sudoer \
 && adduser -D -S -H -s /bin/false -u 101 -G sudoer sudoer \
 && chmod go= /bin /sbin /usr/bin /usr/sbin "$CONST_BIN_DIR" \
 && chmod u+x "$CONST_BIN_DIR/"* \
 && apk add --no-cache sudo \
 && mkdir -p /usr/local/sbin \
 && ln /usr/bin/sudo /usr/local/sbin/sudo \
 && chown root:sudoer /usr/local/sbin \
 && chmod ug=rx,o= /usr/local/sbin \
 && echo 'Defaults lecture="never"' > "$CONST_SUDOERS_DIR/docker1" \
 && echo 'Defaults secure_path="/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' >> "$CONST_SUDOERS_DIR/docker1" \
 && echo 'Defaults env_keep = "CONST_ VAR_"' > "$CONST_SUDOERS_DIR/docker2" \
 && echo 'Defaults !root_sudo' >> "$CONST_SUDOERS_DIR/docker2" \
 && echo "sudoer ALL=(root) NOPASSWD: $CONST_BIN_DIR/start.stage1" >> "$CONST_SUDOERS_DIR/docker2" \
 && chmod u=rw,go= "$CONST_SUDOERS_DIR/docker"*

# Variables
ENV VAR_LINUX_USER="root" \
    VAR_ENVIRONMENT_DIR="/environment"

USER sudoer

CMD ["sudo","start.stage1"]
