resource "aws_efs_file_system" "submissions" {
  creation_token = "submissions"

  tags = {
    Name = "Submissions"
  }
}

resource "aws_efs_mount_target" "submissions" {
  count          = length(aws_subnet.publics)
  file_system_id = aws_efs_file_system.submissions.id
  subnet_id      = element(aws_subnet.publics.*.id, count.index)
  security_groups = [
    aws_security_group.efs_submissions.id
  ]
}

# EFS access point (used by lambda file system)
resource "aws_efs_access_point" "submissions" {
  file_system_id = aws_efs_file_system.submissions.id

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

