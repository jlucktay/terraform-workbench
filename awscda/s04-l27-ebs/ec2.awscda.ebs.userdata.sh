#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Drop a note when this script is done (note: 'done' might include exiting prematurely due to an error!)
trap "echo DONE >> ~ec2-user/user-data.log" INT TERM EXIT

yum update -y

drives=( sdb sdc sdd sde sdf )

for drive in "${drives[@]}"; do
    echo -n "Waiting for device '/dev/$drive'..."
    until ls "/dev/$drive"; do
        sleep 1
    done
    echo " found: $(ls "/dev/$drive")"

    echo -n "Partitioning drive '$drive'..."
    parted --script "/dev/$drive" \
        mklabel gpt \
        mkpart primary ext4 0% 100%
    echo " 'parted' finished: $?"

    echo -n "Waiting for device '/dev/${drive}1'..."
    until ls "/dev/${drive}1"; do
        sleep 1
    done
    echo " found: $(ls "/dev/${drive}1")"

    echo -n "Creating filesystem on '/dev/${drive}1'..."
    mkfs -t ext4 "/dev/${drive}1"
    echo " 'mkfs' finished: $?"

    mkdir -pv "/mnt/${drive}1"

    echo "/dev/${drive}1   /mnt/${drive}1   ext4   defaults   0   2" | tee -a /etc/fstab

    mount "/mnt/${drive}1"

    echo "Drive '$drive' complete!"
    echo
done

echo "User Data complete!"
echo
