#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Drop a note when this script is done (note: 'done' might include exiting prematurely due to an error!)
trap "echo DONE >> ~ec2-user/user-data.log" INT TERM EXIT

# shellcheck disable=2154
if [ -z "${efs_id}" ]; then
    echo "'efs_id' was not set or passed in to user-data!" | tee -a ~ec2-user/user-data.log
    exit 1
fi

# Update/fetch some packages
yum update -y
yum install -y amazon-efs-utils httpd jq

# Sort out Apache (httpd) and its (auto)start
chkconfig httpd on
service httpd start

# Sort out EFS volume mount
# shellcheck disable=2154
echo "${efs_id} /var/www/html efs defaults,_netdev 0 0" | tee -a /etc/fstab

# Keep attempting to mount EFS, until it succeeds
until mount /var/www/html; do
    sleep 1
done

# Create/append to web page, with timestamp and IP
echo "[$(date '+%Y%m%d.%H%M%S.%N%z')] $(curl --silent httpbin.org/ip | jq -r '.origin')<br />" |
    tee -a /var/www/html/index.html
