#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Set up environment with keys
export AWS_DEFAULT_PROFILE="personal"
export AWS_DEFAULT_REGION="eu-west-2"
export TF_VAR_state_bucket="jlucktay-tfstate"
export TF_VAR_state_dynamodb="jlucktay-tfstate"
export TF_VAR_region=$AWS_DEFAULT_REGION

# Clean up any old stuff
find .terraform -type d -not -name .terraform -not -path "*plugins*" -exec rm -rfv -- {} +
rm -fv terraform.tfstate terraform.tfstate.backup .terraform.tfstate.lock.info plan.*.out

# Get Terraform into shape
terraform init

# Disabled errexit for Terraform's import attempts
# This allows flow to fall through to applying/creating resources
set +e
terraform import aws_s3_bucket.state_storage "${TF_VAR_state_bucket:?}"
terraform import aws_dynamodb_table.state_locking_consistency "${TF_VAR_state_dynamodb:?}"
set -e
terraform plan --input=false --refresh=true
terraform apply --auto-approve
