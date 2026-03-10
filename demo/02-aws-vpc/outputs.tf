output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = [for subnet in aws_subnet.private : subnet.id]
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "database_subnets" {
  description = "List of database subnet IDs"
  value       = [for subnet in aws_subnet.database : subnet.id]
}

output "elasticache_subnets" {
  description = "List of elasticache subnet IDs"
  value       = [for subnet in aws_subnet.elasticache : subnet.id]
}

output "cidr" {
  description = "CIDR block used by the VPC"
  value       = aws_vpc.this.cidr_block
}

output "vpc_owner_id" {
  description = "AWS account ID owning the VPC"
  value       = aws_vpc.this.owner_id
}
