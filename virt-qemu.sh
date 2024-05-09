#!/bin/bash

sudo qemu-system-x86_64 -s -name debug -m 40G \
	-machine accel=kvm -cpu host -smp 30 -nographic \
	-drive file=jammy-server-cloudimg-amd64.img \
	-drive if=virtio,format=raw,file=seed.img \
	-device virtio-net-pci,netdev=net0 \
	-netdev user,id=net0,hostfwd=tcp::2222-:22 \
	-kernel /home/csl/shim/qemu_scripts/linux-6.0.10/arch/x86/boot/bzImage \
	-initrd /home/csl/shim/qemu_scripts/linux-6.0.10/initrd.img-6.0.10-debug \
	-append "root=/dev/sda1 console=ttyS0 memmap=20G\$10G" \
	-virtfs local,path=/home/jaehoon/virtio-dir,mount_tag=host0,security_model=passthrough,id=host0
