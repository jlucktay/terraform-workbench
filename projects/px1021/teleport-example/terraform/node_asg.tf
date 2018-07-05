// Node auto scaling group supports multiple teleport nodes joining the cluster, setup for demo/testing purposes.
resource "aws_autoscaling_group" "node" {
  desired_capacity          = 1
  force_delete              = false
  health_check_grace_period = 300
  health_check_type         = "EC2"
  launch_configuration      = "${aws_launch_configuration.node.name}"
  max_size                  = 1000
  min_size                  = 1
  name                      = "${var.cluster_name}-node"

  tags = ["${concat(
    list(
      map(
        "key", "TeleportRole",
        "propagate_at_launch", true,
        "value", "node"
      ),
    ),
    local.default_tags_asg
  )}"]

  vpc_zone_identifier = [
    "${aws_subnet.node.*.id}",
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

data "template_file" "node_user_data" {
  template = "${file("node-user-data.tpl")}"

  vars {
    auth_server_addr = "${aws_lb.auth.dns_name}:3025"
    cluster_name     = "${var.cluster_name}"
    influxdb_addr    = "http://${aws_lb.monitor.dns_name}:8086"
    region           = "${var.region}"
    telegraf_version = "${var.telegraf_version}"
    teleport_version = "${var.teleport_version}"
  }
}

resource "aws_launch_configuration" "node" {
  associate_public_ip_address = false
  iam_instance_profile        = "${aws_iam_instance_profile.node.id}"
  image_id                    = "${data.aws_ami.base.id}"
  instance_type               = "${var.node_instance_type}"
  key_name                    = "${var.key_name}"
  name_prefix                 = "${var.cluster_name}-node-"
  user_data                   = "${data.template_file.node_user_data.rendered}"

  security_groups = [
    "${aws_security_group.node.id}",
  ]

  lifecycle {
    create_before_destroy = true
  }
}
