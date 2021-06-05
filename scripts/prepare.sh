#!/bin/bash

export ROOTFS_DOWNLOAD="https://rcn-ee.com/rootfs/eewiki/minfs/debian-10.9-minimal-armhf-2021-04-14.tar.xz"
export UBOOT_DOWNLOAD="https://github.com/u-boot/u-boot/archive/refs/tags/v2021.04.tar.gz"
export LINARO_DOWNLOAD="https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/arm-linux-gnueabihf/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz"

# create directories
mkdir -p /lfs/tmp/kernel
mkdir -p /lfs/tmp/u-boot
mkdir -p /lfs/tmp/rootfs/boot
mkdir -p /lfs/tmp/rootfs/rootfs
mkdir -p /lfs/tmp/rootfs/rootfs/boot

if [ ! -f /lfs/resources/linaro.tar ]; then
  echo "Downloading linaro ..."
  wget -q -O /lfs/resources/linaro.tar ${LINARO_DOWNLOAD}
  tar xpf /lfs/resources/linaro.tar -C /lfs/linaro --strip-components=1
  # rm /lfs/resources/linaro.tar
else
  echo "Linaro files already exist"
fi

if [ ! -d /lfs/tmp/kernel ]; then
  echo "Downloading kernel ..."
  git clone -b 5.10 --single-branch https://github.com/beagleboard/linux.git /lfs/tmp/kernel
  # tar xpf /lfs/resources/kernel.tar.gz -C /lfs/kernel --strip-components=1
else
  echo "Kernel files already exist"
fi

if [ ! -f /lfs/resources/rootfs.tar ]; then
  echo "Downloading rootfs ..."
  wget -q -O /lfs/resources/rootfs.tar ${ROOTFS_DOWNLOAD}
  # tar xpf /lfs/rootfs.tar -C /lfs/rootfs --strip-components=1
  tar xpf /lfs/resources/rootfs.tar -C /lfs/tmp/rootfs
  # rm /lfs/resources/rootfs.tar
else
  echo "Rootfs files already exist"
fi

if [ ! -f /lfs/resources/u-boot.tar.gz ]; then
  echo "Downloading u-boot ..."
  wget -q -O /lfs/resources/u-boot.tar.gz ${UBOOT_DOWNLOAD}
  tar xpf /lfs/resources/u-boot.tar.gz -C /lfs/tmp/u-boot --strip-components=1
  # rm /lfs/resources/u-boot.tar.gz
else
  echo "U-boot files already exist"
fi

