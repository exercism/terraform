variable "aws_vpc_main" {}
variable "aws_subnet_publics" {}

data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}
