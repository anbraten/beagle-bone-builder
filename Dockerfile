FROM ubuntu:21.04

ENV PATH "/lfs/linaro/bin:${PATH}"

RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y \
    xz-utils bc bison flex libssl-dev make libc6-dev libncurses5-dev lzop kmod \
    util-linux kpartx dosfstools e2fsprogs gddrescue qemu-utils wget git

# setup linaro
RUN mkdir -p /lfs/linaro
ARG LINARO_DOWNLOAD="https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/arm-linux-gnueabihf/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz"
RUN wget -q -O /lfs/linaro.tar ${LINARO_DOWNLOAD}
RUN tar xpf /lfs/linaro.tar -C /lfs/linaro --strip-components=1

WORKDIR /lfs

# copy scripts and set permissions
RUN mkdir -p /lfs/scripts/
COPY ./scripts/* /lfs/scripts/
RUN chmod +x /lfs/scripts/*

CMD [ "/lfs/scripts/build-all.sh" ]

