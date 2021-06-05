#! /bin/bash

set -e

export UBOOT_DOWNLOAD="https://github.com/u-boot/u-boot/archive/refs/tags/v2021.04.tar.gz"
export UBOOT_PATCH="https://github.com/eewiki/u-boot-patches/raw/master/v2020.10-rc2/0001-am57xx_evm-fixes.patch"
export uboot_defconfig="am335x_evm_defconfig"
export kernel_version="5.10.35"
export CC=arm-linux-gnueabihf-

if [ ! -f /lfs/resources/u-boot.tar.gz ]; then
  echo "Downloading u-boot ..."
  wget -nc -nv -O /lfs/resources/u-boot.tar.gz ${UBOOT_DOWNLOAD} || true
fi

if [ ! -d /lfs/tmp/u-boot ]; then
  mkdir -p /lfs/tmp/u-boot
  echo "Extracting u-boot ..."
  tar xpf /lfs/resources/u-boot.tar.gz -C /lfs/tmp/u-boot --strip-components=1
  # git clone -b v2019.04 https://github.com/u-boot/u-boot --depth=1 /lfs/tmp/u-boot
  # rm /lfs/resources/u-boot.tar.gz
else
  echo "U-boot files already exist"
fi

if [ ! -f /lfs/resources/u-boot.patch ]; then
  echo "Downloading u-boot patch ..."
  wget -nc -nv -O /lfs/resources/u-boot.patch ${UBOOT_PATCH} || true

  echo "Patching u-boot ..."
  patch -p1 < /lfs/resources/u-boot.patch
else
  echo "U-boot patch already exist"
fi

echo "Compiling u-boot ..."
cd /lfs/tmp/u-boot

# make ARCH=arm CROSS_COMPILE="ccache ${CC}" distclean
make ARCH=arm CROSS_COMPILE="ccache ${CC}" ${uboot_defconfig}
make ARCH=arm CROSS_COMPILE="ccache ${CC}" -j$(nproc)

echo "installing u-boot files ..."
sh -c "echo 'uname_r=${kernel_version}\nconsole=ttyO0,115200n8' >> /lfs/tmp/fs/boot/uEnv.txt"
cp /lfs/tmp/u-boot/MLO /lfs/tmp/fs/boot
cp /lfs/tmp/u-boot/u-boot.img /lfs/tmp/fs/boot
cp /lfs/tmp/u-boot/MLO /lfs/tmp/fs/rootfs/boot/uboot
cp /lfs/tmp/u-boot/u-boot.img /lfs/tmp/fs/rootfs/boot/uboot

echo "Finished compiling u-boot"