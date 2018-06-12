output "cdn-domain" {
  value = "${aws_cloudfront_distribution.s3-sydney.domain_name}"
}

output "cdn-status" {
  value = "${aws_cloudfront_distribution.s3-sydney.status}"
}
