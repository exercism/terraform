resource "aws_efs_file_system" "tooling_jobs" {
  creation_token  = "tooling_jobs"
  throughput_mode = "elastic"

  tags = {
    Name = "Tooling Jobs"
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

# EFS access point (used by lambda file system)
resource "aws_efs_access_point" "tooling_jobs" {
  file_system_id = aws_efs_file_system.tooling_jobs.id

  root_directory {
    path = "/"
    creation_info {
      owner_gid   = 1001
      owner_uid   = 1001
      permissions = "555"
    }
  }

  posix_user {
    gid = 1000
    uid = 1000
  }
}

