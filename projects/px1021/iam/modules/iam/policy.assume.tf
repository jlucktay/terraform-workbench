# TODO: alter assume policy based on 'jump' or 'sso' input from 'var.role-type'
# Alternatively, create two distinct policy objects, and switch between them at a slightly higher level

data "aws_iam_policy_document" "assume-role" {
  statement {
    actions = ["sts:AssumeRole"]

    effect = "Allow"

    principals {
      type = ""

      identifiers = [
        "",
      ]
    }
  }
}

### Pattern for 'sso' type to trust:
# "Principal": { "Federated": "arn:aws:iam::AWS-account-ID:saml-provider/provider-name" }
#
### Pattern for 'jump' type to trust:
# "Principal": { "AWS": "arn:aws:iam::AWS-account-ID:role/role-name" }
