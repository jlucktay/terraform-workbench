variable "role-delimiter" {
  description = "The character that delimits var.role-names"
  default     = " "
}

variable "role-names" {
  description = "The name(s) of the IAM role, delimited with 'var.role-names'"
}

variable "role-type" {
  description = "The type of the IAM role; valid inputs are 'sso' and 'jump'"
}
