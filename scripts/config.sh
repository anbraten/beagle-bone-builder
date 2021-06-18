source /lfs/scripts/user-config.sh

export ECHO_PREFIX="[\e[96mImage-Builder\e[0m] "

export CC="arm-linux-gnueabihf-"
export CACHED_CC="ccache $CC"

export LINARO_DOWNLOAD="https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/arm-linux-gnueabihf/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz"

export KERNEL_GIT="https://github.com/beagleboard/linux.git"

export UBOOT_DOWNLOAD="https://github.com/u-boot/u-boot/archive/refs/tags/$UBOOT_VERSION.tar.gz"
# export UBOOT_PATCH="https://github.com/eewiki/u-boot-patches/raw/master/v2019.04/0001-am335x_evm-uEnv.txt-bootz-n-fixes.patch"
# export UBOOT_PATCH_2="https://github.com/eewiki/u-boot-patches/raw/master/v2019.04/0002-U-Boot-BeagleBone-Cape-Manager.patch"
export UBOOT_DEFCONFIG="am335x_evm_defconfig"

export ROOTFS_DOWNLOAD="https://rcn-ee.com/rootfs/eewiki/minfs/$ROOTFS_NAME.tar.xz"
export ROOTFS_FILE="armhf-rootfs-debian-buster"

export IMAGE_DATE=$(date '+%F_%H-%M-%S')
export IMAGE_NAME="bone-$ROOTFS_NAME-k$KERNEL_BRANCH-$IMAGE_DATE"
