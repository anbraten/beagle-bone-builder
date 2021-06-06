#! /bin/bash

set -e

export ECHO_PREFIX="[\e[96mImage-Builder\e[0m] "

export CC="arm-linux-gnueabihf-"
export CACHED_CC="ccache $CC"

echo -e "${ECHO_PREFIX}Installing kernel ..."

cd /lfs/tmp/kernel

# install kernel modules and headers
make ARCH=arm CROSS_COMPILE="${CACHED_CC}" -j$(nproc) modules_install INSTALL_MOD_PATH=/lfs/tmp/fs/rootfs
make ARCH=arm CROSS_COMPILE="${CACHED_CC}" -j$(nproc) headers_install INSTALL_HDR_PATH=/lfs/tmp/fs/rootfs/usr

# install kernel binary and device tree
cp arch/arm/boot/zImage /lfs/tmp/fs/rootfs/boot
cp arch/arm/boot/dts/am335x-boneblack.dtb /lfs/tmp/fs/rootfs/boot

# make ARCH=arm CROSS_COMPILE="${CC}" clean

echo -e "${ECHO_PREFIX}Finished installing kernel"