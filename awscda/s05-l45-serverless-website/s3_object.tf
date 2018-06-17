resource "aws_s3_bucket_object" "serverless-index" {
  acl          = "public-read"
  bucket       = "${aws_s3_bucket.serverless-website.bucket}"
  content      = "${data.template_file.index-html.rendered}"
  content_type = "text/html"
  key          = "${aws_s3_bucket.serverless-website.website.0.index_document}"
  tags         = "${local.default-tags}"
}

resource "aws_s3_bucket_object" "website-error" {
  acl          = "public-read"
  bucket       = "${aws_s3_bucket.serverless-website.bucket}"
  content      = "${file("./error.html")}"
  content_type = "text/html"
  key          = "${aws_s3_bucket.serverless-website.website.0.error_document}"
  tags         = "${local.default-tags}"
}

data "template_file" "index-html" {
  template = "${file("${path.module}/index.html")}"

  vars {
    invocation_url = "${aws_api_gateway_deployment.serverless.invoke_url}/${aws_api_gateway_resource.serverless.path_part}"
  }
}
