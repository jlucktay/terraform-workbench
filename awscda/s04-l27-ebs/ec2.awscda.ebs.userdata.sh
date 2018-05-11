#!/bin/bash

sudo yum update -y
echo "alias lsl='ls -Al'" >> ~ec2-user/.bashrc

drives=( sdb sdc sdd )

for drive in "${drives[@]}"
do
    sudo parted --script "/dev/$drive" \
        mklabel gpt \
        mkpart primary ext4 0% 100%

    sudo mkfs.ext4 -F "/dev/$drive"
    sudo mkdir -p "/mnt/$drive"
    echo "/dev/$drive   /mnt/$drive   ext4   defaults   0   2" | sudo tee -a /etc/fstab
    sudo mount "/mnt/$drive"
done
