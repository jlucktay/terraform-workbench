output "s3-website" {
  value = "http://${aws_s3_bucket.website.website_endpoint}"
}
