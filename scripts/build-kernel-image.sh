#! /bin/bash

set -e

export CC="arm-linux-gnueabihf-"
export CACHED_CC="ccache $CC"

echo "Compiling kernel image ..."

cd /lfs/tmp/kernel

# make ARCH=arm CROSS_COMPILE=${CC} distclean
# make ARCH=arm CROSS_COMPILE=${CC} clean
make ARCH=arm CROSS_COMPILE=${CC} bb.org_defconfig

echo "[make ARCH=arm -j$(nproc) CROSS_COMPILE=\"${CACHED_CC}\" zImage]"
make ARCH=arm -j$(nproc) CROSS_COMPILE="${CACHED_CC}" zImage
if [ ! -f arch/arm/boot/zImage ] ; then
	echo "failed: [arch/arm/boot/zImage]"
	exit 1
fi

echo "Finished compiling kernel image"