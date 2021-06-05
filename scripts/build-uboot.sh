#! /bin/bash

export uboot_defconfig="am335x_evm_defconfig"
export kernel_version="5.10.35"
export CC=arm-linux-gnueabihf-

echo "compiling u-boot ..."
cd /lfs/tmp/u-boot
# make ARCH=arm CROSS_COMPILE="ccache ${CC}" distclean
make ARCH=arm CROSS_COMPILE="ccache ${CC}" ${uboot_defconfig}
make ARCH=arm CROSS_COMPILE="ccache ${CC}" -j$(nproc)

echo "installing u-boot files ..."
sh -c "echo 'uname_r=${kernel_version}\nconsole=ttyO0,115200n8' >> /lfs/tmp/rootfs/boot/uEnv.txt"
cp /lfs/tmp/u-boot/MLO /lfs/tmp/rootfs/boot
cp /lfs/tmp/u-boot/u-boot.img /lfs/tmp/rootfs/boot
cp /lfs/tmp/u-boot/MLO /lfs/tmp/rootfs/rootfs/boot/uboot
cp /lfs/tmp/u-boot/u-boot.img /lfs/tmp/rootfs/rootfs/boot/uboot