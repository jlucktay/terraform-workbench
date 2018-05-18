#!/bin/bash

sudo yum update -y
echo "alias lsl='ls -Al'" >> ~ec2-user/.bashrc

# Sort out Apache (httpd)
sudo yum install -y httpd
service httpd start
sudo chkconfig httpd on

# Sort out EFS volume
sudo yum install -y amazon-efs-utils
sudo mount -t efs !!EFS_ID!!:/ /var/www/html
echo "!!EFS_ID!! /var/www/html efs defaults,_netdev 0 0" | sudo tee -a /etc/fstab

# Create/append to web page
sudo yum install -y jq
TIMESTAMP=$(date '+%Y%m%d.%H%M%S')
MY_IP=$(curl --silent httpbin.org/ip | jq -r '.origin')
echo "[${TIMESTAMP}] ${MY_IP}<br />" | sudo tee -a /var/www/html/index.html
