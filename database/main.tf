data "aws_secretsmanager_secret" "rds_creds" {
  name = "ahmad/secret/db"
}

data "aws_secretsmanager_secret_version" "rds_creds_version" {
  secret_id = data.aws_secretsmanager_secret.rds_creds.id
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.rds_creds_version.secret_string)
}












resource "aws_db_instance" "salon_db" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  db_name                = var.dbname
username                = local.db_creds.username
  password                = local.db_creds.password
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = [var.vpc_security_group_ids]
  identifier             = var.db_identifier
  skip_final_snapshot    = var.skip_db_snapshot
  tags = {
    Name = "mtc-db"
  }
}



