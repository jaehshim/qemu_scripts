#!/bin/bash

sudo apt install -y qemu qemu-utils qemu-system-x86 cloud-init cloud-utils

# Configure VM
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
sudo qemu-img resize jammy-server-cloudimg-amd64.img +40G

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
