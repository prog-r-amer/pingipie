FROM ghcr.io/void-linux/void-glibc-full
RUN xbps-install -Suy  bash rpi5-kernel
RUN xbps-install -y git cargo make
RUN xbps-install -y libzstd-devel openssl-devel pkg-config \
glib-devel libostree-devel libarchive-devel
RUN git clone https://github.com/bootc-dev/bootc.git
WORKDIR /bootc
ENV PKG_CONFIG_PATH="/usr/lib/pkgconfig:$PATH"
RUN make
RUN make install
CMD ["bash", "-i"]
