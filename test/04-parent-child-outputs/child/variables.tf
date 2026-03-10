variable "parent_region" {
  description = "Region value inherited from parent outputs"
  type        = string
}

variable "parent_vpc_name" {
  description = "VPC name inherited from parent outputs"
  type        = string
}

variable "parent_instance_count" {
  description = "Instance count inherited from parent outputs"
  type        = number
}

variable "child_suffix" {
  description = "Suffix used to identify this child resource"
  type        = string
  default     = "child-01"
}
