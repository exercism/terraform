resource "aws_launch_template" "main" {
  image_id                = "ami-03c207961a2d90a8e"
  instance_type           = "t4g.small"
  key_name                = "iHiD-v3"
  name                    = "Tooling-Invokers"
  tags                    = {}
  description = "Reduce to small machines"
  ebs_optimized = false

  vpc_security_group_ids = [
    var.aws_security_group_efs_repositories_access.id,
    var.aws_security_group_efs_submissions_access.id,
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
