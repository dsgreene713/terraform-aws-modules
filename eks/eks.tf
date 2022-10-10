locals {
  cluster_name                       = var.cluster_name == "" ? "${random_pet.cluster[0].id}-eks-cluster" : var.cluster_name
  cluster_security_group_description = var.cluster_security_group_description == "" ? "${local.cluster_name}-secgroup" : var.cluster_security_group_description
  iam_role_name                      = var.iam_role_name == "" ? "${local.cluster_name}-iam-role" : var.iam_role_name
  iam_role_description               = var.iam_role_description == "" ? "iam role for ${local.cluster_name}" : var.iam_role_description
  create_encryption_kms_key          = var.default_cluster_encryption_config == "" ? true : false

  cluster_encryption_config = [{
    provider_key_arn = aws_kms_key.eks_cluster.arn
    resources        = ["secrets"]
  }]

  cluster_addons = {
    kube-proxy = {
      addon_version     = var.kube_proxy_addon_version
      resolve_conflicts = "OVERWRITE"
    }

    coredns = {
      addon_version     = var.coredns_addon_version
      resolve_conflicts = "OVERWRITE"
    }

    vpc-cni = {
      addon_version     = var.vpc_cni_addon_version
      resolve_conflicts = "OVERWRITE"
    }
  }

  self_managed_node_group_defaults = {
    use_name_prefix                        = var.default_self_managed_use_name_prefix
    update_launch_template_default_version = var.default_self_managed_update_launch_template
    create_security_group                  = var.default_self_managed_create_security_group

    instance_type     = var.default_self_managed_instance_type
    ami_id            = data.aws_ami.eks_default.id
    key_name          = var.default_self_managed_key_pair
    min_size          = var.default_self_managed_min_size
    max_size          = var.default_self_managed_max_size
    desired_size      = var.default_self_managed_desired_size
    ebs_optimized     = var.default_self_managed_ebs_optimized
    enable_monitoring = var.default_self_managed_ebs_monitoring
    disk_size         = var.default_self_managed_disk_size

    block_device_mappings = {
      xvda = {
        device_name = var.default_self_managed_root_device_name

        ebs = {
          volume_size           = var.default_self_managed_disk_size
          volume_type           = var.default_self_managed_root_volume_type
          iops                  = var.default_self_root_managed_root_iops
          throughput            = var.default_self_managed_root_throughput
          encrypted             = var.default_self_managed_root_encrypted
          delete_on_termination = var.default_self_managed_root_delete_on_termination
        }
      }
    }

    autoscaling_group_tags = merge(
      var.additional_autoscaling_group_tags,
      # list last to ensure these are NOT overridden
      {
        "k8s.io/cluster-autoscaler/enabled" : true,
        "k8s.io/cluster-autoscaler/${local.cluster_name}" : "owned",
      },
    )
  }
}

resource "random_pet" "cluster" {
  count = var.cluster_name == "" ? 1 : 0
}

resource "aws_ec2_tag" "subnets_shared" {
  for_each = toset(var.subnet_ids)

  resource_id = each.key
  key         = "kubernetes.io/cluster/${local.cluster_name}"
  value       = "shared"
}

resource "aws_ec2_tag" "subnets_elb" {
  for_each = toset(var.subnet_ids)

  resource_id = each.key
  key         = "kubernetes.io/role/internal-elb"
  value       = 1
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_id]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.30.0"

  vpc_id                    = var.vpc_id
  subnet_ids                = var.subnet_ids
  create_aws_auth_configmap = var.create_aws_auth_configmap
  manage_aws_auth_configmap = var.manage_aws_auth_configmap
  create_kms_key            = var.create_kms_key

  aws_auth_accounts = var.aws_auth_accounts
  aws_auth_roles    = var.aws_auth_roles
  aws_auth_users    = var.aws_auth_users

  cluster_name                          = local.cluster_name
  cluster_version                       = var.cluster_version
  cluster_endpoint_private_access       = var.cluster_endpoint_private_access
  cluster_endpoint_public_access_cidrs  = var.cluster_endpoint_public_access_cidrs
  cluster_endpoint_public_access        = var.cluster_endpoint_public_access
  cluster_additional_security_group_ids = var.cluster_additional_security_group_ids
  cloudwatch_log_group_kms_key_id       = aws_kms_key.eks_cloudwatch.arn
  cluster_enabled_log_types             = var.cluster_enabled_log_types
  cluster_addons                        = var.cluster_addons == {} ? local.cluster_addons : var.cluster_addons

  iam_role_arn                 = var.iam_role_arn # only use if a custom iam role is required for the worker nodes
  iam_role_name                = local.iam_role_name
  iam_role_use_name_prefix     = var.iam_role_use_name_prefix
  iam_role_description         = local.iam_role_description
  iam_role_tags                = var.iam_role_tags
  iam_role_additional_policies = var.iam_role_additional_policies

  cluster_encryption_config          = local.create_encryption_kms_key ? local.cluster_encryption_config : var.default_cluster_encryption_config
  cluster_security_group_description = local.cluster_security_group_description
  cluster_timeouts                   = var.cluster_timeouts

  cluster_tags = merge(
    { Name = local.cluster_name }, # list first so it can be overridden
    var.additional_cluster_tags,
  )

  cluster_security_group_additional_rules = var.cluster_security_group_additional_rules
  node_security_group_additional_rules    = var.node_security_group_additional_rules
  self_managed_node_group_defaults        = var.self_managed_node_group_defaults == {} ? local.self_managed_node_group_defaults : var.self_managed_node_group_defaults
  self_managed_node_groups                = var.self_managed_node_groups
}
