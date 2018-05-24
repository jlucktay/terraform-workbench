#!/bin/bash

echo "alias lsl='ls -Al'" >> ~ec2-user/.bashrc
echo "alias lsl='ls -Al'" >> ~root/.bashrc

# Drop a note when this script is done (note: 'done' might include exiting prematurely due to an error!)
trap "echo DONE >> ~ec2-user/user-data.log" INT TERM EXIT

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

# Put the public key into ~sftp
mkdir ~sftp/.ssh
echo "I'm a public key!" >> ~sftp/.ssh/authorized_keys

# Fix file/directory permissions in ~sftp
chown -Rc sftp:sftp ~sftp
chmod -Rc ug+rw ~sftp
chmod -c 700 ~sftp/.ssh
chmod -c 600 ~sftp/.ssh/authorized_keys



# # ### /dev/xvdf        99G   61M   94G   1% /home/sftp

# # cd .ssh/
# # cd /etc/ssh/
# # cd /home/sftp/
# # cd /tmp/sftp/
# # cd ~sftp/

# # chmod -Rc ug+rw /mnt/sftp
# # chown -c sftp.sftp .ssh
# # chown -c sftp.sftp authorized_keys
# # chown -R sftp:sftp /mnt/sftp

# # cp -ivr ~sftp/.* /tmp/sftp/
# # cp -ivrt /home/sftp/ .ssh
# # cp -ivt /home/sftp/ ./.bash* .ssh/ test2.txt Test.txt
# # cp /etc/fstab /etc/fstab.20180523
# # cp /etc/sudoers /etc/sudoers.bkp
# # date
# # df -h
# # exit
# # file -s /dev/xvda1
# # file -s /dev/xvda2
# # file -s /dev/xvdf
# # history
# # hostname
# # less sshd_config
# # ll
# # locate nano
# # ls
# # ls -Al
# # ls -Al ~sftp/
# # ls /mnt/sftp/
# # lsblk
# # lsl
# # lsl -a /mnt/sftp/
# # lsl /home/
# # lsl /home/sftp/
# # lsl /mnt/
# # lsl /mnt/sftp/
# # lsl ~sftp/
# # man adduser
# # man useradd
# # mkdir -pv /mnt/sftp
# # mkdir .ssh
# # mount
# # mount -a
# # mount /dev/xvdf /mnt/sftp
# # mount /home/sftp
# # nano authorized_keys
# # passwd dlgfraudanalnprdL2
# # ping 10.74.0.100
# # pwd
# # rm -rfv devopsadmin/ dlgfraudanalnprdL2/ ec2-user/
# # route
# # service --status-all

# # sudo cat ~ec2-user/.ssh/authorized_keys
# # sudo cat ~sftp/.ssh/authorized_keys
# # sudo ls -Al ~sftp
# # sudo ls -Al ~sftp/.ssh
# # sudo lsl ~sftp/
# # sudo nano /etc/ssh/sshd_config
# # sudo passwd devopsadmin
# # sudo su
# # sudo su -
# # sudo systemctl restart sshd.service
# # sudo systemctl status sshd.service
# # sudo useradd devopsadmin
# # sudo vi /etc/ssh/sshd_config
# # sudo vim /etc/ssh/sshd_config
# # sudo visudo
# # systemctl
# # systemctl --help
# # systemctl restart sshd.service
# # systemctl sshd.service
# # systemctl status sshd.service
# # umount /mnt/sftp
# # useradd devopsadmin
# # useradd dlgfraudanalnprdL2
# # vi /etc/fstab
# # vi /etc/sudoers
# # vi authorized_keys
# # visudo
