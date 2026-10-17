variable "dataset" {
  description = "Name of the dummy dataset to import"
  type        = string
  default     = "customers"
}

variable "environment" {
  description = "Environment label"
  type        = string
  default     = "dev"
}

variable "record_count" {
  description = "Number of dummy records to import"
  type        = number
  default     = 5

  validation {
    condition     = var.record_count >= 0 && var.record_count <= 50
    error_message = "record_count must be between 0 and 50."
  }
}
