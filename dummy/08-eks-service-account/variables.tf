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

variable "oidc_provider_arn" {
  description = "IAM OIDC provider ARN from the EKS module"
  type        = string
}

variable "oidc_issuer_url" {
  description = "OIDC issuer URL from the EKS module"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace from the namespace module"
  type        = string
}

variable "service_account_name" {
  description = "Kubernetes service account name"
  type        = string
}

variable "policy_arns" {
  description = "Additional managed IAM policy ARNs attached to the service account role"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags applied to created resources"
  type        = map(string)
  default     = {}
}
