########################################################
# 1. Route 53 Hosted Zone A Record
########################################################
resource "aws_route53_record" "dns_record" {
  zone_id = var.aws_route53_zone_id
  name = "api.dev.toto.aws.to7o.com"
  type = "A"

  alias {
    name = aws_lb.toto_alb.dns_name
    zone_id = aws_lb.toto_alb.zone_id
    evaluate_target_health = false
  }
}