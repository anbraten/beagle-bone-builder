#! /bin/bash

set -e

source /lfs/scripts/config.sh

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
