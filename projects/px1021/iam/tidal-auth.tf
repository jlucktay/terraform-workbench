# Following a pattern from here:
# https://serialseb.com/blog/2016/05/11/terraform-working-around-no-count-on-module/

module "tidal-auth-jump" {
  source = "modules/iam"

  role-type  = "jump"
  role-names = "${join(var.role-delimiter, var.tidal-auth-jump)}"
}

variable "tidal-auth-jump" {
  description = "IAM roles in the 'tidal-auth' account to jump into from SSO"

  default = [
    "fd-billing-admin",
    "fds-devops-admin",
    "fds-devops-security",
  ]
}
