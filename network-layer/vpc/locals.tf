locals {
  vpc_name           = var.vpc_name == "" ? "${random_pet.vpc[0].id}-vpc" : var.vpc_name
  default_tag_name   = "${local.vpc_name}-default"
  availability_zones = length(var.availability_zones) > 0 ? var.availability_zones : slice(data.aws_availability_zones.available.names, 0, 3)

  private_cidr_range   = flatten(chunklist(cidrsubnets(var.cidr_block, 4, 4, 4, 4, 4, 4, 4), 3))
  private_end_index    = length(local.private_cidr_range) - 1
  public_subnet_cidrs  = flatten(chunklist(cidrsubnets(local.private_cidr_range[local.private_end_index], 4, 4, 4), 3))
  private_subnet_cidrs = slice(local.private_cidr_range, 0, local.private_end_index)

  vpc_tags = {
    Example = local.vpc_name
  }
}
