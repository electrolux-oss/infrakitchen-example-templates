output "policy_name_effective" {
  description = "IAM inline policy name created on the role"
  value       = terraform_data.redis_iam.output.name
}

output "target_role" {
  description = "Role that receives Redis IAM permissions"
  value       = terraform_data.attach.output.role
}

output "policy_arn" {
  description = "IAM policy ARN attached to the role"
  value       = terraform_data.attach.output.policy_arn
}

output "redis_username" {
  description = "Redis user the service account authenticates as"
  value       = terraform_data.redis_user.output.name
}

output "redis_user_arn" {
  description = "ElastiCache user ARN granted to the role"
  value       = terraform_data.redis_user.output.arn
}

output "connection_url" {
  description = "Passwordless TLS connection URL; use an IAM auth token as the password"
  value       = "rediss://${terraform_data.redis_user.output.name}@${var.redis_primary_endpoint}:${var.redis_port}"
}
