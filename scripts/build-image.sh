#!/bin/bash

set -e

export ECHO_PREFIX="[\e[96mImage-Builder\e[0m] "

export IMAGE_DATE=$(date '+%F_%H-%M-%S')
export IMAGE_NAME="bone-debian-10.9-armhf-k5.10-$IMAGE_DATE"

cd /lfs/output

echo -e "${ECHO_PREFIX}Building image ..."

# set the size of output image
image_size=1024M

echo -e "${ECHO_PREFIX}Creating new disk-image ..."
qemu-img create image.img $image_size

echo -e "${ECHO_PREFIX}Partioning disk-image ..."
sh -c "echo '1M,48M,0xE,*\n,,,-' | sfdisk image.img"

echo -e "${ECHO_PREFIX}Mounting disk-image ..."
kpartx -av image.img

echo -e "${ECHO_PREFIX}Detecting disk-volumes ..."

# get loop device names
loop_devices=()
for f in $(ls /dev/mapper);
do
    if [ "$f" != "control" ]
    then
        loop_devices+=("$f")
    fi
done

p1=${loop_devices[0]}
p2=${loop_devices[1]}

echo -e "${ECHO_PREFIX}Formatting disk-image ..."


mkfs.vfat -F 16 /dev/mapper/$p1 -n boot
mkfs.ext4 -F -O ^metadata_csum,^64bit /dev/mapper/$p2 -L rootfs
#mkfs.ext4 /dev/mapper/$p2 -L rootfs
mkdir -p /lfs/tmpmnt/boot /lfs/tmpmnt/rootfs

echo -e "${ECHO_PREFIX}Mounting disks ..."
mount /dev/mapper/$p1 /lfs/tmpmnt/boot/
mount /dev/mapper/$p2 /lfs/tmpmnt/rootfs/

# copy files to partitions
echo -e "${ECHO_PREFIX}Copying files to disks ..."
cp -rp /lfs/tmp/fs/boot/. /lfs/tmpmnt/boot/
cp -rp /lfs/tmp/fs/rootfs/. /lfs/tmpmnt/rootfs/

# permissions
chown root:root /lfs/tmpmnt/rootfs/
chmod 755 /lfs/tmpmnt/rootfs/

# sync and unmount partitions
umount /lfs/tmpmnt/boot/
umount /lfs/tmpmnt/rootfs/
kpartx -dv image.img

if [ -n "$CI" ]; then
  echo -e "${ECHO_PREFIX}Running in CI ..."

  # creating archive from rootfs
  echo -e "${ECHO_PREFIX}Creating archive from rootfs ..."
  tar -C /lfs/tmp/ -czpf bb-rootfs.tar.gz fs

  # compress img
  echo -e "${ECHO_PREFIX}Compressing image ..."
  cp image.img compressed-image.img
  xz -0 compressed-image.img
  # rename compressed image
  mv compressed-image.img.xz "$IMAGE_NAME.img.xz"
fi

# rename image
mv image.img "$IMAGE_NAME.img"

echo -e "${ECHO_PREFIX}Image is Ready!"

# list outputs
ls -la .
