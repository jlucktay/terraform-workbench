#!/usr/bin/env bash
IFS=$'\n\t'

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
    echo "This script '${BASH_SOURCE[0]}' must be sourced."
    exit 1
fi

echo -n "Exporting Tidal Teleport demo variables for Terraform... "

export TF_VAR_region="eu-west-1"
export TF_VAR_cluster_name="James.L.Tidal.Teleport.Demo"
export TF_VAR_teleport_version="2.6.6"
export TF_VAR_key_name="james.lucktaylor.${TF_VAR_region}"
export TF_VAR_license_path="/Users/jameslucktaylor/git/bitbucket.org/cloudreach/james-lucktaylor-terraform/projects/px1021/teleport-example/terraform/license.pem"
export TF_VAR_route53_zone="celab.cloudreach.com"
export TF_VAR_route53_domain="tidal.teleport.demo.${TF_VAR_route53_zone}"
export TF_VAR_s3_bucket_name="${TF_VAR_cluster_name}"
export TF_VAR_email="james.lucktaylor@cloudreach.com"

echo "Done!"
