# expert-consultation-api - networking

resource "aws_vpc" "main" {
  cidr_block = local.vpc_cidr_block

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = local.vpc_name
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = local.public_subnet_cidr_block

  availability_zone = "${data.aws_region.main.name}a"

  map_public_ip_on_launch = true

  tags = {
    Name = local.public_subnet_name
  }
}

resource "aws_subnet" "private_a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = local.private_subnet_a_cidr_block

  availability_zone = private_subnet_a_az

  tags = {
    Name = local.private_subnet_a_name
  }
}

resource "aws_subnet" "private_b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = local.private_subnet_b_cidr_block

  availability_zone = private_subnet_b_az

  tags = {
    Name = local.private_subnet_b_name
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = local.igw_name
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = aws_subnet.public.cidr_block
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = local.route_table_name
  }
}

resource "aws_security_group" "web" {
  name        = local.web_security_group_name
  description = "Security Group for legal consultation."
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "port 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "port 8025"
    from_port   = 8025
    to_port     = 8025
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
