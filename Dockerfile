FROM ubuntu:21.04

RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y \
    xz-utils bc bison flex libssl-dev libc6-dev libncurses5-dev lzop kmod fdisk \
    util-linux kpartx dosfstools e2fsprogs gddrescue qemu-utils \
    ccache cpio wget git make rsync

ENV PATH "/lfs/tmp/linaro/bin:/usr/lib/ccache:${PATH}"
ENV CCACHE_DIR "/lfs/tmp/ccache"

RUN mkdir -p /lfs/output /lfs/tmp/ /lfs/linaro /lfs/resources /lfs/tmp/ccache

WORKDIR /lfs
CMD [ "/lfs/scripts/build-all.sh" ]

# copy scripts and set permissions
RUN mkdir -p /lfs/scripts/
COPY ./scripts/* /lfs/scripts/
RUN chmod +x /lfs/scripts/*
