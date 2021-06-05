#! /bin/bash

set -e

/lfs/scripts/prepare.sh
/lfs/scripts/build-kernel-image.sh
/lfs/scripts/build-kernel-modules.sh
/lfs/scripts/build-kernel-device-trees.sh
/lfs/scripts/install-kernel.sh
/lfs/scripts/build-uboot.sh
/lfs/scripts/build-image.sh
