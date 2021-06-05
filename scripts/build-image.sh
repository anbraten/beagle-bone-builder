#!/bin/bash

set -e

cd /lfs/output

echo "Building image ..."

# set the size of output image
image_size=1024M

qemu-img create bb-sd-image.img $image_size
sh -c "echo '1M,48M,0xE,*\n,,,-' | sfdisk bb-sd-image.img"

kpartx -av bb-sd-image.img

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

mkfs.vfat -F 16 /dev/mapper/$p1 -n boot
mkfs.ext4 /dev/mapper/$p2 -L rootfs
mkdir -p /lfs/tmpmnt/boot /lfs/tmpmnt/rootfs
mount /dev/mapper/$p1 /lfs/tmpmnt/boot/
mount /dev/mapper/$p2 /lfs/tmpmnt/rootfs/

# copy files to partitions
cp -rp /lfs/tmp/fs/boot/. /lfs/tmpmnt/boot/
cp -rp /lfs/tmp/fs/rootfs/. /lfs/tmpmnt/rootfs/

# sync and unmount partitions
umount /lfs/tmpmnt/boot/
umount /lfs/tmpmnt/rootfs/
kpartx -dv bb-sd-image.img

# generate tar archives
tar -C /lfs/tmp/ -czpf bb-rootfs.tar.gz fs
tar -czpf bb-sd-image.tar.gz bb-sd-image.img

echo "Image is Ready!"
