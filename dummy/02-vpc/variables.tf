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
  description = "VPC name"
  type        = string
}

variable "cidr_block" {
  description = "VPC CIDR base (for example 10.20.0.0/16)"
  type        = string
}

variable "secondary_cidr_blocks" {
  description = "Optional secondary CIDR blocks"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags applied to created resources"
  type        = map(any)
  default     = {}
}
