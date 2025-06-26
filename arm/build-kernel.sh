#!/bin/bash

# check README for kernel configuration
pushd shared/linux-6.8.10/ 
echo "Make kernel"
sudo make -j 30 || exit

echo ""
echo "Make modules"
sudo make modules_install -j30 || exit

echo ""
echo "initramfs"
sudo mkinitramfs -o initrd.img-6.8.10-debug 6.8.10-debug || exit
popd
