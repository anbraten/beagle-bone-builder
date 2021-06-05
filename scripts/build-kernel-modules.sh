#! /bin/bash

set -e

export CC="arm-linux-gnueabihf-"
export CACHED_CC="ccache $CC"

echo "Compiling kernel modules ..."

cd /lfs/tmp/kernel

echo "[make ARCH=arm -j$(nproc) CROSS_COMPILE=\"${CACHED_CC}\" modules]"
make ARCH=arm -j$(nproc) CROSS_COMPILE="${CACHED_CC}" modules
if [ ! -f drivers/spi/spidev.ko ] ; then
	echo "failed: [drivers/spi/spidev.ko]"
	exit 1
fi

echo "Finished compiling kernel modules"