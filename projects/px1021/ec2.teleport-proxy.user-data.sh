#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Drop a note when this script is done (note: 'done' might include exiting prematurely due to an error!)
trap "echo DONE >> ~ec2-user/user-data.log" INT TERM EXIT

# Update/fetch some packages
yum update -y

# Install Teleport
cd /tmp
wget https://get.gravitational.com/teleport-v2.6.2-linux-amd64-bin.tar.gz
tar -zxvf teleport-v2.6.2-linux-amd64-bin.tar.gz
cd teleport
./install

# Put Teleport config in place
curl https://gist.githubusercontent.com/jlucktay/9c71eb7e64637337e74973534fe74d31/raw/teleport.yaml >> /etc/teleport.yaml

# Start Teleport
TeleportLogDir="/var/log/teleport"
mkdir -pv "$TeleportLogDir"
nohup /usr/local/bin/teleport start >"$TeleportLogDir"/stdout.log 2>"$TeleportLogDir"/stderr.log &
