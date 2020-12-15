# expett-consultation-api - settings

# Names
locals {
  # project name
  name = ["legal", "consultation"]
  # one-word prefix
  name_oneword  = join("", local.name)
  # dash-separated prefix
  name_sep_dash = join("-", local.name)
}

# SSM settings.
locals {
  ssm_db_username      = "MYSQL_DB_USERNAME"
  ssm_db_username_path = "${local.name_oneword}/${local.ssm_db_username}"
  ssm_db_password      = "MYSQL_DB_PASSWORD"
  ssm_db_password_path = "${local.name_oneword}/${local.ssm_db_password}"
  ssm_db_endpoint      = "MYSQL_DB_ENDPOINT"
  ssm_db_endpoint_path = "${local.name_oneword}/${local.ssm_db_endpoint}"
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

  public_subnet_az = "${data.aws_region.main.name}a"

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

  db_allocated_storage = 10
}

# ECS
locals {
  client_task_name = "${local.name_sep_dash}-client"
  api_task_name    = "${local.name_sep_dash}-api"

  taskdef_family = "${local.name_sep_dash}-task"

  cluster_name = "${local.name_sep_dash}-cluster-service"

  service_name = "${local.name_sep_dash}-cluster-service"
}
