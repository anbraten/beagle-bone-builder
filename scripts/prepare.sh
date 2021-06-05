#!/bin/bash

set -e

export ROOTFS_DOWNLOAD="https://rcn-ee.com/rootfs/eewiki/minfs/debian-10.9-minimal-armhf-2021-04-14.tar.xz"
export ROOTFS_NAME="debian-10.9-minimal-armhf-2021-04-14"
export ROOTFS_FILE="armhf-rootfs-debian-buster"
export UBOOT_DOWNLOAD="https://github.com/u-boot/u-boot/archive/refs/tags/v2021.04.tar.gz"
# export UBOOT_DOWNLOAD="https://github.com/u-boot/u-boot/archive/refs/tags/v2020.10.tar.gz"
export UBOOT_PATCH="https://github.com/eewiki/u-boot-patches/raw/master/v2020.10-rc2/0001-am57xx_evm-fixes.patch"
export LINARO_DOWNLOAD="https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/arm-linux-gnueabihf/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz"
export KERNEL_GIT="https://github.com/beagleboard/linux.git"
export KERNEL_BRANCH="5.10"

# cleanup environment
rm -rf /lfs/tmp/fs
rm -rf /lfs/tmp/u-boot
rm -rf /lfs/output/*

if [ ! -d /lfs/tmp/linaro ]; then
  echo "Downloading linaro ..."
  wget -nc -nv -O /lfs/resources/linaro.tar ${LINARO_DOWNLOAD} || true
  mkdir -p /lfs/tmp/linaro
  echo "Extracting linaro ..."
  tar xpf /lfs/resources/linaro.tar -C /lfs/tmp/linaro --strip-components=1
  # rm /lfs/resources/linaro.tar
else
  echo "Linaro files already exist"
fi

if [ ! -d /lfs/tmp/kernel ]; then
  echo "Downloading kernel ..."
  mkdir -p /lfs/tmp/kernel
  git clone -b ${KERNEL_BRANCH} --single-branch ${KERNEL_GIT} /lfs/tmp/kernel
  # tar xpf /lfs/resources/kernel.tar.gz -C /lfs/kernel --strip-components=1
else
  echo "Kernel files already exist"
fi

if [ ! -f /lfs/resources/rootfs.tar ]; then
  echo "Downloading rootfs ..."
  wget -nc -nv -O /lfs/resources/rootfs.tar ${ROOTFS_DOWNLOAD} || true
fi

if [ ! -d /lfs/tmp/fs ]; then
  echo "Extracting rootfs ..."
  mkdir -p /lfs/tmp/fs/rootfs
  chown -R root:root /lfs/tmp/fs/rootfs
  tar -xpO -f /lfs/resources/rootfs.tar ./${ROOTFS_NAME}/${ROOTFS_FILE}.tar | tar -xp -C /lfs/tmp/fs/rootfs
  # rm /lfs/resources/rootfs.tar

  mkdir -p /lfs/tmp/fs/boot
  mkdir -p /lfs/tmp/fs/rootfs/boot
else
  echo "Rootfs files already exist"
fi

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
else
  echo "U-boot patch already exist"
fi

echo "Preparation done."