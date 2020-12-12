# expert-consultation-api - networking

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "legal-consult-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"

  availability_zone = "${data.aws_region.main}a"

  map_public_ip_on_launch = true

  tags = {
    Name = "legal-consult-public-subnet"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  availability_zone = "${data.aws_region.main}a"

  tags = {
    Name = "legal-consult-private-subnet-a"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  availability_zone = "${data.aws_region.main}b"

  tags = {
    Name = "legal-consult-private-subnet-b"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "legal-consult-igw"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = aws_subnet.public.cidr_block
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "legal-consult-route"
  }
}

resource "aws_security_group" "web" {
  name        = "legal-consultation-security-group"
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
