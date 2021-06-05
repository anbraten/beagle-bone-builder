#!/bin/bash

set -e

cd /lfs/output

echo "Building image ..."

# set the size of output image
image_size=1024M

echo "Creating new disk-image ..."
qemu-img create bb-sd-image.img $image_size

echo "Partioning disk-image ..."
sh -c "echo '1M,48M,0xE,*\n,,,-' | sfdisk bb-sd-image.img"

# partioning seem to need a second ;-)
sleep 1

echo "Mounting disk-image ..."
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

echo "Formatting disk-image ..."
mkfs.vfat -F 16 /dev/mapper/$p1 -n boot
mkfs.ext4 /dev/mapper/$p2 -L rootfs
mkdir -p /lfs/tmpmnt/boot /lfs/tmpmnt/rootfs

echo "Mounting disks ..."
mount /dev/mapper/$p1 /lfs/tmpmnt/boot/
mount /dev/mapper/$p2 /lfs/tmpmnt/rootfs/

# copy files to partitions
echo "Copying files to disks ..."
cp -rp /lfs/tmp/fs/boot/. /lfs/tmpmnt/boot/
cp -rp /lfs/tmp/fs/rootfs/. /lfs/tmpmnt/rootfs/

# permissions
chown root:root /lfs/tmpmnt/rootfs/
chmod 755 /lfs/tmpmnt/rootfs/

# sync and unmount partitions
umount /lfs/tmpmnt/boot/
umount /lfs/tmpmnt/rootfs/
kpartx -dv bb-sd-image.img

# creating archive from rootfs
echo "Creating archive from rootfs ..."
tar -C /lfs/tmp/ -czpf bb-rootfs.tar.gz fs

# compress img
echo "Compressing image ..."
cp bb-sd-image.img bb-raw-sd-image.img
xz -0 bb-sd-image.img

echo "Image is Ready!"
