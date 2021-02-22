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


