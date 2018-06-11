resource "aws_iam_role" "ec2-dyndb" {
  name               = "james.lucktaylor.ec2-dyndb"
  assume_role_policy = "${data.aws_iam_policy_document.ec2-assume-role-doc.json}"
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

resource "aws_iam_role_policy_attachment" "ec2-dyndb" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  role       = "${aws_iam_role.ec2-dyndb.name}"
}

resource "aws_iam_instance_profile" "ec2-dyndb" {
  name = "james.lucktaylor.ec2-dyndb"
  role = "${aws_iam_role.ec2-dyndb.name}"
}
