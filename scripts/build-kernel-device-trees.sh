#! /bin/bash

set -e

source /lfs/scripts/config.sh

echo -e "${ECHO_PREFIX}Compiling kernel modules ..."

cd /lfs/tmp/kernel

echo -e "${ECHO_PREFIX}[make ARCH=arm CROSS_COMPILE=\"${CACHED_CC}\" dtbs]"
make ARCH=arm CROSS_COMPILE="${CACHED_CC}" dtbs
if [ ! -f arch/arm/boot/dts/am335x-boneblack.dtb ] ; then
	echo -e "${ECHO_PREFIX}failed: [arch/arm/boot/dts/am335x-boneblack.dtb]"
	exit 1
fi

# install device tree
mkdir -p /lfs/tmp/fs/rootfs/boot/dtbs/${KERNEL_VERSION}/
# cp arch/arm/boot/dts/am335x-boneblack.dtb /lfs/tmp/fs/rootfs/boot/dtbs/${KERNEL_VERSION}/
cp arch/arm/boot/dts/am335x-boneblack.dtb /lfs/tmp/fs/rootfs/boot/

echo -e "${ECHO_PREFIX}Finished compiling & installing kernel device-tree"