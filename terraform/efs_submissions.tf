resource "aws_efs_file_system" "submissions" {
  creation_token = "submissions"
  throughput_mode = "elastic"

  tags = {
    Name = "Submissions"
  }
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  lifecycle_policy {
    transition_to_primary_storage_class = "AFTER_1_ACCESS"
  }
}
