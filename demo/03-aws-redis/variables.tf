variable "account" {
  description = "Target AWS account ID"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "name" {
  description = "Redis replication group name"
  type        = string
}

variable "redis_version" {
  description = "Valkey/Redis engine version"
  type        = string
  default     = "8.0"
}

variable "node_type" {
  description = "Redis node type"
  type        = string
  default     = "cache.t4g.small"
}

variable "vpc_id" {
  description = "VPC ID for subnet and security-group discovery"
  type        = string
}

variable "ingress_cidrs" {
  description = "CIDR blocks allowed to connect"
  type        = list(string)
  default     = []
}

variable "number_of_nodes" {
  description = "Number of cache nodes"
  type        = number
  default     = 2
}

variable "tags" {
  description = "Tags applied to created resources"
  type        = map(string)
  default     = {}
}

variable "family" {
  description = "Redis/Valkey parameter group family"
  type        = string
  default     = "valkey8"
}

variable "default_user_access_string" {
  description = "Default user access string"
  type        = string
  default     = "off -@all"
}

variable "user_prefix" {
  description = "Prefix for generated IAM Redis users"
  type        = string
}

variable "parameters" {
  description = "Redis parameter list wrapper"
  type = object({
    parameters = optional(list(any), [])
  })
  default = {
    parameters = []
  }
}
