output "redis_primary_endpoint" {
  description = "Primary Redis endpoint"
  value       = terraform_data.replication_group.output.primary_endpoint_address
}

output "reader_endpoint_address" {
  description = "Reader endpoint"
  value       = terraform_data.replication_group.output.reader_endpoint_address
}

output "cluster_arn" {
  description = "ElastiCache cluster ARN"
  value       = terraform_data.replication_group.output.arn
}

output "replication_group_id" {
  description = "Replication group ID"
  value       = terraform_data.replication_group.output.replication_group_id
}

output "iam_user_arn" {
  description = "Generated IAM user ARN"
  value       = terraform_data.user["rw"].output.arn
}

output "iam_user_read_only_arn" {
  description = "Generated read-only IAM user ARN"
  value       = terraform_data.user["ro"].output.arn
}

output "user_prefix" {
  description = "User prefix used by Redis module"
  value       = var.user_prefix
}
