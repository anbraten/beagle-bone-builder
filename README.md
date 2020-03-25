# Embedded Linux Image Builder

![embedded-linux-image-builder](./images/embedded.png)

This project creates a fully customized embedded Linux image from source (like Linux From Scratch). You can use this project to fully customize your embedded Linux image like changing kernel configuration, creating new Linux distros, create an image for other board variants, etc. To use this project there is no need to set up any special environment or meet any requirements.

## Features

* Based on Docker so can be run on any machine without any requirements.
* Build Kernel, DTS, modules, and headers from scratch.
* Build Bootloader (u-boot) from the source.
* Can be combined with any Linux distro filesystem.
* Create image file (.img) as output file for easy writing to SD card.
* I've used BeagleBone Black as the target system.
* I've tested the project with Ubuntu18.04 and Ti's official Linux Kernel 4.19.94.

## Requirements

* [Docker](https://docs.docker.com/install/) and [Docker Compose](https://docs.docker.com/compose/install/)
* Download resource files and put them in `resources` directory:
  * Linaro cross compile toolchain.
    * You can get the bianries from [here](https://www.linaro.org/downloads/).
  * Linux Kernel source for your board.
    * For BeagleBone Black you can use the official [kernel](https://github.com/beagleboard/linux)
  * u-boot [source code](https://github.com/u-boot/u-boot)).
  * A base rootfs Linux distro.
    * You can grab Ubuntu or Debian distro from [here](https://rcn-ee.com/rootfs/eewiki/minfs/).
    * [Ubuntu 18.04.3](https://rcn-ee.com/rootfs/eewiki/minfs/ubuntu-18.04.3-minimal-armhf-2020-02-10.tar.xz) used in this project.
  * As the compile process may take longer, you need to increase the Docker engine resources:
    * [Windows](https://docs.docker.com/docker-for-windows/#advanced#resources)
    * [Mac](https://docs.docker.com/docker-for-mac/#memory#resources).

## How to use

1. Make sure that you meet the requirements and put the necessary files into the `resources` directory:
    * For example:

      ```bash
      project
      └───resources
      │   │   armhf-rootfs-ubuntu-bionic.tar
      │   │   gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar
      │   │   linux-4.19.94-ti-rt-r41.tar.gz
      │   │   u-boot-2020.04-rc3.tar.gz

      ```

2. Make sure that you decompress the Linux rootfs to get the right compressed file. The files that contain all the Linux rootfs inside its root directory (e.g. `armhf-rootfs-ubuntu-bionic.tar`).
3. Set the Dockerfile parameters in `docker-compose.yml`:
   * `kernel_version`: kernel version you are using
   * `kernel_filename`: kernel source file path
   * `kernel_defconfig`: kernel configuration file
   * `uboot_filename`: u-boot source file path
   * `uboot_defconfig`: u-boot configuration file
   * `rootfs_filename`: Linux Root file system path
   * `linaro_filename`: Linaro toolchain file path

4. Bring up the console and navigate to project root directory and execute

   ```bash
   docker-compose up --build
   ```

5. If the process complete successfully you should get the image file `sd_image.img` in the `output` directory.

## Credits

* Masoud Rahimi: [masoudrahimi.com](http://masoudrahimi.com)
