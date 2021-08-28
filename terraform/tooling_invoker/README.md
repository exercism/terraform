# Tooling Invoker

Create an AMI using the script in this direcory (ami.sh) with the following base:
- Ubuntu Server 20.04 LTS (HVM), SSD Volume Type (ami-0194c3e07668a7e36)
- c5n.large
- Auto-assign IP: Enable
- IAM Role: tooling-invoker-ec2
- Storage: 100GB (General purpose SSD - gp2)
- Tooling Groups: 
  - tooling-invoker-ec2
  - efs-submissions-access
  - efs-repositories-access
- Tags:
  - tooling-representers: all
  - tooling-test-runners: all
  - tooling-analyzers: all

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
- efs-submissions-access 

- The EFS should be mounted at /mnt/efs/submissions.
- It should be readonly

