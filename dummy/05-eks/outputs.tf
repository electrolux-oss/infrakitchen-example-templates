output "cluster_name" {
  description = "EKS cluster name"
  value       = terraform_data.cluster.output.name
}

output "cluster_arn" {
  description = "EKS cluster ARN"
  value       = terraform_data.cluster.output.arn
}

output "cluster_endpoint" {
  description = "Kubernetes API server endpoint"
  value       = terraform_data.cluster.output.endpoint
}

output "cluster_version" {
  description = "Kubernetes version of the control plane"
  value       = terraform_data.cluster.output.version
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded cluster CA certificate"
  value       = terraform_data.cluster.output.certificate_authority
}

output "cluster_security_group_id" {
  description = "Cluster security group created by EKS"
  value       = terraform_data.cluster.output.cluster_security_group_id
}

output "cluster_role_arn" {
  description = "IAM role ARN used by the EKS control plane"
  value       = terraform_data.cluster_role.output.arn
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL of the cluster"
  value       = terraform_data.cluster.output.oidc_issuer
}

output "oidc_provider_arn" {
  description = "IAM OIDC provider ARN for IRSA"
  value       = terraform_data.oidc_provider.output.arn
}

output "node_group_name" {
  description = "Managed node group name"
  value       = terraform_data.node_group.output.name
}

output "node_role_arn" {
  description = "IAM role ARN used by worker nodes"
  value       = terraform_data.node_role.output.arn
}
