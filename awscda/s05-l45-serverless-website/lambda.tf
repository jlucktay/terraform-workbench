resource "aws_lambda_function" "serverless" {
  description      = "Serverless website with the power of the cloud!"
  filename         = "hellocloudgurus.zip"
  function_name    = "james-lucktaylor-awscda-serverless"
  handler          = "lambda_function.lambda_handler"
  role             = "${aws_iam_role.serverless.arn}"
  runtime          = "python3.6"
  source_code_hash = "${data.archive_file.serverless.output_base64sha256}"

  tags = "${
    merge(
      local.default-tags,
      map(
        "Name", "james-lucktaylor-awscda-serverless",
      )
    )
  }"
}

data "archive_file" "serverless" {
  output_path = "hellocloudgurus.zip"
  source_file = "hellocloudgurus.py"
  type        = "zip"
}
