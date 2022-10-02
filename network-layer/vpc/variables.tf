#----------------------------------------------------------------------------------------------------------
# required variables which must be provided by the caller
#----------------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------------------
# optional variables which can be overriden by the caller
#----------------------------------------------------------------------------------------------------------
variable "vpc_name" {
  type        = string
  description = "name to assign to vpc"
  default     = ""
}

variable "cidr_block" {
  type        = string
  description = "cidr block to assign to vpc"
  default     = "172.31.0.0/16"
}

variable "availability_zones" {
  type        = list(string)
  description = "list of availability zone(s)"
  default     = []
}

variable "manage_default_network_acl" {
  type        = bool
  description = "whether to manage the default network acl"
  default     = true
}

variable "manage_default_route_table" {
  type        = bool
  description = "whether to manage the default route table"
  default     = true
}

variable "manage_default_security_group" {
  type        = bool
  description = "whether to manage the default security group"
  default     = true
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "whether to enable dns hostname support"
  default     = true
}

variable "enable_dns_support" {
  type        = bool
  description = "whether to enable dns support"
  default     = true
}

variable "enable_nat_gateway" {
  type        = bool
  description = "whether to enable nat gateway support"
  default     = true
}

variable "single_nat_gateway" {
  type        = bool
  description = "whether to provision a single nat gateway"
  default     = false
}

variable "one_nat_gateway_per_az" {
  type        = bool
  description = "whether to provision a nat gateway per availability zone"
  default     = true
}

variable "customer_gateways" {
  type        = map(map(any))
  description = "Maps of Customer Gateway's attributes"
  default     = {}
}

variable "enable_vpn_gateway" {
  type        = bool
  description = "whether to provision a vpn gateway"
  default     = false
}

variable "enable_dhcp_options" {
  type        = bool
  description = "whether to enable dhcp custom options"
  default     = false
}

variable "dhcp_options_domain_name" {
  type        = string
  description = "domain name of the dhcp server"
  default     = ""
}

variable "dhcp_options_domain_name_servers" {
  type        = list(string)
  description = "list of dhcp server options"
  default     = []
}

variable "enable_flow_log" {
  type        = bool
  description = "whether to enable vpc flow logs"
  default     = true
}

variable "create_flow_log_cloudwatch_log_group" {
  type        = bool
  description = "whether to create cloudwatch log group"
  default     = true
}

variable "create_flow_log_cloudwatch_iam_role" {
  type        = bool
  description = "whether to create a cloudwatch iam role"
  default     = true
}

variable "flow_log_max_aggregation_interval" {
  type        = number
  description = "value to assign to flow log max aggregation interval"
  default     = 60
}
