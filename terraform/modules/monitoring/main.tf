# ---------------------------------------------------------
# EC2 / Auto Scaling Monitoring
# ---------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "ec2_high_cpu" {
  alarm_name          = "terraform-platform-${var.environment}-ec2-high-cpu"
  alarm_description   = "EC2 Auto Scaling Group average CPU is above 70 percent"
  comparison_operator = "GreaterThanThreshold"

  evaluation_periods  = 2
  datapoints_to_alarm = 2

  metric_name = "CPUUtilization"
  namespace   = "AWS/EC2"
  statistic   = "Average"

  period    = 300
  threshold = 70

  dimensions = {
    AutoScalingGroupName = var.autoscaling_group_name
  }

  treat_missing_data = "notBreaching"

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}


# ---------------------------------------------------------
# ALB - Unhealthy Targets
# ---------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_targets" {
  alarm_name        = "terraform-platform-${var.environment}-alb-unhealthy-targets"
  alarm_description = "ALB has one or more unhealthy EC2 targets"

  comparison_operator = "GreaterThanOrEqualToThreshold"

  evaluation_periods  = 1
  datapoints_to_alarm = 1

  metric_name = "UnHealthyHostCount"
  namespace   = "AWS/ApplicationELB"
  statistic   = "Maximum"

  period    = 60
  threshold = 1

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
    TargetGroup  = var.target_group_arn_suffix
  }

  treat_missing_data = "notBreaching"

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}


# ---------------------------------------------------------
# ALB - High Response Time
# ---------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "alb_high_response_time" {
  alarm_name        = "terraform-platform-${var.environment}-alb-high-response-time"
  alarm_description = "ALB target response time is above 2 seconds"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods  = 2
  datapoints_to_alarm = 2

  metric_name = "TargetResponseTime"
  namespace   = "AWS/ApplicationELB"
  statistic   = "Average"

  period    = 60
  threshold = 2

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

  treat_missing_data = "notBreaching"

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}


# ---------------------------------------------------------
# RDS - High CPU
# ---------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "rds_high_cpu" {
  alarm_name        = "terraform-platform-${var.environment}-rds-high-cpu"
  alarm_description = "RDS CPU utilization is above 80 percent"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods  = 2
  datapoints_to_alarm = 2

  metric_name = "CPUUtilization"
  namespace   = "AWS/RDS"
  statistic   = "Average"

  period    = 300
  threshold = 80

  dimensions = {
    DBInstanceIdentifier = var.db_instance_identifier
  }

  treat_missing_data = "notBreaching"

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}


# ---------------------------------------------------------
# RDS - Low Free Storage
# ---------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "rds_low_storage" {
  alarm_name        = "terraform-platform-${var.environment}-rds-low-storage"
  alarm_description = "RDS free storage has fallen below 5 GiB"

  comparison_operator = "LessThanThreshold"

  evaluation_periods = 1

  metric_name = "FreeStorageSpace"
  namespace   = "AWS/RDS"
  statistic   = "Average"

  period    = 300
  threshold = 5368709120

  dimensions = {
    DBInstanceIdentifier = var.db_instance_identifier
  }

  treat_missing_data = "notBreaching"

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}


# ---------------------------------------------------------
# CloudWatch Dashboard
# ---------------------------------------------------------

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "terraform-platform-${var.environment}-dashboard"

  dashboard_body = jsonencode({
    widgets = [

      # ---------------------------------------------------
      # EC2 CPU
      # ---------------------------------------------------

      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          title  = "EC2 Auto Scaling Group - CPU Utilization"
          region = var.aws_region
          view   = "timeSeries"
          stat   = "Average"
          period = 300

          metrics = [
            [
              "AWS/EC2",
              "CPUUtilization",
              "AutoScalingGroupName",
              var.autoscaling_group_name
            ]
          ]
        }
      },

      # ---------------------------------------------------
      # ALB Request Count
      # ---------------------------------------------------

      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          title  = "ALB - Request Count"
          region = var.aws_region
          view   = "timeSeries"
          stat   = "Sum"
          period = 60

          metrics = [
            [
              "AWS/ApplicationELB",
              "RequestCount",
              "LoadBalancer",
              var.alb_arn_suffix
            ]
          ]
        }
      },

      # ---------------------------------------------------
      # ALB Target Health
      # ---------------------------------------------------

      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          title  = "ALB - Target Health"
          region = var.aws_region
          view   = "timeSeries"
          period = 60

          metrics = [
            [
              "AWS/ApplicationELB",
              "HealthyHostCount",
              "TargetGroup",
              var.target_group_arn_suffix,
              "LoadBalancer",
              var.alb_arn_suffix,
              {
                stat = "Minimum"
              }
            ],

            [
              ".",
              "UnHealthyHostCount",
              ".",
              ".",
              ".",
              ".",
              {
                stat = "Maximum"
              }
            ]
          ]
        }
      },

      # ---------------------------------------------------
      # ALB Response Time
      # ---------------------------------------------------

      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6

        properties = {
          title  = "ALB - Target Response Time"
          region = var.aws_region
          view   = "timeSeries"
          stat   = "Average"
          period = 60

          metrics = [
            [
              "AWS/ApplicationELB",
              "TargetResponseTime",
              "LoadBalancer",
              var.alb_arn_suffix
            ]
          ]
        }
      },

      # ---------------------------------------------------
      # RDS CPU
      # ---------------------------------------------------

      {
        type   = "metric"
        x      = 0
        y      = 12
        width  = 12
        height = 6

        properties = {
          title  = "RDS - CPU Utilization"
          region = var.aws_region
          view   = "timeSeries"
          stat   = "Average"
          period = 300

          metrics = [
            [
              "AWS/RDS",
              "CPUUtilization",
              "DBInstanceIdentifier",
              var.db_instance_identifier
            ]
          ]
        }
      },

      # ---------------------------------------------------
      # RDS Connections
      # ---------------------------------------------------

      {
        type   = "metric"
        x      = 12
        y      = 12
        width  = 12
        height = 6

        properties = {
          title  = "RDS - Database Connections"
          region = var.aws_region
          view   = "timeSeries"
          stat   = "Average"
          period = 300

          metrics = [
            [
              "AWS/RDS",
              "DatabaseConnections",
              "DBInstanceIdentifier",
              var.db_instance_identifier
            ]
          ]
        }
      }
    ]
  })
}