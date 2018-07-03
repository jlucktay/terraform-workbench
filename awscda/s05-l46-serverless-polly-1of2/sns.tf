resource "aws_sns_topic" "new_posts" {
  display_name = "New Posts"
  name         = "james_lucktaylor_awscda_new_posts"
}

resource "aws_sns_topic_subscription" "lambda_polly_convert_to_audio" {
  endpoint  = "${aws_lambda_function.polly_convert_to_audio.arn}"
  protocol  = "lambda"
  topic_arn = "${aws_sns_topic.new_posts.arn}"
}
