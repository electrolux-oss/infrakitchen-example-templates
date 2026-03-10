output "derived_name" {
  description = "Name derived from parent and child values"
  value       = local.derived_name
}

output "region_from_parent" {
  description = "Parent region value"
  value       = var.parent_region
}

output "vpc_name_from_parent" {
  description = "Parent VPC name value"
  value       = var.parent_vpc_name
}

output "inherited_instance_count" {
  description = "Parent instance count"
  value       = var.parent_instance_count
}

output "child_suffix" {
  description = "Child suffix identifier"
  value       = var.child_suffix
}

output "child_marker_file" {
  description = "Path to child marker file"
  value       = local_file.child_marker.filename
}
