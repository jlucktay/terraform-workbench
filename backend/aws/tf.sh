#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Set up environment with keys
awsume jlucktay

# Clean up any old stuff
find .terraform -type d -not -name .terraform -not -path "*plugins*" -exec rm -rfv -- {} +
rm -fv terraform.tfstate terraform.tfstate.backup .terraform.tfstate.lock.info plan.*.out

# Get Terraform into shape
terraform init

set +e
terraform import aws_s3_bucket.state-storage "${TF_VAR_state_bucket:?}"
terraform import aws_dynamodb_table.state-locking-consistency "${TF_VAR_state_dynamodb:?}"

set -e
terraform apply --auto-approve
