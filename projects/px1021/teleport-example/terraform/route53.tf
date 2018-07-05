// Example route53 zone for automation purposes used to provision public DNS name for proxy
data "aws_route53_zone" "proxy" {
  name = "${var.route53_zone}"
}

// Route53 record connects proxy network load balancer
resource "aws_route53_record" "proxy" {
  name    = "${var.route53_domain}"
  type    = "A"
  zone_id = "${data.aws_route53_zone.proxy.zone_id}"

  alias {
    evaluate_target_health = true
    name                   = "${aws_lb.proxy.dns_name}"
    zone_id                = "${aws_lb.proxy.zone_id}"
  }
}
