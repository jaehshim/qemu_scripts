#!/bin/bash

sudo qemu-system-x86_64 -s -name debug -m 40G \
	-machine accel=kvm -cpu host -smp 30 -nographic \
	-drive if=virtio,format=qcow2,file=jammy-server-cloudimg-amd64.img \
	-drive if=virtio,format=raw,file=seed.img \
	-device virtio-net-pci,netdev=net0 \
	-netdev user,id=net0,hostfwd=tcp::2222-:22
