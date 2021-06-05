#!/bin/bash

set -e

export LINARO_DOWNLOAD="https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/arm-linux-gnueabihf/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz"
export KERNEL_GIT="https://github.com/beagleboard/linux.git"
export KERNEL_BRANCH="5.10"
export ROOTFS_DOWNLOAD="https://rcn-ee.com/rootfs/eewiki/minfs/debian-10.9-minimal-armhf-2021-04-14.tar.xz"
export ROOTFS_NAME="debian-10.9-minimal-armhf-2021-04-14"
export ROOTFS_FILE="armhf-rootfs-debian-buster"

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

echo "Preparation done."