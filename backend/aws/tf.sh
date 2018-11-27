#!/usr/local/bin/bash
set -euo pipefail
IFS=$'\n\t'

StateBucket="jlucktay.terraform.state.london"

# Set up environment with keys
awsume jlucktay

# Clean up any old stuff
find .terraform -type d -not -name .terraform -not -path "*plugins*" -exec rm -rfv -- {} +
rm -fv terraform.tfstate terraform.tfstate.backup .terraform.tfstate.lock.info plan.*.out

# Get Terraform into shape
TF_VAR_state_bucket=$StateBucket terraform init
terraform import aws_s3_bucket.state-storage $StateBucket
terraform import aws_dynamodb_table.state-locking-consistency jlucktay.terraform
