#! /bin/bash

set -e

export CC="arm-linux-gnueabihf-"
export CACHED_CC="ccache $CC"

echo "Compiling kernel modules ..."

cd /lfs/tmp/kernel

echo "[make ARCH=arm CROSS_COMPILE=\"${CACHED_CC}\" dtbs]"
make ARCH=arm CROSS_COMPILE="${CACHED_CC}" dtbs
if [ ! -f arch/arm/boot/dts/am335x-boneblack.dtb ] ; then
	echo "failed: [arch/arm/boot/dts/am335x-boneblack.dtb]"
	exit 1
else
	if [ -f arch/arm/boot/dts/am335x-pocketbeagle.dts ] ; then
		if [ ! -f arch/arm/boot/dts/am335x-pocketbeagle.dtb ] ; then
			echo "failed: [arch/arm/boot/dts/am335x-pocketbeagle.dtb]"
			exit 1
		fi
	fi
fi

echo "Finished compiling kernel modules"