output "awesome-cdn" {
  value = "https://${aws_cloudfront_distribution.s3-sydney.domain_name}/${aws_s3_bucket_object.awesome-sydney.key}"
}

output "awesome-s3" {
  value = "https://${aws_s3_bucket.sydney.bucket_regional_domain_name}/${aws_s3_bucket_object.awesome-sydney.key}"
}

output "cdn-status" {
  value = "${aws_cloudfront_distribution.s3-sydney.status}"
}
