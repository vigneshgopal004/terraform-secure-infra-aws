# ----------------------------
# CloudWatch Log Group (EC2 / App logs)
# ----------------------------
resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/secure-prod/ec2/app"
  retention_in_days = 7

  tags = {
    Name = "secure-prod-app-logs"
  }
}

# ----------------------------
# EC2 CPU Utilization Alarm
# ----------------------------
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_high" {
  alarm_name          = "secure-prod-ec2-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    InstanceId = aws_instance.app.id
  }

  alarm_description = "Alarm when EC2 CPU exceeds 80%"
}

# ----------------------------
# ALB Unhealthy Host Alarm
# ----------------------------
resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_hosts" {
  alarm_name          = "secure-prod-alb-unhealthy-hosts"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Average"
  threshold           = 0

  dimensions = {
    LoadBalancer = aws_lb.alb.arn_suffix
    TargetGroup  = aws_lb_target_group.tg.arn_suffix
  }

  alarm_description = "Alarm when ALB has unhealthy targets"
}

