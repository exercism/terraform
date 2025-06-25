resource "aws_autoscaling_group" "spot" {
  name                      = "tooling-runner-spot"
  min_size                  = 10
  desired_capacity          = 12
  max_size                  = 15
  max_instance_lifetime     = 86400
  vpc_zone_identifier       = var.aws_subnet_publics.*.id
  capacity_rebalance        = true
  health_check_type         = "EC2"
  health_check_grace_period = 300
  default_instance_warmup   = 300
  metrics_granularity       = "1Minute"

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.main.id
        version            = "$Latest"
      }

      override { instance_type = "t3.medium" }
      override { instance_type = "t3a.medium" }
    }

    instances_distribution {
      on_demand_base_capacity                  = 4
      on_demand_percentage_above_base_capacity = 0
    }
  }

  enabled_metrics = ["GroupInServiceInstances", "GroupDesiredCapacity",

    "GroupPendingInstances",
    "GroupTerminatingInstances",
    "GroupMinSize",
    "GroupMaxSize"
  ]

  instance_maintenance_policy {
    max_healthy_percentage = 120
    min_healthy_percentage = 100
  }


  tag {
    key                 = "Name"
    value               = "Tooling Runner Spot"
    propagate_at_launch = true
  }
  
  lifecycle {
  ignore_changes = [mixed_instances_policy[0].launch_template[0].launch_template_specification[0].version]
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
  default_instance_warmup   = 300
  max_instance_lifetime     = 86400
  metrics_granularity       = "1Minute"

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  enabled_metrics = [
    "GroupDesiredCapacity", "GroupInServiceInstances",

    "GroupPendingInstances",
    "GroupTerminatingInstances",
    "GroupMinSize",
    "GroupMaxSize"
  ]

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
      namespace   = "AWS/AutoScaling"
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
      namespace   = "AWS/AutoScaling"
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
      namespace   = "AWS/AutoScaling"
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
      namespace   = "AWS/AutoScaling"
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
      namespace   = "AWS/AutoScaling"
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
      namespace   = "AWS/AutoScaling"
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
  name                      = "fallback-scale-up"
  policy_type               = "StepScaling"
  adjustment_type           = "ChangeInCapacity"
  estimated_instance_warmup = 300
  autoscaling_group_name    = aws_autoscaling_group.fallback.name

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
  name                      = "fallback-scale-down"
  policy_type               = "StepScaling"
  adjustment_type           = "ChangeInCapacity"
  estimated_instance_warmup = 300
  autoscaling_group_name    = aws_autoscaling_group.fallback.name

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