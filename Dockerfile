FROM ghcr.io/void-linux/void-glibc-full
RUN xbps-install -Suy  bash eudev rpi5-kernel
RUN xbps-install -y git cargo make
RUN xbps-install -y libzstd-devel openssl-devel pkg-config \
glib-devel libostree-devel libarchive-devel
RUN git clone https://github.com/bootc-dev/bootc.git
WORKDIR /bootc
ENV PKG_CONFIG_PATH="/usr/lib/pkgconfig:$PATH"
RUN make
RUN make install
RUN xbps-install skopeo -y
#-------------------------------------------
WORKDIR /
RUN mkdir -p /sysroot/ostree
COPY prepare-root.conf /etc/ostree/prepare-root.conf
COPY 00-pingipie.toml /usr/lib/bootc/install/
RUN ln -sf sysroot/ostree /ostree
LABEL ostree.bootable=true
WORKDIR /sysroot/ostree
RUN ostree init --repo .
