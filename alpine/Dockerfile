FROM alpine:edge

RUN apk --no-cache --initramfs-diskless-boot --clean-protected upgrade

ONBUILD RUN apk --no-cache --initramfs-diskless-boot --clean-protected upgrade
