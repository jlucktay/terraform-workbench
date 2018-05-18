#!/bin/bash

# Capture user-data kickoff timestamp
TIMESTAMP=$(date '+%Y%m%d.%H%M%S.%N%z')

# Do some boilerplate setup
sudo yum update -y
echo "alias lsl='ls -Al'" >> ~ec2-user/.bashrc

# Get some details ready for later
sudo yum install -y jq
MY_IP=$(curl --silent httpbin.org/ip | jq -r '.origin')

# Sort out Apache (httpd)
sudo yum install -y httpd
service httpd start
sudo chkconfig httpd on

# Sort out EFS volume mount
sudo yum install -y amazon-efs-utils
echo "!!EFS_ID!! /var/www/html efs defaults,_netdev 0 0" | sudo tee -a /etc/fstab

# Keep attempting to mount EFS, until it succeeds
until sudo mount /var/www/html; do
    sleep 1
done

# Create/append to web page, with timestamp and IP
echo "[${TIMESTAMP}] ${MY_IP}<br />" | sudo tee -a /var/www/html/index.html
