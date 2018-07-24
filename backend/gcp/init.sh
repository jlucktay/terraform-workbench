#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Find the values for GCloudOrgId and GCloudBillingId:
# gcloud organizations list
# gcloud beta billing accounts list

GCloudOrgId="1034654569623"
GCloudBillingId="01DA4D-2AA64D-266E55"

# Export the following variables to your environment for use throughout:
export TF_VAR_org_id=$GCloudOrgId
export TF_VAR_billing_account=$GCloudBillingId
export TF_ADMIN="px1060-terraform-admin"
export TF_CREDS=~/.config/gcloud/${TF_ADMIN}.json
# Note: The TF_ADMIN variable will be used for the name of the Terraform Admin Project and must be unique.
