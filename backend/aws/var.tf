variable "region" {
  description = "Which AWS region to operate in?  No default is set, so that prompts will occur"
}

variable "state_bucket" {
  description = "The name of the S3 bucket that Terraform state will be stored in"
}

variable "state_dynamodb" {
  description = "The name of the DynamoDB table that Terraform state will be locked with"
}
