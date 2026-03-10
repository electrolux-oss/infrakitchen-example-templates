variable "name" {
  description = "Name for this long-running test"
  type        = string
  default     = "long-running-test"
}

variable "wait_seconds" {
  description = "How long apply should wait"
  type        = number
  default     = 30
}
