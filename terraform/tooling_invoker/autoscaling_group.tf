resource "aws_autoscaling_group" "main" {
  name = "Tooling Invokers"

  desired_capacity = 3
  max_size         = 4
  min_size         = 2
  max_instance_lifetime = 86400

  default_cooldown   = 600
  capacity_rebalance = false

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  health_check_grace_period = 300
  health_check_type         = "EC2"
  metrics_granularity       = "1Minute"
  protect_from_scale_in     = false
  service_linked_role_arn   = "arn:aws:iam::681735686245:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
  termination_policies      = ["OldestInstance"]
  vpc_zone_identifier       = var.aws_subnet_publics.*.id

  enabled_metrics = [
    "GroupAndWarmPoolDesiredCapacity",
    "GroupAndWarmPoolTotalCapacity",
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupInServiceInstances",
    "GroupMaxSize",
    "GroupMinSize",
    "GroupPendingCapacity",
    "GroupPendingInstances",
    "GroupStandbyCapacity",
    "GroupStandbyInstances",
    "GroupTerminatingCapacity",
    "GroupTerminatingInstances",
    "GroupTotalCapacity",
    "GroupTotalInstances",
    "WarmPoolDesiredCapacity",
    "WarmPoolMinSize",
    "WarmPoolPendingCapacity",
    "WarmPoolTerminatingCapacity",
    "WarmPoolTotalCapacity",
    "WarmPoolWarmedCapacity",
  ]
}
