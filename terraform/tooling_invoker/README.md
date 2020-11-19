# Tooling Invoker

Create an AMI using the script in this direcory (ami.sh).

Then create a launch template and autoscaling group:

```
resource "aws_launch_template" "foobar" {
  name_prefix   = "foobar"
  image_id      = "ami-1a2b3c"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  alb_target_group_arn   = aws_alb_target_group.test.arn
}

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group
vs
https://registry.terraform.io/modules/terraform-aws-modules/autoscaling/aws/latest
?
```

Tooling Invokers need the following security_groups:
- tooling-invoker-ec2
- efs-tooling-jobs-access 

- The EFS should be mounted at /mnt/jobs.
- It should be readonly

