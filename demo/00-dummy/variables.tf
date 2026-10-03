variable "name" {
  description = "Name of the dummy application"
  type        = string
  default     = "dummy-app"
}

variable "environment" {
  description = "Environment label"
  type        = string
  default     = "dev"
}

variable "instance_count" {
  description = "Number of dummy instances to create"
  type        = number
  default     = 2

  validation {
    condition     = var.instance_count >= 0 && var.instance_count <= 10
    error_message = "instance_count must be between 0 and 10."
  }
}

variable "tags" {
  description = "Tags attached to the dummy deployment"
  type        = map(string)
  default = {
    owner = "platform"
  }
}
