# expert-consultation-api - database

resource "aws_security_group" "db" {
  name        = local.db_security_group_name
  description = "Security Group for legal consultation database."
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Database port."
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.public.cidr_block]
  }
}

resource "aws_db_subnet_group" "main" {
  name       = local.db_subnet_group_name
  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]
}

resource "aws_db_instance" "main" {
  allocated_storage = 10
  storage_type      = "gp2" # this is the default
  engine            = "mysql"
  instance_class    = var.db_instance_type
  identifier        = local.db_identifier
  username          = var.db_username
  password          = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]

  timeouts {
    create = "1h"
  }
}
