output "account" {
  description = "AWS account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "env" {
  description = "Environment name"
  value       = var.environment_name
}

output "cicd_admin_role_name" {
  description = "Created CI/CD admin IAM role name"
  value       = aws_iam_role.cicd_admin.name
}

output "cicd_admin_role_arn" {
  description = "Created CI/CD admin IAM role ARN"
  value       = aws_iam_role.cicd_admin.arn
}
