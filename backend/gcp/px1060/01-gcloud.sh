#!/usr/bin/env bash
# shellcheck disable=2154 # Environment variables are already defined by a previous script
set -euo pipefail
IFS=$'\n\t'

# We need to use the Google Cloud SDK so make sure it's present!
if ! command -v gcloud > /dev/null; then
    echo "'gcloud' not found! Please install: https://cloud.google.com/sdk/install"
    exit 1
fi

if ! command -v gsutil > /dev/null; then
    echo "'gsutil' not found! Please install: https://cloud.google.com/storage/docs/gsutil_install"
    exit 1
fi

# Using an Admin Project for your Terraform service account keeps the resources needed for managing your projects separate from the actual projects you create. While these resources could be created with Terraform using a service account from an existing project, in this tutorial you will create a separate project and service account exclusively for Terraform.

# Create a new project and link it to your billing account:
gcloud projects create "${TF_ADMIN}" --organization "${TF_VAR_org_id}" --set-as-default
gcloud beta billing projects link "${TF_ADMIN}" --billing-account "${TF_VAR_billing_account}"

# Create the service account in the Terraform admin project and download the JSON credentials:
gcloud iam service-accounts create terraform --display-name "Terraform admin account"
gcloud iam service-accounts keys create "${TF_CREDS}" --iam-account "terraform@${TF_ADMIN}.iam.gserviceaccount.com"

# Grant the service account permission to view the Admin Project and manage Cloud Storage:
gcloud projects add-iam-policy-binding "${TF_ADMIN}" --member "serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com" --role roles/viewer
gcloud projects add-iam-policy-binding "${TF_ADMIN}" --member "serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com" --role roles/storage.admin

# Any actions that Terraform performs require that the API be enabled to do so. In this guide, Terraform requires the following:
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable cloudbilling.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable compute.googleapis.com

# Add organization/folder-level permissions
# Grant the service account permission to create projects and assign billing accounts:
gcloud organizations add-iam-policy-binding "${TF_VAR_org_id}" --member "serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com" --role roles/resourcemanager.projectCreator
gcloud organizations add-iam-policy-binding "${TF_VAR_org_id}" --member "serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com" --role roles/billing.user

# If your billing account is owned by another organization, then make sure the service account email has been added as a Billing Account User to the billing account permissions.

# Set up remote state in Cloud Storage
# Create the remote backend bucket in Cloud Storage and the backend.tf file for storage of the terraform.tfstate file:
gsutil mb -p "${TF_ADMIN}" "gs://${TF_ADMIN}"

cat > backend.tf <<EOF
terraform {
    backend "gcs" {
        bucket  = "${TF_ADMIN}"
        path    = "/terraform.tfstate"
        project = "${TF_ADMIN}"
    }
}
EOF

# Enable versioning for said remote bucket:
gsutil versioning set on "gs://${TF_ADMIN}"
