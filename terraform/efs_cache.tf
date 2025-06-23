resource "aws_efs_file_system" "cache" {
  creation_token = "cache"
  throughput_mode = "elastic"

  tags = {
    Name = "Cache"
  }
}

resource "aws_efs_mount_target" "cache" {
  count          = length(aws_subnet.publics)
  file_system_id = aws_efs_file_system.cache.id
  subnet_id      = element(aws_subnet.publics.*.id, count.index)
  security_groups = [
    aws_security_group.efs_cache.id
  ]
}