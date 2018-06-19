#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Drop a note when this script is done (note: 'done' might include exiting prematurely due to an error!)
trap "echo DONE >> ~ec2-user/user-data.log" INT TERM EXIT

# Update/fetch some packages
yum update -y

# Get the public key
curl https://gist.githubusercontent.com/jlucktay/9c71eb7e64637337e74973534fe74d31/raw/teleport-ca.pub >> /etc/ssh/teleport-ca.pub

# Update SSHD config and restart it
echo "TrustedUserCAKeys /etc/ssh/teleport-ca.pub" >> /etc/ssh/sshd_config:
service sshd restart
