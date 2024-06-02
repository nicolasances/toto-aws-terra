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
  availability_zone = "eu-west-1a"

  tags = {
    Name = format("toto-%s-pub-subnet-1", var.toto_environment)
  }
}

resource "aws_subnet" "toto_pub_subnet_2" {
  vpc_id = aws_vpc.toto_vpc.id
  cidr_block = "10.0.0.128/25"
  availability_zone = "eu-west-1b"

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

resource "aws_route_table_association" "route_table_subnet_1" {
  subnet_id = aws_subnet.toto_pub_subnet_1.id
  route_table_id = aws_route_table.route_table.id
}
resource "aws_route_table_association" "route_table_subnet_2" {
  subnet_id = aws_subnet.toto_pub_subnet_2.id
  route_table_id = aws_route_table.route_table.id
}


########################################################
# 5. Load Balancer
########################################################
resource "aws_lb" "toto_alb" {
  name = format("toto-alb-%s", var.toto_environment)
  internal = false
  load_balancer_type = "application"
  security_groups = [ aws_security_group.toto_open_service.id ]
  subnets = [aws_subnet.toto_pub_subnet_1.id, aws_subnet.toto_pub_subnet_2.id]
}

resource "aws_lb_listener" "toto_alb_listener" {
  load_balancer_arn = aws_elb.toto_alb.arn
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