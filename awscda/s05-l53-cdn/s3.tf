resource "aws_s3_bucket" "london" {
  bucket   = "james-lucktaylor-cdn-london"
  provider = "aws.london"
  region   = "eu-west-2"

  tags = "${merge(
    local.default-tags,
    map(
      "Name", "james-lucktaylor-cdn-london",
    )
  )}"
}

resource "aws_s3_bucket" "sydney" {
  bucket   = "james-lucktaylor-cdn-sydney"
  provider = "aws.sydney"
  region   = "ap-southeast-2"

  tags = "${merge(
    local.default-tags,
    map(
      "Name", "james-lucktaylor-cdn-sydney",
    )
  )}"
}

data "aws_iam_policy_document" "s3" {
  statement {
    actions = ["s3:GetObject"]

    effect = "Allow"

    principals {
      identifiers = ["arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.s3-sydney.id}"]
      type        = "AWS"
    }

    resources = ["${aws_s3_bucket.sydney.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "sydney" {
  bucket   = "${aws_s3_bucket.sydney.id}"
  policy   = "${data.aws_iam_policy_document.s3.json}"
  provider = "aws.sydney"
}
