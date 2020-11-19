resource "aws_efs_file_system" "tooling_jobs" {
  creation_token = "tooling-jobs"

  tags = {
    name = "Tooling Jobs"
  }
}

resource "aws_efs_mount_target" "tooling_jobs" {
  count          = length(aws_subnet.publics)
  file_system_id = aws_efs_file_system.tooling_jobs.id
  subnet_id      = element(aws_subnet.publics.*.id, count.index)
  security_groups = [
    aws_security_group.efs_tooling_jobs.id
  ]
}


