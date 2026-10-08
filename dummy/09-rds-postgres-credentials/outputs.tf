output "policy_name_effective" {
  description = "IAM policy name created for database access"
  value       = terraform_data.rds_iam.output.name
}

output "target_role" {
  description = "Role that receives database IAM permissions"
  value       = terraform_data.attach.output.role
}

output "policy_arn" {
  description = "IAM policy ARN attached to the role"
  value       = terraform_data.attach.output.policy_arn
}

output "db_username" {
  description = "Database user for IAM authentication"
  value       = terraform_data.db_user.output.name
}

output "db_user_arn" {
  description = "rds-db ARN of the database user"
  value       = local.db_user_arn
}

output "connection_url" {
  description = "Passwordless connection URL; use an IAM auth token as the password"
  value       = "postgresql://${terraform_data.db_user.output.name}@${var.db_instance_address}:${var.db_instance_port}/${var.db_name}?sslmode=require"
}
