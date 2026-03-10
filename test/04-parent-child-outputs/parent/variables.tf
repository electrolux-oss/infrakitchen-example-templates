variable "region" {
  description = "Region value to expose to child resources"
  type        = string
}

variable "vpc_name" {
  description = "VPC name to expose to child resources"
  type        = string
  default     = "primary-vpc"
}

variable "instance_count" {
  description = "Instance count to expose to child resources"
  type        = number
  default     = 3
}
