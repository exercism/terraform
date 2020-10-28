resource "aws_efs_file_system" "repositories" {
  creation_token = "git-repositories"
}

resource "aws_efs_mount_target" "repositories" {
  count          = length(var.aws_subnet_publics)
  file_system_id = aws_efs_file_system.repositories.id
  subnet_id      = element(var.aws_subnet_publics.*.id, count.index)
  security_groups = [
    aws_security_group.efs.id
  ]
}

