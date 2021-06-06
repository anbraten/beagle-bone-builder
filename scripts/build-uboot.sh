#! /bin/bash

set -e

export ECHO_PREFIX="[\e[96mImage-Builder\e[0m] "

export UBOOT_DOWNLOAD="https://github.com/u-boot/u-boot/archive/refs/tags/v2021.04.tar.gz"
# export UBOOT_DOWNLOAD="https://github.com/u-boot/u-boot/archive/refs/tags/v2019.04.tar.gz"
export UBOOT_PATCH="https://github.com/eewiki/u-boot-patches/raw/master/v2019.04/0001-am335x_evm-uEnv.txt-bootz-n-fixes.patch"
export UBOOT_PATCH_2="https://github.com/eewiki/u-boot-patches/raw/master/v2019.04/0002-U-Boot-BeagleBone-Cape-Manager.patch"
export uboot_defconfig="am335x_evm_defconfig"
export kernel_version="5.10.35"
export CC=arm-linux-gnueabihf-

if [ ! -f /lfs/resources/u-boot.tar.gz ]; then
  echo -e "${ECHO_PREFIX}Downloading u-boot ..."
  wget -nc -nv -O /lfs/resources/u-boot.tar.gz ${UBOOT_DOWNLOAD} || true
fi

if [ ! -d /lfs/tmp/u-boot ]; then
  mkdir -p /lfs/tmp/u-boot
  echo -e "${ECHO_PREFIX}Extracting u-boot ..."
  tar xpf /lfs/resources/u-boot.tar.gz -C /lfs/tmp/u-boot --strip-components=1
  # git clone -b v2019.04 https://github.com/u-boot/u-boot --depth=1 /lfs/tmp/u-boot
  # rm /lfs/resources/u-boot.tar.gz
else
  echo -e "${ECHO_PREFIX}U-boot files already exist"
fi

cd /lfs/tmp/u-boot

if [ ! -f /lfs/resources/u-boot.patch ]; then
  echo -e "${ECHO_PREFIX}Downloading u-boot patch ..."
  wget -nc -nv -O /lfs/resources/u-boot.patch ${UBOOT_PATCH} || true
  wget -nc -nv -O /lfs/resources/u-boot-2.patch ${UBOOT_PATCH_2} || true

  echo -e "${ECHO_PREFIX}Patching u-boot ..."
  # patch -p1 -f < /lfs/resources/u-boot.patch
  # patch -p1 -f < /lfs/resources/u-boot-2.patch
else
  echo -e "${ECHO_PREFIX}U-boot patch already exist"
fi

echo -e "${ECHO_PREFIX}Compiling u-boot ..."

# make ARCH=arm CROSS_COMPILE="ccache ${CC}" distclean
make ARCH=arm CROSS_COMPILE="ccache ${CC}" ${uboot_defconfig}
make ARCH=arm CROSS_COMPILE="ccache ${CC}" -j$(nproc)

echo -e "${ECHO_PREFIX}Installing u-boot files ..."
sh -c "echo 'uname_r=${kernel_version}\nconsole=ttyO0,115200n8' >> /lfs/tmp/fs/boot/uEnv.txt"
cp /lfs/tmp/u-boot/MLO /lfs/tmp/fs/boot
cp /lfs/tmp/u-boot/u-boot.img /lfs/tmp/fs/boot
#cp /lfs/tmp/u-boot/MLO /lfs/tmp/fs/rootfs/boot/uboot
#cp /lfs/tmp/u-boot/u-boot.img /lfs/tmp/fs/rootfs/boot/uboot

echo -e "${ECHO_PREFIX}Finished compiling u-boot"