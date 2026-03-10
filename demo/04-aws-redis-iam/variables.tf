variable "cluster_arn" {
  description = "ElastiCache cluster ARN from the Redis module"
  type        = string
}

variable "iam_user_arn" {
  description = "Redis IAM user ARN from the Redis module"
  type        = string
}

variable "aws_iam_role_name" {
  description = "Application IAM role name that needs Redis connect permission"
  type        = string
}

variable "account" {
  description = "Target AWS account ID"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "policy_name" {
  description = "Policy name prefix"
  type        = string
}

variable "tags" {
  description = "Tags applied to created resources"
  type        = map(any)
  default     = {}
}
