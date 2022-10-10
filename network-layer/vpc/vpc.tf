data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_pet" "vpc" {
  count = var.vpc_name == "" ? 1 : 0
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.16.0"

  name = local.vpc_name
  cidr = var.cidr_block
  azs  = local.availability_zones

  private_subnets = slice(local.private_subnet_cidrs, 0, 3)
  intra_subnets   = slice(local.private_subnet_cidrs, 3, 6) # todo: this assumes a 6 element list
  public_subnets  = slice(local.public_subnet_cidrs, 0, 3)  # todo: this assumes a 3 element list

  # todo: add specific nacls
  manage_default_network_acl = var.manage_default_network_acl
  default_network_acl_tags   = { Name = local.default_tag_name }

  manage_default_route_table = var.manage_default_route_table
  default_route_table_tags   = { Name = local.default_tag_name }

  manage_default_security_group = var.manage_default_security_group
  default_security_group_tags   = { Name = local.default_tag_name }

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  # defaults to one nat gateway per az
  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  customer_gateways  = var.customer_gateways
  enable_vpn_gateway = var.enable_vpn_gateway

  enable_dhcp_options              = var.enable_dhcp_options
  dhcp_options_domain_name         = var.dhcp_options_domain_name
  dhcp_options_domain_name_servers = var.dhcp_options_domain_name_servers

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = var.enable_flow_log
  create_flow_log_cloudwatch_log_group = var.create_flow_log_cloudwatch_log_group
  create_flow_log_cloudwatch_iam_role  = var.create_flow_log_cloudwatch_iam_role
  flow_log_max_aggregation_interval    = var.flow_log_max_aggregation_interval
}
