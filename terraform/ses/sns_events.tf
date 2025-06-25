resource "aws_sns_topic" "events" {
  name = "sns-transactional-events"
}

resource "aws_sns_topic_subscription" "events" {
  topic_arn = aws_sns_topic.events.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.events.arn
}

resource "aws_sns_topic_policy" "ses_events" {
  arn    = aws_sns_topic.events.arn
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "notification-policy",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ses.amazonaws.com"
      },
      "Action": "sns:Publish",
      "Resource": "arn:aws:sns:eu-west-2:681735686245:sns-transactional-events",
      "Condition": {
        "StringEquals": {
          "AWS:SourceAccount": "681735686245",
          "AWS:SourceArn": "arn:aws:ses:eu-west-2:681735686245:configuration-set/transactional-basic"
        }
      }
    }
  ]
}
EOF
}
