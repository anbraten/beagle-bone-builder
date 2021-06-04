#! /bin/bash

# create directories
mkdir -p /lfs/output /lfs/tmp/kernel /lfs/tmp/u-boot /lfs/tmp/rootfs/boot /lfs/tmp/rootfs/rootfs /lfs/tmp/rootfs/rootfs/boot

# extract copied files
# tar xpf /lfs/resources/kernel.tar.gz -C /lfs/kernel --strip-components=1
git clone -b 5.10 --single-branch https://github.com/beagleboard/linux.git /lfs/tmp/kernel

# compile Kernel
cd /lfs/tmp/kernel
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- distclean
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- ${kernel_defconfig}
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j$(nproc) zImage dtbs modules

# install kernel modules and headers
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j$(nproc) modules_install INSTALL_MOD_PATH=/lfs/tmp/rootfs/rootfs
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j$(nproc) headers_install INSTALL_HDR_PATH=/lfs/tmp/rootfs/rootfs/usr

# install kernel binary and device tree
cp /lfs/tmp/kernel/arch/arm/boot/zImage /lfs/tmp/rootfs/rootfs/boot
cp /lfs/tmp/kernel/arch/arm/boot/dts/am335x-boneblack.dtb /lfs/tmp/rootfs/rootfs/boot
