#! /bin/bash

# create directories
mkdir -p /lfs/output /lfs/kernel /lfs/u-boot /lfs/rootfs/boot /lfs/rootfs/rootfs /lfs/linaro /lfs/rootfs/rootfs/boot

# extract copied files
# tar xpf /lfs/resources/kernel.tar.gz -C /lfs/kernel --strip-components=1
git clone https://github.com/beagleboard/linux.git /lfs/kernel
git checkout 5.10

# compile Kernel
cd /lfs/kernel
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- distclean
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- ${kernel_defconfig}
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j$(nproc) zImage dtbs modules

# install kernel modules and headers
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j$(nproc) modules_install INSTALL_MOD_PATH=/lfs/rootfs/rootfs
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j$(nproc) headers_install INSTALL_HDR_PATH=/lfs/rootfs/rootfs/usr

# install kernel binary and device tree
cp /lfs/kernel/arch/arm/boot/zImage /lfs/rootfs/rootfs/boot
cp /lfs/kernel/arch/arm/boot/dts/am335x-boneblack.dtb /lfs/rootfs/rootfs/boot
