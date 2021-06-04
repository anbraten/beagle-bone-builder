#!/bin/bash

CMD="${1:-all}"

echo "Building $CMD ..."

DOCKER_ARGS="-rm --privileged"
if [ -t 0 ] ; then
  DOCKER_ARGS="-it --rm --privileged "
fi

docker run $DOCKER_ARGS \
  -v $(pwd)/output:/lfs/output \
  -v $(pwd)/resources:/lfs/resources \
  -v $(pwd)/tmp:/lfs/tmp \
  embedded-linux-builder /lfs/scripts/build-$CMD.sh

# services:
#   app:
#     image: embedded_linux_image_builder
#     privileged: true
#     build:
#       context: .
#       args:
#         - kernel_version=4.19.94
#         - kernel_filename=./resources/linux-4.19.94-ti-rt-r41.tar.gz
#         - kernel_defconfig=bb.org_defconfig
#         - uboot_filename=./resources/u-boot-2020.04-rc3.tar.gz
#         - uboot_defconfig=am335x_evm_defconfig
#         - rootfs_filename=./resources/armhf-rootfs-ubuntu-bionic.tar
#         - linaro_filename=./resources/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar

#     volumes:
#       - ./output:/lfs/output
