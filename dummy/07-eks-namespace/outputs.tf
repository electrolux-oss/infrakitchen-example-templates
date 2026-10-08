output "namespace" {
  description = "Kubernetes namespace name"
  value       = terraform_data.namespace.output.name
}

output "namespace_uid" {
  description = "Kubernetes namespace UID"
  value       = terraform_data.namespace.output.uid
}

output "cluster_name" {
  description = "EKS cluster the namespace lives in"
  value       = terraform_data.namespace.output.cluster_name
}

output "resource_quota_name" {
  description = "Resource quota attached to the namespace"
  value       = terraform_data.resource_quota.output.name
}
