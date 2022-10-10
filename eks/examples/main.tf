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

data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = ["dang-test-vpc"]
  }
}

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
  filter {
    name   = "tag:Name"
    values = ["dang-test-vpc-private*"]
  }
}

module "opinionated_eks" {
  source = "../"

  subnet_ids                           = data.aws_subnets.this.ids
  vpc_id                               = data.aws_vpc.this.id
  cluster_endpoint_public_access       = true
  cluster_endpoint_private_access      = true
  kms_alias_prefix_path                = var.kms_alias_prefix_path
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  default_self_managed_key_pair        = var.default_self_managed_key_pair

  self_managed_node_groups = {
    primary_node_group = {
      name                            = "primary-node-group"
      launch_template_name            = "primary-node-group"
      launch_template_use_name_prefix = false
      launch_template_description     = "primary node group launch template"
    }
  }

  node_security_group_additional_rules = {
    ssh_all = {
      description = "ssh to node"
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      type        = "ingress"
      cidr_blocks = var.ssh_whitelist_cidr_blocks
    }
  }
}
