terraform {
  required_version = "~> 1.2.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.32.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "opinionated_vpc" {
  source = "../"

  vpc_name   = "dang-test-vpc"
  cidr_block = "10.0.0.0/16"
}
