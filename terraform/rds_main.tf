resource "aws_db_subnet_group" "main" {
  name       = "primary"
  subnet_ids = aws_subnet.publics.*.id
  tags = {
    Name = "v3"
  }
}

resource "aws_rds_cluster_parameter_group" "main_v8" {
  name   = "primary-v8"
  family = "aurora-mysql8.0"

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
    value = "utf8mb4_unicode_ci"
  }
  parameter {
    name  = "collation_connection"
    value = "utf8mb4_unicode_ci"
  }
  parameter {
    name  = "slow_query_log"
    value = "1"
  }
  parameter {
    name = "binlog_format"
    value = "MIXED"
    apply_method = "pending-reboot"
  }
  parameter {
    name = "performance_schema"
    value = "1"
    apply_method = "pending-reboot"
  }
  parameter {
    name = "performance-schema-consumer-events-waits-current"
    value = "ON"
    apply_method = "pending-reboot"
  }
  parameter {
    name = "performance-schema-instrument"
    value = "wait/%=ON"
    apply_method = "pending-reboot"
  }
  parameter {
    name = "performance_schema_consumer_global_instrumentation"
    value = "1"
    apply_method = "pending-reboot"
  }
  parameter {
    name = "performance_schema_consumer_thread_instrumentation"
    value = "1"
    apply_method = "pending-reboot"
  }
}

resource "aws_rds_cluster" "main" {
  cluster_identifier              = "primary"
  engine                          = "aurora-mysql"
  engine_mode                     = "provisioned"
  engine_version                  = "8.0.mysql_aurora.3.04.0"
  database_name                   = "exercism"
  master_username                 = "exercism"
  master_password                 = "exercism"
  port                            = 3306
  availability_zones              = data.aws_availability_zones.available.names
  backup_retention_period = 21
  vpc_security_group_ids          = [aws_security_group.rds_main.id]
  db_subnet_group_name            = aws_db_subnet_group.main.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.main_v8.name
  final_snapshot_identifier       = "v3-${formatdate("YYYY-MM-DD", timeadd(timestamp(), "24h"))}T00-00-00Z"

  deletion_protection = true

  # ignore changes to final_snapshot_identifier, which are caused by the
  # timestamp being regenerated on each run.
  lifecycle {
    ignore_changes = [final_snapshot_identifier]
  }

  serverlessv2_scaling_configuration {
    max_capacity = 10
    min_capacity = 2
  }

  cluster_members = [ "primary-a" ]
}

# resource "aws_rds_cluster_instance" "main_write_instance" {
#   identifier         = "writer"
#   cluster_identifier = aws_rds_cluster.main.id
#   instance_class     = "db.r5.large"

#   # These have to be respecified here as well as in the cluster definition
#   # See https://github.com/terraform-providers/terraform-provider-aws/issues/4779#issuecomment-396901712
#   engine         = "aurora"
#   engine_mode    = "serverless"
#   engine_version = "5.7.mysql_aurora.2.07.1"
# }
#
#
#
#
#
#

resource "aws_rds_cluster_parameter_group" "main" {
  name   = "primary"
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
    value = "utf8mb4_unicode_ci"
  }
  parameter {
    name  = "collation_connection"
    value = "utf8mb4_unicode_ci"
  }
  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name = "binlog_format"
    value = "MIXED"
    apply_method = "pending-reboot"
  }
}


