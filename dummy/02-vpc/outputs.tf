output "vpc_id" {
  description = "The ID of the VPC"
  value       = terraform_data.vpc.output.id
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = [for az in local.azs : terraform_data.subnet["private-${az}"].output.id]
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = [for az in local.azs : terraform_data.subnet["public-${az}"].output.id]
}

output "database_subnets" {
  description = "List of database subnet IDs"
  value       = [for az in local.azs : terraform_data.subnet["database-${az}"].output.id]
}

output "elasticache_subnets" {
  description = "List of elasticache subnet IDs"
  value       = [for az in local.azs : terraform_data.subnet["elasticache-${az}"].output.id]
}

output "cidr" {
  description = "CIDR block used by the VPC"
  value       = terraform_data.vpc.output.cidr_block
}

output "vpc_owner_id" {
  description = "AWS account ID owning the VPC"
  value       = terraform_data.vpc.output.owner_id
}
