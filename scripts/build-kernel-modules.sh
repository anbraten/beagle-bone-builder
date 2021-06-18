#! /bin/bash

set -e

source /lfs/scripts/config.sh

echo -e "${ECHO_PREFIX}Compiling kernel modules ..."

cd /lfs/tmp/kernel

echo -e "${ECHO_PREFIX}[make ARCH=arm -j$(nproc) CROSS_COMPILE=\"${CACHED_CC}\" modules]"
make ARCH=arm -j$(nproc) CROSS_COMPILE="${CACHED_CC}" modules
# if [ ! -f drivers/spi/spidev.ko ] ; then
# 	echo -e "${ECHO_PREFIX}failed: [drivers/spi/spidev.ko]"
# 	exit 1
# fi

# install kernel modules and headers
make ARCH=arm CROSS_COMPILE="${CACHED_CC}" -j$(nproc) modules_install INSTALL_MOD_PATH=/lfs/tmp/fs/rootfs
# make ARCH=arm CROSS_COMPILE="${CACHED_CC}" -j$(nproc) headers_install INSTALL_HDR_PATH=/lfs/tmp/fs/rootfs/usr

echo -e "${ECHO_PREFIX}Finished compiling kernel modules"