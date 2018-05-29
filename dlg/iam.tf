resource "aws_iam_instance_profile" "fa-sftp-ec2" {
  name = "fa-sftp-ec2"
  role = "${aws_iam_role.fa-sftp-ec2.name}"
}

resource "aws_iam_role" "fa-sftp-ec2" {
  assume_role_policy = "${data.aws_iam_policy_document.ec2-assume-role-doc.json}"
  name               = "fa-sftp-ec2"
}

data "aws_iam_policy_document" "ec2-assume-role-doc" {
  statement {
    actions = ["sts:AssumeRole"]

    effect = "Allow"

    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role_policy_attachment" "ec2-access-secrets-attach" {
  role       = "${aws_iam_role.fa-sftp-ec2.name}"
  policy_arn = "${aws_iam_policy.ec2-access-secrets-policy.arn}"
}

resource "aws_iam_policy" "ec2-access-secrets-policy" {
  name        = "ec2-access-secrets-policy"
  description = "Allows the FA SFTP EC2 to access the necessary public key in Secrets Manager"
  policy      = "${data.aws_iam_policy_document.ec2-access-secrets-doc.json}"
}

data "aws_iam_policy_document" "ec2-access-secrets-doc" {
  statement {
    actions = ["secretsmanager:GetSecretValue"]

    effect = "Allow"

    resources = ["${data.aws_secretsmanager_secret.fa-sftp-ec2.arn}"]
  }
}

resource "aws_iam_role_policy_attachment" "ec2-instance-profile-attach" {
  role       = "${aws_iam_role.fa-sftp-ec2.name}"
  policy_arn = "${aws_iam_policy.ec2-instance-profile-policy.arn}"
}

resource "aws_iam_policy" "ec2-instance-profile-policy" {
  name        = "ec2-instance-profile-policy"
  description = "Allows the FA SFTP EC2 to describe and disassociate instance profiles, so that it can revoke its access after it has performed the necessary user-data steps."
  policy      = "${data.aws_iam_policy_document.ec2-instance-profile-doc.json}"
}

data "aws_iam_policy_document" "ec2-instance-profile-doc" {
  statement {
    actions = ["ec2:DescribeIamInstanceProfileAssociations"]

    effect = "Allow"

    resources = ["*"]
  }

  statement {
    actions = ["ec2:DisassociateIamInstanceProfile"]

    effect = "Allow"

    resources = ["arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:instance/${aws_instance.fa-sftp-ec2.id}"]
  }
}
