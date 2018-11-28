resource "aws_s3_bucket" "website" {
  bucket = "james-lucktaylor-website"
  region = "${var.region}"

  tags = {
    Name = "james-lucktaylor-website"
  }

  website {
    error_document = "error.html"
    index_document = "index.html"
  }
}
