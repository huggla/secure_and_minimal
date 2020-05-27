# Secure and Minimal
# https://hub.docker.com/repository/docker/huggla/secure_and_minimal

ARG SaM_IMAGE="busybox"
ARG SaM_VERSION="dev"

FROM huggla/secure_and_minimal:$SaM_VERSION-alpine as alpine

RUN exec 2>&1 \
 && set -x \
 && mkdir -m 755 /finalfs \
 && mkdir -m 755 /finalfs/lib /finalfs/usr \
 && mkdir -m 755 /finalfs/usr/local /finalfs/usr/lib \
 && mkdir -m 755 /finalfs/usr/local/bin \
 && mkdir -m 700 /finalfs/bin /finalfs/sbin /finalfs/environment \
 && mkdir -m 750 /finalfs/etc /finalfs/var /finalfs/run \
 && mkdir -m 770 /finalfs/tmp \
 && mkdir -m 700 /finalfs/usr/bin /finalfs/usr/sbin /tmp/onbuild /finalfs/etc/apk \
 && mkdir -m 750 /finalfs/var/cache /finalfs/var/log \
 && >/finalfs/environment/startupexecutables \
 && >/finalfs/environment/gid0writables \
 && >/finalfs/environment/gid0writablesrecursive \
 && >/finalfs/environment/linuxuserowned \
 && >/finalfs/environment/linuxuserownedrecursive \
 && echo "musl" > /finalfs/etc/apk/world \
 && echo "busybox" >> /finalfs/etc/apk/world \
 && cp -a /lib/libz.so* /lib/*musl* /finalfs/lib/ \
 && cp -a /bin/busybox /bin/sh /finalfs/bin/ \
 && cp -a $(find /bin/* -type l | xargs) /finalfs/bin/ \
 && cp -a $(find /sbin/* -type l | xargs) /finalfs/sbin/ \
 && cp -a $(find /usr/bin/* -type l | xargs) /finalfs/usr/bin/ \
 && cp -a $(find /usr/sbin/* -type l | xargs) /finalfs/usr/sbin/ \
 && echo 'root:x:0:0:root:/dev/null:/sbin/nologin' > /finalfs/etc/passwd \
 && echo 'root:x:0:' > /finalfs/etc/group \
 && echo 'starter:x:101:101:starter:/dev/null:/sbin/nologin' >> /finalfs/etc/passwd \
 && echo 'starter:x:101:' >> /finalfs/etc/group \
 && chmod 640 /finalfs/etc/passwd /finalfs/etc/group \
 && cd /finalfs/var \
 && ln -sf ../tmp tmp \
 && ln -sf ../run run \
 && /finalfs/bin/busybox rm -rf /home /usr /var /root /media /mnt /run /sbin /srv /etc /bin/* || /finalfs/bin/busybox true \
 && /finalfs/bin/busybox cp -a /finalfs/bin/* /bin/ \
 && /finalfs/bin/busybox chroot /finalfs /bin/busybox find . -type l -exec /bin/busybox test ! -e {} \; -delete \
 && cd /finalfs \
 && (/finalfs/bin/busybox find . -type l ! -path './tmp/*' ! -path './var/cache/*' -exec /finalfs/bin/busybox sh -c 'echo -n "$(echo "{}" | /finalfs/bin/busybox cut -c 2-)>"' \; -exec /finalfs/bin/busybox readlink "{}" \; && /finalfs/bin/busybox find . -type f ! -path './tmp/*' ! -path './var/cache/*' -exec /finalfs/bin/busybox md5sum "{}" \; | /finalfs/bin/busybox awk '{first=$1; $1=""; print $0">"first}' | /finalfs/bin/busybox sed 's|^ [.]||') | /finalfs/bin/busybox sort -u - > /tmp/onbuild/exclude.filelist \
 && /finalfs/bin/busybox tar -c -z -f /finalfs/environment/onbuild.tar.gz -C /tmp onbuild \
 && echo '.' \
 && echo '**************** Image contents ****************' \
 && /finalfs/bin/busybox chroot /finalfs /bin/busybox ls -laR / \
 && echo '************************************************' \
 && echo '.'

FROM scratch as image

COPY --from=alpine /finalfs /
