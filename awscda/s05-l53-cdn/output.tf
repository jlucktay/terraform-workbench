output "cdn-status" {
  value = "${aws_cloudfront_distribution.s3-sydney.status}"
}
