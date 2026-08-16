# first disposable resource, S3 is cheap, easy to verify and easy to destory

#resource "aws_s3_bucket" "terraform_test" {
#  bucket_prefix = "terraform-platform-test-"
#  tags = {
#    Name        = "Terraform Platform Test"
#    Environment = "var.environment"
#    ManagedBy   = "Terraform"
# }
#}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "terraform-platform-dev-vpc"
    Envrionment = "dev"
    ManagedBy   = "Terraform"
  }
}

