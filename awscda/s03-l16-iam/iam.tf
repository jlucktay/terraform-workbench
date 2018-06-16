resource "aws_iam_role" "main" {
  assume_role_policy = "${data.aws_iam_policy_document.ec2-assume-role-doc.json}"
  name               = "james.lucktaylor.awscda.s3.admin"
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

resource "aws_iam_role_policy_attachment" "s3" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = "${aws_iam_role.main.name}"
}
