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

data "aws_region" "main" {}

data "aws_caller_identity" "main" {}

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

resource "aws_ssm_parameter" "db_endpoint" {
  name        = "/legalconsultation/MYSQL_DB_URL"
  description = "The url for the legalconsultation db."
  type        = "SecureString" # should this be just a string?
  value       = aws_db_instance.main.endpoint
}

resource "aws_s3_bucket" "storage_docs" {
  bucket = "legal-consultation-documents"
  acl    = "private"
}

resource "aws_iam_role" "task_role" {
  name = "taskExecutionRole"
  path = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

  assume_role_policy = file("${path.module}/task_execution_role.policy.json")
}

resource "aws_iam_role_policy" "task_role_policy" {
  name = "taskExecutionRole"
  role = aws_iam_role.task_role.id

  policy = templatefile("${path.module}/allow_params_policy.json.j2", {
    region     = data.aws_region.main
    account_id = data.aws_caller_identity.main.account_id
  })
}

resource "aws_cloudwatch_log_group" "main" {
  name = "legal-consultation-log-group"
}
