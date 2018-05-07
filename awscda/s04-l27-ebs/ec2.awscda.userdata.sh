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
    sudo mkdir -pv "/mnt/$drive"
    sudo mount "/dev/$drive" "/mnt/$drive"
done
