resource "aws_autoscaling_group" "spot" {
  name                      = "tooling-runner-spot"
  min_size                  = 10
  desired_capacity          = 12
  max_size                  = 15
  vpc_zone_identifier       = var.aws_subnet_publics.*.id
  capacity_rebalance        = true
  health_check_type         = "EC2"
  health_check_grace_period = 300
  metrics_granularity       = "1Minute"

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.main.id
        version            = "$Latest"
      }

      override        { instance_type = "t3.medium" }
      override  { instance_type = "t3a.medium" }
        override { instance_type = "t2.medium" }
        override { instance_type = "t3.large" }
        override { instance_type = "t3a.large" }
        override { instance_type = "t2.large" }
        override { instance_type = "m5.large" }
        override { instance_type = "m5a.large" }
        override { instance_type = "m4.large" }
    }

    instances_distribution {
      on_demand_base_capacity                  = 2
      on_demand_percentage_above_base_capacity = 0
    }
  }

  enabled_metrics = ["GroupInServiceInstances", "GroupDesiredCapacity"]

  tag {
    key                 = "Name"
    value               = "Tooling Runner Spot"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "fallback" {
  name                      = "tooling-runner-fallback"
  min_size                  = 0
  desired_capacity          = 0
  max_size                  = 15
  vpc_zone_identifier       = var.aws_subnet_publics.*.id
  health_check_type         = "EC2"
  health_check_grace_period = 300
  metrics_granularity       = "1Minute"

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  enabled_metrics = ["GroupDesiredCapacity", "GroupInServiceInstances"]

  tag {
    key                 = "Name"
    value               = "Tooling Runner Fallback"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [desired_capacity]
  }
}

resource "aws_cloudwatch_metric_alarm" "fallback_scale_up" {
  alarm_name          = "fallback-scale-up"
  evaluation_periods  = 3
  threshold           = 0
  comparison_operator = "GreaterThanThreshold"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_autoscaling_policy.fallback_scale_up.arn]

  metric_query {
    id          = "running"
    return_data = false
    metric {
      namespace  = "AWS/AutoScaling"
      metric_name = "GroupInServiceInstances"
      dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.spot.name
      }
      period = 60
      stat   = "Maximum"
    }
  }

  metric_query {
    id          = "desired"
    return_data = false
    metric {
      namespace  = "AWS/AutoScaling"
      metric_name = "GroupDesiredCapacity"
      dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.spot.name
      }
      period = 60
      stat   = "Maximum"
    }
  }

  metric_query {
    id          = "fallback"
    return_data = false
    metric {
      namespace  = "AWS/AutoScaling"
      metric_name = "GroupDesiredCapacity"
      dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.fallback.name
      }
      period = 60
      stat   = "Maximum"
    }
  }

  metric_query {
    id          = "e1"
    return_data = true
    expression  = "desired - running - fallback"
    label       = "Missing Capacity"
  }
}
resource "aws_cloudwatch_metric_alarm" "fallback_scale_down" {
  alarm_name          = "fallback-scale-down"
  evaluation_periods  = 3
  threshold           = 0
  comparison_operator = "LessThanThreshold"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_autoscaling_policy.fallback_scale_down.arn]

  metric_query {
    id          = "running"
    return_data = false
    metric {
      namespace  = "AWS/AutoScaling"
      metric_name = "GroupInServiceInstances"
      dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.spot.name
      }
      period = 60
      stat   = "Maximum"
    }
  }

  metric_query {
    id          = "desired"
    return_data = false
    metric {
      namespace  = "AWS/AutoScaling"
      metric_name = "GroupDesiredCapacity"
      dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.spot.name
      }
      period = 60
      stat   = "Maximum"
    }
  }

  metric_query {
    id          = "fallback"
    return_data = false
    metric {
      namespace  = "AWS/AutoScaling"
      metric_name = "GroupDesiredCapacity"
      dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.fallback.name
      }
      period = 60
      stat   = "Maximum"
    }
  }

  metric_query {
    id          = "e1"
    return_data = true
    expression  = "desired - running - fallback"
    label       = "Missing Capacity"
  }
}

resource "aws_autoscaling_policy" "fallback_scale_up" {
  name                   = "fallback-scale-up"
  policy_type            = "StepScaling"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  estimated_instance_warmup = 300
  autoscaling_group_name = aws_autoscaling_group.fallback.name

  step_adjustment {
    metric_interval_lower_bound = 0
    metric_interval_upper_bound = 2
    scaling_adjustment          = 1
  }

  step_adjustment {
    metric_interval_lower_bound = 2
    metric_interval_upper_bound = 3
    scaling_adjustment          = 2
  }

  step_adjustment {
    metric_interval_lower_bound = 3
    metric_interval_upper_bound = 5
    scaling_adjustment          = 3
  }

  step_adjustment {
    metric_interval_lower_bound = 5
    scaling_adjustment          = 5
  }
}

resource "aws_autoscaling_policy" "fallback_scale_down" {
  name                   = "fallback-scale-down"
  policy_type            = "StepScaling"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  estimated_instance_warmup = 300
  autoscaling_group_name = aws_autoscaling_group.fallback.name

  step_adjustment {
    metric_interval_upper_bound = 0
    metric_interval_lower_bound = -2
    scaling_adjustment          = -1
  }

  step_adjustment {
    metric_interval_upper_bound = -2
    metric_interval_lower_bound = -3
    scaling_adjustment          = -2
  }

  step_adjustment {
    metric_interval_upper_bound = -3
    metric_interval_lower_bound = -5
    scaling_adjustment          = -3
  }

  step_adjustment {
    metric_interval_upper_bound = -5
    scaling_adjustment          = -5
  }
}

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

  suspended_processes = [
    "Launch",
    "Terminate",
    "HealthCheck",
    "ReplaceUnhealthy",
    "AZRebalance",
    "AlarmNotification",
    "ScheduledActions",
    "AddToLoadBalancer",
  ]

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
