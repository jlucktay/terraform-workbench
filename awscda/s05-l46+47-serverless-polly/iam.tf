resource "aws_iam_role" "lambda_polly" {
  assume_role_policy = "${data.aws_iam_policy_document.lambda_assume.json}"
  name               = "james.lucktaylor.awscda.lambda.polly"
}

data "aws_iam_policy_document" "lambda_assume" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role_policy" "lambda_polly" {
  name   = "james.lucktaylor.awscda.lambda.polly"
  policy = "${file("lambda-policy-polly.json")}"
  role   = "${aws_iam_role.lambda_polly.name}"
}
