resource "aws_security_group" "elasticsearch_logs" {
  name        = "elasticsearch logs"
  description = "Security Group for Elasticsearch Logs"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "elasticsearch-logs"
  }
  
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [
      aws_vpc.main.cidr_block,
    ]
  }
}


