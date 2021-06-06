#! /bin/bash

set -e

export ECHO_PREFIX="[\e[96mImage-Builder\e[0m] "

export ROOTFS_DOWNLOAD="https://rcn-ee.com/rootfs/eewiki/minfs/debian-10.9-minimal-armhf-2021-04-14.tar.xz"
export ROOTFS_NAME="debian-10.9-minimal-armhf-2021-04-14"
export ROOTFS_FILE="armhf-rootfs-debian-buster"

if [ ! -f /lfs/resources/rootfs.tar ]; then
  echo -e "${ECHO_PREFIX}Downloading rootfs ..."
  wget -nc -nv -O /lfs/resources/rootfs.tar ${ROOTFS_DOWNLOAD} || true
fi

if [ ! -f /lfs/tmp/fs/rootfs/etc/os-release ]; then
  echo -e "${ECHO_PREFIX}Extracting rootfs ..."
  mkdir -p /lfs/tmp/fs/rootfs
  chown -R root:root /lfs/tmp/fs/rootfs
  tar -xpO -f /lfs/resources/rootfs.tar ./${ROOTFS_NAME}/${ROOTFS_FILE}.tar | tar -xp -C /lfs/tmp/fs/rootfs
  # rm /lfs/resources/rootfs.tar
else
  echo -e "${ECHO_PREFIX}Rootfs files already exist"
fi

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
