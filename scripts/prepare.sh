#!/bin/bash

set -e

source /lfs/scripts/config.sh

# cleanup environment
echo -e "${ECHO_PREFIX}Cleaning environment ..."
rm -rf /lfs/tmp/fs
rm -rf /lfs/tmp/u-boot
# rm -rf /lfs/resources/u-boot*.patch
rm -rf /lfs/output/*

if [ ! -d /lfs/tmp/linaro ]; then
  echo -e "${ECHO_PREFIX}Downloading linaro ..."
  wget -nc -nv -O /lfs/resources/linaro.tar ${LINARO_DOWNLOAD} || true
  mkdir -p /lfs/tmp/linaro
  echo -e "${ECHO_PREFIX}Extracting linaro ..."
  tar xpf /lfs/resources/linaro.tar -C /lfs/tmp/linaro --strip-components=1
  # rm /lfs/resources/linaro.tar
else
  echo -e "${ECHO_PREFIX}Linaro files already exist"
fi

mkdir -p /lfs/tmp/fs/boot
mkdir -p /lfs/tmp/fs/rootfs/boot

echo -e "${ECHO_PREFIX}Preparation done."