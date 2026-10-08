output "account" {
  description = "AWS account ID"
  value       = var.account
}

output "env" {
  description = "Environment name"
  value       = var.environment_name
}

output "cicd_admin_role_name" {
  description = "Created CI/CD admin IAM role name"
  value       = terraform_data.cicd_admin.output.name
}

output "cicd_admin_role_arn" {
  description = "Created CI/CD admin IAM role ARN"
  value       = terraform_data.cicd_admin.output.arn
}
