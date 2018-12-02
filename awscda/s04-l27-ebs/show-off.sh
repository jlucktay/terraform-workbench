#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

for ec2 in $(terraform output --json awscda-ip | jq -r '.value[]'); do
    ssh "ec2-user@$ec2" "hostname; df -h"
    echo
done
