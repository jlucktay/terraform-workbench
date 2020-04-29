#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Set up environment with keys
export AWS_DEFAULT_PROFILE="personal"
export AWS_PROFILE=$AWS_DEFAULT_PROFILE
export AWS_DEFAULT_REGION="eu-west-2"
export TF_VAR_state_bucket="jlucktay-tfstate"
export TF_VAR_state_dynamodb="jlucktay-tfstate"
export TF_VAR_region=$AWS_DEFAULT_REGION

terraform init \
  --backend-config="bucket=$TF_VAR_state_bucket" \
  --backend-config="dynamodb_table=$TF_VAR_state_dynamodb" \
  --input=false

terraform plan --input=false

terraform apply
