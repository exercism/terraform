resource "aws_security_group" "es_general" {
  name        = "es_general"
  description = "Controls what can access ES general"
  vpc_id      = aws_vpc.main.id

  lifecycle {
    create_before_destroy = true
  }
}
