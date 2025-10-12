########################################################
# 0. Security Group for Load Balancer
########################################################
resource "aws_security_group" "toto_loadbalancer_sg" {
  name = format("toto-%s-loadbalancer_sg", var.toto_environment)
  description = "Allow Internet Access to the Load Balancer"
  vpc_id = aws_vpc.toto_vpc.id

  tags = {
    Name = format("toto-%s-loadbalancer_sg", var.toto_environment)
  }
}
resource "aws_vpc_security_group_ingress_rule" "toto_lb_allow_http_80" {
  security_group_id = aws_security_group.toto_loadbalancer_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port = "80"
  to_port = "80"
}
resource "aws_vpc_security_group_ingress_rule" "toto_lb_allow_tcp_8080" {
  security_group_id = aws_security_group.toto_loadbalancer_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port = "8080"
  to_port = "8080"
}
resource "aws_vpc_security_group_ingress_rule" "toto_lb_allow_tcp_443" {
  security_group_id = aws_security_group.toto_loadbalancer_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port = "443"
  to_port = "8080"
}
resource "aws_vpc_security_group_egress_rule" "toto_lb_allow_all_outgoing" {
  security_group_id = aws_security_group.toto_loadbalancer_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

########################################################
# 1. Load Balancer
########################################################
resource "aws_lb" "toto_alb" {
  name = format("toto-alb-%s", var.toto_environment)
  internal = false
  load_balancer_type = "application"
  security_groups = [ aws_security_group.toto_loadbalancer_sg.id ]
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