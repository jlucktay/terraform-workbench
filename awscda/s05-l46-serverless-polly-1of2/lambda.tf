resource "aws_lambda_function" "polly_newposts" {
  filename         = "${data.archive_file.polly_newposts.output_path}"
  function_name    = "james-lucktaylor-awscda-postreader-newposts"
  handler          = "newposts.lambda_handler"
  role             = "${aws_iam_role.lambda_polly.arn}"
  runtime          = "python3.6"
  source_code_hash = "${data.archive_file.polly_newposts.output_base64sha256}"

  tags = "${merge(
    local.default-tags,
    map(
      "Description", "james.lucktaylor - AWS CDA course on Udemy - section 5 lab 46 - Polly - This function creates posts in DynamoDB",
      "Name", "james-lucktaylor-awscda-postreader-newposts",
    )
  )}"

  environment {
    variables {
      DB_TABLE_NAME = "${aws_dynamodb_table.posts.name}"
      SNS_TOPIC     = "${aws_sns_topic.new_posts.arn}"
    }
  }
}

data "archive_file" "polly_newposts" {
  output_path = "newposts.zip"
  source_file = "newposts.py"
  type        = "zip"
}

# resource "aws_lambda_permission" "serverless" {
#   action        = "lambda:InvokeFunction"
#   function_name = "${aws_lambda_function.serverless.function_name}"
#   principal     = "apigateway.amazonaws.com"
#   source_arn    = "${aws_api_gateway_rest_api.serverless.execution_arn}/*/GET/${aws_api_gateway_resource.serverless.path_part}"
# }
