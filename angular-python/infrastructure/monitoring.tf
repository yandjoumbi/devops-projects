## monitoring auto scaling for web layer
#resource "aws_autoscaling_policy" "web-autoscaling-cpu-policy" {
#  name                   = "web-autoscaling-cpu-policy"
#  autoscaling_group_name = aws_autoscaling_group.web_asg.id
#  adjustment_type        = "ChangeInCapacity"
#  scaling_adjustment     = 1
#  cooldown               = 60
#  policy_type            = "SimpleScaling"
#}
#
#resource "aws_sns_topic" "alarm_sns_topic" {
#  name = "my-alarm-topic"
#}
#
## SNS subscription to send notifications to an email address
#resource "aws_sns_topic_subscription" "email_subscription" {
#  topic_arn = aws_sns_topic.alarm_sns_topic.arn
#  protocol  = "email"
#  endpoint  = "ydjoumbi@gmail.com"
#}
#
#resource "aws_cloudwatch_metric_alarm" "web-cloudwatch-cpu-alarm" {
#  alarm_name                = "web-cloudwatch-cpu-alarm"
#  alarm_description         = "alarm when cpu usage increases"
#  comparison_operator       = "GreaterThanOrEqualToThreshold"
#  statistic                 = "Average"
#  threshold                 = "70"
#  metric_name               = "CPUUtilization"
#  namespace                 = "AWS/EC2"
#  evaluation_periods        = 2
#  period                    = 120
#  alarm_actions             = [aws_autoscaling_policy.web-autoscaling-cpu-policy.arn, aws_sns_topic.alarm_sns_topic.arn]
#  insufficient_data_actions = [aws_autoscaling_policy.web-autoscaling-cpu-policy.arn, aws_sns_topic.alarm_sns_topic.arn]
#  ok_actions                = [aws_autoscaling_policy.web-autoscaling-cpu-policy.arn, aws_sns_topic.alarm_sns_topic.arn]
#  actions_enabled           = true
#
#  dimensions = {
#    "AutoScalingGroupName" : aws_autoscaling_group.web_asg.id
#  }
#
#}
#
#resource "aws_autoscaling_policy" "web-custom-cpu-policy-scaledown" {
#  name                   = "custom-cpu-policy-scaledown"
#  autoscaling_group_name = aws_autoscaling_group.web_asg.id
#  adjustment_type        = "ChangeInCapacity"
#  scaling_adjustment     = -1
#  cooldown               = 60
#  policy_type            = "SimpleScaling"
#}
#
#resource "aws_cloudwatch_metric_alarm" "web-custom-cpu-alarm-scaledown" {
#  alarm_name                = "custom-cpu-alarm-scaledown"
#  alarm_description         = "alarm when cpu usage decreases"
#  comparison_operator       = "LessThanOrEqualToThreshold"
#  metric_name               = "CPUUtilization"
#  namespace                 = "AWS/EC2"
#  statistic                 = "Average"
#  threshold                 = "50"
#  period                    = 120
#  evaluation_periods        = 2
#  alarm_actions             = [aws_autoscaling_policy.web-custom-cpu-policy-scaledown.arn, aws_sns_topic.alarm_sns_topic.arn]
#  ok_actions                = [aws_autoscaling_policy.web-custom-cpu-policy-scaledown.arn, aws_sns_topic.alarm_sns_topic.arn]
#  insufficient_data_actions = [aws_autoscaling_policy.web-custom-cpu-policy-scaledown.arn, aws_sns_topic.alarm_sns_topic.arn]
#  actions_enabled           = true
#
#  dimensions = {
#    "AutoScalingGroupName" : aws_autoscaling_group.web_asg.name
#  }
#}