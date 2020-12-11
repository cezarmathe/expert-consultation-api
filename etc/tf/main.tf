# expert-consultation-api

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider.
provider "aws" {
  # The AWS provider expects to find the following environment variables set with according values:
  #   - AWS_ACCESS_KEY_ID
  #   - AWS_SECRET_ACCESS_KEY
  #   - AWS_DEFAULT_REGION
}

resource "aws_ssm_parameter" "db_username" {
  name        = "/legalconsultation/MYSQL_DB_USERNAME"
  description = "The username for the legalconsultation db."
  type        = "SecureString"
  value       = var.db_username
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/legalconsultation/MYSQL_DB_PASSWORD"
  description = "The password for the legalconsultation db."
  type        = "SecureString"
  value       = var.db_username
}

resource "aws_s3_bucket" "storage_docs" {
  bucket = "legal-consultation-documents"
  acl    = "private"
}

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

  availability_zone = "${aws.region}a"

  map_public_ip_on_launch = true

  tags = {
    Name = "legal-consult-public-subnet"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  availability_zone = "${aws.region}a"

  tags = {
    Name = "legal-consult-private-subnet-a"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  availability_zone = "${aws.region}b"

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
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = aws_subnet.public.cidr_block
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "legal-consult-route"
  }
}
