FROM alpine:3.7

# Build only variables
ENV LANG="en_US.UTF-8" \
    bin_dir="/usr/local/bin" \
    sudoers_dir="/etc/sudoers.d"

# Constants
ENV CONST_ENVIRONMENT_DIR="/environment"

COPY ./bin ${bin_dir}

RUN addgroup -S sudoer \
 && adduser -D -S -H -s /bin/false -u 101 -G sudoer sudoer \
 && chmod go= /bin /sbin /usr/bin /usr/sbin \
 && chmod u+x "$bin_dir/"* \
 && apk add --no-cache sudo \
 && mkdir -p /usr/local/sbin \
 && ln /usr/bin/sudo /usr/local/sbin/sudo \
 && chown root:sudoer /usr/local/sbin \
 && chmod ug=rx,o= /usr/local/sbin "$bin_dir" \
 && echo 'Defaults lecture="never"' > "$sudoers_dir/docker-const" \
 && echo 'Defaults secure_path="/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' >> "$sudoers_dir/docker-const" \
 && echo 'Defaults env_keep = "CONST_ VAR_"' > "$sudoers_dir/docker-var" \
 && echo 'Defaults !root_sudo' >> "$sudoers_dir/docker-var" \
 && echo "sudoer ALL=(root) NOPASSWD: $bin_dir/start.stage1" >> "$sudoers_dir/docker-var" \
 && chmod u=r,go= "$sudoers_dir/docker-const" \
 && chmod u=rw,go= "$sudoers_dir/docker-var"

# Variables
ENV VAR_LINUX_USER="root"

USER sudoer

CMD ["sudo","start.stage1"]
