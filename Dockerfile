ARG RUNDEPS="sudo dash argon2"
ARG MAKEDIRS="/environment"
ARG EXECUTABLES="/usr/bin/sudo /usr/bin/dash /usr/bin/argon2"

FROM huggla/busybox:20180921-edge as init

FROM huggla/build as build
