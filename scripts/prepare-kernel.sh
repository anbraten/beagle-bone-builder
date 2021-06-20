#! /bin/bash

set -e

source /lfs/scripts/config.sh

if [ ! -d /lfs/tmp/kernel ]; then
  echo -e "${ECHO_PREFIX}Downloading kernel ..."
  mkdir -p /lfs/tmp/kernel
  git clone -b ${KERNEL_BRANCH} --single-branch ${KERNEL_GIT} /lfs/tmp/kernel
  # tar xpf /lfs/resources/kernel.tar.gz -C /lfs/kernel --strip-components=1
else
  echo -e "${ECHO_PREFIX}Kernel files already exist"
fi

cd /lfs/tmp/kernel

if [ "$KERNEL_BRANCH" == "5.10" ] || [ "$KERNEL_BRANCH" == "5.10-rt" ]; then
  echo -e "${ECHO_PREFIX}Patching kernel with CTAG-2.4 driver ..."
  patch -t -s -p1 < /lfs/resources/ctag-2.4/ctag-2.4-k5.10.patch || true
fi

make ARCH=arm CROSS_COMPILE=${CC} clean
make ARCH=arm CROSS_COMPILE=${CC} bb.org_defconfig

if [ "$KERNEL_BRANCH" == "5.10" ] || [ "$KERNEL_BRANCH" == "5.10-rt" ]; then
  echo -e "${ECHO_PREFIX}Enabling CTAG-2.4 driver ..."
  patch -t /lfs/tmp/kernel/.config /lfs/resources/ctag-2.4/.config.patch || true
fi
