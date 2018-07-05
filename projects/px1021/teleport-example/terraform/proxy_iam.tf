// Proxy instance profile and roles
resource "aws_iam_role" "proxy" {
  name = "${var.cluster_name}-proxy"

  assume_role_policy = <<EOF
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

// Proxy fetches certificates obtained by auth servers from encrypted S3 bucket.
// Proxies do not setup certificates, to keep privileged operations happening
// only on auth servers.
resource "aws_iam_instance_profile" "proxy" {
  name = "${var.cluster_name}-proxy"
  role = "${aws_iam_role.proxy.name}"

  depends_on = [
    "aws_iam_role_policy.proxy_ssm",
  ]
}

resource "aws_iam_role_policy" "proxy_s3" {
  name = "${var.cluster_name}-proxy-s3"
  role = "${aws_iam_role.proxy.id}"

  policy = <<EOF
{
  "Statement": [
    {
      "Action": [
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.certs.bucket}"
      ]
    },
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.certs.bucket}/*"
      ]
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

// Proxies fetch join tokens from SSM parameter store. Tokens are rotated
// and published by auth servers on an hourly basis.
resource "aws_iam_role_policy" "proxy_ssm" {
  name = "${var.cluster_name}-proxy-ssm"
  role = "${aws_iam_role.proxy.id}"

  policy = <<EOF
{
  "Statement": [
    {
      "Action": [
        "ssm:GetParameters",
        "ssm:GetParametersByPath",
        "ssm:GetParameter"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/teleport/${var.cluster_name}/tokens/proxy"
    },
    {
      "Action": [
        "ssm:GetParameters",
        "ssm:GetParametersByPath",
        "ssm:GetParameter"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/teleport/${var.cluster_name}/ca"
    },
    {
      "Action": [
        "kms:Decrypt"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/${data.aws_kms_alias.ssm.target_key_id}"
      ]
    }
  ],
  "Version": "2012-10-17"
}
EOF
}
