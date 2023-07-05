locals {
  parameter_group_name = "no-tsl"
}
resource "aws_docdb_cluster" "general" {
  cluster_identifier      = "exercism"
  engine                  = "docdb"
  master_username         = "exercism"
  master_password         = "exercism"
  port = 27017
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  db_cluster_parameter_group_name = local.parameter_group_name

  db_subnet_group_name = aws_docdb_subnet_group.default.name
  vpc_security_group_ids = [ aws_security_group.docdb.id ]
}

resource "aws_docdb_cluster_instance" "instances" {
  count              = 1
  identifier         = "docdb-exercism-instance-${count.index}"
  cluster_identifier = aws_docdb_cluster.general.id
  instance_class     = "db.t4g.medium"
}

resource "aws_docdb_subnet_group" "default" {
  name       = "main"
  subnet_ids = aws_subnet.publics.*.id
}

resource "aws_security_group" "docdb" {
  name        = "docdb"
  description = "Allows machines to access docdb"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_docdb_cluster_parameter_group" "exercism" {
  family      = "docdb5.0"
  name        = local.parameter_group_name

  parameter {
    name  = "tls"
    value = "disabled"
  }
}
