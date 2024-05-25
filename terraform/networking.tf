########################################################
# 1. VPC
########################################################
resource "aws_vpc" "toto_vpc" {
  cidr_block = "10.0.0.0/24"
  instance_tenancy = "default"

  tags = {
    Name = format("toto-%s-vpc", var.toto_environment)
  }
}

########################################################
# 2. Subnets
########################################################
resource "aws_subnet" "toto_pub_subnet_1" {
  vpc_id = aws_vpc.toto_vpc.id
  cidr_block = "10.0.0.0/25"

  tags = {
    Name = format("toto-%s-pub-subnet-1")
  }
}

resource "aws_subnet" "toto_pub_subnet_2" {
  vpc_id = aws_vpc.toto_vpc.id
  cidr_block = "10.0.0.128/25"

  tags = {
    Name = format("toto-%s-pub-subnet-2")
  }
}