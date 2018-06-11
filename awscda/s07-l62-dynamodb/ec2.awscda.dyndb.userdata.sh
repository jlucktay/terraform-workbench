#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Drop a note when this script is done (note: 'done' might include exiting prematurely due to an error!)
trap "echo DONE >> ~ec2-user/user-data.log" INT TERM EXIT

# Update/fetch some packages
yum update -y
yum install -y httpd24 php56 git

# Sort out Apache (httpd) and its (auto)start
chkconfig httpd on
service httpd start

# Set up HTML/PHP
cd /var/www/html
echo "<?php phpinfo();?>" > test.php

# Install Composer
export HOME="/root"
echo "'curl'ing Composer installer..."
curl -sS https://getcomposer.org/installer | php

# Get PHP AWS SDK using Composer
echo "'php'ing Composer installer..."
php composer.phar require aws/aws-sdk-php

# Get DynamoDB scripts from GitHub and personalise table names
git clone https://github.com/acloudguru/dynamodb
cd dynamodb
sed -e "s/tableName = '/tableName = 'james.lucktaylor./g" --in-place ./*.php
