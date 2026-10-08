variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "account" {
  description = "Target AWS account ID"
  type        = string
}

variable "master_account_id" {
  description = "Account ID that will assume the role in this account"
  type        = string
}

variable "environment_name" {
  description = "Environment label"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Tags applied to created resources"
  type        = map(any)
  default     = {}
}

variable "max_session_duration" {
  description = "Max IAM role session duration in seconds"
  type        = number
  default     = 10800
}
