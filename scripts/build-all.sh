#! /bin/bash

set -e

/lfs/scripts/prepare.sh
/lfs/scripts/build-kernel.sh
/lfs/scripts/build-uboot.sh
/lfs/scripts/build-image.sh
