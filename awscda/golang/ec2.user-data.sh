#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Drop a note when this script is done (note: 'done' might include exiting prematurely due to an error!)
trap "echo DONE >> ~ec2-user/user-data.log" INT TERM EXIT

# Update all of the things
yum update -y

# Go!
yum install -y golang
cd ~ec2-user
su ec2-user -c "go get -u -v github.com/aws/aws-sdk-go/..."
