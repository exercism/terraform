# Tooling Invoker

Create an AMI using the script in this direcory (ami.sh) with the following base:
- Name: Whatever
- Tags:
  - tooling-representers: all
  - tooling-test-runners: all
  - tooling-analyzers: all
- Ubuntu Server 22.04 LTS (HVM), SSD Volume Type (ami-0eb260c4d5475b901)
- t3.medium
- Keypair: iHiD-v3
- v3 vpc
- Auto-assign IP: Enable
- Security Groups:
  - tooling-invoker-ec2
  - efs-submissions-access
  - efs-repositories-access
- Storage: 130GB (General purpose SSD - gp2)
- IAM Profile: tooling-invoker-ec2

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

