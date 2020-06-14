output "alb_hostname" {
  value = aws_alb.webservers.dns_name
}
