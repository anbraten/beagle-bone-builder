#!/bin/bash

cd /lfs/output

# set the size of output image
image_size=1024M

qemu-img create sd_image.img $image_size
sh -c "echo '1M,48M,0xE,*\n,,,-' | sfdisk sd_image.img"

kpartx -av sd_image.img

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
kpartx -dv sd_image.img

# generate tar archive
tar -C /lfs/tmp/ -czpf rootfs.tar.gz rootfs
echo "Image is Ready!"
