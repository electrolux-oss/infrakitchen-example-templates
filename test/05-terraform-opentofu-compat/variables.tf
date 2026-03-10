variable "organization_name" {
  description = "Organization identifier"
  type        = string
  default     = "acme"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "metadata" {
  description = "Optional metadata payload"
  type        = any
  default     = {}
}
