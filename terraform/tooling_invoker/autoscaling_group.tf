resource "aws_autoscaling_group" "main" {
  name = "Tooling Invokers"

  min_size         = 10
  desired_capacity = 12
  max_size         = 15
  max_instance_lifetime = 86400

  default_cooldown   = 900
  capacity_rebalance = false

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  health_check_grace_period = 900
  health_check_type         = "EC2"
  metrics_granularity       = "1Minute"
  protect_from_scale_in     = false
  service_linked_role_arn   = "arn:aws:iam::681735686245:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
  termination_policies      = ["OldestInstance"]
  vpc_zone_identifier       = var.aws_subnet_publics.*.id


  tag {
    key                 = "Name"
    value               = "Autoscaling Tooling Runner"
    propagate_at_launch = true
  }

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
