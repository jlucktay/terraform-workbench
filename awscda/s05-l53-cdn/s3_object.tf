resource "aws_s3_bucket_object" "awesome-sydney" {
  acl          = "public-read"
  bucket       = "${aws_s3_bucket.sydney.bucket}"
  content_type = "image/png"
  key          = "awesome.png"
  provider     = "aws.sydney"
  source       = "./awesome.png"
}
