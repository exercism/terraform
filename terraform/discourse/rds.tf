resource "aws_db_subnet_group" "discourse" {
  name       = "discourse"
  subnet_ids = var.aws_subnet_publics.*.id
}

resource "aws_rds_cluster_parameter_group" "discourse" {
  name   = "discourse"
  family = "aurora-postgresql10"
}

resource "aws_rds_cluster" "discourse" {
  cluster_identifier              = "discourse"
  engine                          = "aurora-postgresql"
  engine_mode                     = "serverless"
  database_name                   = "exercism"
  master_username                 = "exercism"
  master_password                 = "exercism"
  availability_zones              = data.aws_availability_zones.available.names
  backup_retention_period = 7
  vpc_security_group_ids          = [aws_security_group.rds_discourse.id]
  db_subnet_group_name            = aws_db_subnet_group.discourse.name
  db_cluster_parameter_group_name = "default.aurora-postgresql13"
  final_snapshot_identifier       = "v3-${formatdate("YYYY-MM-DD-hh-mm-ss", timestamp())}"

  # Ignore changes to final_snapshot_identifier, which are caused by the
  # timestamp being regenerated on each run.
  lifecycle {
    ignore_changes = [final_snapshot_identifier]
  }

  scaling_configuration {
    auto_pause   = false
    max_capacity = 2
    min_capacity = 2
  }
}

