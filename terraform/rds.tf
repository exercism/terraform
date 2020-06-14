resource "aws_db_subnet_group" "main" {
  name       = "v3-rds"
  subnet_ids = aws_subnet.publics.*.id
  tags = {
    Name = "v3"
  }
}

resource "aws_db_parameter_group" "main" {
  name   = "rds-v3"
  family = "mysql5.7"

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

resource "aws_db_instance" "main" {
  identifier                = "v3"
  allocated_storage         = 20
  storage_type              = "gp2"
  engine                    = "mysql"
  engine_version            = "5.7.26"
  instance_class            = "db.t3.micro"
  name                      = "exercism_v3"
  username                  = "exercism_v3"
  password                  = "exercism_v3"
  port                      = 3306
  publicly_accessible       = false
  availability_zone         = "${var.region}a"
  security_group_names      = []
  vpc_security_group_ids    = [aws_security_group.rds.id]
  db_subnet_group_name      = aws_db_subnet_group.main.name
  parameter_group_name      = aws_db_parameter_group.main.name
  multi_az                  = false
  final_snapshot_identifier = "v3-${formatdate("YYYY-MM-DD-hh-mm-ss", timestamp())}"
  enabled_cloudwatch_logs_exports = [
    "error",
    "slowquery",
  ]
  tags = {
    Name = "v3"
  }

  # Ignore changes to final_snapshot_identifier, which are caused by the
  # timestamp being regenerated on each run.
  lifecycle {
    ignore_changes = [final_snapshot_identifier]
  }
}

