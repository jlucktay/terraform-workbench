// Dynamodb is used as a backend for auth servers, and only auth servers need access to the tables all other components are stateless.
resource "aws_dynamodb_table" "teleport" {
  hash_key       = "HashKey"
  name           = "${var.cluster_name}"
  range_key      = "FullPath"
  read_capacity  = 20
  tags           = "${local.default_tags}"
  write_capacity = 20

  attribute {
    name = "HashKey"
    type = "S"
  }

  attribute {
    name = "FullPath"
    type = "S"
  }

  lifecycle {
    ignore_changes = [
      "read_capacity",
      "write_capacity",
    ]
  }

  server_side_encryption {
    enabled = true
  }

  ttl {
    attribute_name = "Expires"
    enabled        = true
  }
}

// Dynamodb events table stores events
resource "aws_dynamodb_table" "teleport_events" {
  hash_key       = "SessionID"
  name           = "${var.cluster_name}-events"
  range_key      = "EventIndex"
  read_capacity  = 20
  tags           = "${local.default_tags}"
  write_capacity = 20

  attribute {
    name = "SessionID"
    type = "S"
  }

  attribute {
    name = "EventIndex"
    type = "N"
  }

  attribute {
    name = "EventNamespace"
    type = "S"
  }

  attribute {
    name = "CreatedAt"
    type = "N"
  }

  global_secondary_index {
    hash_key        = "EventNamespace"
    name            = "timesearch"
    projection_type = "ALL"
    range_key       = "CreatedAt"
    read_capacity   = 20
    write_capacity  = 20
  }

  lifecycle {
    ignore_changes = [
      "read_capacity",
      "write_capacity",
    ]
  }

  server_side_encryption {
    enabled = true
  }

  ttl {
    attribute_name = "Expires"
    enabled        = true
  }
}

// Autoscaler scales up/down the provisioned ops for DynamoDB table based on the load.
resource "aws_iam_role" "autoscaler" {
  name = "${var.cluster_name}-autoscaler"

  assume_role_policy = <<EOF
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "application-autoscaling.amazonaws.com"
      }
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

resource "aws_iam_role_policy" "autoscaler_dynamo" {
  name = "${var.cluster_name}-autoscaler-dynamo"
  role = "${aws_iam_role.autoscaler.id}"

  policy = <<EOF
{
  "Statement": [
    {
      "Action": [
        "dynamodb:DescribeTable",
        "dynamodb:UpdateTable"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${var.cluster_name}"
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

resource "aws_iam_role_policy" "autoscaler_cloudwatch" {
  name = "${var.cluster_name}-autoscaler-cloudwatch"
  role = "${aws_iam_role.autoscaler.id}"

  policy = <<EOF
{
  "Statement": [
    {
      "Action": [
        "cloudwatch:PutMetricAlarm",
        "cloudwatch:DescribeAlarms",
        "cloudwatch:DeleteAlarms"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

resource "aws_appautoscaling_target" "read_target" {
  max_capacity       = "${var.autoscale_max_read_capacity}"
  min_capacity       = "${var.autoscale_min_read_capacity}"
  resource_id        = "table/${var.cluster_name}"
  role_arn           = "${aws_iam_role.autoscaler.arn}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"

  lifecycle {
    ignore_changes = [
      "role_arn",
    ]
  }
}

resource "aws_appautoscaling_policy" "read_policy" {
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.read_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.read_target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.read_target.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.read_target.service_namespace}"

  target_tracking_scaling_policy_configuration {
    target_value = "${var.autoscale_read_target}"

    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
  }
}

resource "aws_appautoscaling_target" "write_target" {
  max_capacity       = "${var.autoscale_max_write_capacity}"
  min_capacity       = "${var.autoscale_min_write_capacity}"
  resource_id        = "table/${var.cluster_name}"
  role_arn           = "${aws_iam_role.autoscaler.arn}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"

  lifecycle {
    ignore_changes = [
      "role_arn",
    ]
  }
}

resource "aws_appautoscaling_policy" "write_policy" {
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.write_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.write_target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.write_target.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.write_target.service_namespace}"

  target_tracking_scaling_policy_configuration {
    target_value = "${var.autoscale_write_target}"

    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
  }
}
