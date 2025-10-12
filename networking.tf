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

########################################################
# 2. Subnets
########################################################
resource "aws_subnet" "toto_ecs_subnet_1" {
  vpc_id = aws_vpc.toto_vpc.id
  cidr_block = "10.0.0.0/26"
  availability_zone = "eu-west-1a"

  tags = {
    Name = format("toto-%s-ecs-subnet-1", var.toto_env)
  }
}

resource "aws_subnet" "toto_ecs_subnet_2" {
  vpc_id = aws_vpc.toto_vpc.id
  cidr_block = "10.0.0.64/26"
  availability_zone = "eu-west-1b"

  tags = {
    Name = format("toto-%s-ecs-subnet-2", var.toto_env)
  }
}

# Subnets for Load Balancer
resource "aws_subnet" "toto_pub_subnet_1" {
  vpc_id = aws_vpc.toto_vpc.id
  cidr_block = "10.0.0.128/26"
  availability_zone = "eu-west-1a"

  tags = {
    Name = format("toto-%s-pub-subnet-1", var.toto_env)
  }
}

resource "aws_subnet" "toto_pub_subnet_2" {
  vpc_id = aws_vpc.toto_vpc.id
  cidr_block = "10.0.0.192/26"
  availability_zone = "eu-west-1b"

  tags = {
    Name = format("toto-%s-pub-subnet-2", var.toto_env)
  }
}

########################################################
# 3. Internet Gateway
########################################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.toto_vpc.id
  
  tags = {
    Name = format("toto-%s-igw", var.toto_env)
  }
}

########################################################
# 4. Route Table for Subnets
########################################################
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.toto_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Toto public Routing Table"
  }
}

resource "aws_route_table_association" "route_table_pub_subnet_1" {
  subnet_id = aws_subnet.toto_pub_subnet_1.id
  route_table_id = aws_route_table.route_table.id
}
resource "aws_route_table_association" "route_table_pub_subnet_2" {
  subnet_id = aws_subnet.toto_pub_subnet_2.id
  route_table_id = aws_route_table.route_table.id
}

# Route table for private subnets (no internet access)
resource "aws_route_table" "route_table_private" {
  vpc_id = aws_vpc.toto_vpc.id

  route {
    cidr_block = "10.0.0.0/24"
    target = "local"
  }

  tags = {
    Name = "Toto private Routing Table"
  }
}

# Route tables associations for private subnets (no internet access)
resource "aws_route_table_association" "route_table_ecs_subnet_1" {
  subnet_id = aws_subnet.toto_ecs_subnet_1.id
  route_table_id = aws_route_table.route_table_private.id
}

resource "aws_route_table_association" "route_table_ecs_subnet_2" {
  subnet_id = aws_subnet.toto_ecs_subnet_2.id
  route_table_id = aws_route_table.route_table_private.id
}