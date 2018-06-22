# TODO: alter assume policy based on 'jump' or 'sso' input from 'var.role-type'

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

# Pattern for 'sso' style principal to trust:
# "Principal": { "Federated": "arn:aws:iam::AWS-account-ID:saml-provider/provider-name" }
