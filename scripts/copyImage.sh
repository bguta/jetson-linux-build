#!/bin/bash
# Copy the kernel image on NVIDIA Jetson Developer Kit
# Copyright (c) 2016-21 Jetsonhacks 
# MIT License

cd ${SOURCE_TARGET}kernel/kernel-${KERNEL_RELEASE}

KERNEL_VERSION=$(uname -r)
# copy over modules and image to boot // make sure to backup as things may go wrong!
sudo rm -rf /lib/modules/${KERNEL_VERSION}
sudo cp -R ${TEGRA_MODULES_OUT}/lib/modules/${KERNEL_VERSION} /lib/modules
sudo cp ${TEGRA_KERNEL_OUT}/arch/arm64/boot/Image /boot/Image


# may need to add something like this at the end
#sudo cp ${TEGRA_KERNEL_OUT}/arch/arm64/boot/dts/tegra194-p3668-all-p3509-0000.dtb /boot/test.dtb


