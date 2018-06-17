resource "aws_iam_role" "serverless" {
  assume_role_policy = "${data.aws_iam_policy_document.lambda-assume.json}"
  name               = "james.lucktaylor.awscda.serverless"
}

data "aws_iam_policy_document" "lambda-assume" {
  statement {
    actions = ["sts:AssumeRole"]

    effect = "Allow"

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "cloudwatch-allow" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
    ]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${aws_lambda_function.serverless.function_name}:*",
    ]
  }
}

resource "aws_iam_role_policy" "cloudwatch-allow" {
  name   = "CloudWatch.Allow"
  policy = "${data.aws_iam_policy_document.cloudwatch-allow.json}"
  role   = "${aws_iam_role.serverless.name}"
}

data "aws_iam_policy_document" "dynamodb-allow" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:Scan",
      "dynamodb:UpdateItem",
    ]

    resources = [
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/*",
    ]
  }
}

resource "aws_iam_role_policy" "dynamodb-allow" {
  name   = "DynamoDB.Allow"
  policy = "${data.aws_iam_policy_document.dynamodb-allow.json}"
  role   = "${aws_iam_role.serverless.name}"
}
