########################################################
# 1. Security Groups
########################################################
resource "aws_security_group" "toto_open_service" {
  name = format("toto-%s-service-open", var.toto_environment)
  description = "Allow Internet Access to Toto Services"
  vpc_id = aws_vpc.toto_vpc.id

  tags = {
    Name = format("toto-%s-service-open", var.toto_environment)
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_http_80" {
  security_group_id = aws_security_group.toto_open_service.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port = "80"
  to_port = "80"
}
resource "aws_vpc_security_group_ingress_rule" "allow_tcp_8080" {
  security_group_id = aws_security_group.toto_open_service.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port = "8080"
  to_port = "8080"
}
resource "aws_vpc_security_group_ingress_rule" "allow_tcp_443" {
  security_group_id = aws_security_group.toto_open_service.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port = "443"
  to_port = "8080"
}
resource "aws_vpc_security_group_egress_rule" "allow_all_outgoing" {
  security_group_id = aws_security_group.toto_open_service.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}