# expett-consultation-api - settings

# Names
locals {
  # one-word prefix
  name_oneword  = "legalconsultation"
  # dash-separated prefix
  name_sep_dash = "legal-consultation"
}

# SSM settings.
locals {
  ssm_db_username = "/${local.name_oneword}/MYSQL_DB_USERNAME"
  ssm_db_password = "/${local.name_oneword}/MYSQL_DB_PASSWORD"
  ssm_db_endpoint = "/${local.name_oneword}/MYSQL_DB_ENDPOINT"
}

# S3 settings.
locals {
  s3_storage_docs_name = "${local.name_sep_dash}-documents"
}

# IAM settings.
locals {
  iam_name = "taskExecutionRole"
}

# Cloudwatch settings.
locals {
  cloudwatch_log_group_name = "${local.name_sep_dash}-log-group"
}

# Networking settings.
locals {
  vpc_cidr_block = "10.0.0.0/16"
  vpc_name       = "${local.name_sep_dash}-vpc"

  public_subnet_cidr_block = "10.0.0.0/24"
  public_subnet_name       = "${local.name_sep_dash}-public-subnet"

  private_subnet_a_cidr_block = "10.0.1.0/24"
  private_subnet_a_name       = "${local.name_sep_dash}-private-subnet-a"
  private_subnet_a_az         = "${data.aws_region.main.name}a"

  private_subnet_b_cidr_block = "10.0.2.0/24"
  private_subnet_b_name       = "${local.name_sep_dash}-private-subnet-b"
  private_subnet_b_az         = "${data.aws_region.main.name}b"

  igw_name = "${local.name_sep_dash}-igw"

  route_table_name = "${local.name_sep_dash}-route"

  web_security_group_name = "${local.name_sep_dash}-web=security-group"
}

# DB settings.
locals {
  db_security_group_name = "${local.name_sep_dash}-rds-security-group"

  db_subnet_group_name = "${local.name_sep_dash}-db-subnet-group"

  db_identifier = local.name_oneword
}
