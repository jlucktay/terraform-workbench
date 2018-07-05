// Proxy auto scaling group is for Teleport proxies
// set up in the public subnet. This is the only group of servers that are
// accepting traffic from the internet.
resource "aws_autoscaling_group" "proxy" {
  desired_capacity          = "${length(local.azs)}"
  force_delete              = false
  health_check_grace_period = 300
  health_check_type         = "EC2"
  launch_configuration      = "${aws_launch_configuration.proxy.name}"
  max_size                  = 5
  min_size                  = "${length(local.azs)}"
  name                      = "${var.cluster_name}-proxy"

  tags = ["${concat(
    list(
      map(
        "key", "TeleportRole",
        "propagate_at_launch", true,
        "value", "proxy"
      ),
    ),
    local.default_tags_asg
  )}"]

  // Auto scaling group is associated with load balancer
  target_group_arns = [
    "${aws_lb_target_group.proxy_proxy.arn}",
    "${aws_lb_target_group.proxy_web.arn}",
  ]

  vpc_zone_identifier = [
    "${aws_subnet.public.*.id}",
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

data "template_file" "proxy_user_data" {
  template = "${file("proxy-user-data.tpl")}"

  vars {
    auth_server_addr = "${aws_lb.auth.dns_name}:3025"
    cluster_name     = "${var.cluster_name}"
    domain_name      = "${var.route53_domain}"
    email            = "${var.email}"
    influxdb_addr    = "http://${aws_lb.monitor.dns_name}:8086"
    region           = "${var.region}"
    s3_bucket        = "${var.s3_bucket_name}"
    telegraf_version = "${var.telegraf_version}"
    teleport_uid     = "${var.teleport_uid}"
    teleport_version = "${var.teleport_version}"
  }
}

resource "aws_launch_configuration" "proxy" {
  associate_public_ip_address = true
  ebs_optimized               = true
  iam_instance_profile        = "${aws_iam_instance_profile.proxy.id}"
  image_id                    = "${data.aws_ami.base.id}"
  instance_type               = "${var.proxy_instance_type}"
  key_name                    = "${var.key_name}"
  name_prefix                 = "${var.cluster_name}-proxy-"
  user_data                   = "${data.template_file.proxy_user_data.rendered}"

  security_groups = [
    "${aws_security_group.proxy.id}",
  ]

  lifecycle {
    create_before_destroy = true
  }
}
