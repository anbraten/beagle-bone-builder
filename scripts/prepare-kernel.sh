#! /bin/bash

set -e

source /lfs/scripts/config.sh

if [ ! -d /lfs/tmp/kernel ]; then
  echo -e "${ECHO_PREFIX}Downloading kernel ..."
  mkdir -p /lfs/tmp/kernel
  git clone -b ${KERNEL_BRANCH} --single-branch ${KERNEL_GIT} /lfs/tmp/kernel
  # tar xpf /lfs/resources/kernel.tar.gz -C /lfs/kernel --strip-components=1
else
  echo -e "${ECHO_PREFIX}Kernel files already exist"
fi