#!/bin/bash
# Make the kernel image on NVIDIA Jetson Developer Kit
# Copyright (c) 2016-21 Jetsonhacks 
# MIT License
# Assumes that the .config file is available in /proc/config.gz
# Added check to see if make builds correctly; retry once if not

echo "Source Target: "$SOURCE_TARGET

MAKE_DIRECTORY="$SOURCE_TARGET"kernel/kernel-"${KERNEL_RELEASE}"

cd "$SOURCE_TARGET"kernel/kernel-"${KERNEL_RELEASE}"

# prepare install location
export STAGE="$SOURCE_TARGET"kernel/kernel-"${KERNEL_RELEASE}"/build
sudo rm -rf ${STAGE}
sudo mkdir ${STAGE}

export TEGRA_KERNEL_OUT=${STAGE}/kernel
mkdir $TEGRA_KERNEL_OUT

export TEGRA_MODULES_OUT=${STAGE}/modules
mkdir $TEGRA_MODULES_OUT

# Configure kernel
make ARCH=arm64 O=$TEGRA_KERNEL_OUT tegra_defconfig

# open up the config cli to edit
make ARCH=arm64 O=$TEGRA_KERNEL_OUT menuconfig


# make prepare
# Get the number of CPUs 
NUM_CPU=$(nproc)
 
# Build 
time make ARCH=arm64 O=$TEGRA_KERNEL_OUT -j$(($NUM_CPU - 1))
if [ $? -eq 0 ] ; then
  echo "Build successful"
  echo "Kernel out: "
  echo "$TEGRA_KERNEL_OUT"
else
  # Try to make again; Sometimes there are issues with the build
  # because of lack of resources or concurrency issues
  echo "Make did not build " >&2
  echo "Retrying ... "
  # Single thread this time
  make ARCH=arm64 O=$TEGRA_KERNEL_OUT
  if [ $? -eq 0 ] ; then
    echo "Build successful"
    echo "Kernel out: "
    echo "$TEGRA_KERNEL_OUT"
  else
    # Try to make again
    echo "Make did not successfully build" >&2
    echo "Please fix issues and retry build"
    exit 1
  fi
fi

# install modules
make ARCH=arm64 O=$TEGRA_KERNEL_OUT modules_install INSTALL_MOD_PATH=${TEGRA_MODULES_OUT}/
echo "Module build successful"
echo "Module out: "
echo "$TEGRA_MOUDLES_OUT"



