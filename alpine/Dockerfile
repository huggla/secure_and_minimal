FROM alpine:edge as alpine

RUN mkdir -p /finalfs/etc \
 && cp -a /etc/resolv.conf /etc/apk/repositories /etc/apk/keys /finalfs/etc/ \
 && apk --no-cache --root /finalfs --repositories-file /etc/apk/repositories --keys-dir /etc/apk/keys add --initdb alpine-base \
 && { \
       echo '#!/bin/sh' && \
       echo 'apk --no-cache --repositories-file /etc/repositories --keys-dir /etc/keys add --initdb alpine-base &&' && \
       echo 'rm -rf /etc/keys &&' && \
       echo 'mv -f /etc/repositories /etc/apk/ &&' \
 && } > /finalfs/cmds.sh \
 && chmod +x /finalfs/cmds.sh \
 && chroot /finalfs ./cmds.sh
 
FROM scratch

COPY --from=alpine /finalfs /

ONBUILD RUN apk --no-cache --purge upgrade
