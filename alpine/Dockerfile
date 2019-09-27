ARG SaM_VERSION="1.0"

FROM alpine:edge as alpine

RUN exec 2>&1 \
 && set -x \
 && echo "alpine-base" > /etc/apk/world \
 && apk --no-cache --purge --force-overwrite --force-refresh fix -d -r -u -x --directory-permissions alpine-base \
 && mkdir -p /finalfs/etc/apk \
 && cp -a /etc/resolv.conf /finalfs/etc/ \
 && cp -a /etc/apk/repositories /finalfs/etc/apk/ \
 && apk --no-cache --root /finalfs --keys-dir /etc/apk/keys --initramfs-diskless-boot --clean-protected add --initdb alpine-base

FROM scratch

COPY --from=alpine /finalfs /

ONBUILD RUN apk --no-cache --purge --initramfs-diskless-boot --clean-protected upgrade
