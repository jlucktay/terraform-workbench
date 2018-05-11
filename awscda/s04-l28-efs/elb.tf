resource "aws_elb" "main" {
  name    = "james-lucktaylor-awscda-efs-elb"
  subnets = ["${data.aws_subnet_ids.main.ids}"]

  health_check {
    healthy_threshold   = 3
    interval            = 10
    target              = "HTTP:80/"
    timeout             = 3
    unhealthy_threshold = 2
  }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  tags = "${merge(
    local.default-tags,
    map(
      "Name", "james.lucktaylor.awscda-efs.elb",
    )
  )}"
}

resource "aws_elb_attachment" "awscda-efs" {
  count    = "${length(data.aws_availability_zones.available.names)}"
  elb      = "${aws_elb.main.id}"
  instance = "${element(aws_instance.awscda-efs.*.id, count.index)}"
}
