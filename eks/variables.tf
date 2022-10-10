#----------------------------------------------------------------------------------------------------------
# required variables which must be provided by the caller
#----------------------------------------------------------------------------------------------------------
variable "vpc_id" {
  type        = string
  description = "vpc in which to provision the eks cluster"
}

variable "subnet_ids" {
  type        = list(string)
  description = "list of subnet id(s) to assign to the eks cluster"
}

#----------------------------------------------------------------------------------------------------------
# optional variables which can be overriden by the caller
#----------------------------------------------------------------------------------------------------------
variable "cluster_name" {
  type        = string
  description = "name to assign to the cluster"
  default     = ""
}

variable "cluster_version" {
  type        = string
  description = "kubernetes version to use for the cluster"
  default     = "1.23"
}

variable "cluster_endpoint_private_access" {
  type        = bool
  description = "whether to enable the cluster private endpoint"
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  type        = list(string)
  description = "list of CIDR blocks which can access the public api server endpoint"
  default     = null
}

variable "cluster_endpoint_public_access" {
  type        = bool
  description = "whether to enable the cluster public endpoint"
  default     = true
}

variable "create_kms_key" {
  type        = bool
  description = "whether cluster encryption should be enabled"
  default     = false
}

variable "default_cluster_encryption_config" {
  type        = list(any)
  description = "map of cluster encryption config"
  default     = []
}

variable "cluster_additional_security_group_ids" {
  type        = list(string)
  description = "list of security group(s) to assign to the control plane"
  default     = []
}

variable "manage_aws_auth_configmap" {
  type        = bool
  description = "whether to manage the cluster aws config map"
  default     = false
}

variable "create_aws_auth_configmap" {
  type        = bool
  description = "whether to create the cluster aws config map"
  default     = true
}

variable "cluster_security_group_description" {
  type        = string
  description = "description to assign to the cluster security group"
  default     = ""
}

variable "cluster_security_group_additional_rules" {
  type        = any
  description = "list of security group rule(s) to apply to the control plane"

  default = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }
}

variable "node_security_group_additional_rules" {
  type        = any
  description = "list of security group rule(s) to apply to the nodes"
  default     = {}
}

variable "cluster_enabled_log_types" {
  type        = list(string)
  description = "list of control plane services to log"

  default = [
    "audit",
    "api",
    "authenticator",
    "controllerManager",
    "scheduler",
  ]
}

variable "self_managed_node_group_defaults" {
  type        = any
  description = "map of self-managed node group default configurations"
  default     = {}
}

variable "kms_alias_prefix_path" {
  type        = string
  description = "prefix path for each kms alias"
  default     = "alias"
}

variable "iam_role_arn" {
  type        = string
  description = "custom iam role arn for the cluster"
  default     = null
}

variable "iam_role_name" {
  type        = string
  description = "name to assign to the cluster iam role"
  default     = ""
}

variable "iam_role_additional_policies" {
  type        = list(string)
  description = "list of additional iam policies to add"
  default     = []
}

variable "iam_role_use_name_prefix" {
  type        = bool
  description = "whether the iam role name is used as a prefix"
  default     = false
}

variable "iam_role_description" {
  type        = string
  description = "description of the iam role"
  default     = ""
}

variable "iam_role_tags" {
  type        = map(string)
  description = "map of tag(s) to assing to the iam role"
  default     = {}
}

variable "cluster_addons" {
  type        = any
  description = "map of cluster addons"
  default     = {}
}

variable "kube_proxy_addon_version" {
  type        = string
  description = "version of the kube-proxy addon"
  default     = "v1.23.8-eksbuild.2"
}

variable "coredns_addon_version" {
  type        = string
  description = "version of the kube-proxy addon"
  default     = "v1.8.7-eksbuild.3"
}

variable "vpc_cni_addon_version" {
  type        = string
  description = "version of the kube-proxy addon"
  default     = "v1.11.4-eksbuild.1"
}

variable "aws_auth_accounts" {
  type        = list(any)
  description = "list of account maps to add to the aws-auth configmap"
  default     = []
}

variable "aws_auth_roles" {
  type        = list(any)
  description = "list of account maps to add to the aws-auth configmap"
  default     = []
}

variable "aws_auth_users" {
  type        = list(any)
  description = "list of account maps to add to the aws-auth configmap"
  default     = []
}

variable "cluster_timeouts" {
  type        = map(string)
  description = "map of cluster timeouts"

  default = {
    create = "60m"
    update = "60m"
    delete = "60m"
  }
}

variable "additional_cluster_tags" {
  type        = map(string)
  description = "map of additional cluster tag(s) to merge"
  default     = {}
}

variable "additional_autoscaling_group_tags" {
  type        = map(string)
  description = "map of additional tags to add to the autoscaling group"
  default     = {}
}

variable "self_managed_node_groups" {
  type        = any
  description = "map of self managed node groups"
  default     = {}
}

variable "default_self_managed_instance_type" {
  type        = string
  description = "the default instance type for self managed nodes"
  default     = "t3a.medium"
}

variable "default_self_managed_key_pair" {
  type        = string
  description = "the default key pair for self managed nodes"
  default     = ""
}

variable "default_self_managed_min_size" {
  type        = number
  description = "default min size for self managed nodes"
  default     = 1
}

variable "default_self_managed_max_size" {
  type        = number
  description = "default max size for self managed nodes"
  default     = 1
}

variable "default_self_managed_desired_size" {
  type        = number
  description = "default desired size for self managed nodes"
  default     = 1
}

variable "default_self_managed_ebs_optimized" {
  type        = bool
  description = "whether to enable ebs optimization for self managed nodes"
  default     = true
}

variable "default_self_managed_ebs_monitoring" {
  type        = bool
  description = "whether to enable ebs monitoring for self managed nodes"
  default     = true
}

variable "default_self_managed_disk_size" {
  type        = number
  description = "default disk size for self managed nodes"
  default     = 25
}

variable "default_self_managed_root_device_name" {
  type        = string
  description = "default device name for root volume of self managed nodes"
  default     = "/dev/xvda"
}

variable "default_self_managed_root_volume_type" {
  type        = string
  description = "ebs type for root volume of self managed nodes"
  default     = "gp3"
}

variable "default_self_root_managed_root_iops" {
  type        = number
  description = "default iops for root volume of self managed nodes"
  default     = 1500
}

variable "default_self_managed_root_throughput" {
  type        = number
  description = "default throughput for root volume of self managed nodes"
  default     = 150
}

variable "default_self_managed_root_encrypted" {
  type        = bool
  description = "whether to encrypt the root volume of self managed nodes"
  default     = true
}

variable "default_self_managed_root_delete_on_termination" {
  type        = bool
  description = "whether to delete on termination of root volume of self managed nodes"
  default     = true
}

variable "default_self_managed_use_name_prefix" {
  type        = bool
  description = "whether to assign a name prefix"
  default     = false
}

variable "default_self_managed_update_launch_template" {
  type        = bool
  description = "whether to update the default launch template"
  default     = true
}

variable "default_self_managed_create_security_group" {
  type        = bool
  description = "whether to let eks create the node security group"
  default     = false
}
