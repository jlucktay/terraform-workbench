#!/bin/bash

sudo yum update -y
echo "alias lsl='ls -Al'" >> ~ec2-user/.bashrc

yum install httpd -y
service httpd start

# TODO: get EFS `mount` command, and mount on `/var/www/html`
