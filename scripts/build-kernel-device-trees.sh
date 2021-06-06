#! /bin/bash

set -e

export ECHO_PREFIX="[\e[96mImage-Builder\e[0m] "

export CC="arm-linux-gnueabihf-"
export CACHED_CC="ccache $CC"

echo -e "${ECHO_PREFIX}Compiling kernel modules ..."

cd /lfs/tmp/kernel

echo -e "${ECHO_PREFIX}[make ARCH=arm CROSS_COMPILE=\"${CACHED_CC}\" dtbs]"
make ARCH=arm CROSS_COMPILE="${CACHED_CC}" dtbs
if [ ! -f arch/arm/boot/dts/am335x-boneblack.dtb ] ; then
	echo -e "${ECHO_PREFIX}failed: [arch/arm/boot/dts/am335x-boneblack.dtb]"
	exit 1
else
	if [ -f arch/arm/boot/dts/am335x-pocketbeagle.dts ] ; then
		if [ ! -f arch/arm/boot/dts/am335x-pocketbeagle.dtb ] ; then
			echo -e "${ECHO_PREFIX}failed: [arch/arm/boot/dts/am335x-pocketbeagle.dtb]"
			exit 1
		fi
	fi
fi

echo -e "${ECHO_PREFIX}Finished compiling kernel modules"