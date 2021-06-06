#! /bin/bash

set -e

export ECHO_PREFIX="[\e[96mImage-Builder\e[0m] "

export CC="arm-linux-gnueabihf-"
export CACHED_CC="ccache $CC"

echo -e "${ECHO_PREFIX}Compiling kernel image ..."

cd /lfs/tmp/kernel

# make ARCH=arm CROSS_COMPILE=${CC} distclean
# make ARCH=arm CROSS_COMPILE=${CC} clean
make ARCH=arm CROSS_COMPILE=${CC} bb.org_defconfig

echo -e "${ECHO_PREFIX}[make ARCH=arm -j$(nproc) CROSS_COMPILE=\"${CACHED_CC}\" zImage]"
make ARCH=arm -j$(nproc) CROSS_COMPILE="${CACHED_CC}" zImage
if [ ! -f arch/arm/boot/zImage ] ; then
	echo -e "${ECHO_PREFIX}failed: [arch/arm/boot/zImage]"
	exit 1
fi

echo -e "${ECHO_PREFIX}Finished compiling kernel image"