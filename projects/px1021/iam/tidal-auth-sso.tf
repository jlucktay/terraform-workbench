module "tidal-auth-sso" {
  source = "modules/iam"

  role-type  = "sso"
  role-names = "${join(var.role-delimiter, var.tidal-auth-sso)}"
}

variable "tidal-auth-sso" {
  description = "IAM roles in the 'tidal-auth' account that are assumed by federated logins"

  default = [
    "fd-big-data-admin",
    "fd-big-data-user",
    "fd-billing-admin",
    "fd-business-analytics-user",
    "fd-business-intelligence-admin",
    "fd-business-intelligence-user",
    "fd-commerical-web-admin",
    "fd-commerical-web-user",
    "fd-content-consultant",
    "fd-content-user",
    "fd-crm-user",
    "fd-devops-admin",
    "fd-devops-security",
    "fd-playback-user",
    "fd-user-commercial-web-user",
    "fd-user-management-user",
    "fd-web-client-admin",
    "fd-web-client-user",
  ]
}
