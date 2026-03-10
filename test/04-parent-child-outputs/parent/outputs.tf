output "parent_region" {
  description = "Region value for child resources"
  value       = var.region
}

output "parent_vpc_name" {
  description = "VPC name for child resources"
  value       = var.vpc_name
}

output "parent_instance_count" {
  description = "Instance count for child resources"
  value       = var.instance_count
}

output "parent_marker_file" {
  description = "Path to parent marker file"
  value       = local_file.parent_marker.filename
}
