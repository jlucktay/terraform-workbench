#!/usr/local/bin/bash
set -euo pipefail
IFS=$'\n\t'

awsume celab
rm -rfv .terraform terraform.tfstate terraform.tfstate.backup .terraform.tfstate.lock.info plan.*.out
terraform init
terraform import aws_s3_bucket.state-storage james-lucktaylor-terraform
terraform import aws_dynamodb_table.state-locking-consistency james.lucktaylor.dynamodb.terraform
