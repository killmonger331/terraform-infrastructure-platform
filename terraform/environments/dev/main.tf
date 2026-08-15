# first disposable resource, S3 is cheap, easy to verify and easy to destory

resource "aws_s3_bucket" "terraform_test" {
  bucket_prefix = "terraform-platform-test-"

  tags = {
    Name        = "Terraform Platform Test"
    Environment = "var.environment"
    ManagedBy   = "Terraform"
  }
}

