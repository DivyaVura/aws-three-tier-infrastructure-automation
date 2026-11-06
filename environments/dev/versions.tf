
terraform {
  required_version = ">= 1.5.0, < 2.0.0"

  backend "s3" {
    bucket       = "aws-three-tier-tf-state-669661878204-ap-south-1"
    key          = "three-tier/dev/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
