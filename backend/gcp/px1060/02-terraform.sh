#!/usr/bin/env bash

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
    echo "This script '${BASH_SOURCE[0]}' must be sourced, like so:"
    echo "    $(tput setab 7 ; tput setaf 0). ${BASH_SOURCE[0]}$(tput sgr0)"
    exit 1
fi

PreviousIFS=$IFS
IFS=$'\n\t'

echo -n "Exporting PX1060 variables for Terraform... "

# Configure your environment for the Google Cloud Terraform provider:
export GOOGLE_APPLICATION_CREDENTIALS="${TF_CREDS}"
export GOOGLE_PROJECT="${TF_ADMIN}"

# Next, initialize the backend:
terraform init

IFS=$PreviousIFS

echo "Done!"
