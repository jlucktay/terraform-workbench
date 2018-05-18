#!/bin/bash

sudo yum update -y
echo "alias lsl='ls -Al'" >> ~ec2-user/.bashrc

# Sort out Apache (httpd)
sudo yum install -y httpd
service httpd start
sudo chkconfig httpd on

# Sort out EFS volume
sudo yum install -y amazon-efs-utils
echo "!!EFS_ID!! /var/www/html efs defaults,_netdev 0 0" | sudo tee -a /etc/fstab

# Create/append to web page
sudo yum install -y jq
TIMESTAMP=$(date '+%Y%m%d.%H%M%S.%N%z')
MY_IP=$(curl --silent httpbin.org/ip | jq -r '.origin')

# Keep attempting to mount EFS, until it succeeds
until sudo mount /var/www/html; do
    sleep 1
done

echo "[${TIMESTAMP}] ${MY_IP}<br />" | sudo tee -a /var/www/html/index.html
