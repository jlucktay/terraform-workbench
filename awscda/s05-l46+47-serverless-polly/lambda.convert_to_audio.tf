resource "aws_lambda_function" "polly_convert_to_audio" {
  description      = "james.lucktaylor - AWS CDA course on Udemy - section 5 lab 46 - Polly - This function converts my text to audio files and saves them to S3"
  filename         = "${data.archive_file.polly_convert_to_audio.output_path}"
  function_name    = "james-lucktaylor-awscda-postreader-convert_to_audio"
  handler          = "convert_to_audio.lambda_handler"
  role             = "${aws_iam_role.lambda_polly.arn}"
  runtime          = "python2.7"
  source_code_hash = "${data.archive_file.polly_convert_to_audio.output_base64sha256}"
  timeout          = 300

  tags = "${merge(
    local.default-tags,
    map(
      "Description", "james.lucktaylor - AWS CDA course on Udemy - section 5 lab 46 - Polly - This function converts my text to audio files and saves them to S3",
      "Name", "james-lucktaylor-awscda-postreader-convert_to_audio",
    )
  )}"

  environment {
    variables {
      BUCKET_NAME   = "${aws_s3_bucket.polly_mp3s.bucket}"
      DB_TABLE_NAME = "${aws_dynamodb_table.posts.name}"
    }
  }
}

data "archive_file" "polly_convert_to_audio" {
  output_path = "convert_to_audio.zip"
  source_file = "convert_to_audio.py"
  type        = "zip"
}

resource "aws_lambda_permission" "convert_to_audio" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.polly_convert_to_audio.function_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_sns_topic.new_posts.arn}"
}
