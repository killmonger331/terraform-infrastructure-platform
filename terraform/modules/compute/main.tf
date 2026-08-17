# ---------------------------------------------------------
# Latest Amazon Linux 2023 AMI
# ---------------------------------------------------------

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"

    values = [
      "al2023-ami-2023.*-x86_64"
    ]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# ---------------------------------------------------------
# EC2 Launch Template
# ---------------------------------------------------------

resource "aws_launch_template" "app" {
  name_prefix   = "terraform-platform-${var.environment}-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "var.instance_type"

  vpc_security_group_ids = [
    var.ec2_security_group_id
  ]

  user_data = base64encode(<<-EOF
    #!/bin/bash

    dnf update -y
    dnf install -y nginx

    cat <<HTML > /usr/share/nginx/html/index.html
    <!DOCTYPE html>
    <html>
      <head>
        <title>Terraform Infrastructure Platform</title>
      </head>

      <body>
        <h1>Terraform Infrastructure Platform</h1>
        <p>EC2 instance successfully deployed by Terraform.</p>
        <p>Hostname: $(hostname)</p>
      </body>
    </html>
    HTML

    systemctl enable nginx
    systemctl start nginx
  EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "terraform-platform-${var.environment}-app"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }

  tags = {
    Name        = "terraform-platform-${var.environment}-launch-template"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}


# ---------------------------------------------------------
# Auto Scaling Group
# ---------------------------------------------------------

resource "aws_autoscaling_group" "app" {
  name = "terraform-platform-${var.environment}-asg"

  min_size         = var.min_size
  desired_capacity = var.desired_capacity
  max_size         = var.max_size

  vpc_zone_identifier = var.private_app_subnet_ids

  target_group_arns = [
    aws_lb_target_group.app.arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "terraform-platform-${var.environment}-app"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = ${var.environment}
    propagate_at_launch = true
  }

  tag {
    key                 = "ManagedBy"
    value               = "Terraform"
    propagate_at_launch = true
  }
}