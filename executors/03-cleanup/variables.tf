variable "target" {
  description = "Name of the dummy target to clean up"
  type        = string
  default     = "dummy-target"
}

variable "environment" {
  description = "Environment label"
  type        = string
  default     = "dev"
}

variable "stale_item_count" {
  description = "Number of dummy stale items to remove"
  type        = number
  default     = 4

  validation {
    condition     = var.stale_item_count >= 0 && var.stale_item_count <= 20
    error_message = "stale_item_count must be between 0 and 20."
  }
}
