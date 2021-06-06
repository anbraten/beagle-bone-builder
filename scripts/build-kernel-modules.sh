#! /bin/bash

set -e

export ECHO_PREFIX="[\e[96mImage-Builder\e[0m] "

export CC="arm-linux-gnueabihf-"
export CACHED_CC="ccache $CC"

echo -e "${ECHO_PREFIX}Compiling kernel modules ..."

cd /lfs/tmp/kernel

echo -e "${ECHO_PREFIX}[make ARCH=arm -j$(nproc) CROSS_COMPILE=\"${CACHED_CC}\" modules]"
make ARCH=arm -j$(nproc) CROSS_COMPILE="${CACHED_CC}" modules
if [ ! -f drivers/spi/spidev.ko ] ; then
	echo -e "${ECHO_PREFIX}failed: [drivers/spi/spidev.ko]"
	exit 1
fi

echo -e "${ECHO_PREFIX}Finished compiling kernel modules"