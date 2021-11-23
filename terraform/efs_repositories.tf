resource "aws_efs_file_system" "repositories" {
  creation_token = "git-repositories"
  provisioned_throughput_in_mibps = 10
  throughput_mode = "provisioned"

  tags = {
    Name = "Git Repositories"
  }
}

resource "aws_efs_mount_target" "repositories" {
  count          = length(aws_subnet.publics)
  file_system_id = aws_efs_file_system.repositories.id
  subnet_id      = element(aws_subnet.publics.*.id, count.index)
  security_groups = [
    aws_security_group.efs_repositories.id
  ]
}

