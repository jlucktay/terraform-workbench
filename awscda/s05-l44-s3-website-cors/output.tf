output "s3-website-index" {
  value = "http://${aws_s3_bucket.website-index.website_endpoint}"
}

output "s3-website-cors" {
  value = "http://${aws_s3_bucket.website-cors.website_endpoint}"
}
