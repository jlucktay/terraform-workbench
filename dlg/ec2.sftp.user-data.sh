#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Drop a note when this script is done (note: 'done' might include exiting prematurely due to an error!)
trap "echo DONE >> ~ec2-user/user-data.log" INT TERM EXIT

# Some helpful aliases
echo "alias lsl='ls -Al'" >> ~ec2-user/.bashrc
echo "alias lsl='ls -Al'" >> ~root/.bashrc

# Update all of the things
yum update -y

# Create 'sftp' user
adduser sftp

# Wait for the extra volume to be attached
until ls /dev/xvdb; do
    sleep 1
done

# Create partition and filesystem on the extra volume
parted --script "/dev/xvdb" \
    mklabel gpt \
    mkpart primary ext4 0% 100%

mkfs -t ext4 /dev/xvdb



# # Wait for the second UUID to show up
# cmd_find () {
#     find /dev/disk/by-uuid/ -type l -ilname "*xvd*" | wc -l
# }

# until (( $(cmd_find) == 2 )); do
# 	sleep 1
# done

# # Get the UUID of the extra volume
# DISKUUID=$(find /dev/disk/by-uuid/ -type l -ilname "*xvdb*" | cut -d'/' -f5)



# Add a line for the extra volume to fstab, and mount
echo "/dev/xvdb   /home/sftp   ext4   defaults,nofail   0   2" | tee -a /etc/fstab
mount -a

# Get AWS CLI
curl https://bootstrap.pypa.io/get-pip.py --output /tmp/get-pip.py
python /tmp/get-pip.py --user
echo "export PATH=~/.local/bin:\$PATH" >> ~/.bashrc
PATH=~/.local/bin:$PATH
pip install awscli --upgrade --user

# Get public key from Secrets Manager and put it into ~sftp
PUBKEY=$(aws secretsmanager get-secret-value --secret-id james.lucktaylor.fa-sftp.pub --region eu-west-1 | grep SecretString | cut -d\\ -f4 | cut -d'"' -f2)
mkdir ~sftp/.ssh
echo "$PUBKEY" >> ~sftp/.ssh/authorized_keys

# Fix file/directory permissions in ~sftp
chown -Rc sftp:sftp ~sftp
chmod -Rc ug+rw ~sftp
chmod -c 700 ~sftp/.ssh
chmod -c 600 ~sftp/.ssh/authorized_keys



# # ### /dev/xvdf        99G   61M   94G   1% /home/sftp



# # less sshd_config
# # sudo nano /etc/ssh/sshd_config
# # sudo systemctl restart sshd.service
# # sudo systemctl status sshd.service
# # sudo vi /etc/ssh/sshd_config
# # sudo vim /etc/ssh/sshd_config
# # sudo visudo
# # systemctl restart sshd.service
# # systemctl sshd.service
# # systemctl status sshd.service
