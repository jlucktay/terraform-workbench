resource "aws_lambda_function" "polly_get_posts" {
  description      = "james.lucktaylor - AWS CDA course on Udemy - section 5 lab 46 - Polly - This function gets all posts from our DynamoDB table"
  filename         = "${data.archive_file.polly_get_posts.output_path}"
  function_name    = "james-lucktaylor-awscda-postreader-get_posts"
  handler          = "get_posts.lambda_handler"
  role             = "${aws_iam_role.lambda_polly.arn}"
  runtime          = "python3.6"
  source_code_hash = "${data.archive_file.polly_get_posts.output_base64sha256}"

  tags = "${merge(
    local.default-tags,
    map(
      "Description", "james.lucktaylor - AWS CDA course on Udemy - section 5 lab 46 - Polly - This function gets all posts from our DynamoDB table",
      "Name", "james-lucktaylor-awscda-postreader-get_posts",
    )
  )}"

  environment {
    variables {
      DB_TABLE_NAME = "${aws_dynamodb_table.posts.name}"
    }
  }
}

data "archive_file" "polly_get_posts" {
  output_path = "get_posts.zip"
  source_file = "get_posts.py"
  type        = "zip"
}

resource "aws_lambda_permission" "get_posts" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.polly_get_posts.function_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.polly.execution_arn}/*/${aws_api_gateway_method.polly_get.http_method}/${aws_api_gateway_resource.polly.path_part}"
}
