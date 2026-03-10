output "redis_primary_endpoint" {
  description = "Primary Redis endpoint"
  value       = aws_elasticache_replication_group.redis.primary_endpoint_address
}

output "reader_endpoint_address" {
  description = "Reader endpoint"
  value       = aws_elasticache_replication_group.redis.reader_endpoint_address
}

output "cluster_arn" {
  description = "ElastiCache cluster ARN"
  value       = aws_elasticache_replication_group.redis.arn
}

output "replication_group_id" {
  description = "Replication group ID"
  value       = aws_elasticache_replication_group.redis.replication_group_id
}

output "iam_user_arn" {
  description = "Generated IAM user ARN"
  value       = aws_elasticache_user.rw.arn
}

output "iam_user_read_only_arn" {
  description = "Generated read-only IAM user ARN"
  value       = aws_elasticache_user.ro.arn
}

output "user_prefix" {
  description = "User prefix used by Redis module"
  value       = var.user_prefix
}
