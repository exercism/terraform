resource "aws_security_group" "ec2" {
  name        = "tooling-invoker-ec2"
  description = "Security Group for Tooling Invokers EC2"
  vpc_id      = var.aws_vpc_main.id
  tags = {
    Name = "Tooling Invoker EC2"
  }

  # TODO: Just give this access to tooling_orchestrator
  # TODO: We should probably set up a seperate security group
  # for when creating the AMI that has this general egress on
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    egress {
    from_port = 0
    to_port   = 0
    ipv6_cidr_blocks = [
      "::/0",
    ]
    protocol = "-1"
  }

  # TODO: Remove this before going into
  # production as it allows SSH access.
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

