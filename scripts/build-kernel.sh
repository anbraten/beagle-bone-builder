#! /bin/bash

export CC=arm-linux-gnueabihf-

cd /lfs/tmp/kernel
# make ARCH=arm CROSS_COMPILE=${CC} distclean
# make ARCH=arm CROSS_COMPILE=${CC} clean
make ARCH=arm CROSS_COMPILE=${CC} bb.org_defconfig

echo "[make ARCH=arm -j$(nproc) CROSS_COMPILE=\"ccache ${CC}\" zImage]"
make ARCH=arm -j$(nproc) CROSS_COMPILE="ccache ${CC}" zImage
if [ ! -f arch/arm/boot/zImage ] ; then
	echo "failed: [arch/arm/boot/zImage]"
	exit 1
fi

echo "[make ARCH=arm -j$(nproc) CROSS_COMPILE=\"ccache ${CC}\" modules]"
make ARCH=arm -j$(nproc) CROSS_COMPILE="ccache ${CC}" modules
if [ ! -f drivers/spi/spidev.ko ] ; then
	echo "failed: [drivers/spi/spidev.ko]"
	exit 1
fi

echo "[make ARCH=arm CROSS_COMPILE=\"ccache ${CC}\" dtbs]"
make ARCH=arm CROSS_COMPILE="ccache ${CC}" dtbs
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

# install kernel modules and headers
make ARCH=arm CROSS_COMPILE="ccache ${CC}" -j$(nproc) modules_install INSTALL_MOD_PATH=/lfs/tmp/rootfs/rootfs
make ARCH=arm CROSS_COMPILE="ccache ${CC}" -j$(nproc) headers_install INSTALL_HDR_PATH=/lfs/tmp/rootfs/rootfs/usr

# install kernel binary and device tree
cp arch/arm/boot/zImage /lfs/tmp/rootfs/rootfs/boot
cp arch/arm/boot/dts/am335x-boneblack.dtb /lfs/tmp/rootfs/rootfs/boot

# make ARCH=arm CROSS_COMPILE="ccache ${CC}" clean
