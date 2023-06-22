FROM --platform=linux/arm64 opensuse/leap:15.4

ARG GROMMUNIO_REPO=openSUSE_Leap_15.4

ARG S6_OVERLAY_VERSION=3.1.4.1

# Install Grommunio packages
RUN zypper install -y curl
RUN curl https://download.grommunio.com/RPM-GPG-KEY-grommunio > gr.key
RUN rpm --import gr.key
RUN zypper --non-interactive --quiet ar -C https://download.grommunio.com/community/${GROMMUNIO_REPO} grommunio
RUN zypper --gpg-auto-import-keys ref
RUN zypper -n refresh grommunio
RUN zypper in -y gromox grommunio-common mariadb-client nginx nginx-module-vts nginx-module-brotli nginx-module-zstd postfix grommunio-antispam grommunio-web redis postfix-mysql vim xz tar
RUN zypper clean --all
# Fix bug with binaries on arm. no idea why it does this but this works.
RUN ln -s /usr/lib64/nginx /usr/lib/nginx

# Setup S6
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-aarch64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-aarch64.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-symlinks-arch.tar.xz

# Setup configuration
RUN \  
  sed -i 's/^level = "info";$/level = "notice";/' /etc/grommunio-antispam/logging.inc
RUN   postconf -e -v virtual_alias_maps=mysql:/etc/postfix/g-alias.cf
RUN   postconf -e -v virtual_mailbox_domains=mysql:/etc/postfix/g-virt.cf
RUN   postconf -e -v virtual_transport="smtp:[localhost]:24"

# Setup services in s6
COPY build-assets/s6-overlay/ /etc/s6-overlay/

ENTRYPOINT ["/init"]
