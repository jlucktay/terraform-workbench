#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Drop a note when this script is done (note: 'done' might include exiting prematurely due to an error!)
trap "echo DONE >> ~ec2-user/user-data.log" INT TERM EXIT

### CONFIGURATION
# The ID of the secret within Secrets Manager, which holds the public key that Globalscape will connect with
SecretId="fa-sftp-ec2"
# Note that this is not the fully-qualified ARN, only the name of the secret

### TODO
# The '/etc/ssh/sshd_config' file might need some finessing, to comply with how the Globalscape client connects to this VM
#
# EXAMPLE
# # echo PutYourConfigChangesHere >> /etc/ssh/sshd_config
#
# Make sure to restart the SSHD service after modifying its config.
# Use the following command to do the restart:
# # systemctl restart sshd.service

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

# Add a line for the extra volume to fstab, and mount it ('-a' mounts _everything_; RTFM for more detail)
echo "/dev/xvdb   /home/sftp   ext4   defaults,nofail   0   2" | tee -a /etc/fstab
mount -a

# Install and configure the AWS CLI
curl https://bootstrap.pypa.io/get-pip.py --output /tmp/get-pip.py
python /tmp/get-pip.py --user
echo "export PATH=~/.local/bin:\$PATH" >> ~/.bashrc
PATH=~/.local/bin:$PATH
pip install awscli --upgrade --user
aws configure set default.region eu-west-1

# Get the public key from Secrets Manager and put it into ~sftp
PublicKey=$(aws secretsmanager get-secret-value --secret-id $SecretId | grep SecretString | cut -d'"' -f4)
mkdir ~sftp/.ssh
echo "$PublicKey" >> ~sftp/.ssh/authorized_keys

# Fix file/directory permissions in ~sftp since it was re-homed to a new volume
chown -Rc sftp:sftp ~sftp
chmod -Rc ug+rw ~sftp
chmod -c 700 ~sftp/.ssh
chmod -c 600 ~sftp/.ssh/authorized_keys

# Revoke Secrets Manager access by removing the IAM role from the EC2
InstanceId=$(curl http://169.254.169.254/latest/meta-data/instance-id)
AssociationId=$(aws ec2 describe-iam-instance-profile-associations --query "IamInstanceProfileAssociations[?InstanceId=='$InstanceId']" | grep AssociationId | cut -d'"' -f4)
aws ec2 disassociate-iam-instance-profile --association-id "$AssociationId"
