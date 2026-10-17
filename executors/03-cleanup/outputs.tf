output "target" {
  description = "Cleaned up target"
  value       = terraform_data.cleanup.output.target
}

output "removed_items" {
  description = "Dummy items removed by the cleanup"
  value       = terraform_data.cleanup.output.removed_items
}
