#!/usr/bin/env bash

yum update -y

drives=( sdb sdc sdd )

for drive in "${drives[@]}"
do
    parted --script "/dev/$drive" \
        mklabel gpt \
        mkpart primary ext4 0% 100%

    mkfs.ext4 -F "/dev/$drive"
    mkdir -p "/mnt/$drive"
    echo "/dev/$drive   /mnt/$drive   ext4   defaults   0   2" | tee -a /etc/fstab
    mount "/mnt/$drive"
done
