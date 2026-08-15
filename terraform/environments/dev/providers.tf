# terraform block controls Terraform/provider requirements, while the provider block tells AWS provider how this configuraiton should interact with AWS. 
# terraform init will initalize the directory and install the required provider.

terraform {
  required_version = ">= 1.5.0"

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