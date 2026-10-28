variable "drift_dir" {
  description = "Directory on the worker where the files are written. It must be outside the task workspace, which is removed after every task, so that the files can be changed between tasks."
  type        = string
  default     = "/tmp/infrakitchen-drift-demo"
}

variable "name" {
  description = "Name of the demo, a subdirectory of drift_dir: use a different one per resource"
  type        = string
  default     = "demo"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name))
    error_message = "Use lowercase letters, digits and dashes."
  }
}

variable "environment" {
  description = "Written into the app config file"
  type        = string
  default     = "dev"
}

variable "replicas" {
  description = "Written into the app config file"
  type        = number
  default     = 2
}

variable "welcome_message" {
  description = "Content of the welcome file"
  type        = string
  default     = "Managed by InfraKitchen. Edit or delete me to create drift."
}
