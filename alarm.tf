resource "aws_cloudwatch_metric_alarm" "example" {
  alarm_name          = "EC2 CPU Utilization Alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when EC2 CPU utilization exceeds 80% for 2 minutes"

  alarm_actions = [
    aws_sns_topic.example.arn
  ]
}
