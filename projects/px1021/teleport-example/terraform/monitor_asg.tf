// Monitor is an example of influxdb + grafana deployment
// Grafana is available on port 8443
// Internal influxdb HTTP collector service listens on port 8086
resource "aws_autoscaling_group" "monitor" {
  desired_capacity          = 0
  force_delete              = false
  health_check_grace_period = 300
  health_check_type         = "EC2"
  launch_configuration      = "${aws_launch_configuration.monitor.name}"
  max_size                  = 1
  min_size                  = 1
  name                      = "${var.cluster_name}-monitor"

  tags = ["${concat(
    list(
      map(
        "key", "TeleportRole",
        "propagate_at_launch", true,
        "value", "monitor"
      ),
    ),
    local.default_tags_asg
  )}"]

  vpc_zone_identifier = [
    "${aws_subnet.public.0.id}",
  ]

  // Auto scaling group is associated with internal load balancer for metrics ingestion
  // and proxy load balancer for grafana
  target_group_arns = [
    "${aws_lb_target_group.monitor.arn}",
    "${aws_lb_target_group.proxy_grafana.arn}",
  ]

  // external autoscale algos can modify these values,
  // so ignore changes to them
  lifecycle {
    ignore_changes = [
      "desired_capacity",
      "max_size",
      "min_size",
    ]
  }
}

data "template_file" "monitor_user_data" {
  template = "${file("monitor-user-data.tpl")}"

  vars {
    cluster_name     = "${var.cluster_name}"
    domain_name      = "${var.route53_domain}"
    grafana_version  = "${var.grafana_version}"
    influxdb_version = "${var.influxdb_version}"
    region           = "${var.region}"
    s3_bucket        = "${var.s3_bucket_name}"
    telegraf_version = "${var.telegraf_version}"
  }
}

resource "aws_launch_configuration" "monitor" {
  associate_public_ip_address = true
  ebs_optimized               = true
  iam_instance_profile        = "${aws_iam_instance_profile.monitor.id}"
  image_id                    = "${data.aws_ami.base.id}"
  instance_type               = "${var.monitor_instance_type}"
  key_name                    = "${var.key_name}"
  name_prefix                 = "${var.cluster_name}-monitor-"
  user_data                   = "${data.template_file.monitor_user_data.rendered}"

  security_groups = [
    "${aws_security_group.monitor.id}",
  ]

  lifecycle {
    create_before_destroy = true
  }
}

// Monitors support traffic comming from internal cluster subnets and expose 8443 for grafana
resource "aws_security_group" "monitor" {
  name   = "${var.cluster_name}-monitor"
  tags   = "${local.default_tags}"
  vpc_id = "${local.vpc_id}"
}

// SSH access via bastion only
resource "aws_security_group_rule" "monitor_ingress_allow_ssh" {
  from_port                = 22
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.monitor.id}"
  source_security_group_id = "${aws_security_group.bastion.id}"
  to_port                  = 22
  type                     = "ingress"
}

// Ingress traffic to port 8443 is allowed from everywhere
resource "aws_security_group_rule" "monitor_ingress_allow_web" {
  from_port         = 8443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.monitor.id}"
  to_port           = 8443
  type              = "ingress"

  cidr_blocks = [
    "0.0.0.0/0",
  ]
}

// Influxdb metrics collector traffic is limited to internal VPC CIDR
// We use CIDR here because traffic arriving from NLB is not marked with security group
resource "aws_security_group_rule" "monitor_collector_ingress_allow_vpc_cidr_traffic" {
  from_port         = 8086
  protocol          = "tcp"
  security_group_id = "${aws_security_group.monitor.id}"
  to_port           = 8086
  type              = "ingress"

  cidr_blocks = [
    "${var.vpc_cidr}",
  ]
}

// All egress traffic is allowed
resource "aws_security_group_rule" "monitor_egress_allow_all_traffic" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.monitor.id}"
  to_port           = 0
  type              = "egress"

  cidr_blocks = [
    "0.0.0.0/0",
  ]
}

// Network load balancer for influxdb collector
// Notice that in this case it is in the single subnet because network load balancers only distriute traffic in the same AZ, and this example does not have HA InfluxDB setup
resource "aws_lb" "monitor" {
  idle_timeout       = 3600
  internal           = true
  load_balancer_type = "network"
  name               = "${var.cluster_name}-monitor"
  tags               = "${local.default_tags}"

  subnets = [
    "${aws_subnet.public.0.id}",
  ]
}

// Target group is associated with monitor instance
resource "aws_lb_target_group" "monitor" {
  name     = "${var.cluster_name}-monitor"
  port     = 8086
  protocol = "TCP"
  vpc_id   = "${aws_vpc.teleport.id}"
}

// 8086 is monitor metrics collector
resource "aws_lb_listener" "monitor" {
  load_balancer_arn = "${aws_lb.monitor.arn}"
  port              = "8086"
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.monitor.arn}"
    type             = "forward"
  }
}
