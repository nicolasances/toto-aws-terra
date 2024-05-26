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
    Name = format("toto-%s-pub-subnet-1", var.toto_environment)
  }
}

resource "aws_subnet" "toto_pub_subnet_2" {
  vpc_id = aws_vpc.toto_vpc.id
  cidr_block = "10.0.0.128/25"

  tags = {
    Name = format("toto-%s-pub-subnet-2", var.toto_environment)
  }
}

########################################################
# 3. Internet Gateway
########################################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.toto_vpc.id
  
  tags = {
    Name = format("toto-%s-igw", var.toto_environment)
  }
}