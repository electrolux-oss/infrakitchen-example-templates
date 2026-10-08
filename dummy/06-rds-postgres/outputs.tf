output "db_instance_identifier" {
  description = "RDS instance identifier"
  value       = terraform_data.postgres.output.identifier
}

output "db_instance_arn" {
  description = "RDS instance ARN"
  value       = terraform_data.postgres.output.arn
}

output "db_instance_resource_id" {
  description = "RDS instance resource ID (used in rds-db:connect IAM policies)"
  value       = terraform_data.postgres.output.resource_id
}

output "db_instance_address" {
  description = "Hostname of the RDS instance"
  value       = terraform_data.postgres.output.address
}

output "db_instance_port" {
  description = "Port the database listens on"
  value       = terraform_data.postgres.output.port
}

output "db_instance_endpoint" {
  description = "Connection endpoint in host:port form"
  value       = "${terraform_data.postgres.output.address}:${terraform_data.postgres.output.port}"
}

output "db_name" {
  description = "Name of the initial database"
  value       = terraform_data.postgres.output.db_name
}

output "master_username" {
  description = "Master user name"
  value       = terraform_data.postgres.output.username
}

output "master_user_secret_arn" {
  description = "Secrets Manager ARN holding the master user password"
  value       = terraform_data.postgres.output.master_user_secret_arn
}

output "engine_version_actual" {
  description = "Running PostgreSQL engine version"
  value       = terraform_data.postgres.output.engine_version_actual
}

output "security_group_id" {
  description = "Security group attached to the RDS instance"
  value       = terraform_data.security_group.output.id
}
