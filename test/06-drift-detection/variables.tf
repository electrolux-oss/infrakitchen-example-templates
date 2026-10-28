variable "name" {
  description = "File name (without extension) of the managed file"
  type        = string
  default     = "drift-test"
}

variable "dir" {
  description = "Absolute directory of the managed file; must be absolute because the workspace is deleted after every run"
  type        = string
  default     = "/tmp/ik-drift"
}

variable "content" {
  description = "Content of the managed file"
  type        = string
  default     = "managed by InfraKitchen"
}
