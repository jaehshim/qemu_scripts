#!/bin/bash

#sudo apt install -y qemu-system-aarch64 qemu-utils qemu-system-x86 cloud-init cloud-utils

# Configure VM
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-arm64.img
sudo qemu-img resize jammy-server-cloudimg-arm64.img +40G

# Prepare EFI partiton
dd if=/dev/zero of=flash0.img bs=1M count=64
dd if=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd of=flash0.img conv=notrunc
dd if=/dev/zero of=flash1.img bs=1M count=64

# Configure instance information
cat > metadata.yaml<< EOF
instance-id: csl
local-hostname: cloudimg
EOF

# Configure user information
cat > user-data.yaml << EOF
#cloud-config
password: csl
chpasswd: { expire: False }
ssh_pwauth: True
ssh_authorized_keys:
- 'ssh-add -L'
EOF

# Generate the seed image
cloud-localds seed.img user-data.yaml metadata.yaml
