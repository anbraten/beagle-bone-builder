#! /bin/bash

set -e

source /lfs/scripts/config.sh

echo -e "${ECHO_PREFIX}Compiling kernel image ..."

cd /lfs/tmp/kernel

make ARCH=arm CROSS_COMPILE=${CC} clean
make ARCH=arm CROSS_COMPILE=${CC} bb.org_defconfig

echo -e "${ECHO_PREFIX}[make ARCH=arm -j$(nproc) CROSS_COMPILE=\"${CACHED_CC}\" zImage]"
make ARCH=arm -j$(nproc) CROSS_COMPILE="${CACHED_CC}" zImage
if [ ! -f arch/arm/boot/zImage ] ; then
	echo -e "${ECHO_PREFIX}failed: [arch/arm/boot/zImage]"
	exit 1
fi

# install kernel binary
cp arch/arm/boot/zImage /lfs/tmp/fs/rootfs/boot/
# cp arch/arm/boot/zImage /lfs/tmp/fs/rootfs/boot/vmlinuz-${KERNEL_VERSION}

echo -e "${ECHO_PREFIX}Finished compiling and installing kernel binary"