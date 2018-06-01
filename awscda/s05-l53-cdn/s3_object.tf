resource "aws_s3_bucket_object" "awsome-sydney" {
  acl      = "public-read"
  bucket   = "${aws_s3_bucket.sydney.bucket}"
  key      = "awsome.png"
  provider = "aws.sydney"
  source   = "./awesome.png"
}
