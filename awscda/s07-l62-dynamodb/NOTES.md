# DynamoDB

## New IAM Role

- DynDB
- EC2 service role
- Policy: AmazonDynamoDBFullAccess

## New EC2

- Assign the role
- User-data bootstrap script

``` shell
#!/usr/bin/env bash
yum update -y
yum install httpd24 php56 git -y
service httpd start
chkconfig httpd on
cd /var/www/html
echo "<?php phpinfo();?>" > test.php
git clone https://github.com/acloudguru/dynamodb
```

~~TODO: Regex to prefix tablenames~~

Example: `$tableName = 'ProductCatalog';`

- SG: DMZ
- Add to user-data:

``` shell
curl -sS https://getcomposer.org/installer | php
php composer.phar require aws/aws-sdk-php
```
