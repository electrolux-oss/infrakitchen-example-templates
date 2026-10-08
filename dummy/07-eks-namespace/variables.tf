variable "account" {
  description = "Target AWS account ID"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "cluster_name" {
  description = "EKS cluster name from the EKS module"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace name"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]{0,61}[a-z0-9])?$", var.namespace))
    error_message = "namespace must be a valid DNS-1123 label."
  }
}

variable "labels" {
  description = "Labels applied to the namespace"
  type        = map(string)
  default     = {}
}

variable "resource_quota" {
  description = "Resource quota applied to the namespace"
  type = object({
    requests_cpu    = optional(string, "2")
    requests_memory = optional(string, "4Gi")
    limits_cpu      = optional(string, "4")
    limits_memory   = optional(string, "8Gi")
    pods            = optional(number, 20)
  })
  default = {}
}

variable "tags" {
  description = "Tags applied to created resources"
  type        = map(string)
  default     = {}
}
