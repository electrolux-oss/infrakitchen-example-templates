output "organization_name" {
  description = "Organization identifier"
  value       = var.organization_name
}

output "environment" {
  description = "Environment name"
  value       = var.environment
}

output "metadata" {
  description = "Metadata payload"
  value       = var.metadata
}

output "output_file_path" {
  description = "Path to the compatibility test output file"
  value       = local_file.compat_output.filename
}

output "timestamp" {
  description = "Output generation timestamp"
  value       = local_file.compat_output.id
}
