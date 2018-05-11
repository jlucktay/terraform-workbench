#!/bin/bash

sudo yum update -y
echo "alias lsl='ls -Al'" >> ~ec2-user/.bashrc

sudo yum install -y httpd
service httpd start
sudo chkconfig httpd on

sudo yum install -y amazon-efs-utils
sudo mount -t efs !!EFS_ID!!:/ /var/www/html
