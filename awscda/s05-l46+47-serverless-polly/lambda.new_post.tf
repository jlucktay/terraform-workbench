resource "aws_lambda_function" "polly_new_post" {
  description      = "james.lucktaylor - AWS CDA course on Udemy - section 5 lab 46 - Polly - This function creates posts in DynamoDB"
  filename         = "${data.archive_file.polly_new_post.output_path}"
  function_name    = "james-lucktaylor-awscda-postreader-new_post"
  handler          = "new_post.lambda_handler"
  role             = "${aws_iam_role.lambda_polly.arn}"
  runtime          = "python3.6"
  source_code_hash = "${data.archive_file.polly_new_post.output_base64sha256}"

  tags = "${merge(
    local.default-tags,
    map(
      "Description", "james.lucktaylor - AWS CDA course on Udemy - section 5 lab 46 - Polly - This function creates posts in DynamoDB",
      "Name", "james-lucktaylor-awscda-postreader-new_post",
    )
  )}"

  environment {
    variables {
      DB_TABLE_NAME = "${aws_dynamodb_table.posts.name}"
      SNS_TOPIC     = "${aws_sns_topic.new_posts.arn}"
    }
  }
}

data "archive_file" "polly_new_post" {
  output_path = "new_post.zip"
  source_file = "new_post.py"
  type        = "zip"
}

/*
resource "aws_lambda_permission" "get_posts" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.polly_convert_to_audio.function_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_sns_topic.new_posts.arn}"
}
*/
