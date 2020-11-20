output "alb_hostname" {
  value = aws_alb.language_servers.dns_name
}
