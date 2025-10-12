########################################################
# 1. Load Balancer
########################################################
resource "aws_lb" "toto_alb" {
  name = format("toto-alb-%s", var.toto_environment)
  internal = false
  load_balancer_type = "application"
  security_groups = [ aws_security_group.toto_open_service.id ]
  subnets = [aws_subnet.toto_pub_subnet_1.id, aws_subnet.toto_pub_subnet_2.id]
}

resource "aws_lb_listener" "toto_alb_listener" {
  load_balancer_arn = aws_lb.toto_alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "application/json"
      message_body = "{\"active\": \"true\"}"
      status_code = "200"
    }
  }
}
resource "aws_lb_listener" "toto_alb_listener_https" {
  load_balancer_arn = aws_lb.toto_alb.arn
  port = "443"
  protocol = "HTTPS"
  certificate_arn = aws_acm_certificate.toto_certificate.arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "application/json"
      message_body = "{\"active\": \"true\"}"
      status_code = "200"
    }
  }
}