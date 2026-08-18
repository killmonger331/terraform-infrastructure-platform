terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-platform-state-015809853573"

  tags = {
    Name      = "terraform-platform-state"
    ManagedBy = "Terraform"
    Purpose   = "Terraform Remote State"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]
}

data "aws_iam_policy_document" "github_actions_trust" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.github.arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:killmonger331/terraform-infrastructure-platform:*"
      ]
    }
  }
}

resource "aws_iam_role" "github_terraform" {
  name = "TerraformPlatformGitHubActionsRole"

  assume_role_policy = data.aws_iam_policy_document.github_actions_trust.json

  tags = {
    ManagedBy = "Terraform"
    Purpose   = "GitHub Actions Terraform deployment"
  }
}

resource "aws_iam_role_policy" "github_terraform" {
  name = "TerraformPlatformDeploymentPolicy"
  role = aws_iam_role.github_terraform.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "ec2:*",
          "elasticloadbalancing:*",
          "autoscaling:*",
          "rds:*",
          "cloudwatch:*",
          "secretsmanager:*"
        ]

        Resource = "*"
      },
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]

        Resource = [
          "arn:aws:s3:::terraform-platform-state-015809853573",
          "arn:aws:s3:::terraform-platform-state-015809853573/*"
        ]
      }
    ]
  })
}