variable "database_name" {
  description = "Name of the dummy database to migrate"
  type        = string
  default     = "dummy-db"
}

variable "environment" {
  description = "Environment label"
  type        = string
  default     = "dev"
}

variable "migration_count" {
  description = "Number of dummy migrations to apply"
  type        = number
  default     = 3

  validation {
    condition     = var.migration_count >= 0 && var.migration_count <= 20
    error_message = "migration_count must be between 0 and 20."
  }
}
