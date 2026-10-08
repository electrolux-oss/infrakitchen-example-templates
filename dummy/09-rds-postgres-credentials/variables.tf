variable "account" {
  description = "Target AWS account ID"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "aws_iam_role_name" {
  description = "Service account IAM role name that needs database connect permission"
  type        = string
}

variable "db_instance_resource_id" {
  description = "RDS instance resource ID from the RDS module"
  type        = string
}

variable "db_instance_address" {
  description = "RDS instance hostname from the RDS module"
  type        = string
}

variable "db_instance_port" {
  description = "RDS instance port from the RDS module"
  type        = number
  default     = 5432
}

variable "db_name" {
  description = "Database name from the RDS module"
  type        = string
}

variable "db_username" {
  description = "Database user created for IAM authentication"
  type        = string

  validation {
    condition     = can(regex("^[a-z_][a-z0-9_]{0,62}$", var.db_username))
    error_message = "db_username must be a valid lowercase PostgreSQL identifier."
  }
}

variable "privileges" {
  description = "Privileges granted to the user on the database"
  type        = list(string)
  default     = ["CONNECT", "TEMPORARY"]
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
