#!/bin/bash

sudo qemu-system-aarch64 -m 16G -cpu cortex-a57 -M virt -nographic \
	-pflash flash0.img -pflash flash1.img \
	-drive if=none,file=jammy-server-cloudimg-arm64.img,id=hd0 \
	-drive file=seed.img,format=raw,id=cloud \
	-device virtio-blk-device,drive=hd0 \
	-net user,hostfwd=tcp::2222-:22 -net nic -vnc :3
