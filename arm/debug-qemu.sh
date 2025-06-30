#!/bin/bash

sudo qemu-system-aarch64 -s -S -m 16G \
	-cpu cortex-a57 -M virt -smp 8 -nographic \
	-pflash flash0.img -pflash flash1.img \
	-drive if=none,file=jammy-server-cloudimg-arm64.img,id=hd0 \
	-drive if=virtio,file=seed.img,format=raw,id=cloud \
	-device virtio-blk-device,drive=hd0 \
	-net user,hostfwd=tcp::2222-:22 -net nic -vnc :3 \
	-kernel /home/shim/qemu_scripts/arm/shared/linux-6.8.10/arch/arm64/boot/Image \
	-initrd /home/shim/qemu_scripts/arm/shared/linux-6.8.10/initrd.img-6.8.10-debug \
	-append "root=/dev/vda1 console=ttyAMA0"
