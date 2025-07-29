resource "aws_launch_template" "main" {
  image_id      = "ami-0ea8be7ea04dcfc32"
  instance_type = "t3.medium"
  key_name      = "iHiD-v3"
  name          = "Tooling-Invokers"
  tags          = {}
  ebs_optimized = false

  vpc_security_group_ids = [
    var.aws_security_group_efs_repositories_access.id,
    var.aws_security_group_efs_tooling_jobs_access.id,
    var.aws_security_group_elasticache_git_cache_access.id,
    aws_security_group.ec2.id
  ]

  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2.arn
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      "tooling-analyzers"    = "all"
      "tooling-representers" = "all"
      "tooling-test-runners" = "all"
    }
  }
}
