// Autoscaling group for Teleport Authentication servers.
// Auth servers are most privileged in terms of IAM roles as they are allowed to publish to SSM parameter store, write certificates to encrypted S3 bucket.
resource "aws_autoscaling_group" "auth" {
  desired_capacity          = "${length(local.azs)}"
  force_delete              = false
  health_check_grace_period = 300
  health_check_type         = "EC2"
  launch_configuration      = "${aws_launch_configuration.auth.name}"
  max_size                  = 5
  min_size                  = "${length(local.azs)}"
  name                      = "${var.cluster_name}-auth"

  tags = ["${concat(
    list(
      map(
        "key", "TeleportRole",
        "propagate_at_launch", true,
        "value", "auth"
      ),
    ),
    local.default_tags_asg
  )}"]

  // These are target groups of the auth server network load balancer this autoscaling group is associated with target groups of the NLB
  target_group_arns = [
    "${aws_lb_target_group.auth.arn}",
  ]

  vpc_zone_identifier = [
    "${aws_subnet.auth.*.id}",
  ]

  // External autoscale algos can modify these values, so ignore changes to them
  lifecycle {
    ignore_changes = [
      "desired_capacity",
      "max_size",
      "min_size",
    ]
  }
}

data "template_file" "auth_user_data" {
  template = "${file("auth-user-data.tpl")}"

  vars {
    cluster_name             = "${var.cluster_name}"
    domain_name              = "${var.route53_domain}"
    dynamo_events_table_name = "${aws_dynamodb_table.teleport_events.name}"
    dynamo_table_name        = "${aws_dynamodb_table.teleport.name}"
    email                    = "${var.email}"
    influxdb_addr            = "http://${aws_lb.monitor.dns_name}:8086"
    locks_table_name         = "${aws_dynamodb_table.locks.name}"
    region                   = "${var.region}"
    s3_bucket                = "${var.s3_bucket_name}"
    telegraf_version         = "${var.telegraf_version}"
    teleport_uid             = "${var.teleport_uid}"
    teleport_version         = "${var.teleport_version}"
  }
}

resource "aws_launch_configuration" "auth" {
  associate_public_ip_address = false
  ebs_optimized               = true
  iam_instance_profile        = "${aws_iam_instance_profile.auth.id}"
  image_id                    = "${data.aws_ami.base.id}"
  instance_type               = "${var.auth_instance_type}"
  key_name                    = "${var.key_name}"
  name_prefix                 = "${var.cluster_name}-auth-"
  user_data                   = "${data.template_file.auth_user_data.rendered}"

  security_groups = [
    "${aws_security_group.auth.id}",
  ]

  lifecycle {
    create_before_destroy = true
  }
}
