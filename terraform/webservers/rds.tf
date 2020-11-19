resource "aws_db_subnet_group" "main" {
  name       = "webservers"
  subnet_ids = var.aws_subnet_publics.*.id
  tags = {
    Name = "v3"
  }
}

resource "aws_rds_cluster_parameter_group" "main" {
  name   = "webservers"
  family = "aurora-mysql5.7"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_connection"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }

  parameter {
    name  = "collation_server"
    value = "utf8mb4_general_ci"
  }
  parameter {
    name  = "collation_connection"
    value = "utf8mb4_general_ci"
  }
}

resource "aws_rds_cluster" "main" {
  cluster_identifier              = "webservers"
  engine                          = "aurora-mysql"
  engine_version                  = "5.7.mysql_aurora.2.08.2"
  database_name                   = "exercism_v3"
  master_username                 = "exercism_v3"
  master_password                 = "exercism_v3"
  port                            = 3306
  availability_zones              = data.aws_availability_zones.available.names
  vpc_security_group_ids          = [aws_security_group.rds.id]
  db_subnet_group_name            = aws_db_subnet_group.main.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.main.name
  final_snapshot_identifier       = "v3-${formatdate("YYYY-MM-DD-hh-mm-ss", timestamp())}"
  enabled_cloudwatch_logs_exports = [
    "error",
    "slowquery",
  ]
  tags = {
    Name = "webservers"
  }

  # Ignore changes to final_snapshot_identifier, which are caused by the
  # timestamp being regenerated on each run.
  lifecycle {
    ignore_changes = [final_snapshot_identifier]
  }
}

resource "aws_rds_cluster_instance" "write-instance" {
  identifier         = "writer"
  cluster_identifier = aws_rds_cluster.main.id
  instance_class     = "db.t2.small"

  # These have to be respecified here as well as in the cluster definition
  # See https://github.com/terraform-providers/terraform-provider-aws/issues/4779#issuecomment-396901712
  engine         = "aurora-mysql"
  engine_version = "5.7.mysql_aurora.2.08.2"
}
