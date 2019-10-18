# =========================================================================
# Init
# =========================================================================
# ARGs (can be passed to Build/Final) <BEGIN>
ARG SaM_VERSION="1.0"
ARG TAG="20191018"
ARG IMAGETYPE="secure_and_minimal"
ARG BASEIMAGE="huggla/busybox:$SaM_VERSION-$TAG"
ARG RUNDEPS="sudo dash argon2 libcap"
ARG MAKEFILES="/etc/sudoers.d/docker1 /etc/sudoers.d/docker2"
ARG REMOVEFILES="/usr/sbin/visudo /usr/bin/sudoreplay /usr/bin/cvtsudoers /usr/bin/sudoedit"
ARG EXECUTABLES="/usr/bin/sudo /usr/bin/dash /usr/bin/argon2"
ARG FINALCMDS=\
"   echo 'Defaults lecture=\"never\"' > ./etc/sudoers.d/docker1 "\
"&& echo 'Defaults secure_path=\"/start:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\"' >> ./etc/sudoers.d/docker1 "\
"&& echo 'Defaults env_keep = \"VAR_*\"' > ./etc/sudoers.d/docker2 "\
"&& echo 'Defaults !root_sudo' >> ./etc/sudoers.d/docker2 "\
"&& echo 'starter ALL=(root) NOPASSWD: /start/start' >> ./etc/sudoers.d/docker2 "\
"&& echo 'root ALL=(ALL) ALL' > ./etc/sudoers "\
"&& echo '#includedir /etc/sudoers.d' >> ./etc/sudoers "\
"&& echo 'exec /bin/sh' > ./usr/bin/script "\
"&& chmod u+x ./usr/bin/script "\
"&& cd ./start "\
"&& ln -s stage1 start "\
"&& cd ../stop "\
"&& ln -s ../start/includeFunctions ./ "\
"&& cd ./functions "\
"&& ln -s ../../start/functions/readEnvironmentVars ../../start/functions/sourceDirs ./ "\
"&& cd ../../ "\
"&& chmod u=rx,g= ./start/stage1 ./start/stage2 ./start/delayedDisableStartupExecutables "\
"&& chmod -R g=r ./stop "\
"&& chmod g=rx ./stop ./stop/functions "\
"&& chmod u=rwx,g=rx ./stop/stage1"
# ARGs (can be passed to Build/Final) </END>

# Generic template (don't edit) <BEGIN>
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${CONTENTIMAGE3:-scratch} as content3
FROM ${CONTENTIMAGE4:-scratch} as content4
FROM ${CONTENTIMAGE5:-scratch} as content5
FROM ${INITIMAGE:-${BASEIMAGE:-huggla/base:$SaM_VERSION-$TAG}} as init
# Generic template (don't edit) </END>

# =========================================================================
# Build
# =========================================================================
# Generic template (don't edit) <BEGIN>
FROM ${BUILDIMAGE:-huggla/build:$SaM_VERSION-$TAG} as build
FROM ${BASEIMAGE:-huggla/base:$SaM_VERSION-$TAG} as final
COPY --from=build /finalfs /
# Generic template (don't edit) </END>

# =========================================================================
# Final
# =========================================================================
# RUNs and ENVs <BEGIN>
RUN chgrp -R 101 /usr/lib/sudo /usr/local/bin/sudo \
 && chmod u+s /usr/local/bin/sudo
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/start" \
    VAR_LINUX_USER="root" \
    VAR_FINAL_COMMAND="pause" \
    VAR_ARGON2_PARAMS="-r" \
    VAR_SALT_FILE="/proc/sys/kernel/hostname" \
    HISTFILE="/dev/null"
# RUNs and ENVs </END>

# Generic template (don't edit) <BEGIN>
USER starter
ONBUILD USER root
# Generic template (don't edit) </END>

# Entrypoint and/or CMD <BEGIN>
CMD ["sudo","start"]
# Entrypoint and/or CMD </END>
