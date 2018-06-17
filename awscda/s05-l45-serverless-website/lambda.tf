resource "aws_lambda_function" "serverless" {
  description      = "james.lucktaylor - Serverless website with the power of the cloud!"
  filename         = "hellocloudgurus.zip"
  function_name    = "james-lucktaylor-awscda-serverless"
  handler          = "hellocloudgurus.lambda_handler"
  role             = "${aws_iam_role.serverless.arn}"
  runtime          = "python3.6"
  source_code_hash = "${data.archive_file.serverless.output_base64sha256}"

  tags = "${
    merge(
      local.default-tags,
      map(
        "Description", "james.lucktaylor - Serverless website with the power of the cloud!",
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

resource "aws_lambda_permission" "serverless" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.serverless.function_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.serverless.execution_arn}/*/GET/resource"
}
