#!/usr/bin/env bash

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
    echo "This script '${BASH_SOURCE[0]}' must be sourced, like so:"
    echo "    $(tput setab 7 ; tput setaf 0). ${BASH_SOURCE[0]}$(tput sgr0)"
    exit 1
fi

PreviousIFS=$IFS
IFS=$'\n\t'

echo -n "Exporting PX1060 variables for Terraform... "

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

IFS=$PreviousIFS

echo "Done!"
