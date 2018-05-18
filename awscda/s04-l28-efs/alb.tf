resource "aws_lb" "main" {
  enable_http2       = true
  internal           = false
  load_balancer_type = "application"
  name               = "james-lucktaylor-awscda-efs-alb"
  security_groups    = ["${data.aws_security_group.dmz.id}"]
  subnets            = ["${data.aws_subnet_ids.main.ids}"]

  # access_logs {
  #   bucket  = "${aws_s3_bucket.lb_logs.bucket}"
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  tags = "${merge(
    local.default-tags,
    map(
      "Name", "james-lucktaylor-awscda-efs-alb",
    )
  )}"
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = "${aws_lb.main.arn}"
  port              = "80"

  default_action {
    target_group_arn = "${aws_lb_target_group.main.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "main" {
  name     = "james-lucktaylor-awscda-efs-tg"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = "${data.aws_vpc.main.id}"

  # health_check {
  # https://www.terraform.io/docs/providers/aws/r/lb_target_group.html
  # }

  tags = "${merge(
    local.default-tags,
    map(
      "Name", "james-lucktaylor-awscda-efs-tg",
    )
  )}"
}

resource "aws_lb_target_group_attachment" "main" {
  count            = "${length(data.aws_availability_zones.available.names)}"
  port             = "80"
  target_group_arn = "${aws_lb_target_group.main.arn}"
  target_id        = "${element(aws_instance.awscda-efs.*.id, count.index)}"
}