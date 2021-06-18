export ECHO_PREFIX="[\e[96mImage-Builder\e[0m] "

export CC="arm-linux-gnueabihf-"
export CACHED_CC="ccache $CC"

export LINARO_DOWNLOAD="https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/arm-linux-gnueabihf/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz"

export KERNEL_GIT="https://github.com/beagleboard/linux.git"
export KERNEL_VERSION="5.10.35"
export KERNEL_BRANCH="5.10"

export UBOOT_DOWNLOAD="https://github.com/u-boot/u-boot/archive/refs/tags/v2021.07-rc3.tar.gz"
# export UBOOT_DOWNLOAD="https://github.com/u-boot/u-boot/archive/refs/tags/v2021.04.tar.gz"
# export UBOOT_DOWNLOAD="https://github.com/u-boot/u-boot/archive/refs/tags/v2019.04.tar.gz"
export UBOOT_PATCH="https://github.com/eewiki/u-boot-patches/raw/master/v2019.04/0001-am335x_evm-uEnv.txt-bootz-n-fixes.patch"
export UBOOT_PATCH_2="https://github.com/eewiki/u-boot-patches/raw/master/v2019.04/0002-U-Boot-BeagleBone-Cape-Manager.patch"
export uboot_defconfig="am335x_evm_defconfig"

export ROOTFS_DOWNLOAD="https://rcn-ee.com/rootfs/eewiki/minfs/debian-10.9-minimal-armhf-2021-04-14.tar.xz"
export ROOTFS_NAME="debian-10.9-minimal-armhf-2021-04-14"
export ROOTFS_FILE="armhf-rootfs-debian-buster"

export IMAGE_DATE=$(date '+%F_%H-%M-%S')
export IMAGE_NAME="bone-debian-10.9-armhf-k5.10-$IMAGE_DATE"
