output "iam_role_arn" {
  description = "IAM role ARN assumed by the service account (IRSA)"
  value       = terraform_data.role.output.arn
}

output "iam_role_name" {
  description = "IAM role name assumed by the service account"
  value       = terraform_data.role.output.name
}

output "service_account_name" {
  description = "Kubernetes service account name"
  value       = terraform_data.service_account.output.name
}

output "namespace" {
  description = "Kubernetes namespace of the service account"
  value       = terraform_data.service_account.output.namespace
}
