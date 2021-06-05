#!/bin/bash

export ROOTFS_DOWNLOAD="https://rcn-ee.com/rootfs/eewiki/minfs/debian-10.9-minimal-armhf-2021-04-14.tar.xz"
export ROOTFS_NAME="debian-10.9-minimal-armhf-2021-04-14"
export ROOTFS_FILE="armhf-rootfs-debian-buster"
export UBOOT_DOWNLOAD="https://github.com/u-boot/u-boot/archive/refs/tags/v2021.04.tar.gz"
export LINARO_DOWNLOAD="https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/arm-linux-gnueabihf/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz"
export KERNEL_GIT="https://github.com/beagleboard/linux.git"
export KERNEL_BRANCH="5.10"

# create directories
mkdir -p /lfs/tmp/kernel

if [ ! -d /lfs/tmp/linaro ]; then
  echo "Downloading linaro ..."
  wget -nc -nv -O /lfs/resources/linaro.tar ${LINARO_DOWNLOAD}
  mkdir -p /lfs/tmp/linaro
  echo "Extracting linaro ..."
  tar xpf /lfs/resources/linaro.tar -C /lfs/tmp/linaro --strip-components=1
  # rm /lfs/resources/linaro.tar
else
  echo "Linaro files already exist"
fi

if [ ! -d /lfs/tmp/kernel ]; then
  echo "Downloading kernel ..."
  git clone -b ${KERNEL_BRANCH} --single-branch ${KERNEL_GIT} /lfs/tmp/kernel
  # tar xpf /lfs/resources/kernel.tar.gz -C /lfs/kernel --strip-components=1
else
  echo "Kernel files already exist"
fi

if [ ! -d /lfs/tmp/rootfs ]; then
  echo "Downloading rootfs ..."
  wget -nc -nv -O /lfs/resources/rootfs.tar ${ROOTFS_DOWNLOAD}
  echo "Extracting rootfs ..."
  mkdir -p /lfs/tmp/rootfs
  tar -xOf /lfs/resources/rootfs.tar ./${ROOTFS_NAME}/${ROOTFS_FILE}.tar | tar -x -C /lfs/tmp/rootfs
  # rm /lfs/resources/rootfs.tar

  mkdir -p /lfs/tmp/rootfs/boot
  mkdir -p /lfs/tmp/rootfs/rootfs
  mkdir -p /lfs/tmp/rootfs/rootfs/boot
else
  echo "Rootfs files already exist"
fi

if [ ! -d /lfs/tmp/u-boot ]; then
  echo "Downloading u-boot ..."
  wget -nc -nv -O /lfs/resources/u-boot.tar.gz ${UBOOT_DOWNLOAD}
  mkdir -p /lfs/tmp/u-boot
  echo "Extracting u-boot ..."
  tar xpf /lfs/resources/u-boot.tar.gz -C /lfs/tmp/u-boot --strip-components=1
  # rm /lfs/resources/u-boot.tar.gz
else
  echo "U-boot files already exist"
fi

