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
  description = "RDS instance identifier"
  type        = string
}

variable "engine_version" {
  description = "PostgreSQL engine version (major or major.minor)"
  type        = string
  default     = "17"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "Initial storage in GiB"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Storage autoscaling upper limit in GiB"
  type        = number
  default     = 100
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

variable "db_name" {
  description = "Name of the initial database"
  type        = string
  default     = "app"
}

variable "master_username" {
  description = "Master user name (password is managed in Secrets Manager)"
  type        = string
  default     = "dbadmin"
}

variable "multi_az" {
  description = "Whether to deploy a Multi-AZ standby"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Days to retain automated backups"
  type        = number
  default     = 7
}

variable "iam_database_authentication_enabled" {
  description = "Whether IAM database authentication is enabled"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Whether deletion protection is enabled"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot on destroy"
  type        = bool
  default     = true
}

variable "parameters" {
  description = "PostgreSQL parameter list wrapper"
  type = object({
    parameters = optional(list(any), [])
  })
  default = {
    parameters = []
  }
}

variable "tags" {
  description = "Tags applied to created resources"
  type        = map(string)
  default     = {}
}
