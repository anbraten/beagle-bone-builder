#! /bin/bash

set -e

export CC="arm-linux-gnueabihf-"
export CACHED_CC="ccache $CC"

echo "Installing kernel ..."

cd /lfs/tmp/kernel

# install kernel modules and headers
make ARCH=arm CROSS_COMPILE="${CACHED_CC}" -j$(nproc) modules_install INSTALL_MOD_PATH=/lfs/tmp/fs/rootfs
make ARCH=arm CROSS_COMPILE="${CACHED_CC}" -j$(nproc) headers_install INSTALL_HDR_PATH=/lfs/tmp/fs/rootfs/usr

# install kernel binary and device tree
cp arch/arm/boot/zImage /lfs/tmp/fs/rootfs/boot
cp arch/arm/boot/dts/am335x-boneblack.dtb /lfs/tmp/fs/rootfs/boot

# make ARCH=arm CROSS_COMPILE="${CC}" clean

# set /etc/fstab
sh -c "echo '/dev/mmcblk0p1  /  auto  errors=remount-ro  0  1' >> /lfs/tmp/fs/rootfs/etc/fstab"

# update /etc/network/interfaces
cat <<EOT >> /lfs/tmp/fs/rootfs/etc/network/interfaces
#/etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
EOT

echo "Finished installing kernel"