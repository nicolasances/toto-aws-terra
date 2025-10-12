########################################################
# 1. VPC
########################################################
resource "aws_vpc" "toto_vpc" {
  cidr_block = "10.0.0.0/24"
  instance_tenancy = "default"

  tags = {
    Name = format("toto-%s-vpc", var.toto_env)
  }
}
