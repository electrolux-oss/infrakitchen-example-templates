output "policy_name_effective" {
  description = "IAM inline policy name created on the role"
  value       = aws_iam_policy.redis_iam.name
}

output "target_role" {
  description = "Role that receives Redis IAM permissions"
  value       = var.aws_iam_role_name
}

output "policy_arn" {
  description = "IAM policy ARN attached to the role"
  value       = aws_iam_policy.redis_iam.arn
}

