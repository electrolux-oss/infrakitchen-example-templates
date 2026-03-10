variable "should_fail" {
  description = "When true, this module fails deterministically"
  type        = bool
  default     = true
}

variable "error_message" {
  description = "Custom message shown on failure"
  type        = string
  default     = "InfraKitchen intentional module failure"
}
