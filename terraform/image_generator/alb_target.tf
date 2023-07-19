resource "aws_alb_listener_rule" "main" {
  listener_arn = var.aws_alb_listener_internal.arn
  priority = 100
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.main.id
  }

  condition {
    path_pattern {
      values = ["/generate_image"]
    }
  }
}

resource "aws_alb_target_group" "main" {
  name        = "solution-generator"
  target_type = "lambda"
}

resource "aws_lambda_permission" "main" {
  statement_id  = "AllowExecutionFromlb"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.main.arn
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_alb_target_group.main.arn
}

resource "aws_alb_target_group_attachment" "main" {
  target_group_arn = aws_alb_target_group.main.arn
  target_id        = aws_lambda_function.main.arn
  depends_on       = [aws_lambda_permission.main]
}
