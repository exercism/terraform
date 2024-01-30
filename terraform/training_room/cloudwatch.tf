resource "aws_cloudwatch_log_group" "training_room" {
  name = "training-room"

  retention_in_days = 1
}

