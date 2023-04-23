
# Set up the cluster
# ###
resource "aws_ecs_cluster" "webservers" {
  name = "webservers"
}
