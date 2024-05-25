########################################################
# 1. VPC
########################################################
resource "aws_vpc" "totovpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = format("toto-%s-vpc", var.toto_environment)
  }
}