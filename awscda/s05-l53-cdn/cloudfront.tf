resource "aws_cloudfront_origin_access_identity" "s3-sydney" {
  comment = "For S3 bucket: james-lucktaylor-cdn-sydney"
}

resource "aws_cloudfront_distribution" "s3-sydney" {
  enabled = true

  depends_on = [
    "aws_s3_bucket_object.awesome-sydney",
  ]

  tags = "${
    merge(
      local.default-tags,
      map(
        "Name", "james-lucktaylor-cdn-s3-sydney",
      )
    )
  }"

  default_cache_behavior {
    target_origin_id       = "S3-james-lucktaylor-cdn-sydney"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = [
      "GET",
      "HEAD",
    ]

    cached_methods = [
      "GET",
      "HEAD",
    ]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  origin {
    domain_name = "${aws_s3_bucket.sydney.bucket_regional_domain_name}"
    origin_id   = "S3-james-lucktaylor-cdn-sydney"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.s3-sydney.cloudfront_access_identity_path}"
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
