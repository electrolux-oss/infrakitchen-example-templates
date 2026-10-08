variable "cluster_arn" {
  description = "ElastiCache cluster ARN from the Redis module"
  type        = string
}

variable "iam_user_arn" {
  description = "Redis IAM user ARN from the Redis module (iam_user_arn or iam_user_read_only_arn)"
  type        = string

  validation {
    condition     = can(regex("user:([^:/]+)$", var.iam_user_arn))
    error_message = "iam_user_arn must be an ElastiCache user ARN (arn:aws:elasticache:<region>:<account>:user:<name>)."
  }
}

variable "redis_primary_endpoint" {
  description = "Primary Redis endpoint from the Redis module"
  type        = string
}

variable "redis_port" {
  description = "Redis port"
  type        = number
  default     = 6379
}

variable "aws_iam_role_name" {
  description = "Service account IAM role name that needs Redis connect permission"
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
