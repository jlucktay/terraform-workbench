#!/usr/bin/env bash

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
    echo "This script '${BASH_SOURCE[0]}' must be sourced, like so:"
    echo "    $(tput setab 7 ; tput setaf 0). ${BASH_SOURCE[0]}$(tput sgr0)"
    exit 1
fi

PreviousIFS=$IFS
IFS=$'\n\t'

echo -n "Exporting Tidal Teleport demo variables for Terraform... "

export TF_VAR_region="eu-west-1"
export TF_VAR_cluster_name="James-L-Tidal"
export TF_VAR_teleport_version="2.6.6"
export TF_VAR_key_name="james.lucktaylor.${TF_VAR_region}"
export TF_VAR_license_path="/Users/jameslucktaylor/git/bitbucket.org/cloudreach/james-lucktaylor-terraform/projects/px1021/teleport-example/terraform/license.pem"
export TF_VAR_route53_zone="celab.cloudreach.com"
export TF_VAR_route53_domain="tidal.teleport.demo.${TF_VAR_route53_zone}"
export TF_VAR_s3_bucket_name="james.lucktaylor.tidal.teleport.demo"
export TF_VAR_email="james.lucktaylor@cloudreach.com"

TF_VAR_grafana_pass=$(base64 --decode < export.secret.grafana_pass.txt)
export TF_VAR_grafana_pass

IFS=$PreviousIFS

echo "Done!"
