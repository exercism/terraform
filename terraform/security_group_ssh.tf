resource "aws_security_group" "ssh" {
  name        = "ssh-access"
  description = "Allows public SSH access"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22

    # TODO: Change this to only allow specific IPs
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
