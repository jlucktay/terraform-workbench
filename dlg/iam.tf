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
